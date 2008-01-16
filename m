Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYAQPJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:09:25 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <f6ca9fed0801160208x40acfb91p8446298fda9e7726@mail.gmail.com>
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu> <474D75D9.7070908@gmail.com>
	 <1196268612.6058.157.camel@johannes.berg>
	 <f6ca9fed0801110052ja95e86s9f1842846f0dd8fc@mail.gmail.com>
	 <1200068256.3861.172.camel@johannes.berg>
	 <f6ca9fed0801160208x40acfb91p8446298fda9e7726@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q737v3oLyR5GoWOeIKqq"
Date: Wed, 16 Jan 2008 19:38:14 +0100
Message-Id: <1200508694.8708.24.camel@johannes.berg> (sfid-20080117_150931_608636_748418F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q737v3oLyR5GoWOeIKqq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hmm.

Not really very helpful. Do you have the WEP key that was in use at that
time? Also, did the message actually occur during this dump?

Is there any way to get the FCS of packets up to mac80211 from the
iwlwifi drivers, or is it already snipped off by the firmware?

Maybe you have a separate device you could capture traffic with?
Preferably not iwlwifi, it seems to have trouble in monitor mode, at
least my iwl4965 doesn't really seem to see traffic in foreign BSSes.

Could you amend the failing printk to something like:

DECLARE_MAC_BUF(mac1);
DECLARE_MAC_BUF(mac2);

[...]

printk(KERN_DEBUG "WEP decrypt failed (ICV, A1=3D%s, A2=3D%s, seq=3D%x, wep=
idx=3D%d\n",
	print_mac(mac1, hdr->addr1), print_mac(mac2, hdr->addr2),
	le16_to_cpu(hdr->seq_ctrl), keyidx)

Then start a packet capture and wait until the message occurs. Once it
does, quickly run "iwlist key" as root to know what keys are currently
in use and send me both the keys and the failing packet.

Also, please see if maybe the printk is correlated (in time) with
rekeying, the wpa_supplicant output (maybe with -dd) should tell you.

johannes

--=-Q737v3oLyR5GoWOeIKqq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR45PFKVg1VMiehFYAQLUVBAApD4W4fx4zuQquFvHHRQTNYla/e0DHFIN
S4e4WxIrAdxp0l1Jtk+JxTk7UO5LXALqHVtW9Cj3vZbjgWMhYatGmsaNOV4k4bK3
OdJMlzEAvhTb7L4DH7OAifO8r8LBv7zMhZ3iSrf82ZOHX/2+J6PkIqmfCJdAYuZc
7xwHB6bZMi6kn521Ia/4JTwjbZlTdOtnIQLQeipSZXS2kMnyKVXucytzV8IOHsRP
zD/OuKFJWM03Ww8lv10lnZDUpB0YPwSTxTK3VQX1RFnudGOrNsBy5I4zRgGd4R/g
tTRWSsKCL0wxHFIptRy5Fvg+ORjD9ruin45khcPIijTAWfem2VXuHcxDTCvqmgr4
FBy4+l+av3pOt6Yhons88tgFjL3UYBjNGJ3McWFbxrzl2ww37z25M4vdmiSRkAqa
DvqQ4DxYIWfOfDCMkUUEbP25P9lgYG4SpdlNJeQuR0NULK5Y4zo628DaRHQ+S84h
29g9CTEyAWmGqWEHAeiL/FpfUlQ1q8vvJkslyzKOT/5ZskgTrMInUmBT7jF1Vfyz
sbm9Bpd9y7QMWdYpdK2RlNvaz5ypS/ZKzKjeRjfGiKttX5Ei0DXKkHoAs9UB/2Ix
77D4ERnk1c+WmWGMnSZJZfgMSbaHRxHh6OZUdQY+YurmsPEI4VerbbQOKbAmcc2A
h3s6OCfITro=
=s7ea
-----END PGP SIGNATURE-----

--=-Q737v3oLyR5GoWOeIKqq--

