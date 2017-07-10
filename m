Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36369 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbdGJMo1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:44:27 -0400
Received: by mail-pf0-f195.google.com with SMTP id z6so14393272pfk.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:44:22 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 01/17] rsi: add common structures needed for command packets
Date: Mon, 10 Jul 2017 18:10:32 +0530
Message-Id: <1499690448-9956-2-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144441_365740_B02D84E1)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

All internal management packets (command packets) use some common
fields and some packet specific fields for packet descriptors.
This patch adds some common structures which are needed for all
command packets.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_mgmt.h | 38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index a8a195e..63360c2 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -221,6 +221,44 @@ struct rsi_mac_frame {
 	__le16 desc_word[8];
 } __packed;
 
+#define PWR_SAVE_WAKEUP_IND		BIT(0)
+#define TCP_CHECK_SUM_OFFLOAD		BIT(1)
+#define CONFIRM_REQUIRED_TO_HOST	BIT(2)
+#define ADD_DELTA_TSF			BIT(3)
+#define FETCH_RETRY_CNT_FROM_HOST_DESC	BIT(4)
+#define EOSP_INDICATION			BIT(5)
+#define REQUIRE_TSF_SYNC_CONFIRM	BIT(6)
+#define ENCAP_MGMT_PKT			BIT(7)
+
+struct rsi_cmd_desc_dword0 {
+	__le16 len_qno;
+	u8 frame_type;
+	u8 misc_flags;
+};
+
+struct rsi_cmd_desc_dword1 {
+	u8 xtend_desc_size;
+	u8 reserved1;
+	__le16 reserved2;
+};
+
+struct rsi_cmd_desc_dword2 {
+	__le32 pkt_info; /* Packet specific data */
+};
+
+struct rsi_cmd_desc_dword3 {
+	__le16 token;
+	u8 qid_tid;
+	u8 sta_id;
+};
+
+struct rsi_cmd_desc {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	struct rsi_cmd_desc_dword1 desc_dword1;
+	struct rsi_cmd_desc_dword2 desc_dword2;
+	struct rsi_cmd_desc_dword3 desc_dword3;
+};
+
 struct rsi_boot_params {
 	__le16 desc_word[8];
 	struct bootup_params bootup_params;
-- 
2.7.4
