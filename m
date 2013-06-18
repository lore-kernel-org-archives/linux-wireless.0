Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43621 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3FRWE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 18:04:58 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 5/6] wireless:  Fix bss ref count leak in __cfg80211_mlme_assoc
Date: Tue, 18 Jun 2013 15:03:36 -0700
Message-Id: <1371593017-10985-5-git-send-email-greearb@candelatech.com> (sfid-20130619_000500_208538_EEFE0895)
In-Reply-To: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The rdev_assoc path holds it's own reference, so the
mlme_assoc must release the reference it took earlier
before returning.

This actually appears to be the leak I have been seeing
in my tests.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index d975510..1c60268 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -432,8 +432,8 @@ out:
 	if (err) {
 		if (was_connected)
 			SET_SME_STATE(wdev, CFG80211_SME_CONNECTED);
-		cfg80211_put_bss(&rdev->wiphy, req.bss);
 	}
+	cfg80211_put_bss(&rdev->wiphy, req.bss);
 
 	return err;
 }
-- 
1.7.3.4

