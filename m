Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58042 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbcAASZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 13:25:08 -0500
Subject: [PATCH 2/2] net-ath9k_htc: Replace a variable initialisation by an
 assignment in ath9k_htc_set_channel()
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686C390.5060600@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5686C47E.1040906@users.sourceforge.net> (sfid-20160101_192535_754416_9729D519)
Date: Fri, 1 Jan 2016 19:25:02 +0100
MIME-Version: 1.0
In-Reply-To: <5686C390.5060600@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Jan 2016 19:09:32 +0100

Replace an explicit initialisation for one local variable at the beginning
by a conditional assignment.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a680a97..30bd59e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -246,7 +246,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	struct ieee80211_conf *conf = &common->hw->conf;
 	bool fastcc;
 	struct ieee80211_channel *channel = hw->conf.chandef.chan;
-	struct ath9k_hw_cal_data *caldata = NULL;
+	struct ath9k_hw_cal_data *caldata;
 	enum htc_phymode mode;
 	__be16 htc_mode;
 	u8 cmd_rsp;
@@ -274,10 +274,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 		priv->ah->curchan->channel,
 		channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
 		fastcc);
-
-	if (!fastcc)
-		caldata = &priv->caldata;
-
+	caldata = fastcc ? NULL : &priv->caldata;
 	ret = ath9k_hw_reset(ah, hchan, caldata, fastcc);
 	if (ret) {
 		ath_err(common,
-- 
2.6.3

