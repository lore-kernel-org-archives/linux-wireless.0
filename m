Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33227 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbcC2GGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 02:06:49 -0400
Received: by mail-pf0-f174.google.com with SMTP id 4so6636955pfd.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2016 23:06:49 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 10/16] wcn36xx: Copy all members in config_sta v1 conversion
Date: Mon, 28 Mar 2016 23:06:27 -0700
Message-Id: <1459231593-360-11-git-send-email-bjorn.andersson@linaro.org> (sfid-20160329_080821_339963_6019F830)
In-Reply-To: <1459231593-360-1-git-send-email-bjorn.andersson@linaro.org>
References: <1459231593-360-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

When converting to version 1 of the config_sta struct not all
members where copied. This fixes the problem of multicast frames
not being delivered on an encrypted network.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 2b416ee9f105..ce764cce1a3e 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -949,17 +949,32 @@ static void wcn36xx_smd_convert_sta_to_v1(struct wcn36xx *wcn,
 	memcpy(&v1->mac, orig->mac, ETH_ALEN);
 	v1->aid = orig->aid;
 	v1->type = orig->type;
+	v1->short_preamble_supported = orig->short_preamble_supported;
 	v1->listen_interval = orig->listen_interval;
+	v1->wmm_enabled = orig->wmm_enabled;
 	v1->ht_capable = orig->ht_capable;
-
+	v1->tx_channel_width_set = orig->tx_channel_width_set;
+	v1->rifs_mode = orig->rifs_mode;
+	v1->lsig_txop_protection = orig->lsig_txop_protection;
 	v1->max_ampdu_size = orig->max_ampdu_size;
 	v1->max_ampdu_density = orig->max_ampdu_density;
 	v1->sgi_40mhz = orig->sgi_40mhz;
 	v1->sgi_20Mhz = orig->sgi_20Mhz;
-
+	v1->rmf = orig->rmf;
+	v1->encrypt_type = orig->encrypt_type;
+	v1->action = orig->action;
+	v1->uapsd = orig->uapsd;
+	v1->max_sp_len = orig->max_sp_len;
+	v1->green_field_capable = orig->green_field_capable;
+	v1->mimo_ps = orig->mimo_ps;
+	v1->delayed_ba_support = orig->delayed_ba_support;
+	v1->max_ampdu_duration = orig->max_ampdu_duration;
+	v1->dsss_cck_mode_40mhz = orig->dsss_cck_mode_40mhz;
 	memcpy(&v1->supported_rates, &orig->supported_rates,
 	       sizeof(orig->supported_rates));
 	v1->sta_index = orig->sta_index;
+	v1->bssid_index = orig->bssid_index;
+	v1->p2p = orig->p2p;
 }
 
 static int wcn36xx_smd_config_sta_rsp(struct wcn36xx *wcn,
-- 
2.5.0

