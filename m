Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B584A38A71F
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 03:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790652867; cv=none; b=rdolLocwrA+rmyX3CBmQ5eA5Y+0jpbtxs23Uivwz6rjSkPhk0BtL4MALSM66vBY7I5geWZcAZxRpG7lDALf2juKBrV57QC4PxM/49iBwbdMtf5jvyW3+2G6tQlw8qG67coobaIVtkekSMbcO3UVODtvx8JvGFj9MMq5CN4ZYvXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790652867; c=relaxed/simple;
	bh=VxwXC2ymXKg74iOjqM9DjfTdB1xIYPBNvf4/+U+F+Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJyQuJQ31xZuvFGPml4+To7TDNfssjrPujHDEIP8eS0GHMAU2cgQoY8QFG5l8YYzaPCfuQzR34PaTuDaKn197WpUL86t3vGwUgjFZep8b5Ez9f2BKmNghLNfgB35jFmCIH96QNvzTV+lEoIRmJwXI1yLKWXZER/2GebanvoG1Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=UsKJJukW; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="UsKJJukW"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39dacf053eeso1862278a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 20:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1790652865; x=1791257665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=siXZRHtc0EzHRD/AbY1MMiRZMS/5vni0rs/ARWRBsZg=;
        b=UsKJJukW0xIQR4Pprbgh1/3hmuoEuu5IZO0IWtk2KnrsoB7V6kkXrFHC14Y3CY91A4
         zu6HdzSQrZw9krjqGCXAh6juv6Gs7BqWizRVmszEEJujqCH+s9UXx9lYOMIG4RDtr1i7
         wm+Vqpjws87YoB0AfBK2PVfctUPaMPj2U3i8LQwlzQ2N4B9v0Ptn9gfwGzzmAxSEnnH8
         +s3q0O91B01j/GM5JJdA5J1cHS9Nk3zMkQRHPmUZ3sGyFJLptiCDhnUIXD7sE+fZxWhw
         YNDaPKwkOt+WetVN9+zUtr1CoAmTARDCzYyc2sGxP8NZu6ricX1sEUeLDX8kJHqpTz2S
         frYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790652865; x=1791257665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=siXZRHtc0EzHRD/AbY1MMiRZMS/5vni0rs/ARWRBsZg=;
        b=k6ne5cELI/fKtKqn+i1DKOs9qMoarf5IUMIIytAIBlwynuv87AJw2pRKE19oPB7hL+
         hanHASrv10ey4TMRylQ5q8uijTDiGgPAEgFJY3enM7BJyQb1jZkIOnyHnsdoUMJRtxvz
         pW89WIG3V1dAQvuzG8dLNe3GoGCSrG0fGQQT2hg77K2m57lz0aQa2zl7Xn1d5BHT/QNv
         pNFwvEsd24rON0nlnJ24/l6INGESO1Cb7P0o4Nl6CIPD4Nkv/AbL9ey/rI+U91P0K0IE
         TdUaz9UUHHzaNGZKb5KELhUxVj+7dkNNOIbLjXjqXuSk9ACZhYIayJE+gA1QIO3yIILO
         ILIQ==
X-Forwarded-Encrypted: i=1; AKwUvBziQRyuDrT2HWPVPLxMIQphL1giuDaGgoW66yZb5cuupcQPc+oyl5gs1Ngr/D6IBafEgTg5lO1GNWB8KlVMGw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIg7FrTpGft5WzXLV6CUFpOGu/7dnEInM3hOhEABQwk6TPaS9QF
	KoxtpDhbZDJwRTzXzEy15s3Pb08jRw+derY/4iJQtVAr7wluwIVWtqBdTKMac5Jk/Q0uOdwKN4j
	xVqXrrRTC6Q==
X-Gm-Gg: AYBFou25iELu7inMCQbAT4szlCUpNnys4vo2GP6S9e6y8E/FkhZdQDhVw/7vlensWdr
	0nmmt6k8LfcgEElEpHjlDS4MEVp5Jhnh8/73YFx4jAHupXtsX2+pwqTuNjv+F7apGKB3STxn7aW
	9YV5DV/Bzu8qhzjJ8GFyrTR/tPc0zL+oHQVatazvJjC0Nh2Q3IFPcxFneE9uLHbKeb49GDESXBN
	hTjmvcT9gBGKPRXP2aIsJ1804G+ObkdI8UZ1Pd9DlQ+u8FxfKb5W9s5rWREY2LizSG6QxSZwDvU
	Yh+Ov2y+N5UYIFrprSZX1pMqs5epnXSsFuyrB4/1PCQDRBBqKAnYmV1kVDHx3K/JQkq8TIWuwM2
	Rm4DrI88UMrEYW3XxmBQF90TWwlTfMmNsyq/P3YabpgFeYWwJJv17pMV7n5C+MpsPWaJsg1Ldhk
	qHQwN3JKx8b6YUBgw9kO40Isrx3L48xbabat19fuCLrwzndeGbLDlxJPGYKD+4hqiHxkFMhtRWT
	enMFp/SFvegBbOTmUe7dQjHosG3Nn1quBiStsLtFcmCsPQBntg0UlrEIOQLxviB
X-Received: by 2002:a17:90a:ac8:b0:3a4:a619:9e6a with SMTP id 98e67ed59e1d1-3a4a619a4bdmr112878a91.41.1790652864893;
        Mon, 28 Sep 2026 20:34:24 -0700 (PDT)
Received: from MMA-10015.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a498fb91d6sm887594a91.4.2026.09.28.20.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 20:34:24 -0700 (PDT)
From: samuele.yang@morsemicro.com
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Samuele Yang <samuele.yang@morsemicro.com>
Subject: [PATCH wireless-next] wifi: mm81x: start beaconing on beacon enable not interface add
Date: Tue, 29 Sep 2026 13:34:08 +1000
Message-ID: <20260929033408.69266-1-samuele.yang@morsemicro.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Samuele Yang <samuele.yang@morsemicro.com>

Currently we only initialise and start the beaconing process when the
AP interface is first added. If the BSS alone is reconfigured and
beaconing is temporarily stopped, the subsequent call to re-enable
the beacon via BSS_CHANGED_BEACON_ENABLED is ignored and beaconing will
be permanently stopped until the interface is completely re-added.

To fix, move the beaconing start/stop to mm81x_mac_ops_bss_info_changed
and react accordingly to info->enable_beacon and just keep the per-vif
work item init in the add_interface callback.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Samuele Yang <samuele.yang@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 4485748518b4..e61978c28ae4 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -1356,11 +1356,10 @@ static void mm81x_mac_beacon_work(struct work_struct *work)
 		mm81x_mac_send_buffered_bc(mors, vif);
 }
 
-static void mm81x_mac_beacon_init(struct mm81x_vif *mors_vif)
+static void mm81x_mac_beacon_start(struct mm81x_vif *mors_vif)
 {
 	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
 
-	INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
 	mm81x_mac_beacon_irq_enable(mors_vif, true);
 	atomic_inc(&mors->num_bcn_vifs);
 }
@@ -1583,7 +1582,9 @@ static void mm81x_mac_ops_bss_info_changed(struct ieee80211_hw *hw,
 		mm81x_cmd_config_beacon_timer(mors, mors_vif,
 					      info->enable_beacon);
 
-		if (!info->enable_beacon)
+		if (info->enable_beacon)
+			mm81x_mac_beacon_start(mors_vif);
+		else
 			mm81x_mac_beacon_finish(mors_vif);
 	}
 
@@ -2261,7 +2262,7 @@ static int mm81x_mac_ops_add_interface(struct ieee80211_hw *hw,
 	rcu_assign_pointer(mors->vifs[mors_vif->id], vif);
 
 	if (vif->type == NL80211_IFTYPE_AP)
-		mm81x_mac_beacon_init(mors_vif);
+		INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
 
 	ret = mm81x_cmd_get_capabilities(mors, mors_vif->id, &mors->fw_caps);
 	if (ret) {
-- 
2.55.0

