Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:10901 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYDNLhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 07:37:02 -0400
Received: by nf-out-0910.google.com with SMTP id g13so328313nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 04:37:00 -0700 (PDT)
To: Thomas =?utf-8?q?B=C3=A4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Mon, 14 Apr 2008 13:39:45 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br> <1208074049.4111.18.camel@johannes.berg> <4801C4FF.5060606@archlinux.org>
In-Reply-To: <4801C4FF.5060606@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200804141339.45645.IvDoorn@gmail.com> (sfid-20080414_123714_213065_5506EAA6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 April 2008, Thomas B=C3=A4chler wrote:
> Johannes Berg schrieb:
> >>> I compiled half a dozen kernels and now figured it out. This is t=
he=20
> >>> patch that causes rt2500pci to be slow. If I revert it, it is fas=
t again:
> >>> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.gi=
t;a=3Dcommitdiff;h=3Dd43c7b37ad787173d08683f05eadeea0398fefdf
> >=20
> >> That's odd. But that patch looks a bit fishy now that I look at it=
, care
> >> to try below change (manually, this isn't a patch)?
> >>
> >> johannes
> >>
> >>         bool use_protection =3D (erp_value & WLAN_ERP_USE_PROTECTI=
ON) !=3D 0;
> >> -       bool use_short_preamble =3D (erp_value & WLAN_ERP_BARKER_P=
REAMBLE) =3D=3D 0;
> >> =EF=BB=BF=EF=BB=BF+       bool use_short_preamble =3D (erp_value &=
 WLAN_ERP_BARKER_PREAMBLE) !=3D 0;
> >>         DECLARE_MAC_BUF(mac);
> >=20
> > No, wait, I'm confused, the original patch is correct. As far as I =
can
> > tell, the code there is correct. The bug in that code was actually
> > introduced by me based on the wrong thinking I just did again.
>=20
> I figured as much from the original commit message. So rt2500pci work=
s=20
> properly when the use_short_preamble has the wrong value, and breaks=20
> when it has the right one.
> By the way, 2.6.25-rc8 was the first time that rt2500pci was ever fas=
t=20
> enough to be usable at all for me, so the bug you introduced seemed t=
o=20
> be the fix for my speed problems (which is odd). My guess is that=20
> rt2500pci treats use_short_preamble wrong.

Could you test this with the below patch?
This enables short_preamble for all rt2x00 drivers regardless of what m=
ac80211 issues.

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/w=
ireless/rt2x00/rt2x00config.c
index a9930a0..1c24f5a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -83,7 +83,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00de=
v,
=20
 	memset(&erp, 0, sizeof(erp));
=20
-	erp.short_preamble =3D bss_conf->use_short_preamble;
+	erp.short_preamble =3D 1;
 	erp.ack_timeout =3D PLCP + get_duration(ACK_SIZE, 10);
 	erp.ack_consume_time =3D SIFS + PLCP + get_duration(ACK_SIZE, 10);
=20
@@ -92,7 +92,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00de=
v,
 	else
 		erp.ack_timeout +=3D DIFS;
=20
-	if (bss_conf->use_short_preamble) {
+	if (1) {
 		erp.ack_timeout +=3D SHORT_PREAMBLE;
 		erp.ack_consume_time +=3D SHORT_PREAMBLE;
 	} else {

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
