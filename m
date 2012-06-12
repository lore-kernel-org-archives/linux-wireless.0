Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59432 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FLKkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 06:40:39 -0400
Received: by wgbdr13 with SMTP id dr13so4291762wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 03:40:38 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: handle auth failure returned with unmatching auth algo
Date: Tue, 12 Jun 2012 13:40:30 +0300
Message-Id: <1339497630-31589-1-git-send-email-eyal@wizery.com> (sfid-20120612_124043_440735_AA5069CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some Netgear APs like WNAP210 have a quirk behavior when
configured for WEP Shared. They send an auth response with algo
SHARED and status code NOT_SUPPORTED_AUTH_ALG (13) when being
sent a request made with auth algo OPEN. Enable such response to
propagate to userspace instead of discarding it so wpa_s can
reattempt to auth with SHARED.

Reported-by: Noam Shaked <noams@ti.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 net/mac80211/mlme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0f45d02..3ad4366 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1783,7 +1783,8 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
-	if (auth_alg != ifmgd->auth_data->algorithm ||
+	if ((auth_alg != ifmgd->auth_data->algorithm &&
+	     status_code != WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) ||
 	    auth_transaction != ifmgd->auth_data->expected_transaction)
 		return RX_MGMT_NONE;
 
-- 
1.7.4.1

