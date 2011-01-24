Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58065 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1AXSo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 13:44:59 -0500
Received: by ywe10 with SMTP id 10so1008480ywe.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 10:44:58 -0800 (PST)
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: brudley@broadcom.com, henryp@broadcom.com, dowan@broadcom.com,
	vossen@broadcom.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] brcm80211: fix error report string
Date: Mon, 24 Jan 2011 16:45:23 -0200
Message-Id: <1295894723-28346-1-git-send-email-padovan@profusion.mobi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 drivers/staging/brcm80211/sys/wlc_mac80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 5eb41d6..ee1bcc5 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -6910,7 +6910,7 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 		preamble = 0;
 		if (IS_CCK(rspec)) {
 			if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
-				WL_ERROR("Short CCK\n");
+				WL_ERROR("%s: Short CCK\n, __func__");
 			rx_status->flag |= RX_FLAG_SHORTPRE;
 		} else if (IS_OFDM(rspec)) {
 			rx_status->flag |= RX_FLAG_SHORTPRE;
-- 
1.7.4.rc2

