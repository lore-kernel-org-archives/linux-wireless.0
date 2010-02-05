Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:36467 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933476Ab0BEAVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 19:21:23 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>,
	stable@kernel.org
Subject: [PATCH] mac80211: Fix probe request filtering in IBSS mode
Date: Fri,  5 Feb 2010 01:21:03 +0100
Message-Id: <1265329263-3120-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We only reply to probe request if either the requested SSID is the
broadcast SSID or if the requested SSID matches our own SSID. This
latter case was not properly handled since we were replying to different
SSID with the same length as our own SSID.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
Cc: stable@kernel.org
---
 net/mac80211/ibss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 86bd2a0..e905c45 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -714,7 +714,7 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	}
 	if (pos[1] != 0 &&
 	    (pos[1] != ifibss->ssid_len ||
-	     !memcmp(pos + 2, ifibss->ssid, ifibss->ssid_len))) {
+	     memcmp(pos + 2, ifibss->ssid, ifibss->ssid_len))) {
 		/* Ignore ProbeReq for foreign SSID */
 		return;
 	}
-- 
1.6.3.3

