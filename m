Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:52309 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982Ab2LDORr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:17:47 -0500
Message-ID: <50BE0606.3000103@posedge.com> (sfid-20121204_151750_251499_7D8BF9DF)
Date: Tue, 04 Dec 2012 19:47:42 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: add debug file for mic failure
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mic failure count will provide the number of mic failure that 
have happened without a countermeasure being started. Once the 
countermeasure is started, the counter will be reset to 0.
This count will be helpful when the consecutive 
mic failure occur at intervals greater than 60 seconds regularly(frequently).

Signed-off-by: Saravana <saravanad@posedge.com>
---
 net/mac80211/debugfs_key.c |   17 +++++++++++++++++
 net/mac80211/key.h         |    3 +++
 net/mac80211/wpa.c         |    2 ++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 2d42354..65ecfee 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -199,6 +199,22 @@ static ssize_t key_icverrors_read(struct file *file, char __user *userbuf,
 }
 KEY_OPS(icverrors);
 
+static ssize_t key_mic_failures_read(struct file *file, char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	struct ieee80211_key *key = file->private_data;
+	char buf[20];
+	int len;
+
+	if (key->conf.cipher != WLAN_CIPHER_SUITE_TKIP)
+		return -EINVAL;
+	len = scnprintf(buf, sizeof(buf), "%u\n",
+			key->u.tkip.mic_failures);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+KEY_OPS(mic_failures);
+
 static ssize_t key_key_read(struct file *file, char __user *userbuf,
 			    size_t count, loff_t *ppos)
 {
@@ -260,6 +276,7 @@ void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 	DEBUGFS_ADD(rx_spec);
 	DEBUGFS_ADD(replays);
 	DEBUGFS_ADD(icverrors);
+	DEBUGFS_ADD(mic_failures);
 	DEBUGFS_ADD(key);
 	DEBUGFS_ADD(ifindex);
 };
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 7cff0d3..382dc44 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -81,6 +81,9 @@ struct ieee80211_key {
 
 			/* last received RSC */
 			struct tkip_ctx rx[IEEE80211_NUM_TIDS];
+
+			/* number of mic failures */
+			u32 mic_failures;
 		} tkip;
 		struct {
 			atomic64_t tx_pn;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 8bd2f5c..aad79f3 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -161,6 +161,8 @@ update_iv:
 	return RX_CONTINUE;
 
 mic_fail:
+
+	rx->key->u.tkip.mic_failures++;
 	/*
 	 * In some cases the key can be unset - e.g. a multicast packet, in
 	 * a driver that supports HW encryption. Send up the key idx only if
