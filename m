Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C2BC43217
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Nov 2022 02:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbiKSCTG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Nov 2022 21:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiKSCSe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2022 21:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E068C0523;
        Fri, 18 Nov 2022 18:14:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2055CB82672;
        Sat, 19 Nov 2022 02:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FFAC433C1;
        Sat, 19 Nov 2022 02:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824035;
        bh=EOEbAUBC9oY0+jjwQpj5atG/TX43ekcl7mzK0U0e+H0=;
        h=From:To:Cc:Subject:Date:From;
        b=P7V+5W+XY6zPzgbSIQOc6ZM10Xln8okOGKPDLm0Gy8hnbwfApe3OWjf5e4Wbo2Md4
         tXEQBmF/PDnkQynxYmiU/gb6/UbT0FVau3E9rqMZxCJOK9CvfKZIJrtMVBLGJ6u+fw
         moZ3DUonpjt2DPoPdKHpFHzWBm/npMpEnb35hqNpWaU6cZu2M6RGT6SnVQPUfN9h+1
         nTenARpFL7lH6MiOiuSQ4UGSDCEFu0oY1EXdULbdtDzXGZIAknaf1XUN8HM2PVryoo
         bVOPX9g03nAGe3JN3SsQ/crWI9eKjzHtluyodUwA8FcbM/FcBxB36UIdgI+F9WHZI4
         W/j6CLDVFLgow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     taozhang <taozhang@bestechnic.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/27] wifi: mac80211: fix memory free error when registering wiphy fail
Date:   Fri, 18 Nov 2022 21:13:26 -0500
Message-Id: <20221119021352.1774592-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: taozhang <taozhang@bestechnic.com>

[ Upstream commit 50b2e8711462409cd368c41067405aa446dfa2af ]

ieee80211_register_hw free the allocated cipher suites when
registering wiphy fail, and ieee80211_free_hw will re-free it.

set wiphy_ciphers_allocated to false after freeing allocated
cipher suites.

Signed-off-by: taozhang <taozhang@bestechnic.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5311c3cd3050..9617ff8e2714 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1357,8 +1357,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 	kfree(local->int_scan_req);
 	return result;
 }
@@ -1426,8 +1428,10 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
 
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 
 	idr_for_each(&local->ack_status_frames,
 		     ieee80211_free_ack_frame, NULL);
-- 
2.35.1

