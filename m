Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58617 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754471AbZJBXD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 19:03:27 -0400
Message-ID: <4AC686C0.1050506@gmx.de>
Date: Sat, 03 Oct 2009 01:03:28 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
References: <200910011654.10963.chunkeey@googlemail.com> <200910020852.36427.malte.gell@gmx.de> <200910021246.34699.chunkeey@googlemail.com> <200910021345.55567.malte.gell@gmx.de> <4AC67DEB.80900@gmx.de>
In-Reply-To: <4AC67DEB.80900@gmx.de>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

could anyone with a WN111v2 (or any other device with one LED only)
apply the patch below and look into syslog for the value of "hwtype"?

I get 22212221 for an AVM stick (057c:8401) and 22211111 for a Netgear WNDA3100 (0846:9010).

Thanks,
Joerg.

-- 
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 6cbfb2f..74b619c 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -77,6 +77,7 @@ enum ar9170_cmd {
 #define AR9170_EP_IRQ				3
 #define AR9170_EP_CMD				4
 
+#define AR9170_EEPROM_HWTYPE                    0x1374
 #define AR9170_EEPROM_START			0x1600
 
 #define AR9170_GPIO_REG_BASE			0x1d0100
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c1f8c69..bffd6c4 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2598,6 +2598,7 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 	__le32 offsets[RW];
 	unsigned int rx_streams, tx_streams, tx_params = 0;
 	int i, j, err, bands = 0;
+	u32 hwtype;
 
 	BUILD_BUG_ON(sizeof(ar->eeprom) & 3);
 
@@ -2665,6 +2666,14 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 	/* second part of wiphy init */
 	SET_IEEE80211_PERM_ADDR(ar->hw, addr);
 
+	/* read hw type (aka the led modes) */
+	err = ar9170_read_reg(ar, AR9170_EEPROM_HWTYPE, &hwtype);
+	if (err)
+		return err;
+	/* jal: for debugging only */
+	printk(KERN_INFO "%s: hwtype %08x\n",
+	       wiphy_name(ar->hw->wiphy), hwtype);
+
 	return bands ? 0 : -EINVAL;
 }
 
