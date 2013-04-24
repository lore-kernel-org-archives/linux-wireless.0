Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56013 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3DXF4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 01:56:46 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/2] mac80211:  Add debugfs for sdata and sdata->sta_vhash
Date: Tue, 23 Apr 2013 22:56:36 -0700
Message-Id: <1366782996-27821-2-git-send-email-greearb@candelatech.com> (sfid-20130424_075651_126413_1F31424B)
In-Reply-To: <1366782996-27821-1-git-send-email-greearb@candelatech.com>
References: <1366782996-27821-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This gives the user some idea how well the hash functions
are working.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2bbe377... c18a6d1... M	net/mac80211/debugfs.c
:100644 100644 234576c... 51269c5... M	net/mac80211/debugfs_netdev.c
 net/mac80211/debugfs.c        |   43 ++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c |   54 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2bbe377..c18a6d1 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -210,9 +210,51 @@ static ssize_t sta_hash_read(struct file *file, char __user *user_buf,
 	return q;
 }
 
+static ssize_t sdata_hash_read(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int mxln = 15000;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
+	int q, res = 0;
+	struct ieee80211_sub_if_data *s;
+
+	if (!buf)
+		return 0;
+
+	mutex_lock(&local->iflist_mtx);
+	for (q = 0; q < STA_HASH_SIZE; q++) {
+		s = local->sdata_hash[q];
+		if (s) {
+			res += snprintf(buf + res, mxln - res, "%i: ", q);
+			if (res >= mxln)
+				goto done;
+		}
+		while (s) {
+			res += snprintf(buf + res, mxln - res, " %pM",
+					s->vif.addr);
+			if (res >= mxln)
+				goto done;
+			s = s->hnext;
+		}
+		if (local->sdata_hash[q]) {
+			res += snprintf(buf + res, mxln - res, "\n");
+			if (res >= mxln)
+				goto done;
+		}
+	}
+done:
+	mutex_unlock(&local->iflist_mtx);
+
+	q = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+	return q;
+}
+
 DEBUGFS_READONLY_FILE_OPS(hwflags);
 DEBUGFS_READONLY_FILE_OPS(queues);
 DEBUGFS_READONLY_FILE_OPS(sta_hash);
+DEBUGFS_READONLY_FILE_OPS(sdata_hash);
 
 /* statistics stuff */
 
@@ -282,6 +324,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD(sta_hash);
+	DEBUGFS_ADD(sdata_hash);
 #ifdef CONFIG_PM
 	DEBUGFS_ADD_MODE(reset, 0200);
 #endif
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 234576c..51269c5 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -30,17 +30,22 @@ static ssize_t ieee80211_if_read(
 	size_t count, loff_t *ppos,
 	ssize_t (*format)(const struct ieee80211_sub_if_data *, char *, int))
 {
-	char buf[70];
+	int mxln = STA_HASH_SIZE * 10;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
 	ssize_t ret = -EINVAL;
 
+	if (!buf)
+		return 0;
+
 	read_lock(&dev_base_lock);
 	if (sdata->dev->reg_state == NETREG_REGISTERED)
-		ret = (*format)(sdata, buf, sizeof(buf));
+		ret = (*format)(sdata, buf, mxln);
 	read_unlock(&dev_base_lock);
 
 	if (ret >= 0)
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
 
+	kfree(buf);
 	return ret;
 }
 
@@ -201,6 +206,50 @@ ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
 }
 __IEEE80211_IF_FILE(hw_queues, NULL);
 
+static ssize_t
+ieee80211_if_fmt_sta_hash(const struct ieee80211_sub_if_data *sdata,
+			  char *buf, int buflen)
+{
+	int q, res = 0;
+	struct sta_info *sta;
+
+	mutex_lock(&sdata->local->sta_mtx);
+	for (q = 0; q < STA_HASH_SIZE; q++) {
+		int cnt = 0;
+		sta = sdata->sta_vhash[q];
+		while (sta) {
+			cnt++;
+			sta = sta->vnext;
+		}
+		if (cnt) {
+			res += snprintf(buf + res, buflen - res, "%i: %i ",
+					q, cnt);
+			if (res >= buflen) {
+				res = buflen;
+				break;
+			}
+			sta = sdata->sta_vhash[q];
+			while (sta) {
+				res += snprintf(buf + res, buflen - res, " %pM",
+						sta->sta.addr);
+				if (res >= buflen) {
+					res = buflen;
+					break;
+				}
+				sta = sta->vnext;
+			}
+			res += snprintf(buf + res, buflen - res, "\n");
+			if (res >= buflen) {
+				res = buflen;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&sdata->local->sta_mtx);
+	return res;
+}
+__IEEE80211_IF_FILE(sta_hash, NULL);
+
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
@@ -544,6 +593,7 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
+	DEBUGFS_ADD(sta_hash);
 }
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
-- 
1.7.3.4

