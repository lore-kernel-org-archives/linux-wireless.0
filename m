Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58575 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1HKORy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 10:17:54 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so1694353fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 07:17:54 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2 2/2] mac80211: Tear down BA session on BAR tx failure
Date: Thu, 11 Aug 2011 16:17:42 +0200
Message-Id: <1313072262-25413-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20110811_161758_327900_A241E512)
In-Reply-To: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com>
References: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As described at [1] some STAs (i.e. Intel 5100 Windows) can end up
correctly BlockAcking incoming frames without delivering them to user
space if a AMPDU subframe got lost and we don't flush the receipients
reorder buffer with a BlockAckReq. This in turn results in stuck
connections.

According to 802.11n-2009 it is not necessary to send a BAR to flush
the recepients RX reorder buffer but we still do that to be polite.

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

Changes since v1:
- Fix commit message typos
- Make use of IEEE80211_BAR_CTRL_* defines
- Exclude Multi TID BARs (we don't send Multi TID bars yet and they need
  multiple TIDs being processed)

 net/mac80211/status.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 1658efa..02a8c13 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -187,6 +187,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	int rates_idx = -1;
 	bool send_to_cooked;
 	bool acked;
+	struct ieee80211_bar *bar;
+	u16 tid;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if (info->status.rates[i].idx < 0) {
@@ -243,6 +245,22 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
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
+			if (!(bar->control & IEEE80211_BAR_CTRL_MULTI_TID)) {
+				tid = (bar->control &
+				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
+				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
+				ieee80211_stop_tx_ba_session(&sta->sta, tid);
+			}
+		}
+
 		if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 			ieee80211_handle_filtered_frame(local, sta, skb);
 			rcu_read_unlock();
-- 
1.7.3.4

