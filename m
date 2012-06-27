Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33239 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2F0LSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 07:18:14 -0400
Received: by werb10 with SMTP id b10so183075wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 04:18:13 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: flush queues before deauth/disassoc
Date: Wed, 27 Jun 2012 14:18:22 +0300
Message-Id: <1340795902-12334-1-git-send-email-eliad@wizery.com> (sfid-20120627_131817_012719_CB7C0692)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On deauth/disassoc we tear down all BA sessions. These
DELBA packets are sent on the appropriate TID, while
deauth/disassoc is always sent on VO. This sometimes
ends with the DELBA being sent after the deauth was
already sent.

Fix it by flushing all the pending frames before
sending deauth/disassoc.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: move drv_flush() to a higher function (thanks Johannes!)

 net/mac80211/mlme.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ca36ef1..4b8e0a4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1368,6 +1368,10 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->sta_mtx);
 
+	/* flush out any pending frame (e.g. DELBA) before deauth/disassoc */
+	if (tx)
+		drv_flush(local, false);
+
 	/* deauthenticate/disassociate now */
 	if (tx || frame_buf)
 		ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid, stype,
-- 
1.7.6.401.g6a319

