Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43344 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1AXVfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:35:11 -0500
Received: by gwj20 with SMTP id 20so1444370gwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 13:35:11 -0800 (PST)
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: brudley@broadcom.com, henryp@broadcom.com, dowan@broadcom.com,
	rvossen@broadcom.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] brcm80211: fix error report string
Date: Mon, 24 Jan 2011 19:35:46 -0200
Message-Id: <1295904946-11983-1-git-send-email-padovan@profusion.mobi>
In-Reply-To: <AANLkTi=GqWNd6yu0CeWAzt9ZRgCDkFRgwMExZiqEUr3Z@mail.gmail.com>
References: <AANLkTi=GqWNd6yu0CeWAzt9ZRgCDkFRgwMExZiqEUr3Z@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 drivers/staging/brcm80211/sys/wlc_mac80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 5eb41d6..a23dc5c 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -6910,7 +6910,7 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 		preamble = 0;
 		if (IS_CCK(rspec)) {
 			if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
-				WL_ERROR("Short CCK\n");
+				WL_ERROR("%s: Short CCK\n", __func__);
 			rx_status->flag |= RX_FLAG_SHORTPRE;
 		} else if (IS_OFDM(rspec)) {
 			rx_status->flag |= RX_FLAG_SHORTPRE;
-- 
1.7.4.rc2

