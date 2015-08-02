Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38012 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbHBLfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 07:35:04 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] staging: vt6655: vnt_bss_info_changed check conf->beacon_rate is not NULL
Date: Sun,  2 Aug 2015 12:34:46 +0100
Message-Id: <1438515286-3316-1-git-send-email-tvboxspy@gmail.com> (sfid-20150802_133528_111120_75BB8F83)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

conf->beacon_rate can be NULL on association. So check conf->beacon_rate

BSS_CHANGED_BEACON_INFO needs to flagged in changed as the beacon_rate
will appear later.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/device_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c97353b..b74af8d 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1456,8 +1456,9 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (changed & BSS_CHANGED_ASSOC && priv->op_mode != NL80211_IFTYPE_AP) {
-		if (conf->assoc) {
+	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_BEACON_INFO) &&
+	    priv->op_mode != NL80211_IFTYPE_AP) {
+		if (conf->assoc && conf->beacon_rate) {
 			CARDbUpdateTSF(priv, conf->beacon_rate->hw_value,
 				       conf->sync_tsf);
 
-- 
2.5.0

