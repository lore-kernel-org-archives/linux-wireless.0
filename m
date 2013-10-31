Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49158 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3JaOlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 10:41:04 -0400
From: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <j@w1.fi>, <usdutt@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Introduce critical protocol indication for p2p connection.
Date: Thu, 31 Oct 2013 20:10:52 +0530
Message-ID: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com> (sfid-20131031_154108_037102_6F3E1A6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A reliable P2P connection needs to avoid any offload off channel
operations triggered by the host driver.Thus, indicate such
attempts to the host driver by including a new protocol id,
signifying the p2p connection.

Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8f01961..cae07aa 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3894,6 +3894,7 @@ enum nl80211_protocol_features {
  * @NL80211_CRIT_PROTO_DHCP: BOOTP or DHCPv6 protocol.
  * @NL80211_CRIT_PROTO_EAPOL: EAPOL protocol.
  * @NL80211_CRIT_PROTO_APIPA: APIPA protocol.
+ * @NL80211_CRIT_PROTO_P2P: P2P protocol.
  * @NUM_NL80211_CRIT_PROTO: must be kept last.
  */
 enum nl80211_crit_proto_id {
@@ -3901,6 +3902,7 @@ enum nl80211_crit_proto_id {
 	NL80211_CRIT_PROTO_DHCP,
 	NL80211_CRIT_PROTO_EAPOL,
 	NL80211_CRIT_PROTO_APIPA,
+	NL80211_CRIT_PROTO_P2P,
 	/* add other protocols before this one */
 	NUM_NL80211_CRIT_PROTO
 };
-- 
1.8.2.1

