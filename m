Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB56C43613
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF262084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbeLOJDj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:39 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42248 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730028AbeLOJDj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:39 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rF-0002oc-8m; Sat, 15 Dec 2018 11:03:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:10 +0200
Message-Id: <20181215090325.31604-10-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/24] mac80211: fix a kernel panic when TXing after TXQ teardown
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Recently TXQ teardown was moved earlier in ieee80211_unregister_hw(),
to avoid a use-after-free of the netdev data. However, interfaces
aren't fully removed at the point, and cfg80211_shutdown_all_interfaces
can for example, TX a deauth frame. Move the TXQ teardown to the
point between cfg80211_shutdown_all_interfaces and the free of
netdev queues, so we can be sure they are torn down before netdev
is freed, but after there is no ongoing TX.

Fixes: 77cfaf52eca5 ("mac80211: Run TXQ teardown code before de-registering interfaces")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/iface.c | 3 +++
 net/mac80211/main.c  | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5836ddeac9e3..90ffdd9f756f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -7,6 +7,7 @@
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (c) 2016        Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1949,6 +1950,8 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	WARN(local->open_count, "%s: open count remains %d\n",
 	     wiphy_name(local->hw.wiphy), local->open_count);
 
+	ieee80211_txq_teardown_flows(local);
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 83e71e6b2ebe..7b8320d4a8e4 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1262,7 +1262,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	rtnl_unlock();
 	ieee80211_led_exit(local);
 	ieee80211_wep_free(local);
-	ieee80211_txq_teardown_flows(local);
  fail_flows:
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
@@ -1288,7 +1287,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 #if IS_ENABLED(CONFIG_IPV6)
 	unregister_inet6addr_notifier(&local->ifa6_notifier);
 #endif
-	ieee80211_txq_teardown_flows(local);
 
 	rtnl_lock();
 
-- 
2.19.2

