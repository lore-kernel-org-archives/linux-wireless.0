Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59835 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBLlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 07:41:55 -0400
Received: by werb14 with SMTP id b14so2450555wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 04:41:54 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: destroy assoc_data correctly if assoc fails
Date: Mon,  2 Jul 2012 14:42:03 +0300
Message-Id: <1341229323-6551-1-git-send-email-eliad@wizery.com> (sfid-20120702_134158_959059_F0D33C62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If association failed due to internal error (e.g. no
supported rates IE), we call ieee80211_destroy_assoc_data()
with assoc=true, while we actually reject the association.

This results in the BSSID not being zeroed out.

After passing assoc=false, we no longer have to call
sta_info_destroy_addr() explicitly. While on it, move
the "associated" message after the assoc_success check.

Cc: stable@vger.kernel.org [3.4+]
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a91c888..a2c48ff 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2174,15 +2174,13 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			   mgmt->sa, status_code);
 		ieee80211_destroy_assoc_data(sdata, false);
 	} else {
-		sdata_info(sdata, "associated\n");
-
 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
-			ieee80211_destroy_assoc_data(sdata, true);
-			sta_info_destroy_addr(sdata, mgmt->bssid);
+			ieee80211_destroy_assoc_data(sdata, false);
 			cfg80211_put_bss(*bss);
 			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
 		}
+		sdata_info(sdata, "associated\n");
 
 		/*
 		 * destroy assoc_data afterwards, as otherwise an idle
-- 
1.7.6.401.g6a319

