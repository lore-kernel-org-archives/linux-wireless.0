Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34500 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:52:44 -0500
Received: by mail-wg0-f48.google.com with SMTP id dt10so2538513wgb.15
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:52:43 -0800 (PST)
Message-Id: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_155248_247145_439B732E)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 15 Dec 2012 23:18:06 +0100
Subject: [PATCH 1/8] carl9170: advertise support for TDLS
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on a quick test [ath9k and carl9170],
TDLS seemed to be working fine. And while
we are at it, let's move the wiphy feature
flag set from carl9170_alloc into a single
place in carl9170_fw.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fw.c   |    6 +++++-
 drivers/net/wireless/ath/carl9170/main.c |    4 ----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index aaebecd..5a8a9f8 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -354,7 +354,11 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 
 	ar->hw->wiphy->interface_modes |= if_comb_types;
 
-	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	ar->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+
+	/* As IBSS Encryption is software-based, IBSS RSN is supported. */
+	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+		 WIPHY_FLAG_IBSS_RSN | WIPHY_FLAG_SUPPORTS_TDLS;
 
 #undef SUPPORTED
 	return carl9170_fw_tx_sequence(ar);
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 25a1e2f..9dce200 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1805,10 +1805,6 @@ void *carl9170_alloc(size_t priv_size)
 	for (i = 0; i < ARRAY_SIZE(ar->noise); i++)
 		ar->noise[i] = -95; /* ATH_DEFAULT_NOISE_FLOOR */
 
-	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-
-	/* As IBSS Encryption is software-based, IBSS RSN is supported. */
-	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	return ar;
 
 err_nomem:
-- 
1.7.10.4

