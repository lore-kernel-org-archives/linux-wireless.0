Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta21.charter.net ([216.33.127.81]:64404 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1FCDYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 23:24:13 -0400
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 5/5 v2] iwlegacy: add missing null check
Date: Thu,  2 Jun 2011 22:24:06 -0500
Message-Id: <1307071446-28730-1-git-send-email-Gregory.Dietsche@cuw.edu> (sfid-20110603_052435_043379_1968D055)
In-Reply-To: <20110603030746.GA4834@joana>
References: <20110603030746.GA4834@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

lq_sta has other null checks in this function.
assuming they are correct, this additional null check
should be added too.

Incorporating suggestion from Gustavo Padovan.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 24d1499..9b65153 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -2275,6 +2275,9 @@ iwl4965_rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
+	if (!lq_sta)
+		return;
+
 	rate_idx  = lq_sta->last_txrate_idx;
 
 	if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
-- 
1.7.2.5

