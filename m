Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36241 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbcAEOhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:37:36 -0500
Received: by mail-wm0-f48.google.com with SMTP id l65so25151956wmf.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:37:36 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Don't buffer non-bufferable MMPDUs
Date: Tue,  5 Jan 2016 15:37:12 +0100
Message-Id: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20160105_153752_428924_A43877DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Non-bufferable MMPDUs are sent out to STAs even while in PS mode
(for example probe responses). Applying filtered frame handling for
these doesn't seem to make much sense and will only create more
air utilization when the STA wakes up. Hence, apply filtered frame
handling only for bufferable MMPDUs.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/status.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 5bad05e..14bd53b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -51,6 +51,12 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	int ac;
 
+	if (ieee80211_is_mgmt(hdr->frame_control) &&
+	    !ieee80211_is_bufferable_mmpdu(hdr->frame_control)) {
+		ieee80211_free_txskb(&local->hw, skb);
+		return;
+	}
+
 	/*
 	 * This skb 'survived' a round-trip through the driver, and
 	 * hopefully the driver didn't mangle it too badly. However,
-- 
1.8.4.5

