Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A543472771
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 08:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252995; cv=none; b=sPNqfKbfCFEjoAWPZ+RdMxujEHTVGRG83Fki5Gwe/fgNTSE2RYhdX9NKF2ULI0QOoGaXpyjKFVow2haPdU8FcA2QluRg36/jb1HJvQxEOCo32a3v/qeK/JieqJBE/KsUbo3R4Hn6/8PpHk1+NFNeNcZfp2wWXvOS7tqlCoebrNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252995; c=relaxed/simple;
	bh=A4xUzfDdDJYsOGANI2gW2/2hVZXzXBKxIuvh9sx7HyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xz2G/2AEgrCtZc41WfWGkYf2WCIPHj4u3XL9xJzUKlbrP9Kz3NWNbcyaJv3vys1pV76CEeVIbJAh/2M6Kqs+5EWPelfTTVDC4bu7XHE0lD/RBPuTysz2sbQbm9gQsXpFqMh+HL2L/IzaDuxq03QIiNA6Ia5vRG85GQXGSKlxC4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H54HGPWZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZaXrksSA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H54HGPWZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZaXrksSA"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68179OOJ2321944
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2026 08:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=MatJlJXhqEb
	HsgisvSSw+ap61p7CAazHvfTs4veKE8o=; b=H54HGPWZG+wJOTSrAnQWSSU4BQX
	oLp9JMeTDfiLFaeyFbZKkwZklJDwNsSf+BMEQ2JOKY7L+tkNN1S11q2KaMRMUeZs
	mRlN5J6U7G56xbz84PQVIB8wGQ9/luL+pp3yhWcrZbA9hm9vCPYpykFS/ZIXMt+h
	4NDBSqq8uX4TPOgT/4dDVEw00RLv/BqR8i7QDT/c6TvOtahj7YW60RmNr8DI6QIS
	GXRfWoX4vur4/aKPEyzfrZaWSgzLYSvosUQgQ6fvxiGfqKs0K4ILTdTBbcnRhmUW
	L8PB2+/8j9LPoSOLt834ge7haj8vxy5l2IbPgL6nNmW02erYUiXfgdpLS2Q==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdfchb2xp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 08:56:30 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d932ef41c4so13235775ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788252990; x=1788857790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MatJlJXhqEbHsgisvSSw+ap61p7CAazHvfTs4veKE8o=;
        b=ZaXrksSAcpZjxd7d+XX7cabldZVNZjI6MQoF4PxMc/Fo/qSWt2BhuWuXGoHG8RMvo2
         akdn5YEYT49Zih8C5j506PDhXIGmV3JTvGODEF0dqxKriPP5umSbbBquGiLtRT/uKlTv
         ZHDdNX+2AceRmx70woTkurhLYGizkmCQehhgS2GmaUonaytQKM0Wx4gWUt+IsciOoGsf
         Bf6s3O3kqhKAv2H8KceatqKpsEinamyNHLLDzaHsryaCFqLfyCRqQsqMOtLyyArF8dtN
         KelXJGVIyVS6XQgfGnN6YJQBEfrnsa9QsshvIq9gbI6azIP8NaGxZHAcegGFTZqlvyYN
         AhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252990; x=1788857790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MatJlJXhqEbHsgisvSSw+ap61p7CAazHvfTs4veKE8o=;
        b=CBwskbx2gax8DeQTWV6J9bH2WSYCh6ocGvXDJhBrJhbXoIAQo7cx6n6tB2xtvlOvJk
         NMX5/x2n91VvXwIelr347agS6w/0nGZBmHbzni3uEJoy/ChxqNBaSGWS81Etl8MQvkLD
         DqPVnRRaoGEqX8IlA6hN/XRuoieF5qSiUjhrgSXfUyC5MpJQ5rUhyFGzuENserHlv2nv
         RNt9mHalNhGOnwlSDJQKHUTvVWdvUAvZ9c57abjfx+gND7Mx/luFz8PiDNY86x/aSfUk
         OZKLKlmwzoqr7T/eV+yGnyZwWUM7u3+PePzAO7SRZnkz/xxEviH897QgUjFDxmgQG/5P
         DHkA==
X-Gm-Message-State: AFuF++kzfvyGM8J5ITFp+gyNj5Og8ZdGSxSwQKixto9z89R9pQSa6fVg
	TRqXFa0SES8eZBakiT9oHFMk2d5Sp0+WHSHY0HGPt+1Lvxo0ME6pPOLoUUZSf2Sl0VpJahkwX5k
	AX2ZVgtMwEQdi2ljLE0nZkw6/RRbs8xzCb8QKbE/5SYK6/OzeIWZkAkDeSrwVYtA2NNLNJg==
X-Gm-Gg: AYBFou1TRZEOfqX7Sq+sBXbyBUe/oCajCL/kIGzQLLIaYQ3bfaUzxXeGiZ7LxLPZrdn
	umoa/96Q4vZAGvxkF63APHa/sjzukrkkMutXl3nBWOgAJTXGy0rFb4eBAMNgJa0Sg8Y2YwWuyZh
	LPDtQNDOR6J7Etozd8NCGhIabw4a1ZX6eCF8wZPPBKMfhHlgTXSajERhEou6/Grh6830AWrUp66
	MDjVlReIz5MogTSppDUl8+GLD5si3ClU7TirzrAz18u5lwsXvWQa98kncf5Z1caXOsQE5idPKEl
	L0PhuDt0Em+b2JmDFTBoMnFf1QkFakF81W8XFDm6ndTGywebYLzJnojbH9p3BnNXtjEOcBYBdgN
	a+RM/CrYKQUSQEWkwR7BjKsDVT7BzfVw6qz8yO3qzfJHzt5jROb/Kd8mmd08ePl+oqJyj/UxbqS
	2LjjnQCPZZWxpsxA==
X-Received: by 2002:a17:903:2c08:b0:2d8:d4d2:d139 with SMTP id d9443c01a7336-2d952960702mr42859335ad.21.1788252989749;
        Tue, 01 Sep 2026 01:56:29 -0700 (PDT)
X-Received: by 2002:a17:903:2c08:b0:2d8:d4d2:d139 with SMTP id d9443c01a7336-2d952960702mr42859045ad.21.1788252989294;
        Tue, 01 Sep 2026 01:56:29 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b5bef7683sm22490776eec.12.2026.09.01.01.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:56:28 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH ath-next 2/2] wifi: ath12k: move is_authorized flag to ath12k_sta
Date: Tue,  1 Sep 2026 14:26:16 +0530
Message-Id: <20260901085616.2959268-3-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
References: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SWWCh7l9yI-HUeJmpYT0YPWeTz37GBQi
X-Authority-Analysis: v=2.4 cv=G9Ms1dk5 c=1 sm=1 tr=0 ts=6a96933e cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=P8DYBBCEK76YGRFjgHgA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: SWWCh7l9yI-HUeJmpYT0YPWeTz37GBQi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3OSBTYWx0ZWRfX3ATeJaFXM2IV
 Sgjvq9U5YC92XyBOPlKlVhrV3d57OepDxT6rhUJ96tcJFi2BDqoNlz5Xpsb6QAbYT2vzrU/zjhT
 VEjvjjBE7j0LyDBHeh7bJZ70+3wv9KA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3OSBTYWx0ZWRfX9SWnq6Z0EjGS
 dGRu1J518HsfJdDOQJmFksR1L1cQlS/vUEbmdJp2nvgLg63uoURlxgdEOjys+bbwM/QVhj1lfy2
 gJMpzs6xEFgVHDwE3J6mai58IenfISIJrBljR7xrDSFZtEnNqdwSEZkq2rqpHDa1OaXtiLU4dwm
 V+7/7M8aWbktqdfyyynTCNq/ZgKbizgKOgGil71LXTSa/ASqE26+BiH2Q4AbIDqMlPoNKhaKg1P
 tioA0iE0duqK70WX4Bb03vPh37J0qTAnlCsBB9byYC0EHkm12oa7Yo/kLiAq9+AU/gu44NU5pjN
 dD0Sxz3u8tlUiXLaAIkp/HEiCnPqOUSyCMZ84ZCF7eZcIlPAF92KmUTpn8r5itEC8dyJ8anAvhz
 1TlVdsCPNk0pjaL/iw1x2B8wSjBKFWG6KeV1tYImhsqAaLUtC49Cfeh+63AJ6Mn5hss7V3XZcv1
 j+9edBM+a7zykCiaEzg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010079

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
index 5ddd60e0a1f5..4ec2ee1b17fc 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3914,11 +3914,8 @@ static void ath12k_bss_assoc(struct ath12k *ar,
 	struct ath12k_link_sta *arsta;
 	struct ieee80211_sta *ap_sta;
 	struct ath12k_sta *ahsta;
-	struct ath12k_dp_link_peer *peer;
-	bool is_auth = false;
 	u32 hemode = 0;
 	int ret;
-	struct ath12k_dp *dp = ath12k_ab_to_dp(ar->ab);
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -4022,17 +4019,8 @@ static void ath12k_bss_assoc(struct ath12k *ar,
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
@@ -7020,20 +7008,11 @@ static int ath12k_mac_station_unauthorize(struct ath12k *ar,
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
@@ -7055,21 +7034,12 @@ static int ath12k_mac_station_authorize(struct ath12k *ar,
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

