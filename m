Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CFE1DDA18
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313060; cv=none; b=SciBDKhFNk6BeHGFHMYJ04Kz2ViGvfjgDBH9POOqwphvc+BeXLZfHmCo3gOvJ0sqZ4RbYmiCOOf6f/H6zxHoviYSi+LzSnVQ6AWWNsRYgPKnnqERQ/uXqD/dHKxL/Wt/a9FFwSpQb3SgjAd7lg1QMZeQmFYJtgZ47vNSBgjiqYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313060; c=relaxed/simple;
	bh=CPf9MDbbFRS1zVdMZBZThQTshFynaHFz9andhtsLs+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NsHpA9yKpAlfvoRn1R2HCx01+DlOb0v0VTFCZM3NOR+xlUDuUjAuB5DRtYhU5MM+KjIHu3d7IVlMMzGFE0JP7sQZ7SOAxNeNI13RwgP0vT/uS6oIcSdpj/wLnTAL+l5rczDjAxZKqGkHfmw0YCMzmhLo545sK700YEWsKKtDU6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=htmiuO7B; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gbBZeoUN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="htmiuO7B";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gbBZeoUN"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4YbCw3535382
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=z5+0mAmKxUM
	1XeRLsm139VMveExpHBAiGp2IilLfPQE=; b=htmiuO7BQRoqlLcpux8G5+qV0LU
	3GsGtNbAuwWkUvyvsTYaAgnPanCHyBGo/ulJQpY7a1boW7AwpotEIKKC6G2/IgMp
	3/TaXIjt212ymbilfcUBC2iURnsUggXFYnMswVC1r4/AiWoElMiQrE5J22ckRXLA
	xll7++/GZE/cS2TgW9eyjhNyoUc+kkJuA3v2TVZLIcvDp1HwBXkkBZcKfjV8tRXk
	QmEmIUvHKMjeYDDVK3h1KhiDG6mvCrsjcauLl4pcu+MwOiDAglcY8qEc/1gO0xJX
	uWpeOEMr43O09AGVx+jdU7wWItFdcckTvNOKXmw7miF7irTNMLsguOwLcqQ==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw1t7uwrq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:57 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1438719cc1eso759495c88.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 22:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790313056; x=1790917856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z5+0mAmKxUM1XeRLsm139VMveExpHBAiGp2IilLfPQE=;
        b=gbBZeoUN2rFeFZQlY4zLPBI0vzyTRUIMR8mfimTNx5gt0wbSvFx+ZNROJRVwPRXy7S
         k4aG0e1n8tudwgsWhSEHBLlHklzjs2F0uNHLutYm7emZWE40/TRSESZ3UmTgGidy+9+T
         w/2CIAUmbajUEx6VNP7nz+fAK2nehJnt7bC+r4CuOMhEsipYnqBUxKpmSK8xP7GCsxyx
         ayV9Y+seUJ1FbVEVWe5irNt5/7foOuMjceLggf2Ge78KLNdpDHIvOPt8SdmxrahIw6GN
         JdC+Px4zjjpI17FJhq74nhF43N3UKS1EJpisa+6CF6pexC4/tU3/uHA1rjl49Aahihew
         7+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790313056; x=1790917856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z5+0mAmKxUM1XeRLsm139VMveExpHBAiGp2IilLfPQE=;
        b=n6ca3ZWXLYUByWebUEpcRPVuJwB9A1UZTtFNd1ZGV+sZ7MjLuYuNgsBOAj6sHZRfrJ
         5wKovuvxd1a4tFAGf7Eo23jdn6QKCOY6dFv9cbsXEs7r1rqiAWlvZrRt8YY8jDCZaRuf
         gjQjc7nIIUW28idwAqc960WlQ9C1fOm3IBrGDyoZc6krXPmxKzpM76nccC4AD1TtLZJQ
         6/FD4VVfQq1X9WWMTv1CjdlZMsKyaPCXxdmkqBgcTsSXJwWdwXaVfQRsHy57mXKAtDG9
         dJKbd6/DhHDIgpc0eSKizZGMfveNgs33QchpxpalW5LU2eUcCqIKBbEUm+oyUbNUkHg6
         9g0w==
X-Gm-Message-State: AFuF++lWSHiOEUtHC8UVwd5WinafnpMHfwLWGpZP6lbZTfylbqt2LSOi
	NCrysqnUo/TSPZcdEKyBb81FDkzB0LgiCp3YkDE1FO2Ogv0WVfUJgsygcqkLFyTQ39sz9E3/sU0
	6RVI1Ok7SrzwdhkLESaHS0QHe+DfoE/+Exb+PLtFc37lRkUFbrNkY0FfORT9MZq+jioN1Dya1Fy
	8r4g==
X-Gm-Gg: AYBFou07eZItnu/i0RBaxigZJg+ngBf2csDZ1C7Ss1tivCIBweJshecWl7+Ba8nZor6
	Ux49unmFtAL4TEEKL4g4wodo2NvicsgeJ9yVvQOZwuWAi72MjUkybHueLDCnHOlUfqMf+gFWHXF
	UnapSN/0FtRQ4HSTGY0rjVfbPXj4almuz8esbtVR7GlEbitCkCvqs+mTF23b0o5fOC/D3FOst8G
	qTJfZGT7ZiKKViP6PahaTwtjpxr9wm0uUlLRZA5jG6JOn+ug4CkjqiC5Ih1tgLnOkbhjSgMd3o8
	8ZwpwK9uutULRoapxXXhZAVGfCDbPi0Oe5ZBE/Qrf52evVDzVRafTFYK2MuDFz67XSQ6GcVUAOP
	dag1LuO3qy3v2KOi6qetT680HZ0cZFXpNSD1xgVXiQ9auLd7hBKaaKiMIBqjdyAa0+uW+CHpXVP
	K731IUZoVjPvCxag==
X-Received: by 2002:a05:7022:b042:20b0:143:8829:5fbf with SMTP id a92af1059eb24-14503fdf3b2mr3682102c88.28.1790313055962;
        Thu, 24 Sep 2026 22:10:55 -0700 (PDT)
X-Received: by 2002:a05:7022:b042:20b0:143:8829:5fbf with SMTP id a92af1059eb24-14503fdf3b2mr3682077c88.28.1790313055203;
        Thu, 24 Sep 2026 22:10:55 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ac67c505sm2955163c88.5.2026.09.24.22.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 22:10:54 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH ath-next v2 2/2] wifi: ath12k: move is_authorized flag to ath12k_sta
Date: Fri, 25 Sep 2026 10:40:36 +0530
Message-Id: <20260925051036.2838210-3-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
References: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 65tqoBmcXfhC6CcgH0ctmR7wXuAHU_b4
X-Authority-Analysis: v=2.4 cv=U/MHnuru c=1 sm=1 tr=0 ts=6ab60261 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=P8DYBBCEK76YGRFjgHgA:9 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAyMCBTYWx0ZWRfX3AI++GHej7yB
 hSpWkEEi03xkfS5j4YHfuB/vdeF7dUSccYMDj7f3692FXjjrwhrWLr/Q3motry7CaY/+bEd9AWf
 MQCaAOcx/8yA56Q731SRVy2U6UehlHXGI32mTWx6Y2+ZGc8kfE17OADM367HM5GDPodI9d5W+6f
 qv1cvBbP7DuzxRfuGp5TH8OE9WmFaNV9bWruWYyRXyiRtEkSLM+hzAl0KimiB50CJPmmmIvizqp
 AKfnW3w1NoCN48Emr0nz9boVgXcBsp3qr5Q4mMt6N8nSst8PhXV7Ru0Tr0vXyBxamXsn6FgMXEF
 23OC8rqr/Sr0yEA1fsJ1lLblfGZwus6QIoWdWYaETGFFGE6fDvNxX02IoN3YbtysjdzpFNPi1qv
 JO7er9cFBlJagY+qZ85oURIl7oETuC5r+FG2TkvEW15wf2Iz37sGaZaP+jgkSFu4cshIHl2WXXj
 eIk142o+eZcYzhu/VyQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAyMCBTYWx0ZWRfX6t2DOn4ziZK8
 jZWIo0hwmr627CMwKLzNHWVcB4YLyRBSvLKxVy9OGRLTIZ7N95Lqh/L19KZoMGXShWAYPJvBSlM
 bvzwobGUbCtk9LYKT/ERPmtQbDJdiM8=
X-Proofpoint-ORIG-GUID: 65tqoBmcXfhC6CcgH0ctmR7wXuAHU_b4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250020

Authorization state is shared across all link peers that belong to the
station level property. Storing is_authorized in struct
ath12k_dp_link_peer duplicates the same state for every link and
requires all copies to be updated whenever the authorization state
changes.

Move is_authorized to ath12k_sta and update the authorize/unauthorize
handlers to set it there directly. ath12k_bss_assoc() only reads the
flag to decide whether to re-authorize the BSS peer after vdev up, so
read it from ahsta instead of looking up the dp_peer.

Previously, is_authorized was protected by dp_lock. After moving it to
ath12k_sta, all accesses are serialized by the wiphy mutex, so the flag
is now protected by the wiphy lock instead.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h    |  2 ++
 drivers/net/wireless/ath/ath12k/dp_peer.h |  1 -
 drivers/net/wireless/ath/ath12k/mac.c     | 36 ++---------------------
 3 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index a98fc6e0699d..a04757a038f2 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -529,6 +529,8 @@ struct ath12k_sta {
 	enum ieee80211_sta_state state;
 
 	bool enable_4addr;
+
+	bool is_authorized;
 };
 
 #define ATH12K_HALF_20MHZ_BW	10
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index 256fc79d714e..d01ef1aea48b 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -80,7 +80,6 @@ struct ath12k_dp_link_peer {
 
 	struct ppdu_user_delayba ppdu_stats_delayba;
 	bool delayba_flag;
-	bool is_authorized;
 	bool mlo;
 	/* protected by ab->data_lock */
 
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index c04b4e2709b3..8de3c2421738 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3921,11 +3921,8 @@ static void ath12k_bss_assoc(struct ath12k *ar,
 	struct ath12k_link_sta *arsta;
 	struct ieee80211_sta *ap_sta;
 	struct ath12k_sta *ahsta;
-	struct ath12k_dp_link_peer *peer;
-	bool is_auth = false;
 	u32 hemode = 0;
 	int ret;
-	struct ath12k_dp *dp = ath12k_ab_to_dp(ar->ab);
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -4029,17 +4026,8 @@ static void ath12k_bss_assoc(struct ath12k *ar,
 		   "mac vdev %d up (associated) bssid %pM aid %d\n",
 		   arvif->vdev_id, bss_conf->bssid, vif->cfg.aid);
 
-	spin_lock_bh(&dp->dp_lock);
-
-	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, arvif->vdev_id,
-							 arvif->bssid);
-	if (peer && peer->is_authorized)
-		is_auth = true;
-
-	spin_unlock_bh(&dp->dp_lock);
-
 	/* Authorize BSS Peer */
-	if (is_auth) {
+	if (ahsta->is_authorized) {
 		ret = ath12k_wmi_set_peer_param(ar, arvif->bssid,
 						arvif->vdev_id,
 						WMI_PEER_AUTHORIZE,
@@ -7027,20 +7015,11 @@ static int ath12k_mac_station_unauthorize(struct ath12k *ar,
 					  struct ath12k_link_vif *arvif,
 					  struct ath12k_link_sta *arsta)
 {
-	struct ath12k_dp_link_peer *peer;
 	int ret;
-	struct ath12k_dp *dp = ath12k_ab_to_dp(ar->ab);
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
-	spin_lock_bh(&dp->dp_lock);
-
-	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, arvif->vdev_id,
-							 arsta->addr);
-	if (peer)
-		peer->is_authorized = false;
-
-	spin_unlock_bh(&dp->dp_lock);
+	arsta->ahsta->is_authorized = false;
 
 	/* Driver must clear the keys during the state change from
 	 * IEEE80211_STA_AUTHORIZED to IEEE80211_STA_ASSOC, since after
@@ -7062,21 +7041,12 @@ static int ath12k_mac_station_authorize(struct ath12k *ar,
 					struct ath12k_link_vif *arvif,
 					struct ath12k_link_sta *arsta)
 {
-	struct ath12k_dp_link_peer *peer;
 	struct ieee80211_vif *vif = ath12k_ahvif_to_vif(arvif->ahvif);
 	int ret;
-	struct ath12k_dp *dp = ath12k_ab_to_dp(ar->ab);
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
-	spin_lock_bh(&dp->dp_lock);
-
-	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, arvif->vdev_id,
-							 arsta->addr);
-	if (peer)
-		peer->is_authorized = true;
-
-	spin_unlock_bh(&dp->dp_lock);
+	arsta->ahsta->is_authorized = true;
 
 	if (vif->type == NL80211_IFTYPE_STATION && arvif->is_up) {
 		ret = ath12k_wmi_set_peer_param(ar, arsta->addr,
-- 
2.34.1

