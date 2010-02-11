Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13615 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab0BKSm2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:28 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: fix AMSDU Rx after paged Rx patch
Date: Thu, 11 Feb 2010 10:42:22 -0800
Message-Id: <1265913742-4340-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Previous patch "use paged Rx" broke AMSDU Rx functionality. If an AP
sends out A-MSDU packets the station will crash.  Fix it by linearizing
skbuff for AMSDU packet before handing it to mac80211 since mac80211
doesn't support paged skbuff.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2155

Reported-by: Norbert Preining <preining@logic.at>
Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

This patchs is also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-rx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 6f36b6e..2dbce85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -928,7 +928,10 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	if (ieee80211_is_mgmt(fc) ||
 	    ieee80211_has_protected(fc) ||
 	    ieee80211_has_morefrags(fc) ||
-	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)
+	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG ||
+	    (ieee80211_is_data_qos(fc) &&
+	     *ieee80211_get_qos_ctl(hdr) &
+	     IEEE80211_QOS_CONTROL_A_MSDU_PRESENT))
 		ret = skb_linearize(skb);
 	else
 		ret = __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, len)) ?
-- 
1.6.3.3

