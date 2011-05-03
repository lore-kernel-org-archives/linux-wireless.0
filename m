Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2371 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 11/61] staging: brcm80211: remove unnecessary if
 statements from bss_info_changed
Date: Tue, 3 May 2011 11:35:11 +0200
Message-ID: <1304415361-7813-12-git-send-email-arend@broadcom.com> (sfid-20110503_113643_142977_983A1CDC)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 api callback bss_info_changed contained two placeholders
that were expected to need to be implemented. However, reading the mac80211
notes (http://wireless.kernel.org/en/developers/Documentation/mac80211/API)
shows that it is not needed as the driver honours the flags provided with
the transmit sk_buff.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 7e9ed52..8144587 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -346,17 +346,6 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 			  __func__, info->assoc ? "" : "dis");
 		wlc_associate_upd(wl->wlc, info->assoc);
 	}
-	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		/* CTS protection changed */
-		wiphy_err(wiphy, "%s: use_cts_prot: %s (implement)\n", __func__,
-			  info->use_cts_prot ? "true" : "false");
-	}
-	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		/* preamble changed */
-		wiphy_err(wiphy, "%s: short preamble: %s (implement)\n",
-			  __func__, info->use_short_preamble ? "true" :
-			  "false");
-	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		/* slot timing changed */
 		if (info->use_short_slot)
-- 
1.7.4.1


