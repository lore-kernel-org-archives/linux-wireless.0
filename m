Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427D2418360;
	Sun,  4 Oct 2026 11:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112957; cv=none; b=G9NPnKIl8T+K1R7TgNZWMPGlFr4P79uHvbMlYSozs/hh9tWJScFynxjWnswtW1rV3jKFGi21SCdN25eXRPHKlYs0Y+K4SPdO/AJcbiv9sSJlcP3QRacNDswRgSUSGcKyl9+CQgzlMnKwlQx4IzgTyxshcBBewFR5/6Q5bYE9x5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112957; c=relaxed/simple;
	bh=c6BU/0gNoAWhyFms6C9Xl2vJDU0oKsMwvjR/X6mxXrc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGmbX3NUPOxN+SujKQQ0wfX4SJDNdWXu5/zje7FJ7G6sRvPgK7DGxGViErVWbVgO90Kuz0jWM34nSUwB23BbYmlww8Kx2TFSTVd/z/AYOoeOL8vE4FurHAPw42DyTXTN8rloD9ylP0oO7pttm4FK8JGXRtfp+Mr5ZUq0w6jss6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=bVk3tkMQ; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="bVk3tkMQ"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 591B01041D;
	Sun, 04 Oct 2026 14:22:34 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=9co3YkOyafTXzgWODdF7
	QzveReMbu0CL7bnlrsTbKow=; b=bVk3tkMQIXlM2qHhFhu2GmgPahE2/vuPE/Zw
	UMYpq3YWs+M37iz1o1g8rg0Ka/T8q7ABLHejjMh0OesWAxLBjUAISCB5ojkITDDe
	lQeIB1cz6YrR/Rfhaq4PzghZ6yc0eUO86GpHnDFZHlxx7Q5A+SBelBLSNerXQ6y/
	LDD3pKjXbQuqx5v4LpQ5Mp0g7buDu58/XaVbeblPCtbgyBCTKc+NrTLVNC3tdoaD
	T7TUah1UMzyEpkVOcUh5hvCXNyXhQYs8Umzc3mGJte7W4Hb1j24jvXSFZ04QGiHb
	Bo5fYK1+YRSDJBhaios/DLQAOe6dSncqAAuCe1/Di8lmBeFCDg==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id DCB69103C6;
	Sun, 04 Oct 2026 14:22:33 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:22:33 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH ath-next 4/5] wifi: ath11k: set the 6 GHz transmit power limits of an AP
Date: Sun, 4 Oct 2026 14:18:06 +0300
Message-ID: <2ad58e6455d8e1416a6d32b088297d606deade47.1791111135.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791111135.2.git.me@andrei-z.com>
References: <cover.1791111135.2.git.me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

A 6 GHz AP has to keep within the regulatory power limits of its
channel, which for low power indoor operation are given per MHz (IEEE
Std 802.11-2024, 11.7.6, E.2.7). ath11k sends the per-20 MHz limits to
firmware with WMI_VDEV_SET_TPC_POWER_CMDID only for station vdevs; an AP
got just one transmit power limit for the whole channel, and the
firmware, as the driver's own comment says, is not aware of the EIRP
limits unless the driver sets them with that command.

Send them for AP vdevs too, as ath12k does, with the low power indoor
AP type, the only AP power mode supported for now. An AP builds its
limits from the regulatory rules alone: power levels kept from an
earlier start are not a received Transmit Power Envelope.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 28 ++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index a10d191b1a..f4243d40ca 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3515,13 +3515,14 @@ static int ath11k_mac_config_obss_pd(struct ath11k *ar,
 	return 0;
 }
 
-static bool ath11k_mac_supports_station_tpc(struct ath11k *ar,
-					    struct ath11k_vif *arvif,
-					    const struct cfg80211_chan_def *chandef)
+static bool ath11k_mac_supports_tpc(struct ath11k *ar,
+				    struct ath11k_vif *arvif,
+				    const struct cfg80211_chan_def *chandef)
 {
 	return ath11k_wmi_supports_6ghz_cc_ext(ar) &&
 		test_bit(WMI_TLV_SERVICE_EXT_TPC_REG_SUPPORT, ar->ab->wmi_ab.svc_map) &&
-		arvif->vdev_type == WMI_VDEV_TYPE_STA &&
+		(arvif->vdev_type == WMI_VDEV_TYPE_STA ||
+		 arvif->vdev_type == WMI_VDEV_TYPE_AP) &&
 		arvif->vdev_subtype == WMI_VDEV_SUBTYPE_NONE &&
 		chandef->chan &&
 		chandef->chan->band == NL80211_BAND_6GHZ;
@@ -7655,8 +7656,8 @@ ath11k_mac_vdev_start_restart(struct ath11k_vif *arvif,
 	/* TODO: For now we only set TPC power here. However when
 	 * channel changes, say CSA, it should be updated again.
 	 */
-	if (ath11k_mac_supports_station_tpc(ar, arvif, chandef)) {
-		ath11k_mac_fill_reg_tpc_info(ar, arvif->vif, &arvif->chanctx);
+	if (ath11k_mac_supports_tpc(ar, arvif, chandef)) {
+		ath11k_mac_fill_reg_tpc_info(ar, arvif->vif, ctx);
 		ath11k_wmi_send_vdev_set_tpc_power(ar, arvif->vdev_id,
 						   &arvif->reg_tpc_info);
 	}
@@ -8168,7 +8169,11 @@ void ath11k_mac_fill_reg_tpc_info(struct ath11k *ar,
 	start_freq = ath11k_mac_get_6ghz_start_frequency(&ctx->def);
 	pwr_reduction = bss_conf->pwr_reduction;
 
-	if (arvif->reg_tpc_info.num_pwr_levels) {
+	/* Only a station takes power levels from its AP's TPE; an AP's own
+	 * levels from an earlier start are not a TPE.
+	 */
+	if (arvif->vdev_type == WMI_VDEV_TYPE_STA &&
+	    arvif->reg_tpc_info.num_pwr_levels) {
 		is_tpe_present = true;
 		num_pwr_levels = arvif->reg_tpc_info.num_pwr_levels;
 	} else {
@@ -8319,8 +8324,13 @@ void ath11k_mac_fill_reg_tpc_info(struct ath11k *ar,
 	reg_tpc_info->num_pwr_levels = num_pwr_levels;
 	reg_tpc_info->is_psd_power = is_psd_power;
 	reg_tpc_info->eirp_power = eirp_power;
-	reg_tpc_info->ap_power_type =
-		ath11k_reg_ap_pwr_convert(vif->bss_conf.power_type);
+	if (arvif->vdev_type == WMI_VDEV_TYPE_STA)
+		reg_tpc_info->ap_power_type =
+			ath11k_reg_ap_pwr_convert(vif->bss_conf.power_type);
+	else
+		/* LPI is the only AP power mode supported for now */
+		reg_tpc_info->ap_power_type =
+			ath11k_reg_ap_pwr_convert(IEEE80211_REG_LPI_AP);
 }
 
 static void ath11k_mac_parse_tx_pwr_env(struct ath11k *ar,
-- 
2.47.3


