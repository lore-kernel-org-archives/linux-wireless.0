Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:32829 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbcJJQs3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 12:48:29 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCH v2] mac80211: enable to inject a-msdu frames using monitor interface
Date: Mon, 10 Oct 2016 18:48:25 +0200
Message-Id: <1476118105-7641-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161010_184833_583724_39D6EFF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Problem: When injecting an A-MSDU using a PF_PACKET socket, the qos flag
IEEE80211_QOS_CTL_A_MSDU_PRESENT is cleared.

How to reproduce: Inject a frame on a mac80211 hwsim monitor interface and
have tshark sniffing on this monitor interface.
You'll see the packet twice: Once with correct flag and once with flag
cleared. On hwsim0, you'll only see the packet with a cleared flag.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/wme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 9eb0aee..f6a708c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -248,6 +248,11 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 	/* preserve EOSP bit */
 	ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
 
+	/* preserve A-MSDU bit for MONITOR interfaces to allow injecting
+	 * A-MSDU frames
+	 */
+	ack_policy |= *p & IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->noack_map & BIT(tid)) {
 		ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
-- 
2.1.4
