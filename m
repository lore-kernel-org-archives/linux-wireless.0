Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10274C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED4220877
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BED4220877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=strongswan.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbeIYNri (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 09:47:38 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:57409 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbeIYNri (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 09:47:38 -0400
Received: from book.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id A494440F30;
        Tue, 25 Sep 2018 09:41:27 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH 2/3] mac80211_hwsim: fix race in radio destruction from netlink notifier
Date:   Tue, 25 Sep 2018 09:41:14 +0200
Message-Id: <20180925074115.18169-3-martin@strongswan.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20180925074115.18169-1-martin@strongswan.org>
References: <20180925074115.18169-1-martin@strongswan.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The asynchronous destruction from a work-queue of radios tagged with
destroy-on-close may race with the owning namespace about to exit,
resulting in potential use-after-free of that namespace.

Instead of using a work-queue, move radios about to destroy to a
temporary list, which can be worked on synchronously after releasing
the lock. This should be safe to do from the netlink socket notifier,
as the namespace is guaranteed to not get released.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8c76e9a3499a..09fcd6911020 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -521,7 +521,6 @@ struct mac80211_hwsim_data {
 	int channels, idx;
 	bool use_chanctx;
 	bool destroy_on_close;
-	struct work_struct destroy_work;
 	u32 portid;
 	char alpha2[2];
 	const struct ieee80211_regdomain *regd;
@@ -3561,30 +3560,27 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
 
-static void destroy_radio(struct work_struct *work)
-{
-	struct mac80211_hwsim_data *data =
-		container_of(work, struct mac80211_hwsim_data, destroy_work);
-
-	hwsim_radios_generation++;
-	mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy), NULL);
-}
-
 static void remove_user_radios(u32 portid)
 {
 	struct mac80211_hwsim_data *entry, *tmp;
+	LIST_HEAD(list);
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
 		if (entry->destroy_on_close && entry->portid == portid) {
-			list_del(&entry->list);
+			list_move(&entry->list, &list);
 			rhashtable_remove_fast(&hwsim_radios_rht, &entry->rht,
 					       hwsim_rht_params);
-			INIT_WORK(&entry->destroy_work, destroy_radio);
-			queue_work(hwsim_wq, &entry->destroy_work);
+			hwsim_radios_generation++;
 		}
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
+
+	list_for_each_entry_safe(entry, tmp, &list, list) {
+		list_del(&entry->list);
+		mac80211_hwsim_del_radio(entry, wiphy_name(entry->hw->wiphy),
+					 NULL);
+	}
 }
 
 static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
-- 
2.17.1

