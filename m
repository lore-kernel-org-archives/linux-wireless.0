Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shetland.sei.cmu.edu ([192.58.107.44]:45166 "EHLO
	shetland.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbbKBPZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 10:25:03 -0500
From: arwelle@cert.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: check ATTR_FREQ for wmediumd (netlink) packets
Date: Mon,  2 Nov 2015 10:25:00 -0500
Message-Id: <1446477900-10430-1-git-send-email-arwelle@cert.org> (sfid-20151102_162513_205145_D945D54F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Welle <arwelle@cert.org>

If a packet is received from netlink with the frequency value set it is
checked against the current radio's frequency and discarded if different.

Signed-off-by: Adam Welle <arwelle@cert.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee46f46..191b576 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2827,10 +2827,16 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
-	/* TODO: Check ATTR_FREQ if it exists, and maybe throw away off-channel
-	 * packets?
-	 */
-	rx_status.freq = data2->channel->center_freq;
+
+	/* Check ATTR_FREQ if it exists, and throw away off-channel packets */
+	if (info->attrs[HWSIM_ATTR_FREQ]) {
+		rx_status.freq = nla_get_u32(info->attrs[HWSIM_ATTR_FREQ]);
+		if (rx_status.freq != data2->channel->center_freq)
+			goto out;
+	} else {
+		rx_status.freq = data2->channel->center_freq;
+	}
+
 	rx_status.band = data2->channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
-- 
2.1.4

