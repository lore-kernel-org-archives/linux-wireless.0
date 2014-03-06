Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:32981 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaCFOQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 09:16:58 -0500
From: Michael Braun <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: Michael Braun <michael-dev@fami-braun.de>,
	<stable@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<projekt-wlan@fem.tu-ilmenau.de>
Subject: [PATCH] mac80211: fix WPA with VLAN on AP side with ps-sta again
Date: Thu,  6 Mar 2014 15:08:43 +0100
Message-Id: <1394114923-6380-1-git-send-email-michael-dev@fami-braun.de> (sfid-20140306_151702_591608_F07B3386)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit de74a1d9032f4d37ea453ad2a647e1aff4cd2591
  "mac80211: fix WPA with VLAN on AP side with ps-sta"
fixed an issue where queued multicast packets would
be sent out encrypted with the key of an other bss.

commit "7cbf9d017dbb5e3276de7d527925d42d4c11e732"
  "mac80211: fix oops on mesh PS broadcast forwarding"
essentially reverted it, because vif.type cannot be AP_VLAN
due to the check to vif.type in ieee80211_get_buffered_bc before.

As the later commit intended to fix the MESH case, fix it
by checking for IFTYPE_AP instead of IFTYPE_AP_VLAN.

Fixes: 7cbf9d017dbb
Cc: <stable@vger.kernel.org> # 3.10.x
Cc: <stable@vger.kernel.org> # 3.11.x
Cc: <stable@vger.kernel.org> # 3.12.x
Cc: <stable@vger.kernel.org> # 3.13.x
Cc: <linux-wireless@vger.kernel.org>
Cc: <projekt-wlan@fem.tu-ilmenau.de>
Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cd9f80498c48..19d36d4117e0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2900,7 +2900,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 		if (!ieee80211_tx_prepare(sdata, &tx, skb))
 			break;
-- 
1.8.3.2

