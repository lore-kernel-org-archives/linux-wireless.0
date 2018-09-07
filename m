Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42731 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbeIGWFj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 18:05:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id g23-v6so6872084plq.9
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 10:23:45 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: utilize random MAC address if none is provided
Date: Fri,  7 Sep 2018 10:21:57 -0700
Message-Id: <20180907172157.203785-1-briannorris@chromium.org> (sfid-20180907_192354_386262_F385084A)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 9d5804662ce1 ("ath10k: retrieve MAC address from system
firmware if provided"), we support pulling our MAC address from system
firmware. Along with this, we should admit that it's possible for system
firmware to be screwed up as well, omitting the MAC address there.

Provide a fallback, such that we choose a randomly-generated MAC
address, with the local assignment bit set.

This is not a preferred mode of operation and really should only serve
the purpose of keeping the system chugging along while someone figures
out what's wrong with the system. Grepping through other wireless
drivers shows very similar fallback logic though, so why not?

  git grep eth_random_addr drivers/net/wireless/

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97548f96a2f7..484f9c74ce46 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8325,6 +8325,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	void *channels;
 	int ret;
 
+	if (!is_valid_ether_addr(ar->mac_addr)) {
+		ath10k_warn(ar, "invalid MAC address; choosing random\n");
+		eth_random_addr(ar->mac_addr);
+	}
 	SET_IEEE80211_PERM_ADDR(ar->hw, ar->mac_addr);
 
 	SET_IEEE80211_DEV(ar->hw, ar->dev);
-- 
2.19.0.rc2.392.g5ba43deb5a-goog
