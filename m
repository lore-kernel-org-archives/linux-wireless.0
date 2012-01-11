Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:63836 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab2AKPzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 10:55:54 -0500
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nicolas Cavallari <cavallar@lri.fr>
Subject: [PATCH] carl9170: claim to support IBSS RSN.
Date: Wed, 11 Jan 2012 16:44:50 +0100
Message-Id: <1326296690-2644-1-git-send-email-cavallar@lri.fr> (sfid-20120111_165558_251836_53539AC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On carl9170, HW encryption is disabled on IBSS; the mac80211
software-based encryption is used instead. As mac80211 supports IBSS
RSN (per-STA GTK), claim its support in the carl9170 PHY.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
 drivers/net/wireless/ath/carl9170/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index f06e069..24c7f85 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1796,6 +1796,9 @@ void *carl9170_alloc(size_t priv_size)
 		ar->noise[i] = -95; /* ATH_DEFAULT_NOISE_FLOOR */
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+
+	/* As IBSS Encryption is software-based, IBSS RSN is supported. */
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	return ar;
 
 err_nomem:
-- 
1.7.7.3

