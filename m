Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:29334 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYEJLeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 07:34:18 -0400
Received: by an-out-0708.google.com with SMTP id d40so335298and.103
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 04:34:16 -0700 (PDT)
Message-ID: <c68f135e0805100434h241995fqc89f1acfc5746bc1@mail.gmail.com> (sfid-20080510_133421_232446_E60DEBDA)
Date: Sat, 10 May 2008 13:34:16 +0200
From: "Andrea Merello" <andrea.merello@gmail.com>
Reply-To: andrea.merello@gmail.com
To: "John W. Linville" <linville@tuxdriver.com>
Subject: PATCH Rtl8180 ch14 [3/3]
Cc: linux-wireless@vger.kernel.org,
	"Alessandro Di Marco" <dmr@c0nc3pt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rtl8180: fix wrong parameter in RF code function invokation for gct radio

The grf5101 RF code needs to invoke grf5101_write_phy_antenna every time the
channel is being switch.

This should be done passing the channel number to that function.
Incorrectly we were passing the same value that is written on the
channel RF register.
This may cause problems when operating on ch 14.

This patch fixes it.

Thanks to Alessandro Di Marco who found this issue!


signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

--- a/drivers/net/wireless/rtl8180_grf5101.c    2008-02-02
14:48:52.000000000 +0100
+++ b/drivers/net/wireless/rtl8180_grf5101.c    2008-02-02
14:52:59.000000000 +0100
@@ -87,7 +87,7 @@ static void grf5101_rf_set_channel(struc
        write_grf5101(dev, 0x0B, chan);
        write_grf5101(dev, 0x07, 0x1000);

-       grf5101_write_phy_antenna(dev, chan);
+       grf5101_write_phy_antenna(dev, conf->channel);
 }

 static void grf5101_rf_stop(struct ieee80211_hw *dev)
