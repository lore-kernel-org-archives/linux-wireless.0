Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:33476 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbcB2BIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 20:08:23 -0500
Received: by mail-qg0-f66.google.com with SMTP id y89so9657919qge.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 17:08:23 -0800 (PST)
Received: from hash ([2001:470:1d:6db:230:48ff:fe9d:9c89])
        by smtp.gmail.com with ESMTPSA id c60sm9942482qga.20.2016.02.28.17.08.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2016 17:08:22 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] ath5k: fix incorrect indentation
Date: Sun, 28 Feb 2016 20:07:55 -0500
Message-Id: <1456708077-19652-1-git-send-email-me@bobcopeland.com> (sfid-20160229_020827_337654_F5CC4B25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

smatch said:

drivers/net/wireless/ath/ath5k/phy.c:1449 ath5k_hw_channel() warn: inconsistent indenting
drivers/net/wireless/ath/ath5k/reset.c:637 ath5k_hw_on_hold() warn: inconsistent indenting
drivers/net/wireless/ath/ath5k/reset.c:702 ath5k_hw_nic_wakeup() warn: inconsistent indenting

All of these lines were indented a tabstop too far.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/phy.c   | 2 +-
 drivers/net/wireless/ath/ath5k/reset.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 0fce1c76638e..98ee85456321 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1446,7 +1446,7 @@ ath5k_hw_channel(struct ath5k_hw *ah,
 			"channel frequency (%u MHz) out of supported "
 			"band range\n",
 			channel->center_freq);
-			return -EINVAL;
+		return -EINVAL;
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 99e62f99a182..4b1c87fa15ac 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -634,7 +634,7 @@ ath5k_hw_on_hold(struct ath5k_hw *ah)
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_DMA |
 			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
-			usleep_range(2000, 2500);
+		usleep_range(2000, 2500);
 	} else {
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_BASEBAND | bus_flags);
@@ -699,7 +699,7 @@ ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_DMA |
 			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
-			usleep_range(2000, 2500);
+		usleep_range(2000, 2500);
 	} else {
 		if (ath5k_get_bus_type(ah) == ATH_AHB)
 			ret = ath5k_hw_wisoc_reset(ah, AR5K_RESET_CTL_PCU |
-- 
2.6.1

