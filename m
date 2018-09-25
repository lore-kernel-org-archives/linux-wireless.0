Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3FEC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D76120877
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D76120877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=strongswan.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbeIYNri (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 09:47:38 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:57408 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728751AbeIYNri (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 09:47:38 -0400
Received: from book.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 9CBF740A78;
        Tue, 25 Sep 2018 09:41:27 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH 1/3] mac80211_hwsim: fix locking when iterating radios during ns exit
Date:   Tue, 25 Sep 2018 09:41:13 +0200
Message-Id: <20180925074115.18169-2-martin@strongswan.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20180925074115.18169-1-martin@strongswan.org>
References: <20180925074115.18169-1-martin@strongswan.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The cleanup of radios during namespace exit has recently been reworked
to directly delete a radio while temporarily releasing the spinlock,
fixing a race condition between the work-queue execution and namespace
exits. However, the temporary unlock allows unsafe modifications on the
iterated list, resulting in a potential crash when continuing the
iteration of additional radios.

Move radios about to destroy to a temporary list, and clean that up
after releasing the spinlock once iteration is complete.

Fixes: 8cfd36a0b53a ("mac80211_hwsim: fix use-after-free bug in hwsim_exit_net")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f3863101af78..8c76e9a3499a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3642,6 +3642,7 @@ static __net_init int hwsim_init_net(struct net *net)
 static void __net_exit hwsim_exit_net(struct net *net)
 {
 	struct mac80211_hwsim_data *data, *tmp;
+	LIST_HEAD(list);
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry_safe(data, tmp, &hwsim_radios, list) {
@@ -3652,17 +3653,19 @@ static void __net_exit hwsim_exit_net(struct net *net)
 		if (data->netgroup == hwsim_net_get_netgroup(&init_net))
 			continue;
 
-		list_del(&data->list);
+		list_move(&data->list, &list);
 		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
 				       hwsim_rht_params);
 		hwsim_radios_generation++;
-		spin_unlock_bh(&hwsim_radio_lock);
+	}
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	list_for_each_entry_safe(data, tmp, &list, list) {
+		list_del(&data->list);
 		mac80211_hwsim_del_radio(data,
 					 wiphy_name(data->hw->wiphy),
 					 NULL);
-		spin_lock_bh(&hwsim_radio_lock);
 	}
-	spin_unlock_bh(&hwsim_radio_lock);
 
 	ida_simple_remove(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
 }
-- 
2.17.1

