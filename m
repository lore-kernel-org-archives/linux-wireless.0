Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35667 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1HYSd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 14:33:26 -0400
Received: by ywf7 with SMTP id 7so1980650ywf.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 11:33:26 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Ivan Seskar <seskar@winlab.rutgers.edu>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC] mac80211: add IBSS merge support
Date: Thu, 25 Aug 2011 11:33:21 -0700
Message-Id: <1314297201-19007-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110825_203330_748503_D0CDE296)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

When you try to create an IBSS network with a lot of nodes
you typically end up with split networks due to the fact that
some nodes for one reason or another end up not listening to
beacons from the node others do with a higher TSF. What ends
up happening is you split the IBSS network and these do not
converge. To address this you can force the BSSID as well as
the SSID but if you just want to specify the SSID you can
use the ibss_merge knob to force an IBSS merge by focing the
BSSID to be based on the passed SSID.

Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Ivan Seskar <seskar@winlab.rutgers.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---

Ivan, I think this is what you were looking for but an alternative to this
problem is to specify the BSSID every time you want to create your own large
IBSS network, this would mean that its a requirement and also means we
acknowledge a limitation by IEEE's adhoc definition. Is there any reason
forcing a BSSID on the experimenter is not an equally good solution?

Mind you -- I've only test compiled this while on the train, I haven't
tested it or even run-time tested it.

 net/mac80211/debugfs.c     |   36 ++++++++++++++++++++++++++++++++++++
 net/mac80211/ibss.c        |   19 +++++++++++++++++--
 net/mac80211/ieee80211_i.h |    1 +
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 186e02f..dc77ae0 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -146,10 +146,45 @@ static const struct file_operations reset_ops = {
 	.write = reset_write,
 	.open = mac80211_open_file_generic,
 	.llseek = noop_llseek,
 };
 
+static ssize_t ibss_merge_read(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+
+	return mac80211_format_buffer(user_buf, count, ppos, "%d\n",
+				      local->ibss_merge);
+}
+
+static ssize_t ibss_merge_write(struct file *file,
+				const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[100];
+	size_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	local->ibss_merge = !!simple_strtoul(buf, NULL, 0);
+
+	return count;
+}
+
+static const struct file_operations ibss_merge_ops = {
+	.read = ibss_merge_read,
+	.write = ibss_merge_write,
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,
+};
+
+
 static ssize_t noack_read(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
 
@@ -458,10 +493,11 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(uapsd_max_sp_len);
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
+	DEBUGFS_ADD(ibss_merge);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
 	if (!statsd)
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 56c24ca..abffba8 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -33,11 +33,10 @@
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
-
 static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_mgmt *mgmt,
 					size_t len)
 {
 	u16 auth_alg, auth_transaction;
@@ -523,28 +522,44 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 			ifibss->fixed_channel ? ifibss->channel : NULL);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	u8 bssid[ETH_ALEN];
 	u16 capability;
 	int i;
 
 	lockdep_assert_held(&ifibss->mtx);
 
 	if (ifibss->fixed_bssid) {
 		memcpy(bssid, ifibss->bssid, ETH_ALEN);
-	} else {
+	} else if (!local->ibss_merge) {
 		/* Generate random, not broadcast, locally administered BSSID. Mix in
 		 * own MAC address to make sure that devices that do not have proper
 		 * random number generator get different BSSID. */
 		get_random_bytes(bssid, ETH_ALEN);
 		for (i = 0; i < ETH_ALEN; i++)
 			bssid[i] ^= sdata->vif.addr[i];
 		bssid[0] &= ~0x01;
 		bssid[0] |= 0x02;
+	} else {
+		/*
+		 * One large IBSS networks some nodes will not converge to
+		 * the same BSSID and you end up with split IBSS networks,
+		 * to force merging we base the BSSID based on the specified
+		 * SSID. An alternative is to require a fixed BSSID
+		 */
+		printk(KERN_DEBUG "%s: Forcing IBSS merge by basing "
+		       "BSSID on SSID\n",
+		       sdata->name);
+		for (i = 0; i < ETH_ALEN; i++)
+			bssid[i] ^=
+				sdata->u.ibss.ssid[i % sdata->u.ibss.ssid_len];
+		bssid[0] &= ~0x01;
+		bssid[0] |= 0x02;
 	}
 
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
 	       sdata->name, bssid);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c204cee..421e29e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -943,10 +943,11 @@ struct ieee80211_local {
 	int total_ps_buffered; /* total number of all buffered unicast and
 				* multicast packets for power saving stations
 				*/
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
+	int ibss_merge; /* Force BSSID to be based on SSID for IBSS */
 
 	/*
 	 * Bitmask of enabled u-apsd queues,
 	 * IEEE80211_WMM_IE_STA_QOSINFO_AC_BE & co. Needs a new association
 	 * to take effect.
-- 
1.7.4.15.g7811d

