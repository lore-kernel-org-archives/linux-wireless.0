Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shetland.sei.cmu.edu ([192.58.107.44]:35583 "EHLO
	shetland.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760668AbbJ3VMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 17:12:30 -0400
From: arwelle@cert.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211_hwsim: Implements a check for ATTR_FREQ inside hwsim_cloned_frame_received_nl
Date: Fri, 30 Oct 2015 17:00:20 -0400
Message-Id: <1446238820-21004-1-git-send-email-arwelle@cert.org> (sfid-20151030_221236_751536_542657CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Welle <arwelle@cert.org>

If a frame is received from netlink with this value set it is checked against the current radio's frequency and discarded if different.

Signed-off-by: Adam Welle <arwelle@cert.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee46f46..78faa72 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2827,10 +2827,17 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
-	/* TODO: Check ATTR_FREQ if it exists, and maybe throw away off-channel
-	 * packets?
-	 */
-	rx_status.freq = data2->channel->center_freq;
+
+	/* Check ATTR_FREQ if it exists, and throw away off-channel packets */
+	if (info->attrs[HWSIM_ATTR_FREQ])
+		rx_status.freq = nla_get_u32(info->attrs[HWSIM_ATTR_FREQ]);
+	else
+		rx_status.freq = data2->channel->center_freq;
+
+	/* Drop packet if not on the same frequency as this radio */
+	if (rx_status.freq != data2->channel->center_freq)
+		goto out;
+
 	rx_status.band = data2->channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
-- 
2.1.4

