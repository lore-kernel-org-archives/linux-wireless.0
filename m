Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:42752 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaEGTxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:46 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so1500594wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:45 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/23] iwlwifi: mvm: rs: choose correct expected tpt table
Date: Wed,  7 May 2014 22:52:45 +0300
Message-Id: <1399492380-12050-8-git-send-email-egrumbach@gmail.com> (sfid-20140507_215446_738552_5E14C1D4)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The expected throughput table used when estimating a new column
depends on the channel bandwidth. When switching from legacy to
siso or mimo the wrong expected throughput table was used as it
was chosen based on the the channel bandwidth in legacy which is
always 20Mhz. Instead it should be chosen based on the current sta
bandwidth which could be also 40Mhz or 80Mhz.
When enabling MCS9 this bug leads to a problem where the max
expected throughput of the siso or mimo column is 0 as MCS9 isn't
supported in 20Mhz. This in turns prevents switching to siso or mimo.

Fix this by using the sta bandwidth when deciding which table to choose.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 6216618..6d5af48 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1553,7 +1553,7 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 
 		tpt = lq_sta->last_tpt / 100;
 		expected_tpt_tbl = rs_get_expected_tpt_table(lq_sta, next_col,
-							     tbl->rate.bw);
+						     rs_bw_from_sta_bw(sta));
 		if (WARN_ON_ONCE(!expected_tpt_tbl))
 			continue;
 
-- 
1.8.3.2

