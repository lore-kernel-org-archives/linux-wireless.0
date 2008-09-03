Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYICUm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 16:42:26 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] iwlwifi: rs - take a fresh set of supported rates at each cycle
Date: Wed,  3 Sep 2008 23:42:18 +0300
Message-Id: <1220474540-16737-2-git-send-email-tomas.winkler@intel.com> (sfid-20080903_224230_367973_87585B6A)
In-Reply-To: <1220474540-16737-1-git-send-email-tomas.winkler@intel.com>
References: <1220474540-16737-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Regression iwl-agn-rs IBSS: work in single rate.

This patch fixes regression in iwlwifi IBSS rate scaling caused by patch:

commit 6bc37c06bc424bcf3f944e6a79e2d5bb537e02ed
Author: Vladimir Koutny <vlado@work.ksp.sk>
Date:   Fri Jun 13 16:50:44 2008 +0200

    mac80211: eliminate IBSS warning in rate_lowest_index()

An IBSS station might added on reception of a packet that doesn't
carry rate information (beacon, probe resp). In that case the rate
scaling was initialized only with single rate matching the received packet
rate with the hope that correct rate scale information will be updated
when beacon or probe for that station will arrive.

iwl-agn-rs copied supported rates on initialization and was never updated
again.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Vladimir Koutny <vlado@work.ksp.sk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 754fef5..3dc57f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1668,6 +1668,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		return;
 
 	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
+	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

