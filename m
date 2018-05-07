Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:25144 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752565AbeEGIoe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:34 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 16/30] staging: wilc1000: fix line over 80 charas in wilc_wfi_remain_on_channel_expired()
Date: Mon, 7 May 2018 14:13:20 +0530
Message-ID: <1525682614-3824-17-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104440_942665_C09716D5)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor wilc_wfi_remain_on_channel_expired() to avoid line over 80
character issue reported by checkpatch.pl script. Also assigned value in the
variable at the time of declaration.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ca221f1..4f35178 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1490,18 +1490,16 @@ static void wilc_wfi_remain_on_channel_ready(void *priv_data)
 
 static void wilc_wfi_remain_on_channel_expired(void *data, u32 session_id)
 {
-	struct wilc_priv *priv;
+	struct wilc_priv *priv = data;
+	struct wilc_wfi_p2p_listen_params *params = &priv->remain_on_ch_params;
 
-	priv = data;
+	if (session_id != params->listen_session_id)
+		return;
 
-	if (session_id == priv->remain_on_ch_params.listen_session_id) {
-		priv->p2p_listen_state = false;
+	priv->p2p_listen_state = false;
 
-		cfg80211_remain_on_channel_expired(priv->wdev,
-						   priv->remain_on_ch_params.listen_cookie,
-						   priv->remain_on_ch_params.listen_ch,
-						   GFP_KERNEL);
-	}
+	cfg80211_remain_on_channel_expired(priv->wdev, params->listen_cookie,
+					   params->listen_ch, GFP_KERNEL);
 }
 
 static int remain_on_channel(struct wiphy *wiphy,
-- 
2.7.4
