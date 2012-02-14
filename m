Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62031 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2BNPDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 10:03:17 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Remove bogus non-NULL pointer check
Date: Tue, 14 Feb 2012 20:33:00 +0530
Message-ID: <1329231780-18929-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120214_160319_410827_1953E40D)
In-Reply-To: <1329231780-18929-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1329231780-18929-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ath6kl_cfg80211_add_key(), params is checked for non-NULL
but this pointer has been deferenced many times before this check. This
gives the following smatch warning. add_key() can never carry NULL as
params, remove this bogus check.

ath6kl_cfg80211_add_key(86) warn: variable dereferenced before check 'params'

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a91f521..313787e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1059,7 +1059,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (vif->nw_type == AP_NETWORK && !pairwise &&
 	    (key_type == TKIP_CRYPT || key_type == AES_CRYPT ||
-	     key_type == WAPI_CRYPT) && params) {
+	     key_type == WAPI_CRYPT)) {
 		ar->ap_mode_bkey.valid = true;
 		ar->ap_mode_bkey.key_index = key_index;
 		ar->ap_mode_bkey.key_type = key_type;
-- 
1.7.0.4

