Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE042C10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 18:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE1B32146F
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 18:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfDKSUX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:20:23 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:40858 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbfDKSUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 14:20:23 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2019 14:20:21 EDT
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 8875A3C01;
        Thu, 11 Apr 2019 20:13:33 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id a87f091d;
        Thu, 11 Apr 2019 20:13:32 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        <stable@vger.kernel.org>
Subject: [PATCH] mwl8k: Fix rate_idx underflow
Date:   Thu, 11 Apr 2019 20:13:30 +0200
Message-Id: <1555006410-6090-1-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It was reported on OpenWrt bug tracking system[1], that several users
are affected by the endless reboot of their routers if they configure
5GHz interface with channel 44 or 48.

The reboot loop is caused by the following excessive number of WARN_ON
messages:

 WARNING: CPU: 0 PID: 0 at backports-4.19.23-1/net/mac80211/rx.c:4516
                             ieee80211_rx_napi+0x1fc/0xa54 [mac80211]

as the messages are being correctly emitted by the following guard:

 case RX_ENC_LEGACY:
      if (WARN_ON(status->rate_idx >= sband->n_bitrates))

as the rate_idx is in this case erroneously set to 251 (0xfb). This fix
simply converts previously used magic number to proper constant and
guards against substraction which is leading to the currently observed
underflow.

1. https://bugs.openwrt.org/index.php?do=details&task_id=2218

Fixes: 854783444bab ("mwl8k: properly set receive status rate index on 5 GHz receive")
Cc: <stable@vger.kernel.org>
Tested-by: Eubert Bao <bunnier@gmail.com>
Reported-by: Eubert Bao <bunnier@gmail.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/net/wireless/marvell/mwl8k.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 8e4e9b6..ffc565a 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -441,6 +441,9 @@ struct mwl8k_sta {
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 #define MWL8K_CMD_BASTREAM		0x1125
 
+#define MWL8K_LEGACY_5G_RATE_OFFSET \
+	(ARRAY_SIZE(mwl8k_rates_24) - ARRAY_SIZE(mwl8k_rates_50))
+
 static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 {
 	u16 command = le16_to_cpu(cmd);
@@ -1016,8 +1019,9 @@ static void mwl8k_rxd_ap_refill(void *_rxd, dma_addr_t addr, int len)
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->encoding == RX_ENC_HT))
-			status->rate_idx -= 5;
+		if (!(status->encoding == RX_ENC_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
 	}
@@ -1124,8 +1128,9 @@ static void mwl8k_rxd_sta_refill(void *_rxd, dma_addr_t addr, int len)
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->encoding == RX_ENC_HT))
-			status->rate_idx -= 5;
+		if (!(status->encoding == RX_ENC_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
 	}
-- 
1.9.1

