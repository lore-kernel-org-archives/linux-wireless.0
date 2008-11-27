Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:9847 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYK0Fsq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 00:48:46 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net,
	Zhu Yi <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: [PATCH 2.6.28] ipw2200: fix netif_*_queue() removal regression
Date: Thu, 27 Nov 2008 13:42:20 +0800
Message-Id: <1227764540-9439-1-git-send-email-yi.zhu@intel.com> (sfid-20081127_064903_432791_37326D5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 521c4d96e0840ecce25b956e00f416ed499ef2ba, netif_stop_queue()
and netif_wake_queue() were removed with the reason
"netif_carrier_{on,off}() handles starting and stopping packet flow into
the driver". The patch also removes a valid condition check that
ipw_tx_skb() cannot be called if device is not in STATUS_ASSOCIATED state.
But netif_carrier_off() doesn't guarantee netdev->hard_start_xmit won't
be called because linkwatch event is handled in a delayed workqueue. This
caused a kernel oops reported by Frank Seidel:
https://bugzilla.novell.com/show_bug.cgi?id=397390

This patch fixes the problem by moving the STATUS_ASSOCIATED check back
to ipw_tx_skb(). It also adds a missing netif_carrier_off() call to
ipw_disassociate().

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Chatre, Reinette <reinette.chatre@intel.com>
Tested-by: Frank Seidel <fseidel@suse.de>
---
 drivers/net/wireless/ipw2200.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..7a9f901 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -3897,6 +3897,7 @@ static int ipw_disassociate(void *data)
 	if (!(priv->status & (STATUS_ASSOCIATED | STATUS_ASSOCIATING)))
 		return 0;
 	ipw_send_disassociate(data, 0);
+	netif_carrier_off(priv->net_dev);
 	return 1;
 }
 
@@ -10190,6 +10191,9 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 	u16 remaining_bytes;
 	int fc;
 
+	if (!(priv->status & STATUS_ASSOCIATED))
+		goto drop;
+
 	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 	switch (priv->ieee->iw_mode) {
 	case IW_MODE_ADHOC:
-- 
1.5.3.6

