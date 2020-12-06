Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A85C19425
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 12:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 622662310E
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 12:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgLFMz4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 6 Dec 2020 07:55:56 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34914 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727971AbgLFMzm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Dec 2020 07:55:42 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kltZ1-003AHZ-Ik; Sun, 06 Dec 2020 14:54:56 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Sun,  6 Dec 2020 14:54:44 +0200
Message-Id: <iwlwifi.20201206145305.fcc7d29c4590.I11f77e9e25ddf871a3c8d5604650c763e2c5887a@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206125450.564941-1-luca@coelho.fi>
References: <20201206125450.564941-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/11] mac80211: don't set set TDLS STA bandwidth wider than possible
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When we set up a TDLS station, we set sta->sta.bandwidth solely based
on the capabilities, because the "what's the current bandwidth" check
is bypassed and only applied for other types of stations.

This leads to the unfortunate scenario that the sta->sta.bandwidth is
160 MHz if both stations support it, but we never actually configure
this bandwidth unless the AP is already using 160 MHz; even for wider
bandwidth support we only go up to 80 MHz (at least right now.)

For iwlwifi, this can also lead to firmware asserts, telling us that
we've configured the TX rates for a higher bandwidth than is actually
available due to the PHY configuration.

For non-TDLS, we check against the interface's requested bandwidth,
but we explicitly skip this check for TDLS to cope with the wider BW
case. Change this to
 (a) still limit to the TDLS peer's own chandef, which gets factored
     into the overall PHY configuration we request from the driver,
     and
 (b) limit it to when the TDLS peer is authorized, because it's only
     factored into the channel context in this case.

Fixes: 504871e602d9 ("mac80211: fix bandwidth computation for TDLS peers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/vht.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index fb0e3a657d2d..c3ca97373774 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -465,12 +465,18 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 	 * IEEE80211-2016 specification makes higher bandwidth operation
 	 * possible on the TDLS link if the peers have wider bandwidth
 	 * capability.
+	 *
+	 * However, in this case, and only if the TDLS peer is authorized,
+	 * limit to the tdls_chandef so that the configuration here isn't
+	 * wider than what's actually requested on the channel context.
 	 */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
-	    test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW))
-		return bw;
-
-	bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
+	    test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW) &&
+	    test_sta_flag(sta, WLAN_STA_AUTHORIZED) &&
+	    sta->tdls_chandef.chan)
+		bw = min(bw, ieee80211_chan_width_to_rx_bw(sta->tdls_chandef.width));
+	else
+		bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
 
 	return bw;
 }
-- 
2.29.2

