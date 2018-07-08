Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 10.mo173.mail-out.ovh.net ([46.105.74.148]:42757 "EHLO
        10.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752951AbeGHITf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jul 2018 04:19:35 -0400
Received: from player773.ha.ovh.net (unknown [10.109.120.28])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 6078EC6CBA
        for <linux-wireless@vger.kernel.org>; Sun,  8 Jul 2018 10:10:30 +0200 (CEST)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
To: Johannes Berg <johannes@sipsolutions.net>
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
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <da9c6878-56ff-3a63-07cf-dae7813173a2@web.de> (sfid-20180708_101939_359923_6762150E)
Date: Sun, 8 Jul 2018 10:10:04 +0200
MIME-Version: 1.0
In-Reply-To: <1530662787.4735.59.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------1EB139F7EB2C1A9FD9727068"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1EB139F7EB2C1A9FD9727068
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>>> I think easier would be to just disconnect ourselves? At least if we'=
re
>>> in managed mode...
>>>
>>
>> I still have much to learn about 802.11, but so far I did not see way =
to
>>  directly disconnect a STA. (Maybe spoofing a "signal lost" event or
>> something like that, but I fear complications by losing the sync with
>> the remote STA.) Is there any call/signal you have in mind I could tes=
t?
>=20
> ieee80211_set_disassoc(), this can also send a frame out to indicate to=

> the AP that we're disconnecting instead.
>

I'll try that, but will probably take another week. My main main work
station got severe file system corruption, forcing me to reinstall it
from scratch. I suspect it was something in the wireless testing kernel
4.18-rc1 (944ae08d4e71) related to either btrfs or the ssd disk but
since I needed the system just started over and avoid to run 4.18 if I
do not have a full backup...

>> hostapd or wpa_supplicant are "ordering" mac80211 to install a new key=

>> and are implementing the state machine and are in a good position to
>> handle the fallout... at least theoretically.
>=20
> Ideally it would even know beforehand that we don't want to handle the
> PTK rekeying, and then could reconnect instead of going through the
> handshake.
>=20

Don't see how we could do that in the kernel, all the relevant
information is handled in the state machine. I guess an API extension
telling hostap/supplicant if we can handle rekeys or not would tbe he
only way to avoid that.

>> Instead I get a pop up asking for the PSK. Entering it reconnects
>> normally. Cancel the prompt disconnect till a manual reconnect.
>> I suspect NetworkManager is handling the rekey like the initial key
>> install and then assumes the PSK is wrong. Hardly surprising but also
>> highly visible to the users.
>=20
> That's pretty awkward.
>=20
>> But then only to those using the now broken rekey...
>=20
> Yeah, but you don't necessarily control that - i.e. client device and A=
P
> might have different owners :-)
>=20
>> Using wpa_supplicant directly reconnects after ~15s.
>> It also assumes the key is wrong and seems to rate limit the connectio=
n
>> attempts. Here a log with wpa_supplicat running in the console and dme=
sg
>> -wT output on top of that:
>=20
> So I think we're probably better off accepting the set_key but not
> actually using it, and instead disconnecting... even if that's awkward
> and should come with a big comment :-)

Instead of returning an error I'll change the code to accept the rekey
but do nothing with it. (Basically delete the new key and keep the old
active).
And of course calling ieee80211_set_disassoc() prior to return "success".=


Let's see how the supplicant will react on a disassoc while doing a rekey=
=2E..

Alexander


--------------1EB139F7EB2C1A9FD9727068
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

--------------1EB139F7EB2C1A9FD9727068--
