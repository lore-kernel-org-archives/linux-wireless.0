Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9060C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 05:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C753218A1
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 05:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfBFF7w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 00:59:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55522 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725897AbfBFF7w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 00:59:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grGFS-00014d-CR; Wed, 06 Feb 2019 07:59:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date:   Wed,  6 Feb 2019 07:59:42 +0200
Message-Id: <20190206055943.11757-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206055943.11757-1-luca@coelho.fi>
References: <96393f6a0a9d06776260368db9d2fd89c11cd33b.camel@coelho.fi>
 <20190206055943.11757-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/2] cfg80211: pmsr: fix MAC address setting
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When we destroy the interface we already hold the wdev->mtx
while calling cfg80211_pmsr_wdev_down(), which assumes this
isn't true and flushes the worker that takes the lock, thus
leading to a deadlock.

Fix this by refactoring the worker and calling its code in
cfg80211_pmsr_wdev_down() directly.

We still need to flush the work later to make sure it's not
still running and will crash, but it will not do anything.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c |  2 ++
 net/wireless/pmsr.c | 22 +++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 623dfe5e211c..b36ad8efb5e5 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1068,6 +1068,8 @@ static void __cfg80211_unregister_wdev(struct wireless_dev *wdev, bool sync)
 
 	ASSERT_RTNL();
 
+	flush_work(&wdev->pmsr_free_wk);
+
 	nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);
 
 	list_del_rcu(&wdev->list);
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index f2e388e329fd..78c3f5633692 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -529,14 +529,14 @@ void cfg80211_pmsr_report(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL_GPL(cfg80211_pmsr_report);
 
-void cfg80211_pmsr_free_wk(struct work_struct *work)
+static void cfg80211_pmsr_process_abort(struct wireless_dev *wdev)
 {
-	struct wireless_dev *wdev = container_of(work, struct wireless_dev,
-						 pmsr_free_wk);
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_pmsr_request *req, *tmp;
 	LIST_HEAD(free_list);
 
+	lockdep_assert_held(&wdev->mtx);
+
 	spin_lock_bh(&wdev->pmsr_lock);
 	list_for_each_entry_safe(req, tmp, &wdev->pmsr_list, list) {
 		if (req->nl_portid)
@@ -546,14 +546,22 @@ void cfg80211_pmsr_free_wk(struct work_struct *work)
 	spin_unlock_bh(&wdev->pmsr_lock);
 
 	list_for_each_entry_safe(req, tmp, &free_list, list) {
-		wdev_lock(wdev);
 		rdev_abort_pmsr(rdev, wdev, req);
-		wdev_unlock(wdev);
 
 		kfree(req);
 	}
 }
 
+void cfg80211_pmsr_free_wk(struct work_struct *work)
+{
+	struct wireless_dev *wdev = container_of(work, struct wireless_dev,
+						 pmsr_free_wk);
+
+	wdev_lock(wdev);
+	cfg80211_pmsr_process_abort(wdev);
+	wdev_unlock(wdev);
+}
+
 void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 {
 	struct cfg80211_pmsr_request *req;
@@ -567,8 +575,8 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	spin_unlock_bh(&wdev->pmsr_lock);
 
 	if (found)
-		schedule_work(&wdev->pmsr_free_wk);
-	flush_work(&wdev->pmsr_free_wk);
+		cfg80211_pmsr_process_abort(wdev);
+
 	WARN_ON(!list_empty(&wdev->pmsr_list));
 }
 
-- 
2.20.1

