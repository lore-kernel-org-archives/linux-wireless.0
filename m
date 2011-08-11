Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51531 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab1HKJI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 05:08:29 -0400
Received: by fxh19 with SMTP id 19so1526711fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 02:08:28 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Tear down BA session on BAR tx failure
Date: Thu, 11 Aug 2011 11:08:17 +0200
Message-Id: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110811_110838_357586_918C4354)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As described at [1] some STAs (i.e. Intel 5100 on Windows) can end up
correctly BlockAcking incoming frames without delivering them to user
space if a AMPDU subframe got lost and its reorder buffer isn't flushed
by a BlockAckReq. This in turn results in up to 64 frames being stuck
in the reorder buffer.

Accroding to 802.11n-2009 it is not necessary to send a BAR to flush
the receipients RX reorder buffer but we still do that to be polite.

However, assume the following frame exchange:

AP -> STA, AMPDU (failed)
AP -> STA, BAR (failed)

The client in question then ends up in the same situation and won't
deliver frames to userspace anymore since we weren't able to flush
its reorder buffer.

This is not a hypothetical situation but I was able to observe this
exact behavior during a stress test between a rt2800pci AP and a Intel
5100 Windows client.

In order to work around this issue just tear down the BA session as
soon as a BAR failed to be TX'ed.

[1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/66867

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

IMHO the Windows driver is just buggy and should be fixed to use a
reasonable timeout for flushing its reorder buffer but the described
behavior doesn't appear with the Ralink Legacy drivers for example since
they trigger a tear down of the BA session in several other situations
as well (a single failed AMPDU :) for example) and thus don't end up in
this situation.

Johannes, feel free to NACK this patch as it really is just a
workaround for buggy clients but I'd say it still makes sense to fall
back to non-aggregated frames in such a situation. Furthermore, this
situation is unlikely to happen very often but as written before I was
able to reproduce it a couple of times.

Thanks,
Helmut
 
 net/mac80211/status.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 1658efa..6c4b728 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -187,6 +187,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	int rates_idx = -1;
 	bool send_to_cooked;
 	bool acked;
+	struct ieee80211_bar *bar;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if (info->status.rates[i].idx < 0) {
@@ -243,6 +244,18 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 					   tid, ssn);
 		}
 
+		if (!acked && ieee80211_is_back_req(fc)) {
+			/*
+			 * BAR failed, let's tear down the BA session as a
+			 * last resort as some STAs (Intel 5100 on Windows)
+			 * can get stuck when the BA window isn't flushed
+			 * correctly.
+			 */
+			bar = (struct ieee80211_bar *) skb->data;
+			ieee80211_stop_tx_ba_session(&sta->sta,
+						     bar->control >> 12 & 0xf);
+		}
+
 		if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 			ieee80211_handle_filtered_frame(local, sta, skb);
 			rcu_read_unlock();
-- 
1.7.3.4

