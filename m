Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63964 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1DZU1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:27:30 -0400
Received: by wwa36 with SMTP id 36so1147917wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 13:27:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: report MIC failure for truncated packets in AP mode
Date: Tue, 26 Apr 2011 23:27:22 +0300
Message-Id: <1303849642-9014-1-git-send-email-arik@wizery.com> (sfid-20110426_222733_585236_1FDE31FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MIC failure notifications for packets too short to contain a key index
are currently ignored in AP-mode. Fix the check to only ignore packets
with an existing non-zero key index.

The wl12xx chip always truncates packets with a failed MIC and requires
this change to operate correctly in AP-mode.

No such check is made in STA mode. Therefore its relatively safe to assume
there's no other HW that relies on the current code to avoid spurious
MIC failures with correct yet truncated packets.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a864890..875fc3c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2391,7 +2391,7 @@ static void ieee80211_rx_michael_mic_report(struct ieee80211_hdr *hdr,
 	if (!ieee80211_has_protected(hdr->frame_control))
 		return;
 
-	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
+	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx > 0) {
 		/*
 		 * APs with pairwise keys should never receive Michael MIC
 		 * errors for non-zero keyidx because these are reserved for
-- 
1.7.1

