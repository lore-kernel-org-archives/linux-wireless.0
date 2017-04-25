Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9671 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428701AbdDYVUD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 17:20:03 -0400
From: <ryanhsu@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <ryanhsu@qti.qualcomm.com>
Subject: [PATCH] ath10k: append the wmi_op_version to testmode get_version cmd
Date: Tue, 25 Apr 2017 14:19:16 -0700
Message-ID: <1493155156-22697-1-git-send-email-ryanhsu@qti.qualcomm.com> (sfid-20170425_232007_062370_493CB047)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qti.qualcomm.com>

QCA9xxx and QCA61x4/QCA93xx are using different wmi operation, in order
for userspace to differentiate it, appends the wmi_op_version information
alone with the get_version command.

Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/testmode.c   | 7 +++++++
 drivers/net/wireless/ath/ath10k/testmode_i.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index ed85f93..eaf4a4b 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -137,6 +137,13 @@ static int ath10k_tm_cmd_get_version(struct ath10k *ar, struct nlattr *tb[])
 		return ret;
 	}
 
+	ret = nla_put_u32(skb, ATH10K_TM_ATTR_WMI_OP_VERSION,
+			  ar->normal_mode_fw.fw_file.wmi_op_version);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
 	return cfg80211_testmode_reply(skb);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/testmode_i.h b/drivers/net/wireless/ath/ath10k/testmode_i.h
index ba81bf6..191a8f3 100644
--- a/drivers/net/wireless/ath/ath10k/testmode_i.h
+++ b/drivers/net/wireless/ath/ath10k/testmode_i.h
@@ -33,6 +33,7 @@ enum ath10k_tm_attr {
 	ATH10K_TM_ATTR_WMI_CMDID	= 3,
 	ATH10K_TM_ATTR_VERSION_MAJOR	= 4,
 	ATH10K_TM_ATTR_VERSION_MINOR	= 5,
+	ATH10K_TM_ATTR_WMI_OP_VERSION	= 6,
 
 	/* keep last */
 	__ATH10K_TM_ATTR_AFTER_LAST,
-- 
1.9.1
