Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1C39C63E
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529822; cv=none; b=LQRkMLMITSGVu/HwO5Gh1J+l8pPUEBeyPMJJ/tB1rCJ6rNtiN6mPfK0XBlxF+oTJ8Z/lxoa8w9l7NgRjXqHZbQlvt5rH52u2NdVbFuRglrSMMszKtAkFg7Cz8fCB0cJzcJ5G9sJHJXpNKAykHOX8PWq9QPwdp0VquWoKUe6bg4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529822; c=relaxed/simple;
	bh=Ou4xjKO29BEr84tp+hcSjLxPMBWoI8AasAo1v7PeQVM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LFbCzJNjHCVJoNA54HOOci4GlU3oP2yjhVO7CP7CNVWqWDt1wfu26spcoELrLvFo/vxG5gJQS1OzlgkQSFTuWuvWNrB86haoJ1ozg1suH1U63UylGYigjKNz2/XCm0pdRnlgvF0YpI5rE90IYTxFC8+fF3HlzyAKUfx5tvS8vcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fU+l8DGx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d9VLpqiZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fU+l8DGx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d9VLpqiZ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6RgAg1774812
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lbntze55jigljzoUT73kZ+mmGEEM5eO3u1lu+cENJLU=; b=fU+l8DGxf2/IUAEx
	ueds5ln7gpP20UQGJmSIAW5j91OfuYxXhc6rqZCuFKGqNLU3uggL+W1uiLuCDvPP
	lJYn6bn9dG7MqBlg9gJiyRZtT5buPpRM02gRIZ5IE5/DlSllg24mEVm3vy0Vmh9I
	WdVRVCvjfss5f6PaG1AaUNZLlFfGPYEYq8A2+Tis76fWekEopgErrES2QMVGiEby
	CSgd+YhGOvaqafvy/a31BGyQZQGxEj9K0hcmzS/stT7dpvhPJ/df7NrEXH6xynh1
	XUwug31IWzaZT71hPGAwoInlhasRqjv9rWraH+C6VQLzSCKdk718NOk1H00SB0H3
	iqI5kQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2af4sa0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:37 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84240683a82so3252390b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529817; x=1785134617; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lbntze55jigljzoUT73kZ+mmGEEM5eO3u1lu+cENJLU=;
        b=d9VLpqiZB98drUruDWe7mtyaTFUaSEcHa8vAHuuaT3SNl92V8SWQJQHvXCzdE5xDc8
         J+xCPXL3IA9t4lKKh8CYJtCZY3bthhGilG/oCMx2zw1MD7HJAytJI9rNex4KAb/ji7H9
         ++cIPAhC8QqJi2H+44FmOu6P1Qvk1+JXa9AWXVeRerkb3IN1/7ip6a21XIs+CmtxqjpX
         JEAGlPeJs8WDhU+wkwupaKHTLR+iAC49KI5rVJ5SFjWOBPRDgB8CCnoCPYqLJ4DqO8wg
         +vArRqBNLBcVQR6RHxTeK1zLgXTMD90GeeaVqZaL9fWuGOOXDaCxRJSfTuU+cFEXJPr5
         G+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529817; x=1785134617;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lbntze55jigljzoUT73kZ+mmGEEM5eO3u1lu+cENJLU=;
        b=P26i3rpd8MFUbFzwrOFpibA1QoeHH1e4vaNe6UGF/NNMtthgddw5XBT12u28ITfifC
         4VZW+efj6IEgM3+QWVBDwbeaCEKqtDTQDiFwMr3jTGABaPrnWJBOiULn2JJBv/MQ6e+g
         uzakl5sZFofsBvY+qrtU1zBSxMmAduHTJOLfKBjbenbYZWIghXP4hqJRArRyMfKGhkaO
         QoYgqCJLuXfxwk1I4i0LshfST42LBJGF7sBxVaqDW+m8GPz/XEZE3OWGywLxatsJVTFI
         delNM9EOq2gcbMzfiw/BKaK5BAjvx7ipd4n0mWQ530jirNjDZyMaMpIfC/fgh9NqUGqh
         r8/A==
X-Gm-Message-State: AOJu0Yz5sWbTvbsygFvp/ud4AbYlBfSyYji6aNdJ8kv9l8hjZ1DX0eCN
	IZ+NSSBXSa0vesprAHn+ix7on8aIsXxTOqGKBiJSc2EqCe8ESgcGdOIIG0gWliaVOzEP3AYw1Gr
	a8Mu0Srb7nBU8/WQRPPZp0jNnLEgrhbXEb/32uistmd7tUh1Frxcv5cx1FKSkLSxfbV4CQw==
X-Gm-Gg: AfdE7cnGTZgOWhCHYpFsyadSiXL5xbqDtSoIeHXlHK7N7/C1rkWkn4x0eOdUGowG6pE
	EjRcoK+xSACfY4rCXHQOQooasgeRLdsgGqnYJKQsO2jW1UBVZu78HIY3BHWIQE24ZGn/sgLHPqI
	eoY0YX6/mWayLNSTNbqdFTUnhL8Rw87DArBVm57HoPGPs68D9AtyIeEqc1a2eGDScQCqOj+7XJK
	ktpKLGVyoALtf4nAvLsQ+bvwF4M36IDINEprlzfrouk6IvD1ZNdIrsmOaYe7utJs0djQrRpYNNp
	9ZUs0q4xitsltygljeqVji77xgvHkkW6A/RCnnPEJwxmFsEgkdxHaaL/3Hg7gh/RJT0FEVOhzvE
	kyMFNToslu+D2mCVTMuYaBMJcLYg5krrI5jnzs26TxVwDwprgoRrKKQ==
X-Received: by 2002:a05:6a00:429a:b0:842:3838:cb03 with SMTP id d2e1a72fcca58-84c2858d945mr11950265b3a.11.1784529816859;
        Sun, 19 Jul 2026 23:43:36 -0700 (PDT)
X-Received: by 2002:a05:6a00:429a:b0:842:3838:cb03 with SMTP id d2e1a72fcca58-84c2858d945mr11950244b3a.11.1784529816388;
        Sun, 19 Jul 2026 23:43:36 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:34 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:43:24 +0800
Subject: [PATCH ath-current v2 3/8] wifi: ath12k: keep
 ATH12K_PEER_ML_ID_VALID set in ath12k_sta::ml_peer_id
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-3-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfXwr18hS/opsFg
 rh9vxuwGwbZWu3MsPGYchDkZPbR2rlyiQq4T6Q7gCz8Y0I90Z/oxrZkS/20eQ0dXmX6OjiShg3L
 dMF1P+wqjYOPVG51k6HXpLpMBwCNKzU=
X-Proofpoint-GUID: KiXKH-B5_2hhLmT18vTcUMdZZuHHPHvP
X-Proofpoint-ORIG-GUID: KiXKH-B5_2hhLmT18vTcUMdZZuHHPHvP
X-Authority-Analysis: v=2.4 cv=a+sAM0SF c=1 sm=1 tr=0 ts=6a5dc399 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=MLhnoK1rgViGvFeMoKUA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX1HTo3QJfxrXt
 vVzDCnvXLD2tNAFpWWkWNp0vYwBx8sLJCBSdlDFQKLby83G12HZ49RC5sWfzngcXHAtl4A7GK60
 gLvGJJ4YesZdy2B99Xo+2MaCZOGWkdm+LUFkJuiGkja3BSmiiA3bDnJHlPIzYdeVK/jCiuL/bBI
 W7r/Vny/P0ptTw4RXzEnf6Arz0Gkqg69gabZ1m1qQHcjbe9j9wVim+DhHnku8jE5Yfy1HIRqIko
 Li82BvBxba8a7rR2IRd2CM8hLT79Cwk0ixP9aTaEsbHDhqxiUceAtT9WSNgkO9uMkyGy7cXbLwv
 2TwBw3c6QPXQCzFEeK82Y02gdQqh9tsw5l1N6rxXHNjkwoGXkz082X7GLKZU82xRea9DsWg6XMv
 WtlCtuQD/SFVOaLPZoJ5TY0qW93X7LqCGpTTJppjilVHq+CIV+9D9nS7CpLeojM2/CJOSDguSkw
 /XPm4LffdEB9CEcz5NQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200072

Several pieces of host bookkeeping for MLD peer IDs encode the
same fact in different ways:

  - ath12k_sta::ml_peer_id stores the raw ID in [0, ATH12K_MAX_MLO_PEERS);
  - ath12k_dp_peer::peer_id, ath12k_dp_link_peer::ml_id and the index used
    on ath12k_dp_hw::dp_peers[] always carry the ATH12K_PEER_ML_ID_VALID
    bit (BIT(13)) when the ID is real;
  - WMI_MLO_PEER_ASSOC_PARAMS::ml_peer_id sent down to firmware is
    raw, without the bookkeeping bit.

The mismatch leaks into call sites that have to remember to OR
the bit in (ath12k_peer_create(), ath12k_mac_op_sta_state()) or
remember not to (ath12k_peer_assoc_h_mlo()).

Make ath12k_sta::ml_peer_id carry the VALID bit when valid, the same
way ath12k_dp_peer::peer_id and ath12k_dp_link_peer::ml_id do:

  - ath12k_peer_ml_alloc() OR-s the bit in once on the way out;
    the internal bitmap stays raw [0, ATH12K_MAX_MLO_PEERS);
  - ath12k_peer_create() and ath12k_mac_op_sta_state() drop the
    explicit OR;
  - ath12k_peer_assoc_h_mlo() masks the bit off when populating
    the WMI ml_peer_id;

While there, introduce ath12k_peer_ml_free() to mirror
ath12k_peer_ml_alloc(), which helps avoid code duplication.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c  | 27 +++++++++++++--------------
 drivers/net/wireless/ath/ath12k/peer.c | 17 ++++++++++++++---
 drivers/net/wireless/ath/ath12k/peer.h |  1 +
 3 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 3e3b06e15f80..7d0d7d5fbf53 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1278,16 +1278,15 @@ void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah)
 	struct ath12k_dp_peer *dp_peer, *tmp;
 	struct ath12k_dp_hw *dp_hw = &ah->dp_hw;
 
+	lockdep_assert_wiphy(ah->hw->wiphy);
+
 	INIT_LIST_HEAD(&peers);
 
 	spin_lock_bh(&dp_hw->peer_lock);
 	list_for_each_entry_safe(dp_peer, tmp, &dp_hw->dp_peers_list, list) {
 		if (dp_peer->is_mlo) {
-			struct ath12k_sta *ahsta = ath12k_sta_to_ahsta(dp_peer->sta);
-
 			rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
-			clear_bit(ahsta->ml_peer_id, ah->free_ml_peer_id_map);
-			ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;
+			ath12k_peer_ml_free(ah, ath12k_sta_to_ahsta(dp_peer->sta));
 		}
 
 		list_move(&dp_peer->list, &peers);
@@ -3547,7 +3546,11 @@ static void ath12k_peer_assoc_h_mlo(struct ath12k_link_sta *arsta,
 
 	ether_addr_copy(ml->mld_addr, sta->addr);
 	ml->logical_link_idx = arsta->link_idx;
-	ml->ml_peer_id = ahsta->ml_peer_id;
+	/*
+	 * WMI_MLO_PEER_ASSOC_PARAMS expects the raw ML peer ID without
+	 * the host-side ATH12K_PEER_ML_ID_VALID bookkeeping bit.
+	 */
+	ml->ml_peer_id = ahsta->ml_peer_id & ~ATH12K_PEER_ML_ID_VALID;
 	ml->ieee_link_id = arsta->link_id;
 	ml->num_partner_links = 0;
 	ml->eml_cap = sta->eml_cap;
@@ -7264,10 +7267,8 @@ static void ath12k_mac_ml_station_remove(struct ath12k_vif *ahvif,
 		ath12k_mac_free_unassign_link_sta(ah, ahsta, link_id);
 	}
 
-	if (sta->mlo) {
-		clear_bit(ahsta->ml_peer_id, ah->free_ml_peer_id_map);
-		ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;
-	}
+	if (sta->mlo)
+		ath12k_peer_ml_free(ah, ahsta);
 }
 
 static int ath12k_mac_handle_link_sta_state(struct ieee80211_hw *hw,
@@ -7739,7 +7740,7 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 			}
 
 			dp_params.is_mlo = true;
-			dp_params.peer_id = ahsta->ml_peer_id | ATH12K_PEER_ML_ID_VALID;
+			dp_params.peer_id = ahsta->ml_peer_id;
 		}
 
 		dp_params.sta = sta;
@@ -7876,10 +7877,8 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 peer_delete:
 	ath12k_dp_peer_delete(&ah->dp_hw, sta->addr, sta);
 ml_peer_id_clear:
-	if (sta->mlo) {
-		clear_bit(ahsta->ml_peer_id, ah->free_ml_peer_id_map);
-		ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;
-	}
+	if (sta->mlo)
+		ath12k_peer_ml_free(ah, ahsta);
 exit:
 	/* update the state if everything went well */
 	if (!ret)
diff --git a/drivers/net/wireless/ath/ath12k/peer.c b/drivers/net/wireless/ath/ath12k/peer.c
index c222bdaa333c..ae93731b4177 100644
--- a/drivers/net/wireless/ath/ath12k/peer.c
+++ b/drivers/net/wireless/ath/ath12k/peer.c
@@ -230,7 +230,7 @@ int ath12k_peer_create(struct ath12k *ar, struct ath12k_link_vif *arvif,
 		/* Fill ML info into created peer */
 		if (sta->mlo) {
 			ml_peer_id = ahsta->ml_peer_id;
-			peer->ml_id = ml_peer_id | ATH12K_PEER_ML_ID_VALID;
+			peer->ml_id = ml_peer_id;
 			ether_addr_copy(peer->ml_addr, sta->addr);
 
 			/* the assoc link is considered primary for now */
@@ -276,9 +276,20 @@ u16 ath12k_peer_ml_alloc(struct ath12k_hw *ah)
 	}
 
 	if (ml_peer_id == ATH12K_MAX_MLO_PEERS)
-		ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;
+		return ATH12K_MLO_PEER_ID_INVALID;
 
-	return ml_peer_id;
+	return ml_peer_id | ATH12K_PEER_ML_ID_VALID;
+}
+
+void ath12k_peer_ml_free(struct ath12k_hw *ah, struct ath12k_sta *ahsta)
+{
+	lockdep_assert_wiphy(ah->hw->wiphy);
+
+	if (ahsta->ml_peer_id <
+	    (ATH12K_MAX_MLO_PEERS | ATH12K_PEER_ML_ID_VALID))
+		clear_bit(ahsta->ml_peer_id & ~ATH12K_PEER_ML_ID_VALID,
+			  ah->free_ml_peer_id_map);
+	ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;
 }
 
 int ath12k_peer_mlo_link_peers_delete(struct ath12k_vif *ahvif, struct ath12k_sta *ahsta)
diff --git a/drivers/net/wireless/ath/ath12k/peer.h b/drivers/net/wireless/ath/ath12k/peer.h
index 49d89796bc46..0f7f25b8e89c 100644
--- a/drivers/net/wireless/ath/ath12k/peer.h
+++ b/drivers/net/wireless/ath/ath12k/peer.h
@@ -26,4 +26,5 @@ int ath12k_link_sta_rhash_add(struct ath12k_base *ab, struct ath12k_link_sta *ar
 struct ath12k_link_sta *ath12k_link_sta_find_by_addr(struct ath12k_base *ab,
 						     const u8 *addr);
 u16 ath12k_peer_ml_alloc(struct ath12k_hw *ah);
+void ath12k_peer_ml_free(struct ath12k_hw *ah, struct ath12k_sta *ahsta);
 #endif /* _PEER_H_ */

-- 
2.25.1

