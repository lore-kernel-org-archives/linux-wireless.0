Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plainfield.sei.cmu.edu ([192.58.107.45]:45363 "EHLO
	plainfield.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbbLAWOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 17:14:01 -0500
From: arwelle@cert.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211_hwsim: check ATTR_FREQ for wmediumd (netlink) packets
Date: Tue,  1 Dec 2015 17:13:52 -0500
Message-Id: <1449008032-6541-1-git-send-email-arwelle@cert.org> (sfid-20151201_231405_693894_A70D1EA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Welle <arwelle@cert.org>

If a packet is received from netlink with the frequency value set it is
checked against the current radio's frequency and discarded if different.
The frequency is also checked against data2->tmp_chan if non-zero to support
the off-channel/scan case.

Signed-off-by: Adam Welle <arwelle@cert.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 194264c..94c30cb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2876,10 +2876,19 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
-	/* TODO: Check ATTR_FREQ if it exists, and maybe throw away off-channel
-	 * packets?
-	 */
-	rx_status.freq = data2->channel->center_freq;
+	/* Check ATTR_FREQ if it exists, and throw away off-channel packets */
+	if (info->attrs[HWSIM_ATTR_FREQ]) {
+		rx_status.freq = nla_get_u32(info->attrs[HWSIM_ATTR_FREQ]);
+		if (data2->tmp_chan) {
+			if (rx_status.freq != data2->tmp_chan->center_freq)
+				goto out;
+		}
+		if (rx_status.freq != data2->channel->center_freq)
+			goto out;
+	} else {
+			rx_status.freq = data2->channel->center_freq;
+	}
+
 	rx_status.band = data2->channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
-- 
2.1.4

