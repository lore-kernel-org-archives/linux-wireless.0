Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44904 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaLUNZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 08:25:34 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so5885928wiw.7
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 05:25:32 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix dot11MulticastTransmittedFrameCount tested address
Date: Sun, 21 Dec 2014 15:25:28 +0200
Message-Id: <1419168328-6114-1-git-send-email-eliad@wizery.com> (sfid-20141221_142537_501373_27D66430)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dot11MulticastTransmittedFrameCount should be updated according
to the DA, which might be different from hdr1.

(Checking hdr1 results in the counter being 0 in case of station,
as TODS data frames use hdr1 for the bssid address)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/status.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index d64037c..7d4e930 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -862,7 +862,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	    (info->flags & IEEE80211_TX_STAT_NOACK_TRANSMITTED)) {
 		if (ieee80211_is_first_frag(hdr->seq_ctrl)) {
 			local->dot11TransmittedFrameCount++;
-			if (is_multicast_ether_addr(hdr->addr1))
+			if (is_multicast_ether_addr(ieee80211_get_DA(hdr)))
 				local->dot11MulticastTransmittedFrameCount++;
 			if (retry_count > 0)
 				local->dot11RetryCount++;
-- 
1.8.5.1.109.g3d252a9

