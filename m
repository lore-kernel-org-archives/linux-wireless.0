Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9.mo69.mail-out.ovh.net ([46.105.56.78]:36390 "EHLO
        9.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732445AbeGKRV5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 13:21:57 -0400
Received: from player737.ha.ovh.net (unknown [10.109.120.122])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id CBC3D1C596
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2018 19:08:44 +0200 (CEST)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
To: Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
References: <1523258757.3076.5.camel@sipsolutions.net>
 <20180515102202.2021-1-alexander.wetzel@web.de>
 <1529062392.10037.7.camel@sipsolutions.net>
 <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
 <1529357234.3092.57.camel@sipsolutions.net>
 <2de1493a-5439-b9ef-6d06-3895333f01c3@web.de>
 <1530267147.3481.78.camel@sipsolutions.net>
 <bb4d75d3-7f90-1b58-9525-3f5a54cd952e@web.de>
 <1530611484.4735.18.camel@sipsolutions.net>
 <b1913512-7d33-cd9b-5eb5-4d7f367eb41a@web.de>
 <1530662787.4735.59.camel@sipsolutions.net>
 <da9c6878-56ff-3a63-07cf-dae7813173a2@web.de>
 <1139d0cb-28dc-53d2-5371-44dc82fda2db@gmail.com>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <3c5c2e73-d529-fbd8-ac43-d5ee078643e6@web.de> (sfid-20180711_191643_284133_479B4BFA)
Date: Wed, 11 Jul 2018 19:08:19 +0200
MIME-Version: 1.0
In-Reply-To: <1139d0cb-28dc-53d2-5371-44dc82fda2db@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------8FE74DE93DC18031F41E0CBF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------8FE74DE93DC18031F41E0CBF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Denis,

> Hi Alexander,
>=20
>>>> hostapd or wpa_supplicant are "ordering" mac80211 to install a new k=
ey
>>>> and are implementing the state machine and are in a good position to=

>>>> handle the fallout... at least theoretically.
>>>
>>> Ideally it would even know beforehand that we don't want to handle th=
e
>>> PTK rekeying, and then could reconnect instead of going through the
>>> handshake.
>>>
>>
>> Don't see how we could do that in the kernel, all the relevant
>> information is handled in the state machine. I guess an API extension
>> telling hostap/supplicant if we can handle rekeys or not would tbe he
>> only way to avoid that.
>>
>=20
> Can the kernel / driver provide some sort of hint to user space that PT=
K
> rekey isn=E2=80=99t supported?=C2=A0 We could then have user space deau=
thenticate
> with a big warning about what/why this is happening and try to
> re-connect to the last used BSS.
>=20

Sure. In fact the latest patch is already doing that by returning an
error when set_key is called for PTK and it's not an initial call.
Tests with wpa_supplicant shows that this is is then handled like the
initial key set is failing. Networkmanager prompts for the password and
wpa_supplicant running without seems to blacklist a reconnect for 15s.

I kind of liked that solution, but with existing implematations out this
is indeed awkward to find a "correct" solution.

The main problem for me currently is to find a correct and still
acceptable solution. This turned from "let's fix this nasty wlan
connection freezes" to a projet spanning the complete wlan stack: From
hardware up to and including the userspace...

It's fun to learn how that interacts (if not very fast), I'm stuggling
finding the best way forward here. Whatever we do has undesired
consequences.
Maybe I'm missing something, but here the high level options we have in
my opinion:

1) Keep it as it is and solve that in a indefinite future when we and
the world implement the ieee802.11 2012 addition, to use key 0+1 for PTK
and 2+3 for GTK
- rekey has a extrem high probability of freezing connections and
leaking a few clear text packets for years (decades?) to come
+ The issue is fixed at the core

2) Make it worse, like some (most) Windows systems/cards seem to handle
it by encrypting EAPOL #4 with the NEW key, breaking the handshake and
forcing a reconnect.
- break something more to fix a problem sounds like a insane approach
+ This seems to be quite common and therefore well "tested" (based on my
very limited data on that)

3) Fix what we can in mac80211 but keep the API stable
- Without driver actions still many drivers will be "undefined" and even
if they are not freezing leak packets
+ This will reduce the problems to a fraction of what is is today with
only a mac80211 update

4) Redesign the mac80211 rekey handling and interaction with drivers to
only rekey if it is save and decline when not.
+ We only have to touch the kernel
- any supplicant (whatever runs the wpa state machine) may get errors
where the programmes did not expect them, leading to unexpected side
effects.

5) The full-stack solution: Update the API for the userpace
+ We do not have to "trick" the wpa state machine to disconnect, the
programmers of it have to code it.
- Well, it must be suppurted from the wpa state machine. If not we still
have to handle the rekey somehow or we accept freezes/cleartext leaks...

The last two solutions will also need some "fallback" when a secure
rekey is not possible and/or the user is runing an old state machine not
knowing about the new way...


>>> So I think we're probably better off accepting the set_key but not
>>> actually using it, and instead disconnecting... even if that's awkwar=
d
>>> and should come with a big comment :-)
>>
>> Instead of returning an error I'll change the code to accept the rekey=

>> but do nothing with it. (Basically delete the new key and keep the old=

>> active).
>> And of course calling ieee80211_set_disassoc() prior to return "succes=
s".
>>
>> Let's see how the supplicant will react on a disassoc while doing a
>> rekey...
>>
>=20
> This sounds pretty awful actually.=C2=A0 Now that wpa_s is not the only=
 game
> in town, can we stop resorting to these tactics?

Nothing of it is wpa_supplicat/hostap specifiy. Only my current "test"
environment is using it, simply due to the fact that I tracked the issue
down in that environment.
Everything besides ath9k as an AP running hostapd and a iwldvm card
running wpa_supplicant is mostly untested. And even there I have some
areas marked for follow up after we find a solution acceptable for the
kernel...

Do you have any other software you think I should add to my prelimitary
tests? If possible I'll happy to extend the test of the patches with thos=
e.

Alexander


--------------8FE74DE93DC18031F41E0CBF
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

mQENBFtAvL4BCACtPZ93/agIvsDbj+o6JDsjm77pJlR2MuKm7Mw9Pd2mlo/aHhd4
o5kyuF6QyYMmJfgCwoP1d3WRmiwMYBfaS5IKl6cqN4CO4lao9wiRbxfAY/kEXToN
/B/92mkHjfn56YyLWZu77YNBXLBvA8v3Dsnvlrpy3pq/sx2wAkpIxP2Yi8XX3qxa
UL/0/tmwHJ04PeB+UEiNbAQYtVOsJzyrRv2luaAHAEoJRmWP93lyr280VoNP/PQc
kQn+0Gi3SuuKa2XzLd3fEhi+OXvu9KkSFBGR84WbAHbHuP7zXgI3eV5C/pNivR7X
6DwuAKGtituL5dFvWfPW+Puwfebfz3yGldX/ABEBAAG0KkFsZXhhbmRlciBXZXR6
ZWwgPGFsZXhhbmRlci53ZXR6ZWxAd2ViLmRlPokBVAQTAQgAPhYhBFKdmwUau/6+
5rxVXwpMJQ66a613BQJbQLy/AhsDBQkB4TOABQsJCAcCBhUKCQgLAgQWAgMBAh4B
AheAAAoJEApMJQ66a613ZIkH+wYvmVcCVBVuMTqMs7mh3KX+/YexKCPElt0K6JMp
2zWNNRxef0o4Vt5hNmatJpCrVXdWbmzTXfD/9VbJ24tRV/B48VkgRB08JjC8hZqJ
wsARifVvE3TUh5XB4q/B1TYUhS6VHgZGKU7++iPUbd6FqYQEKAIepkVw09eAx/d6
6I2YcCgz4WKm0Fbl8RWz9sJ6gULVVoLa8p/5oezvK3g2KDl5LmD+sobu5oFWrR6M
t8ajjLnzBQ51Rd+ORu4i71jU9leYfHOQLyXlgploTVuo2MNE6M3qeCSgxtarXKsH
8ZXvDKEeVr69kifdICZ/SM0FsgomdXu6Nz8aeU1zctB43JS5AQ0EW0C8vgEIAJpd
ZCmLGzAQD0P4nRaSZy4TelP5hpCEAf2rJgR2hOrpZfpPzmE9JbVMdBegUgilK34M
2qRF9oRQRNVM3FBSV1D84w/EtxcidZO0cSyYzHBfTg+QGk4k845V9yFc1cQDR8J2
atdcN59F40Q5npguVi1rAs3YYPnzC9mZ+Wuzk+S8zqhN7YbdV8veI/FPePdwjxtk
J3h/m0rLCP5CX1TduOaZ900nqASEIUBlsxOZCA1NTukDBMnVPrwj9uT2RTWAS24p
W1d4Q04rIn/+fO8qPqQFpMshLBr3d1LUeotCebtByrOwaxolfHsN2A5SAFb8bteP
0ujBpiPBTmaHRaMCcSsAEQEAAYkBPAQYAQgAJhYhBFKdmwUau/6+5rxVXwpMJQ66
a613BQJbQLy+AhsMBQkB4TOAAAoJEApMJQ66a613zn4H/3Q81vz8qkt6a/ZsWjnr
3dEFJZ78MtJojAbLLHotHEvkBhOwHBeKIbKnsbnDIy6QxxzWaiT5rg5KP69PkW7D
5BlrQ2T7coVSmCjMOS70eZ5K07oiUIuRJYj3wjNh+7C1Dt0Hr8nuMzIeHVFskvs3
AqFBmMP9yB9u87ezC36wKlukmD0y7x1XKsaFbxAw0Oj99YpF4niK8Qm2vtjmYfcN
xIw/NYuUbunK1bT2wJm0g7WVFau7do98Z1IGB3U6XWZKFMJJNArX3h7d2503rD8g
YGxTj6hxPIYPoVpmfGvc4o9HyQxXRAnYQjFuxdO6sa8+fYvrFRYpHzguOh949+UB
zvI=3D
=3DJkqe
-----END PGP PUBLIC KEY BLOCK-----

--------------8FE74DE93DC18031F41E0CBF--
