Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54817 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYJWGqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:46:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 23:46:34 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18688.7474.39470.106619@gargle.gargle.HOWL> (sfid-20081023_084637_368301_34D3DF00)
Date: Thu, 23 Oct 2008 12:14:02 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>, <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Change WARN_ON to WARN_ON_ONCE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A warning would be printed for every packet that
is transmitted if the rate control information isn't
setup. Change this to WARN_ON_ONCE.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8b56048..3678325 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -565,8 +565,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 				IEEE80211_TX_RC_USE_RTS_CTS;
 
 		/* RC is busted */
-		if (WARN_ON(info->control.rates[i].idx >=
-			    sband->n_bitrates)) {
+		if (WARN_ON_ONCE(info->control.rates[i].idx >=
+				 sband->n_bitrates)) {
 			info->control.rates[i].idx = -1;
 			continue;
 		}
-- 
1.6.0.2

