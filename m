Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2DPQZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 12:25:40 -0400
Date: Mon, 16 Apr 2012 19:25:35 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Remove incorrect Probe Response offload support for
 Interworking
Message-ID: <20120416162535.GA9636@jouni.qca.qualcomm.com> (sfid-20120416_182543_330612_9189AC3B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl does not support Probe Response offloading for Interworking (IEEE
802.11u), so remove the incorrectly added capability flag for it.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5b988aa..35233eb 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3472,8 +3472,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	ar->wiphy->probe_resp_offload =
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
-		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P |
-		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U;
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
-- 
1.7.5.4


-- 
Jouni Malinen                                            PGP id EFC895FA
