Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37533 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbYJJAiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 20:38:55 -0400
Message-ID: <48EEA41C.6020306@lwfinger.net> (sfid-20081010_023900_651485_0B8877D2)
Date: Thu, 09 Oct 2008 17:38:52 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>, Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: Move rx_mtu to struct bootrec_desc
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch entitled "[PATCH] p54: Fix sparse warnings" added the __le16
variable rx_mtu to struct bootrec, but it could equally well be placed
in the struct bootrec_desc, which overlays the 'data' section of bootrec.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I'm neutral regarding this change, which was suggested by Christian.
I'll leave it up to you whether it gets applied. It is 2.6.28 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -183,7 +183,7 @@ int p54_parse_firmware(struct ieee80211_
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
 			if (le32_to_cpu(bootrec->len) == 11)
-				priv->rx_mtu = le16_to_cpu(bootrec->rx_mtu);
+				priv->rx_mtu = le16_to_cpu(desc->rx_mtu);
 			else
 				priv->rx_mtu = (size_t)
 					0x620 - priv->tx_hdr_len;
Index: wireless-testing/drivers/net/wireless/p54/p54common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.h
+++ wireless-testing/drivers/net/wireless/p54/p54common.h
@@ -19,7 +19,6 @@ struct bootrec {
 	__le32 code;
 	__le32 len;
 	u32 data[10];
-	__le16 rx_mtu;
 } __attribute__((packed));

 struct bootrec_exp_if {
@@ -39,6 +38,8 @@ struct bootrec_desc {
 	u8 tailroom;
 	u8 unimportant[6];
 	u8 rates[16];
+	u8 padding2[4];
+	__le16 rx_mtu;
 } __attribute__((packed));

 #define BR_CODE_MIN			0x80000000


