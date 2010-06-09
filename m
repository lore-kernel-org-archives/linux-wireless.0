Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0FIPH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 11:07:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OMMsJ-0008BP-On
	for linux-wireless@vger.kernel.org; Wed, 09 Jun 2010 17:07:27 +0200
Message-Id: <20100609150456.978159079@sipsolutions.net>
Date: Wed, 09 Jun 2010 17:02:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 21/22] mac80211: allow drivers to sleep in ampdu_action
References: <20100609150142.227469359@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow drivers to sleep, and indicate this in
the documentation. ath9k has some locking I
don't understand, so keep it safe and disable
BHs in it, all other drivers look fine with
the context change.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 include/net/mac80211.h                |    2 +-
 net/mac80211/driver-ops.h             |    3 +--
 3 files changed, 6 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-06-09 14:20:07.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-06-09 14:20:22.000000000 +0200
@@ -1640,7 +1640,7 @@ enum ieee80211_ampdu_mlme_action {
  * 	is the first frame we expect to perform the action on. Notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
  *	Returns a negative error code on failure.
- *	The callback must be atomic.
+ *	The callback can sleep.
  *
  * @get_survey: Return per-channel survey information
  *
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2010-06-09 14:20:07.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2010-06-09 14:20:22.000000000 +0200
@@ -1769,6 +1769,8 @@ static int ath9k_ampdu_action(struct iee
 	struct ath_softc *sc = aphy->sc;
 	int ret = 0;
 
+	local_bh_disable();
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		if (!(sc->sc_flags & SC_OP_RXAGGR))
@@ -1798,6 +1800,8 @@ static int ath9k_ampdu_action(struct iee
 			  "Unknown AMPDU action\n");
 	}
 
+	local_bh_enable();
+
 	return ret;
 }
 
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-06-09 14:20:07.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2010-06-09 14:20:22.000000000 +0200
@@ -352,11 +352,10 @@ static inline int drv_ampdu_action(struc
 
 	might_sleep();
 
-	local_bh_disable();
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
 					       sta, tid, ssn);
-	local_bh_enable();
+
 	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, ret);
 	return ret;
 }


