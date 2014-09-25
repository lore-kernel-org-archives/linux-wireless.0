Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47084 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaIYVW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 17:22:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] mac-hwsim:  fix typo, remove un-needed goto.
Date: Thu, 25 Sep 2014 14:22:20 -0700
Message-Id: <1411680140-20208-3-git-send-email-greearb@candelatech.com> (sfid-20140925_232230_930961_33066EEF)
In-Reply-To: <1411680140-20208-1-git-send-email-greearb@candelatech.com>
References: <1411680140-20208-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Trivial cleanups.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ae90438..43435c0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -436,7 +436,7 @@ struct mac80211_hwsim_data {
 	/*
 	 * Only radios in the same group can communicate together (the
 	 * channel has to match too). Each bit represents a group. A
-	 * radio can be in more then one group.
+	 * radio can be in more than one group.
 	 */
 	u64 group;
 
@@ -2465,7 +2465,6 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	return 0;
 err:
 	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
-	goto out;
 out:
 	dev_kfree_skb(skb);
 	return -EINVAL;
-- 
1.7.11.7

