Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbYICDbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:39 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 34/39] iwlwifi: take a fresh set of supported rates at each cycle
Date: Wed,  3 Sep 2008 11:26:54 +0800
Message-Id: <1220412419-15404-35-git-send-email-yi.zhu@intel.com> (sfid-20080903_055042_126109_5C8673FA)
In-Reply-To: <1220412419-15404-34-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-33-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-34-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes regression in iwlwifi IBSS rate scaling caused by the
patch named "mac80211: eliminate IBSS warning in rate_lowest_index()"
by Vladimir Koutny <vlado@work.ksp.sk>.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index c1b70c8..169c548 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1669,6 +1669,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		return;
 
 	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
+	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
 
-- 
1.5.3.6

