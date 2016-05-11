Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53955 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbcEKRCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:45 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 17/21] ath10k: Enable detecting failure to install key in firmware (CT).
Date: Wed, 11 May 2016 10:02:29 -0700
Message-Id: <1462986153-16318-18-git-send-email-greearb@candelatech.com> (sfid-20160511_190255_506433_25DB0EB1)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

CT firmware has been modified so that it will always return
a response message when user requests to add a key, even if
the key could not actually be added.  Upstream firmware may
assert or just not respond in a failure case.

This change should be compatible with non CT firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  1 +
 drivers/net/wireless/ath/ath10k/htt.h    |  7 +++++--
 drivers/net/wireless/ath/ath10k/htt_rx.c | 20 +++++++++++++++++---
 drivers/net/wireless/ath/ath10k/mac.c    |  3 ++-
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f9e3b20..fda66bf 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -848,6 +848,7 @@ struct ath10k {
 	unsigned int filter_flags;
 	unsigned long dev_flags;
 	bool dfs_block_radar_events;
+	int install_key_rv; /* Store error code from key-install */
 
 	/* protected by conf_mutex */
 	bool radar_enabled;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 911c535..c50b343 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -702,8 +702,9 @@ enum htt_security_types {
 };
 
 enum htt_security_flags {
-#define HTT_SECURITY_TYPE_MASK 0x7F
+#define HTT_SECURITY_TYPE_MASK 0x3F
 #define HTT_SECURITY_TYPE_LSB  0
+	HTT_SECURITY_IS_FAILURE = 1 << 6, /* CT firmware only */
 	HTT_SECURITY_IS_UNICAST = 1 << 7
 };
 
@@ -712,7 +713,9 @@ struct htt_security_indication {
 		/* dont use bitfields; undefined behaviour */
 		u8 flags; /* %htt_security_flags */
 		struct {
-			u8 security_type:7, /* %htt_security_types */
+			u8 security_type:6, /* %htt_security_types */
+			   is_failure:1, /* does this response indicate failure
+					    (CT Firmware) */
 			   is_unicast:1;
 		} __packed;
 	} __packed;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 47da904..02b5417 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2307,9 +2307,23 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 
 		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "sec ind peer_id %d unicast %d type %d\n",
-			  __le16_to_cpu(ev->peer_id),
-			  !!(ev->flags & HTT_SECURITY_IS_UNICAST),
-			  MS(ev->flags, HTT_SECURITY_TYPE));
+			   __le16_to_cpu(ev->peer_id),
+			   !!(ev->flags & HTT_SECURITY_IS_UNICAST),
+			   MS(ev->flags, HTT_SECURITY_TYPE));
+
+		/* CT firmware adds way to determine failure of key set, without
+		 * just timing things out.  Indication of failure is determined
+		 * by the 6th bit of the security-type being set.
+		 */
+		if (ev->flags & HTT_SECURITY_IS_FAILURE) {
+			ath10k_warn(ar, "Firmware failed to set security key, peer_id: %d unicast %d type %d\n",
+				    __le16_to_cpu(ev->peer_id),
+				    !!(ev->flags & HTT_SECURITY_IS_UNICAST),
+				    MS(ev->flags, HTT_SECURITY_TYPE));
+			ar->install_key_rv = -EINVAL;
+		} else {
+			ar->install_key_rv = 0;
+		}
 		complete(&ar->install_key_done);
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2169337..373f2ee 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -255,7 +255,8 @@ static int ath10k_install_key(struct ath10k_vif *arvif,
 	if (time_left == 0)
 		return -ETIMEDOUT;
 
-	return 0;
+	ret = ar->install_key_rv;
+	return ret;
 }
 
 static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
-- 
2.4.3

