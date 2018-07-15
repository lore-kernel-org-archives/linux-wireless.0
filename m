Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:56324 "EHLO
        14.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeGOKvB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jul 2018 06:51:01 -0400
Received: from player763.ha.ovh.net (unknown [10.109.143.109])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 4975F1C244B
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jul 2018 11:11:03 +0200 (CEST)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes/clear text packet leaks at
 rekey
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
 <da9c6878-56ff-3a63-07cf-dae7813173a2@web.de>
 <1531120427.3298.1.camel@sipsolutions.net>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <30c8651d-6a6b-cc28-bfcc-b129524da6ac@web.de> (sfid-20180715_122835_870679_66537F6E)
Date: Sun, 15 Jul 2018 11:10:32 +0200
MIME-Version: 1.0
In-Reply-To: <1531120427.3298.1.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------036EC6F7F22EF893A15E4FD8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------036EC6F7F22EF893A15E4FD8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,


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
>=20
> Right. Did you handle/consider modes other than BSS/P2P client btw?

I've tested that on a client only and it's already not working. Problem
is, that with ieee80211_set_disassoc() we just dump the association in
the kernel and are not informing the userspace, so the state machine is
stuck in "connected" but the STA is unable to communicate.

I also tried ieee80211_mgd_deauth():
While better this is basically the same behaviour as returning an error
on key replace. By setting the error code to inactivity at least
wpa_supplicant was actually starting to reconnect, unfortunatelly
set_key then failes since we purged the assosication in the kernel. (Or
that's my best interpretation from the logs). Networkmanager then again
prompted for the password...

I started experimenting with just signals to the userspace, but then
paused... Trying to control the state machine with spoofed errors trying
to trigger an "desireable" action can't be the way forward, can it?

Even if we get that working changes or different implementations in
userspace may well break it.

I now think we only have two reasonable ways forward:

1) The user friendly one: If the userspace does not know about the new
API just print a error message and do the insecure key replace. With
potential clear text packet leaks and connection freezes.

2) The secure way: Report an error on key install and accept that users
will encounter new problems when they are using rekeys with the old API
with "old" userspace software.

Since we have this issue in the kernel at least as long as we have
mac80211 I would vote for 1) here. Fix mac80211 and add a new way for
the userspace to to securely replace the keys and detect when this is
not possible. Then get the userspace software updated to act
accordingly, finally preventing the clear text packet leaks.

After some time we can then decide to reject insecure rekeys, burning
only those who use kernels much newer than the userspace.

Does this sound like an reasonable approch or should I go back figuring
out how to trick the userspace to reconnect without user
notification/intervention?

Alexander


--------------036EC6F7F22EF893A15E4FD8
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

--------------036EC6F7F22EF893A15E4FD8--
