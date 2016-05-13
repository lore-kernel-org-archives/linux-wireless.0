Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:58682 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbcEMKmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 06:42:04 -0400
From: Martin Willi <martin@strongswan.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Add missing check for HWSIM_ATTR_SIGNAL
Date: Fri, 13 May 2016 12:41:48 +0200
Message-Id: <1463136108-4434-1-git-send-email-martin@strongswan.org> (sfid-20160513_124209_190429_B7FDC681)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A wmediumd that does not send this attribute causes a NULL pointer
dereference, as the attribute is accessed even if it does not exist.

The attribute was required but never checked ever since userspace frame
forwarding has been introduced. The issue gets more problematic once we
allow wmediumd registration from user namespaces.

Fixes: 7882513bacb1 ("mac80211_hwsimdriver support userspace frame tx/rx")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 303d94d..a16cd0c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2817,6 +2817,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
 	    !info->attrs[HWSIM_ATTR_FLAGS] ||
 	    !info->attrs[HWSIM_ATTR_COOKIE] ||
+	    !info->attrs[HWSIM_ATTR_SIGNAL] ||
 	    !info->attrs[HWSIM_ATTR_TX_INFO])
 		goto out;
 
-- 
2.7.4

