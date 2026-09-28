Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BED356755
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 03:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790565733; cv=none; b=i1LZ4YNzyisJesqZGVLhR5FaQNDCe/vnX0FAcni0N6Bzv1ihwiIUOlbS2rMNgPvB46JArm3GRwbFzcDNtcpyQ7+UBz78FB9IkSs2Dz5P0vLfMF9ODy+PRhw70FrrIeQmtBbPVU0GJBOVDT4F+4uWXkRhjB4W6Ju/F9UfaUDN98o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790565733; c=relaxed/simple;
	bh=VxwXC2ymXKg74iOjqM9DjfTdB1xIYPBNvf4/+U+F+Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XkhdPdp45ztDnW8Uj5IIDjI+1EGqFLqVu35yVOltdQxbxfmOCTsGyCjZM4JPZLsX4uYylf8qtNdkzCXI/lvZPwahWero/59594ysIV7rzTeqylaL7Iy3BOYU3j9rjdQoZNWF2fOpAnVD5V3FII2Z5Ya84T2AIeOa19dsx2eKoXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=GgtcI9NC; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="GgtcI9NC"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85f0fc1fd8eso1235006b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 20:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1790565731; x=1791170531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=siXZRHtc0EzHRD/AbY1MMiRZMS/5vni0rs/ARWRBsZg=;
        b=GgtcI9NCA1XPKPp+JjfVVuqjw8vD4n4cBywBxX5yoSxhw+Xx6kHH+5C/yji6+e5mlu
         s3QAA3hqnQ+UtUfTcb+jNioO4xj/NNKPxltqEaRzyVz+GLgiewSl1baSv9kmof8b29Sd
         EmwcVCz4TUpZTbBMyBxHGMbtfjPWn8LOeff+7eIKTPokceQtH6I/EqfyZ3ds9mBYTJRR
         CWbKbLUaImSndVX94KmkbCiUeEOtKS7QvaHn2QJacYhXSotU0M9UpSbtAlREYO/2LVBW
         P5fjdtUulb0E0yaQeene+Bt2Ngh8SwnoB25N3qHxqhRmQikdwukL1s2pf2SY9XxdIMBw
         /jBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790565731; x=1791170531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=siXZRHtc0EzHRD/AbY1MMiRZMS/5vni0rs/ARWRBsZg=;
        b=G6AfvHXTaoMKUNIT+cdGhkhm2HgqzkQv3yyfiFUdSi4oZ7YPSLRnT0eGbO6ccZX456
         K4fpFVToQgDZhRcxZUsB9xvLPL4V6dizUcPyg09o/SaL5rYbCEB0G4QmwKyqoQ6bRO0e
         +6MvrzAvzjoaJ5dY82OKraFloJTnM2VyOkXgwz1nXLeSXNET+O+P67B05AP8KyAlqyrh
         DFmgaJ/IiiKffCSleIcGJchePrxswereWJBlpUh/0xqXOVMT3JVyXSnrLYKKWKnO+eIV
         1msC0ui8xEKdK3iCGW5dv2T8i0GP+Y7k4M/R4pDQZbbaazjP0ukHlPsK1BuH6Oc1bIG4
         QRgg==
X-Forwarded-Encrypted: i=1; AKwUvByHX08IAtzE7CVACH58z5df96Beoma/adBD54dUGfrYVYEK1/VJrZokPnTCGoiYuPTGiS7x1tTMmnbx3h8ZGA==@vger.kernel.org
X-Gm-Message-State: AFuF++kY6mUv3FndxcTUpm2EsA46JsnhZPLFARz7L7+oNOPNRC87UOeR
	0ITbFdXxlh5fBPjd6PGvll1uHLMnu1faRE4SoQrbodr9605SqVC1rGH0T6mJHrJab1QeWpqutnM
	8pRY37MpS9A==
X-Gm-Gg: AYBFou3QzjwsPHgsB8ckW9ALqcllNG5q/0MAO2Pi1eRyEY3HQSBsojSCSdyyFAwkKi8
	cV1iIIxuyL38QZFr+wt185lmgtozz+RweE8//kbAD1WZ7fOHw//2dOu4G8+Hl7anSjtGNCYLtW7
	XzS5IRU1RpHitbOxp+pGOfNVxaLCaAFZE9hW9rDf5wmxH51Y0HkwCtBlcE+Q5w0Zj/BrC5F4nK3
	vqUqwVVZQbIiRKXsm51t8OEOQLXlWMo5IFjGyuDj91wDhvjhTWXSdUgsfYv0LUr6FoW5DDlat6/
	0cSf+aF5nKYvLroOuKrTo9rBlegxEqTTmQcRiiJCcLwX8GzME0+GhNVGy2jGALYCqM5JfwlEpYF
	GVzZNoYLCRHcuoNF2Qi0YzLZ0877cZxFAx5cBJB7blHEQzPJSoO4LsoQqpvifna8SVgJYMvh5a8
	Z9KQcGnpqgZFQBywFwREqjC6mU/YFYH/VMKv1Wul5mGonyLvacwujVuOS73wP2pis3ouYzya0uY
	j2x3VTvZ9M8hVJHO4TYuER+pBBXF5VNLjronjQfc+f9obeaGgFNXw==
X-Received: by 2002:a05:6a20:9194:b0:3c3:a31b:3949 with SMTP id adf61e73a8af0-3de0e6754b3mr10913020637.11.1790565731126;
        Sun, 27 Sep 2026 20:22:11 -0700 (PDT)
Received: from MMA-10015.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7b805182csm181592a12.2.2026.09.27.20.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 20:22:09 -0700 (PDT)
From: samuele.yang@morsemicro.com
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Samuele Yang <samuele.yang@morsemicro.com>
Subject: [PATCH wireless-next] wifi: mm81x: start beaconing on beacon enable not interface add
Date: Mon, 28 Sep 2026 13:21:31 +1000
Message-ID: <20260928032131.55670-1-samuele.yang@morsemicro.com>
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

