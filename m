Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33522 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaCZT5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:57:34 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so2101025eei.28
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:57:33 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 03/20] rtl8180: add rtl8187se fields to TX descriptor
Date: Wed, 26 Mar 2014 20:58:43 +0100
Message-Id: <1395863923-4427-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_205741_884642_5ECF3BCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch modifies the TX descriptor struct so it can work also
for rtl8187se.
Some reserved field is now meaningful, and where needed union is
used.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index e7127f3..47a084c 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -34,13 +34,25 @@ struct rtl8180_tx_desc {
 	__le16 rts_duration;
 	__le16 plcp_len;
 	__le32 tx_buf;
-	__le32 frame_len;
+	union{
+		__le32 frame_len;
+		struct {
+			__le16 frame_len_se;
+			__le16 frame_duration;
+		} __packed;
+	} __packed;
 	__le32 next_tx_desc;
 	u8 cw;
 	u8 retry_limit;
 	u8 agc;
 	u8 flags2;
-	u32 reserved[2];
+	/* rsvd for 8180/8185.
+	 * valid for 8187se but we dont use it
+	 */
+	u32 reserved;
+	/* all rsvd for 8180/8185 */
+	__le16 flags3;
+	__le16 frag_qsize;
 } __packed;
 
 struct rtl8180_rx_desc {
-- 
1.8.3.2

