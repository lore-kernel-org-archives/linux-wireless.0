Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:27605 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYEJLcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 07:32:35 -0400
Received: by an-out-0708.google.com with SMTP id d40so335226and.103
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 04:32:34 -0700 (PDT)
Message-ID: <c68f135e0805100432n5d90e9d1p26d2bd35ac99f994@mail.gmail.com> (sfid-20080510_133237_907939_2407A379)
Date: Sat, 10 May 2008 13:32:34 +0200
From: "Andrea Merello" <andrea.merello@gmail.com>
Reply-To: andrea.merello@gmail.com
To: "John W. Linville" <linville@tuxdriver.com>
Subject: PATCH Rtl8180 ch14 [2/3]
Cc: linux-wireless@vger.kernel.org,
	"Alessandro Di Marco" <dmr@c0nc3pt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rtl8180: fix wrong parameter in RF code function invokation for maxim radio

The max2820 RF code needs to invoke max2820_write_phy_antenna every time the
channel is being switch.

This should be done passing the channel number to that function.
Incorrectly we were passing the same value that is written on the
channel RF register.
This may cause problems when operating on ch 14.

This patch fixes it.

Thanks to Alessandro Di Marco who found this issue!


signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

--- a/drivers/net/wireless/rtl8180_max2820.c    2008-02-02
14:48:52.000000000 +0100
+++ b/drivers/net/wireless/rtl8180_max2820.c    2008-02-02
14:55:29.000000000 +0100
@@ -86,7 +86,7 @@ static void max2820_rf_set_channel(struc
         * sa2400, for MAXIM we do this directly from BB */
        rtl8180_write_phy(dev, 3, txpw);

-       max2820_write_phy_antenna(dev, chan);
+       max2820_write_phy_antenna(dev, chan_idx + 1);
        write_max2820(dev, 3, chan);
 }
