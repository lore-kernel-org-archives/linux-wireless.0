Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10633 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1FOE6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 00:58:40 -0400
From: "Shajakhan, Mohammed" <mohammed@qca.qualcomm.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [RFC] ath9k: remove a redundant call to pcipowersave
Date: Wed, 15 Jun 2011 04:58:39 +0000
Message-ID: <D106CD05FEFBA74BA17F929FD27C8AB3099B3164@nasanexd02a.na.qualcomm.com> (sfid-20110615_065844_549575_21AD8D64)
References: <1308066179-8195-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1308066179-8195-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Mohammed Shafi Shajakhan [mohammed@qca.qualcomm.com]
Sent: 14 June 2011 21:12:59
To: linux-wireless@vger.kernel.org
Cc: Rodriguez, Luis; Shajakhan, Mohammed
Subject: [RFC] ath9k: remove a redundant call to pcipowersave

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

during suspend/resume ath9k_stop will always call ath_radio_disable
which will inturn call ath9k_hw_configpcipowersave, so need to call

mistake "so no need to call"

it explicitly in ath9k_stop

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7f94533..e7f8ef2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1259,7 +1259,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)

        /* disable HAL and put h/w to sleep */
        ath9k_hw_disable(ah);
-       ath9k_hw_configpcipowersave(ah, 1, 1);

        spin_unlock_bh(&sc->sc_pcu_lock);

--
1.7.0.4

