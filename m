Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35325 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1KPMbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:31:48 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 2/2] mac80211: remove debugfs noack test
Date: Wed, 16 Nov 2011 13:31:06 +0100
Message-Id: <1321446667-8348-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111116_133153_604754_59553829)
In-Reply-To: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This feature has been superseded by the NoAck per Queue feature.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/debugfs.c     |   35 -----------------------------------
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/tx.c          |    2 --
 net/mac80211/wme.c         |    4 +---
 4 files changed, 1 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 00cefcb..90baea5 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -97,40 +97,6 @@ static const struct file_operations reset_ops = {
 	.llseek = noop_llseek,
 };
 
-static ssize_t noack_read(struct file *file, char __user *user_buf,
-			  size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-
-	return mac80211_format_buffer(user_buf, count, ppos, "%d\n",
-				      local->wifi_wme_noack_test);
-}
-
-static ssize_t noack_write(struct file *file,
-			   const char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	char buf[10];
-	size_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-	buf[len] = '\0';
-
-	local->wifi_wme_noack_test = !!simple_strtoul(buf, NULL, 0);
-
-	return count;
-}
-
-static const struct file_operations noack_ops = {
-	.read = noack_read,
-	.write = noack_write,
-	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
-};
-
 static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
@@ -398,7 +364,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD_MODE(reset, 0200);
-	DEBUGFS_ADD(noack);
 	DEBUGFS_ADD(uapsd_queues);
 	DEBUGFS_ADD(uapsd_max_sp_len);
 	DEBUGFS_ADD(channel_type);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 068cc92..5c62579 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -957,7 +957,6 @@ struct ieee80211_local {
 	int total_ps_buffered; /* total number of all buffered unicast and
 				* multicast packets for power saving stations
 				*/
-	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	/*
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 62a3190..7b442a9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1157,8 +1157,6 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	} else {
 		tx->flags |= IEEE80211_TX_UNICAST;
-		if (unlikely(local->wifi_wme_noack_test))
-			info->flags |= IEEE80211_TX_CTL_NO_ACK;
 		/*
 		 * Flags are initialized to 0. Hence, no need to
 		 * explicitly unset IEEE80211_TX_CTL_NO_ACK since
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index ba22a08..f973ddf 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -151,9 +151,7 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 		/* preserve EOSP bit */
 		ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
 
-		if (sdata->tx_conf[q].noack)
-			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
-		if (unlikely(sdata->local->wifi_wme_noack_test) ||
+		if (sdata->tx_conf[q].noack ||
 		    is_multicast_ether_addr(hdr->addr1))
 			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		/* qos header is 2 bytes */
-- 
1.7.7.2

