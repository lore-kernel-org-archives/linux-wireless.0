Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1CESfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 13:35:42 -0500
Subject: [PATCH] iwlagn: fix offchannel TX bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 19:35:39 +0100
Message-ID: <1299350139.29845.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the case where remain-on-channel rather than
offchannel TX should be used, my offchannel TX
patch introduced a bug because mac80211 will
use the now-freed SKB.

iwlagn shouldn't free the SKB when it returns 1
here since then the SKB will still be used.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:32:58.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:33:08.000000000 +0100
@@ -3171,7 +3171,7 @@ static int iwl_mac_offchannel_tx(struct
  out:
 	mutex_unlock(&priv->mutex);
  free:
-	if (ret)
+	if (ret < 0)
 		kfree_skb(skb);
 
 	return ret;


