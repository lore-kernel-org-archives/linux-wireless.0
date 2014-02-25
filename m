Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64107 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaBYG7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 01:59:23 -0500
Received: by mail-ee0-f47.google.com with SMTP id e49so1553073eek.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Feb 2014 22:59:22 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: enable spectrum management support
Date: Tue, 25 Feb 2014 07:59:14 +0100
Message-Id: <1393311554-8131-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140225_075926_507701_21275F2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indicate spectrum management support in hardware
flags, while we already handle power set
(IEEE80211_CONF_CHANGE_POWER) in the ath10k driver.
This enable 802.11h support for station mode.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1e0308f..78fc4f5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4235,7 +4235,8 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_SUPPORTS_STATIC_SMPS |
 			IEEE80211_HW_WANT_MONITOR_VIF |
-			IEEE80211_HW_AP_LINK_PS;
+			IEEE80211_HW_AP_LINK_PS |
+			IEEE80211_HW_SPECTRUM_MGMT;
 
 	/* MSDU can have HTT TX fragment pushed in front. The additional 4
 	 * bytes is used for padding/alignment if necessary. */
-- 
1.7.9.5

