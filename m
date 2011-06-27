Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62772 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1F0U6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 16:58:54 -0400
Received: by wyg8 with SMTP id 8so1345783wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 13:58:53 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 2/2] wl12xx: AP-mode - use mac80211 indication about STA WME support
Date: Mon, 27 Jun 2011 23:58:46 +0300
Message-Id: <1309208326-18260-2-git-send-email-arik@wizery.com> (sfid-20110627_230053_023700_1A93AFED)
In-Reply-To: <1309208326-18260-1-git-send-email-arik@wizery.com>
References: <1309208326-18260-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding a station, use the information given in the mac80211
populated ieee80211_sta structure to determine if it supports WME.
Provide this information to the FW.

This patch depends on "mac80211: propagate information about
STA WME support down".

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index b3a4f58..c7f6f60 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1166,14 +1166,7 @@ int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->aid = sta->aid;
 	cmd->hlid = hlid;
-
-	/*
-	 * FIXME: Does STA support QOS? We need to propagate this info from
-	 * hostapd. Currently not that important since this is only used for
-	 * sending the correct flavor of null-data packet in response to a
-	 * trigger.
-	 */
-	cmd->wmm = 0;
+	cmd->wmm = sta->wme ? 1 : 0;
 
 	cmd->supported_rates = cpu_to_le32(wl1271_tx_enabled_rates_get(wl,
 						sta->supp_rates[wl->band]));
-- 
1.7.4.1

