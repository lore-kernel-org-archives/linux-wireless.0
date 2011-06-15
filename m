Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8667 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab1FOOpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 10:45:12 -0400
From: "Shajakhan, Mohammed" <mohammed@qca.qualcomm.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"Gulasekaran, Susinder" <susinder@qca.qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: RE: [PATCH] ath9k: Add debug messages to track PAPRD failures
Date: Wed, 15 Jun 2011 14:45:10 +0000
Message-ID: <D106CD05FEFBA74BA17F929FD27C8AB3099B3196@nasanexd02a.na.qualcomm.com> (sfid-20110615_164517_691621_F4FD85E9)
References: <1308142531-21062-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1308142531-21062-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Mohammed Shafi Shajakhan [mohammed@qca.qualcomm.com]
Sent: 15 June 2011 18:25:31
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org; Rodriguez, Luis; Shajakhan, Mohammed; Gulasekaran, Susinder; Balasubramanian, senthilkumar
Subject: [PATCH] ath9k: Add debug messages to track PAPRD failures

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Add few debug messages for some of the possible scenarios
where we can detect PAPRD failures. this will help us to be
sure that we had really enabled PAPRD

Cc: susinder@qca.qualcomm.com
Cc: senthilb@qca.qualcomm.com
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7f94533..e0e0e86 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -360,7 +360,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
        txctl.paprd = BIT(chain);

        if (ath_tx_start(hw, skb, &txctl) != 0) {
-               ath_dbg(common, ATH_DBG_XMIT, "PAPRD TX failed\n");
+               ath_dbg(common, ATH_DBG_CALIBRATE, "PAPRD TX failed\n");
                dev_kfree_skb_any(skb);
                return false;
        }
@@ -369,7 +369,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
                        msecs_to_jiffies(ATH_PAPRD_TIMEOUT));

        if (!time_left)
-               ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_CALIBRATE,
+               ath_dbg(common, ATH_DBG_CALIBRATE,
                        "Timeout waiting for paprd training on TX chain %d\n",
                        chain);

@@ -431,11 +431,18 @@ void ath_paprd_calibrate(struct work_struct *work)
                if (!ath_paprd_send_frame(sc, skb, chain))
                        goto fail_paprd;

-               if (!ar9003_paprd_is_done(ah))
+               if (!ar9003_paprd_is_done(ah)) {
+                       ath_dbg(common, ATH_DBG_CALIBRATE,
+                               "PAPRD not yet done on chain %d\n", chain);
                        break;
+               }

this message seems to indeed hit for AR9485, as this register value is different for AR9485
#define AR_PHY_PAPRD_TRAINER_STAT1                              (AR_SM_BASE + 0x4a0)


-               if (ar9003_paprd_create_curve(ah, caldata, chain) != 0)
+               if (ar9003_paprd_create_curve(ah, caldata, chain)) {
+                       ath_dbg(common, ATH_DBG_CALIBRATE,
+                               "PAPRD create curve failed on chain %d\n",
+                                                                  chain);
                        break;
+               }

                chain_ok = 1;
        }
--
1.7.0.4

