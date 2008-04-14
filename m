Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:5526 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879AbYDNRpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 13:45:06 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1649356fgb.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 10:45:04 -0700 (PDT)
To: Thomas =?iso-8859-15?q?B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Mon, 14 Apr 2008 19:47:51 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br> <200804141339.45645.IvDoorn@gmail.com> <4803963C.2000101@archlinux.org>
In-Reply-To: <4803963C.2000101@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200804141947.51893.IvDoorn@gmail.com> (sfid-20080414_184511_248511_C62CD4CD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 April 2008, Thomas B=E4chler wrote:
> Ivo van Doorn schrieb:
> >>> No, wait, I'm confused, the original patch is correct. As far as =
I can
> >>> tell, the code there is correct. The bug in that code was actuall=
y
> >>> introduced by me based on the wrong thinking I just did again.
> >> I figured as much from the original commit message. So rt2500pci w=
orks=20
> >> properly when the use_short_preamble has the wrong value, and brea=
ks=20
> >> when it has the right one.
> >> By the way, 2.6.25-rc8 was the first time that rt2500pci was ever =
fast=20
> >> enough to be usable at all for me, so the bug you introduced seeme=
d to=20
> >> be the fix for my speed problems (which is odd). My guess is that=20
> >> rt2500pci treats use_short_preamble wrong.
> >=20
> > Could you test this with the below patch?
> > This enables short_preamble for all rt2x00 drivers regardless of wh=
at mac80211 issues.
>=20
> What tree is this against? It doesn't apply to linux-2.6.git=20
> (2.6.25-rc9), which was the one I was talking about all the time. I d=
id=20
> not test the wireless-testing or rt2x00 tree.

Hmm, it was against the rt2x00.git tree (which means it should apply to=
 wireless-testing,
wireless-2.6.26 and the -mm tree).
Anyway it doesn't matter at this time, could you try below patch instea=
d?
I found 1 irregularity in the handling of preamble settings compared to=
 the legacy code.

(This patch is against latest linux-2.6.git)

---
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wire=
less/rt2x00/rt2500pci.c
index 91e87b5..9a87e83 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -309,7 +309,7 @@ static void rt2500pci_config_preamble(struct rt2x00=
_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
=20
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
-	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00 | preamble_mask);
+	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
 	rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
 	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 10));
 	rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
