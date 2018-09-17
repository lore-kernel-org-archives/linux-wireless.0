Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54384 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbeIQWBM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 18:01:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id c14-v6so10396205wmb.4
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 09:33:04 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id c3-v6sm17807307wrm.56.2018.09.17.09.33.03
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 17 Sep 2018 09:33:03 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] rt2x00: rework channel config function
Date: Mon, 17 Sep 2018 18:32:52 +0200
Message-Id: <1537201975-3032-2-git-send-email-pozega.tomislav@gmail.com> (sfid-20180917_183316_663148_156AD687)
In-Reply-To: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable LNAs only for the current operating band. Change power
amplifiers enabling style to the one in vco calibration routine
and drop redundant cap_bt_coexist enable of PA0.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   75 ++++++++++++------------
 1 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 33968ab..5546bd8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3723,49 +3723,48 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	else
 		tx_pin = 0;
 
-	switch (rt2x00dev->default_ant.tx_chain_num) {
-	case 3:
-		/* Turn on tertiary PAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN,
-				   rf->channel > 14);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN,
-				   rf->channel <= 14);
-		/* fall-through */
-	case 2:
-		/* Turn on secondary PAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
-				   rf->channel > 14);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
-				   rf->channel <= 14);
-		/* fall-through */
-	case 1:
-		/* Turn on primary PAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN,
-				   rf->channel > 14);
-		if (rt2x00_has_cap_bt_coexist(rt2x00dev))
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
+		switch (rt2x00dev->default_ant.tx_chain_num) {
+		case 3:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN, 1);
+		case 2:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
+		case 1:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, 1);
+		break;
+		}
+	} else {
+		switch (rt2x00dev->default_ant.tx_chain_num) {
+		case 3:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN, 1);
+		case 2:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
+		case 1:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
-		else
-			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN,
-					   rf->channel <= 14);
 		break;
+		}
 	}
 
-	switch (rt2x00dev->default_ant.rx_chain_num) {
-	case 3:
-		/* Turn on tertiary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
-		/* fall-through */
-	case 2:
-		/* Turn on secondary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
-		/* fall-through */
-	case 1:
-		/* Turn on primary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN, 1);
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
+		switch (rt2x00dev->default_ant.rx_chain_num) {
+		case 3:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
+		case 2:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
+		case 1:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
+		break;
+		}
+	} else {
+		switch (rt2x00dev->default_ant.rx_chain_num) {
+		case 3:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
+		case 2:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
+		case 1:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN, 1);
 		break;
+		}
 	}
 
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFTR_EN, 1);
-- 
1.7.0.4
