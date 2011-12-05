Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:16991 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab1LER4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 12:56:48 -0500
Message-ID: <4EDCF7EC.2030106@allnet.de> (sfid-20111205_185652_361182_EAEDA733)
Date: Mon, 5 Dec 2011 17:57:16 +0100
From: Daniel Golle <dgolle@allnet.de>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v1 1/3] support for antenna configuration profiles
References: <20111128161240.GA25454@localhost>	 (sfid-20111128_171813_665159_36F11CCF) <1322996760.4633.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1322996760.4633.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

On 12/04/2011 12:06 PM, Johannes Berg wrote:
> On Mon, 2011-11-28 at 17:12 +0100, Daniel Golle wrote:
>> This adds support for antenna switch configuration profiles to nl80211.
> 
> Meh, I couldn't find this patch because the subjects are all wrong.
> Three patches with exactly the same subject?! Come on. Also please use
> threaded mode to submit -- otherwise the 0/N discussion & the patches
> get torn apart (which is the reason I'm replying here).
I see, I try to use git-email in future to automatize the submission process and
hope that would improve the form.
The draft/v0 patch was posted on ath9k-devel, I re-posted this one to
linux-wireless after Mohammed suggested to post it here to have a broader
audience for discussion. Unfortunately I didn't repost the board-setup and
userspace patches as well, I'll try to prepare that in the next days.

> Anyway, enough complaining.
Please excuse me being a noob when it comes to collaboration methods, trying to
emulate what I observe. I highly appreciate people showing me where and how I
can improve.

> Those length restrictions are completely bogus, but they're also
> unnecessary since this data is output data only so you aren't using the
> policy anywhere anyway.
Should I completely skip adding it to the policy then or just ommit the length
restriction?

> Oh so that's supposed to be an array -- there's no way to tell this from
> the header files. It's acceptable, but please give it an explicit
> length.
Ok, I haven't seen any devices with more than 2 possible antenna configuation
profiles (horizontal/vertical, built-in/external) so far, so giving the array a
fixed length of 4 should be fine for now.

> Anyway, apart from these technical issues that you must fix, I also want
> somebody who knows what this is used for and how it is used to review
> it, which might mean waiting for Adrian who says it'll be a couple of
> weeks at least.
No worries about that, I'll also be traveling in the next few weeks and we can
further discuss when Adrian has returned as well.



Daniel

- -- 
ALLNET GmbH ; Maistr. 2 ; D-82110 Germering ; Germany
Tel. +49-89-89422222 - Fax +49-89-89422233
http://www.allnet.de
email: Daniel Golle <dgolle@allnet.de>
Schulungs-/Veranstaltungsprogramm: http://www.802lab.de<http://www.802lab.de/>
Geschäftsführer: Wolfgang Marcus Bauer
Handelsregister München B 95922 ; UST-ID-Nr. DE 128214294 ;
St.-Nr.117/115/00164
WEEE-Reg.-NR. DE 13101093
Bankverbindung:
Sparkasse Fürstenfeldbruck KTO: 2774594 ; BLZ: 70053070
Swift-Code: BYLADEM1FFB ; IBAN: DE61700530700002774594
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3PfpAAoJEDy9cKN/1Et0gSwP/33wyuFu6Hz0o8BnSO7QCP5p
QPH/KO9tzIsLh7VgDqGYFpkhInh4JCc+zumSM7OL8JY0NkJv+PVoCs9o3WqtDqdY
k10CV4l1kT0ckfcvsE0E/LTsQAzq53tlc/A8g0NJCRVWUT2ikXE93ixcOh77n/lC
VvcblSU1wvgvmKn9848Ydm31T32wdrI910kLnGH97NVc3K6cpQUtNLRA5adLTBlz
nlxj7eFP2rwkiXpBMHO6HWqvW2LpgFgzHCnpCxVyq0To5l4l2KZuscRs94nRm717
uScjxN7fPHj8WNv/QXlJ5+xQQLL5xfXzJd0UMNSx3yIY3ObgBbjA9j6eme3QLvKG
Yz6jDzRbCCO0n4YfFxYnrcAsZawjHx4WqjmqV9vpYrEXDEmkaj3LSMt9dYfjWiZX
PBfUs+Al+2NjO7lqq7nWMevmOlX+GBkQPJeH9Ov3NT8xAlqDmEEE8EzD5NXdAdDw
BSATVJkTh5OVsU5S13Wlf98N6mcV904lmRDi9jEPUITL1ygiVFiqBMakIF62Ozgc
flF83MR9f+NxLC0oeqVEYgMddwUK2O3wj5YrT9EsWt6mwJ2kzFfSugo4cf+IGCml
6MZDX5OoeIB1jWe7MS7jONKXmz2dWU4g1tB8DHc6XSRZKXkrKm7hzrOSF9sIK6hJ
i76D1gt+BH5/zFAHY4Fd
=ytEh
-----END PGP SIGNATURE-----
