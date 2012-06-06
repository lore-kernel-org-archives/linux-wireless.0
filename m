Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24327 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2FFFDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 01:03:50 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: remove incompatible IBSS interface check in change_iface
Date: Wed, 6 Jun 2012 10:33:42 +0530
Message-ID: <1338959022-2786-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120606_070353_106789_36117324)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

'cfg80211: fix interface combinations' ensures that if an interface
type is not advertised by the driver in any of the interface combinations
(via ieee80211_iface_combination) then it shall be treated as a single
incompatible interface. if there are more than one interfaces present
and changing them to incompatible interface type is not possible.
These checks will be properly handled by cfg80211_change_iface ->
cfg80211_can_change_interface.

this patch is dependent on 'cfg80211: fix interface combinations'

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9ae76bd..00c0996 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1467,15 +1467,6 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 
-	/* See if new interface type is valid. */
-	if ((new_type == NL80211_IFTYPE_ADHOC) &&
-	    (sc->nvifs > 1)) {
-		ath_err(common, "When using ADHOC, it must be the only"
-			" interface.\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (ath9k_uses_beacons(new_type) &&
 	    !ath9k_uses_beacons(vif->type)) {
 		if (sc->nbcnvifs >= ATH_BCBUF) {
-- 
1.7.0.4

