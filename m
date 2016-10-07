Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:35921 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754792AbcJGU33 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 16:29:29 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCH] mac80211: enable to inject a-msdu frames using monitor interface
Date: Fri,  7 Oct 2016 22:29:22 +0200
Message-Id: <1475872162-2835-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161007_222933_196758_B156759A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Problem: When injecting an A-MSDU using a PF_PACKET socket, the qos flag
IEEE80211_QOS_CTL_A_MSDU_PRESENT is cleared.

How to reproduce: Inject a frame on a mac80211 hwsim monitor interface and
have tshark sniffing on this monitor interface.
You'll see the packet twice: Once with correct flag and once with flag
cleared. On hwsim0, you'll only see the packet with a cleared flag.

I guess the same is needed for packets with IEEE80211_TX_CTRL_AMSDU set.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/wme.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 9eb0aee..3faa972 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -248,6 +248,13 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 	/* preserve EOSP bit */
 	ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
 
+	/* preserve A-MSDU bit for MONITOR interfaces to allow injecting
+	 * A-MSDU frames
+	 */
+	if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+	    info->control.flags & IEEE80211_TX_CTRL_AMSDU)
+		ack_policy |= *p & IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->noack_map & BIT(tid)) {
 		ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
-- 
2.1.4
