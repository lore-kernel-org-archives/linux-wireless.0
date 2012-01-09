Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63616 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab2AIIhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:37:50 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 6/8] ath6kl: Configure WOW patterns while going to wow_suspend
Date: Mon, 9 Jan 2012 14:06:20 +0530
Message-ID: <1326098182-9103-7-git-send-email-rmani@qca.qualcomm.com> (sfid-20120109_093753_251562_634FA0F1)
In-Reply-To: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

First preference is given to the user configured WOW patterns.
If the user doesn't configure any patterns (for ex, via iw command),
the default patterns will be configured while going to WOW suspend.

Make use of ath6kl_ap_add_default_wow_patterns() and
ath6kl_non_ap_add_default_wow_patterns() func to configure
default WOW patterns.

Additionally, new conditional check is added to make sure user
configured pattern count is within the limit (WOW_MAX_FILTERS_PER_LIST).

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 347c5a4..a8880af 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1923,10 +1923,27 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	if (!test_bit(CONNECTED, &vif->flags))
 		return -EINVAL;
 
+	if (wow && (wow->n_patterns > WOW_MAX_FILTERS_PER_LIST))
+		return -EINVAL;
+
 	/* Clear existing WOW patterns */
 	for (i = 0; i < WOW_MAX_FILTERS_PER_LIST; i++)
 		ath6kl_wmi_del_wow_pattern_cmd(ar->wmi, vif->fw_vif_idx,
 					       WOW_LIST_ID, i);
+	/*
+	 * Skip the default WOW pattern configuration if the driver
+	 * receives any WOW patterns from the user.
+	 */
+	if (wow)
+		ret = ath6kl_add_usr_wow_patterns(ar, vif, wow, &filter);
+	else if (vif->nw_type == AP_NETWORK)
+		ret = ath6kl_ap_add_default_wow_patterns(ar, vif);
+	else
+		ret = ath6kl_non_ap_add_default_wow_patterns(ar, vif);
+
+	if (ret)
+		return ret;
+
 	/* Setup own IP addr for ARP agent. */
 	in_dev = __in_dev_get_rtnl(vif->ndev);
 	if (!in_dev)
-- 
1.7.1

