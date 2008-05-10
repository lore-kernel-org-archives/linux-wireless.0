Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:26044 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYEJLaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 07:30:14 -0400
Received: by an-out-0708.google.com with SMTP id d40so335135and.103
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 04:30:12 -0700 (PDT)
Message-ID: <c68f135e0805100430s668492b0l56107f1fa4fc4ff7@mail.gmail.com> (sfid-20080510_133039_682523_F395CDE8)
Date: Sat, 10 May 2008 13:30:12 +0200
From: "Andrea Merello" <andreamrl@tiscali.it>
Reply-To: andreamrl@tiscali.it
To: "John W. Linville" <linville@tuxdriver.com>
Subject: PATCH Rtl8180 ch14 [1/3]
Cc: linux-wireless@vger.kernel.org,
	"Alessandro Di Marco" <dmr@c0nc3pt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rtl8180: fix wrong parameter in RF code funcion invokation for philips radio

The sa2400 RF code needs to invoke sa2400_write_phy_antenna every time the
channel is being switch.

This should be done passing the channel number to that function.
Incorrectly we were passing the same value that is written on the
channel RF register.
This may cause problems when operating on ch 14.

This patch fixes it.

Thanks to Alessandro Di Marco who found this issue!


signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

--- a/drivers/net/wireless/rtl8180_sa2400.c     2008-02-02
14:48:52.000000000 +0100
+++ b/drivers/net/wireless/rtl8180_sa2400.c     2008-02-02
14:49:44.000000000 +0100
@@ -85,7 +85,7 @@ static void sa2400_rf_set_channel(struct

        write_sa2400(dev, 7, txpw);

-       sa2400_write_phy_antenna(dev, chan);
+       sa2400_write_phy_antenna(dev, conf->channel);

        write_sa2400(dev, 0, chan);
        write_sa2400(dev, 1, 0xbb50);
