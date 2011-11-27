Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39369 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1K0WQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 17:16:09 -0500
Received: by vbbfc26 with SMTP id fc26so3310820vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 14:16:08 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 1/2] mac80211: use timeout from addba resp
Date: Sun, 27 Nov 2011 17:15:52 -0500
Message-Id: <1322432153-17425-2-git-send-email-mar.kolya@gmail.com> (sfid-20111127_231613_419810_ED318BDD)
In-Reply-To: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com>
References: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  If other side sent us non zero timeout in addba response use it as a
timeout for TX session.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/agg-tx.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 5eeac6d..e363120 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -761,12 +761,13 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 				  size_t len)
 {
 	struct tid_ampdu_tx *tid_tx;
-	u16 capab, tid;
+	u16 capab, tid, timeout;
 	u8 buf_size;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
+	timeout = le16_to_cpu(mgmt->u.action.u.addba_resp.timeout);
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
@@ -802,6 +803,13 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 		tid_tx->buf_size = buf_size;
 
+		/*
+		 * If other side sent us nonzero timeout - use it,
+		 * otherwise stick to our local value.
+		 */
+		if(timeout)
+			tid_tx->timeout = timeout;
+
 		if (test_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state))
 			ieee80211_agg_tx_operational(local, sta, tid);
 
-- 
1.7.4.1

