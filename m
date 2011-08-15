Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45398 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1HSVKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 17:10:35 -0400
Received: by fxh19 with SMTP id 19so2180790fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 14:10:34 -0700 (PDT)
Message-Id: <75dddcb57243e0a2a1a2676444f19746b9c19072.1313434481.git.chunkeey@googlemail.com> (sfid-20110819_231041_571141_A8667BB5)
In-Reply-To: <2de58131999ccc3a6d8f048c5ccbbeaec8f8eec9.1313434481.git.chunkeey@googlemail.com>
References: <2de58131999ccc3a6d8f048c5ccbbeaec8f8eec9.1313434481.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 15 Aug 2011 19:39:51 +0200
Subject: [PATCH 2/4] carl9170: import updated firmware headers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Import new headers from our firmware branch:
git://git.kernel.org/pub/scm/linux/kernel/git/chr/carl9170fw.git

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h   |   11 +++++++++++
 drivers/net/wireless/ath/carl9170/version.h |    4 ++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 0a6dec5..9443c80 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -55,6 +55,7 @@ enum carl9170_cmd_oids {
 	CARL9170_CMD_READ_TSF		= 0x06,
 	CARL9170_CMD_RX_FILTER		= 0x07,
 	CARL9170_CMD_WOL		= 0x08,
+	CARL9170_CMD_TALLY		= 0x09,
 
 	/* CAM */
 	CARL9170_CMD_EKEY		= 0x10,
@@ -286,6 +287,15 @@ struct carl9170_tsf_rsp {
 } __packed;
 #define CARL9170_TSF_RSP_SIZE		8
 
+struct carl9170_tally_rsp {
+	__le32 active;
+	__le32 cca;
+	__le32 tx_time;
+	__le32 rx_total;
+	__le32 rx_overrun;
+	__le32 tick;
+} __packed;
+
 struct carl9170_rsp {
 	struct carl9170_cmd_head hdr;
 
@@ -300,6 +310,7 @@ struct carl9170_rsp {
 		struct carl9170_gpio		gpio;
 		struct carl9170_tsf_rsp		tsf;
 		struct carl9170_psm		psm;
+		struct carl9170_tally_rsp	tally;
 		u8 data[CARL9170_MAX_CMD_PAYLOAD_LEN];
 	} __packed;
 } __packed __aligned(4);
diff --git a/drivers/net/wireless/ath/carl9170/version.h b/drivers/net/wireless/ath/carl9170/version.h
index 6470377..e651db8 100644
--- a/drivers/net/wireless/ath/carl9170/version.h
+++ b/drivers/net/wireless/ath/carl9170/version.h
@@ -1,7 +1,7 @@
 #ifndef __CARL9170_SHARED_VERSION_H
 #define __CARL9170_SHARED_VERSION_H
 #define CARL9170FW_VERSION_YEAR 11
-#define CARL9170FW_VERSION_MONTH 6
-#define CARL9170FW_VERSION_DAY 30
+#define CARL9170FW_VERSION_MONTH 8
+#define CARL9170FW_VERSION_DAY 15
 #define CARL9170FW_VERSION_GIT "1.9.4"
 #endif /* __CARL9170_SHARED_VERSION_H */
-- 
1.7.5.4

