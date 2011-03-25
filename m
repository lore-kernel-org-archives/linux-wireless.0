Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab1CYObi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/12] iwlwifi: limit number of attempts for highest HT rate
Date: Fri, 25 Mar 2011 07:14:09 -0700
Message-Id: <1301062456-17249-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

When filling out its rate scale table, iwlwifi repeats the first HT rate
IWL_HT_NUMBER_TRY times. The hardware scheduler will stop using
aggregation for any frame that fails LINK_QUAL_AGG_DISABLE_START_DEF
times. Currently, both these constants equal 3.

If iwlwifi probes a faster rate than the link supports, all frames in a
(potentially tens of frames large) batch will fail IWL_HT_NUMBER_TRY
times. Because this happens to be as large as
LINK_QUAL_AGG_DISABLE_START_DEF, all frames will then be sent
individually. This leads to a short, but performance-degrading window
where the legacy stop-and-wait MAC takes over.

Bounding the initial rate by (LINK_QUAL_AGG_DISABLE_START_DEF-1)
attempts makes the third try use a lower rate and hence more be likely
to succeed. This somewhat mitigates the above described behavior.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index d03b473..63b58ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2912,7 +2912,8 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		ant_toggle_cnt = 1;
 		repeat_rate = IWL_NUMBER_TRY;
 	} else {
-		repeat_rate = IWL_HT_NUMBER_TRY;
+		repeat_rate = min(IWL_HT_NUMBER_TRY,
+				  LINK_QUAL_AGG_DISABLE_START_DEF - 1);
 	}
 
 	lq_cmd->general_params.mimo_delimiter =
-- 
1.7.0.4

