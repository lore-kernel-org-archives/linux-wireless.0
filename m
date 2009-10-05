Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31219 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZJERhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2009 13:37:41 -0400
Subject: [PATCH] iwlwifi: use %pM for formatted MAC addresses
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Oct 2009 11:37:01 -0600
Message-ID: <20091005173701.28350.85734.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User-visible messages should use formatted MAC addresses ("00:01:...")
rather than raw ("0001...") so they match other parts of the system.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: ilw@linux.intel.com
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index a16bd41..cbb0585 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -702,7 +702,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		u8 sta_id = iwl_find_station(priv, hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_RATE(priv, "LQ: ADD station %pm\n",
+			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
 				       hdr->addr1);
 			sta_id = iwl_add_station(priv, hdr->addr1, false,
 				CMD_ASYNC, NULL);

