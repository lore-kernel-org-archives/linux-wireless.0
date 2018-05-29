Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35601 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932284AbeE2JOT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 05:14:19 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: add error check to call to rhashtable_init
Date: Tue, 29 May 2018 10:14:12 +0100
Message-Id: <20180529091412.8530-1-colin.king@canonical.com> (sfid-20180529_111554_128803_44C33AA7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The call to rhashtable_init is missing an error return check, it is
possible for this to fail various different ways, so fix this by adding
an error check.

Detected by: CoverityScan, CID#1469446 ("Unchecked return value")

Fixes: c6509cc3b3e8 ("mac80211_hwsim: add hashtable with mac address keys for faster lookup")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 89fc22520d40..f4b4f5690b16 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3573,7 +3573,9 @@ static int __init init_mac80211_hwsim(void)
 	hwsim_wq = alloc_workqueue("hwsim_wq", 0, 0);
 	if (!hwsim_wq)
 		return -ENOMEM;
-	rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
+	err = rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
+	if (err)
+		return err;
 
 	err = register_pernet_device(&hwsim_net_ops);
 	if (err)
-- 
2.17.0
