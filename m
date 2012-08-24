Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50773 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab2HXOSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 10:18:02 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qca.qualcomm.com>
Subject: [RFC 3/3] ath9k_htc: Cancel BTCOEX related work before disabling BTCOEX
Date: Fri, 24 Aug 2012 19:47:31 +0530
Message-ID: <1345817851-8700-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120824_161806_904787_F571C9A2)
In-Reply-To: <1345817851-8700-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1345817851-8700-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Before disabling BTCOEX in the h/w cancel all BTCOEX related
works. This is similar to the commit in ath9k(c32cdbd8)
ath9k: Stop the BTCOEX timers before disabling BTCOEX

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index fe4836b..8fd64a6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -173,9 +173,9 @@ void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv)
 
 	if (ah->btcoex_hw.enabled &&
 	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
-		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath_htc_cancel_btcoex_work(priv);
+		ath9k_hw_btcoex_disable(ah);
 	}
 }
 
-- 
1.7.0.4

