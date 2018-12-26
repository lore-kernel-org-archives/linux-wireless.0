Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7173C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E72214D8
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545864577;
	bh=7ZIPItXITmPQYVXlukkA3DSHCGg4Ob16j3JgVQjedjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u010uEE1eZCKKq3c7286LeV1aqayCzGxn3nwe+iYt/T6aovqwx5QxjxJzp77URUQc
	 bu3jRoMVlYMm8/rCMXXq2rIPIhNHYzV9Q7VJQr8yetAbDyL/mV334t5qh2W5TJh6zl
	 x/Vu+iX6+EUmrgcNpMjJZvWK7qDWZ6Iz0fSBEdJ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbeLZWth (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Dec 2018 17:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbeLZWhv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Dec 2018 17:37:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1491E218E2;
        Wed, 26 Dec 2018 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545863870;
        bh=7ZIPItXITmPQYVXlukkA3DSHCGg4Ob16j3JgVQjedjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvBVI9W5+SBvnzGNx6xzOiP4iV56MU2hJxiyxA0y4t04R3YrtuaG2AxyOofe23ktP
         VlnQvEC42IXcjXo/QhlWbSPhQ0gYI9L+0J8Lx6SYEmPm9FcM1dhH7vFZVBvHLZGyKh
         LxS6TGItfMJLIbWGevdhd49QgL9LqirFBS1IdgqU=
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 65/97] mac80211: fix a kernel panic when TXing after TXQ teardown
Date:   Wed, 26 Dec 2018 17:35:25 -0500
Message-Id: <20181226223557.149329-65-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit a50e5fb8db83c5b57392204c21ea6c5c4ccefde6 ]

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
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 3 +++
 net/mac80211/main.c  | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5f3c81e705c7..3a0171a65db3 100644
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
@@ -1951,6 +1952,8 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	WARN(local->open_count, "%s: open count remains %d\n",
 	     wiphy_name(local->hw.wiphy), local->open_count);
 
+	ieee80211_txq_teardown_flows(local);
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 513627896204..68db2a356443 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1198,7 +1198,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	rtnl_unlock();
 	ieee80211_led_exit(local);
 	ieee80211_wep_free(local);
-	ieee80211_txq_teardown_flows(local);
  fail_flows:
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
@@ -1224,7 +1223,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 #if IS_ENABLED(CONFIG_IPV6)
 	unregister_inet6addr_notifier(&local->ifa6_notifier);
 #endif
-	ieee80211_txq_teardown_flows(local);
 
 	rtnl_lock();
 
-- 
2.19.1

