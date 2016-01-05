Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36065 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbcAEQmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:42:39 -0500
Received: by mail-wm0-f42.google.com with SMTP id l65so29699418wmf.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 08:42:38 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2] mac80211: Don't buffer non-bufferable MMPDUs
Date: Tue,  5 Jan 2016 17:42:13 +0100
Message-Id: <1452012133-19157-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20160105_174246_843756_2BDF6BD9)
In-Reply-To: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com>
References: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Non-bufferable MMPDUs are sent out to STAs even while in PS mode
(for example probe responses). Applying filtered frame handling for
these doesn't seem to make much sense and will only create more
air utilization when the STA wakes up. Hence, apply filtered frame
handling only for bufferable MMPDUs.

Discovered while testing an old VOIP phone that started probing
for APs while in PS mode. The mac80211/ath9k AP where the STA is
associated would reply with a probe response but the phone sometimes
moved to a new channel already and couldn't ack the probe response
anymore. In that case mac80211 applied filtered frame handling
for the un-acked probe response.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Changes in v2: Check IEEE80211_TX_CTL_NO_PS_BUFFER instead of frame_control field

 net/mac80211/status.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 5bad05e..6101deb 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -51,6 +51,11 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	int ac;
 
+	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER) {
+		ieee80211_free_txskb(&local->hw, skb);
+		return;
+	}
+
 	/*
 	 * This skb 'survived' a round-trip through the driver, and
 	 * hopefully the driver didn't mangle it too badly. However,
-- 
1.8.4.5

