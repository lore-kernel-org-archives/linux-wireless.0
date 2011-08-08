Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10562 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1HHJKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 05:10:37 -0400
Date: Mon, 8 Aug 2011 12:10:30 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211: Indicate driver-based offchannel TX on
 mgmt_tx_cancel_wait
Message-ID: <20110808091030.GA4749@jouni.qca.qualcomm.com> (sfid-20110808_111040_754087_DE164C85)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that support frame transmission with mgmt_tx() may not support
driver-based offchannel TX. Use mgmt_tx_cancel_wait instead of mgmt_tx
when figuring out whether to indicate support for this with
NL80211_ATTR_OFFCHANNEL_TX_OK.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ec8444e..ca76977 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -871,8 +871,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_U32(msg, NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
 			    dev->wiphy.max_remain_on_channel_duration);
 
-	/* for now at least assume all drivers have it */
-	if (dev->ops->mgmt_tx)
+	if (dev->ops->mgmt_tx_cancel_wait)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_OFFCHANNEL_TX_OK);
 
 	if (mgmt_stypes) {
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
