Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18992 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab1BRKj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 05:39:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 02:39:37 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Fix a compilation warning.
Date: Fri, 18 Feb 2011 16:09:51 +0530
Message-ID: <1298025591-12626-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize caldata to avoid compilation warning.

CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_main.o
drivers/net/wireless/ath/ath9k/htc_drv_main.c: In function ‘ath9k_htc_config’:
drivers/net/wireless/ath/ath9k/htc_drv_main.c:172: warning: ‘caldata’ may be used uninitialized in this function
drivers/net/wireless/ath/ath9k/htc_drv_main.c:172: note: ‘caldata’ was declared here

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 953036a..50fde0e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -169,7 +169,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	struct ieee80211_conf *conf = &common->hw->conf;
 	bool fastcc;
 	struct ieee80211_channel *channel = hw->conf.channel;
-	struct ath9k_hw_cal_data *caldata;
+	struct ath9k_hw_cal_data *caldata = NULL;
 	enum htc_phymode mode;
 	__be16 htc_mode;
 	u8 cmd_rsp;
-- 
1.6.3.3

