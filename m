Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D44E4756A3
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252989; cv=none; b=DLnGjgfLX76xjhH3DS1XcwSsWVyRMyvn5LamQsPF8yzoASTgGs5aahxedms9o4mpskVLw8pCZv5Arr1gaanMbYno1NxGl7Smy90Sg+eVyx03XuRzVC76dIcHEeA+8/QzlvIprxLk85zkbnnoYYJngUtrBdWb/PdCDJqS2NMclYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252989; c=relaxed/simple;
	bh=J3c6Y57eUPr44C0TjXh6iy5wDb/0iIeIWFZBTNG15hE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bLXR2WmT4UcDlhs086k+h0hz2j7JAR08F8MpXTWq1MyanAkmnp1Tc0TqgwaWcPLd+HgPxnOy0bJuE+1RPbJJu6ltJJoJj8nMm6Ie6VvSYBJNmuoWKYYuinKOJ/RL34YUe/EyVABLJ6zRHWqb05ZzYniqpMgoWGk2yKNhagsCSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oRjHTYHS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jNx59He6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oRjHTYHS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jNx59He6"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68179Mqe1335519
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2026 08:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=w6W6DtLpCXE
	DbyMXizZ6X6n6NO7Y+i+0cNS1p9Ah5oU=; b=oRjHTYHS/f4a63F1sHnDf1mbkGo
	Y77IdCvCxL9bujVyYClZv3Udi5Oo8RXAIKK8hw8n2MEeYaTOHeMl27r3lYLwCcVT
	creIi1dblIrmbjR2DDbC3Gkk+8nBIOD8GjNY3ysknSADQ9bYE7szWfXx5HC5Ac84
	clDdvWRZezzS+9DRTSmtBvZAlpY6dKVh6UpCMI8tDAUCEVTKIkRu4WnJgcGalu+Y
	Hv0ddU7ybFr5gs3oIRvjCzAqyQueHA7DYl4v9TUu0XuBrtnLMi+KioMHIFFmKiM+
	gwdz+g1t9MU8xDXDxbW7OyUGTG6fewsYNyLr273rRhrxoqcGT4K4asD1DXQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdjtx29h1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 08:56:27 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc2229450b4so862217a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788252987; x=1788857787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w6W6DtLpCXEDbyMXizZ6X6n6NO7Y+i+0cNS1p9Ah5oU=;
        b=jNx59He6Mif75x6JD6vF2Oj0LVlCwiX7ebKqw1teoMGp6KOhJoiAizYEZUak+tSzV1
         W3FScBa/OqxteADs2QCC6IBUWHGqaRbM1fDHwW3WfRc78lV9ba8IbsxiDqs27vL0oxs9
         riEym0LenBC68FIRgabOnPTC+KzOqVGEGYMpKmUGs8m50NVSdCzz3HxXctZeO6YcELKL
         E+lXun83VgYJZNf52Ll1gPuzgLseHYu+KNplEtFcQG6dPnveH1kZzsr82Ir1IXL0jqFB
         2+vZmTCEcB6Sy15M8TkE9QJ66f6IMULkPuLjNCPCmU4E8Zg2OACL2re1jI+PpwdUrPPX
         comA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252987; x=1788857787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w6W6DtLpCXEDbyMXizZ6X6n6NO7Y+i+0cNS1p9Ah5oU=;
        b=XqraX/CRSnGVZ/NiSxJVKri1z5hg1EczzrrZCN3vjL45RGsmBE7feOAWjkN5JWc9kh
         pB1+nwI5SzPcFqblXSuETO3m9di9bmtmEOUQlTIxybCnrsez6k+2RwefCrE/OfTX0FzB
         v42M0tOao9PWuHeRXH1rn/IUsZvthzxiTW2o9Ae0B2rYrP7lnZ82dlXV+T7NnroIZ9EL
         /kj2nay4myAHZnSH/7MWWlYteoiy1cDtqZ/wYyXw+PG7Yn30mu8D+/Yh66jSC3C9OIla
         gt6RM+D4WdLhX5t0hquhvH1rg03Nlsqvukcb0kcJxrSQ0FJjmwbovYCQi3qt0LdF/Sng
         5G0Q==
X-Gm-Message-State: AFuF++kMamnsPLS3vPnJxnGugODEyx3owo+uhZQftSeNrER2e+xTOVux
	3NuAmHcdw2zmYCo9GtKSzyN+OI6DID5EoavwVRD+jrZg6tE0NIB3KanmQrO1yVZ8bzTK+xEVx5Z
	/tOBpe9LNtei9ZuCBYXVTVNnv+vhMx2ta3S9ssIVMxQo/Jxa8bpNwe5MtTcfOWN6ZFHDu6w==
X-Gm-Gg: AYBFou0T6tQGISBf0AQD+H9f9Xxl799wYXHfHlQ23LiV70OU83t1yOciK8zi6xJmCQB
	yx5ceCueFf/c8kJi0OHWbyD8VuNvZO2FjGfOkPLcSk0TGvvxTd7oT2JkRWrqhGBTwUgJEjwUzwI
	8v0D2oByUfcalZWZTTmc5sSCv6e//zTtIxEAqkCo0/wItw+PFEgOAAwLbaAwNLvl9KI81w6WqE2
	4rZTXD4ni94PA2sauDDDNt8mvVv/NrZDBd5R7qMe261ar68B5lop1pqlmH+DrewwjJG5eUJA3A/
	7m0isp4kE3gzm4e0mhuiO2W4K6GPtI49xOMFziUvbYARIwQr+8hLlIM9WJ1WeqvyYFSYk7h4DtG
	kp2VKE3EfEQ6iKtU4591Z5e1A1dT/CRhT1zb6VrWcHRKFchAJhPSdM4Ii1ClrtdUNHiCdMe+j31
	ZnHndh/txTaNH1gQ==
X-Received: by 2002:a17:90b:4ac4:b0:37f:e1b6:4c7d with SMTP id 98e67ed59e1d1-396d0e20f0bmr43860192a91.6.1788252986430;
        Tue, 01 Sep 2026 01:56:26 -0700 (PDT)
X-Received: by 2002:a17:90b:4ac4:b0:37f:e1b6:4c7d with SMTP id 98e67ed59e1d1-396d0e20f0bmr43860144a91.6.1788252985898;
        Tue, 01 Sep 2026 01:56:25 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b5bef7683sm22490776eec.12.2026.09.01.01.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:56:25 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>,
        Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
Subject: [PATCH ath-next 1/2] wifi: ath12k: store station pointer only in dp_peer
Date: Tue,  1 Sep 2026 14:26:15 +0530
Message-Id: <20260901085616.2959268-2-aishwarya.r@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=K78S2SWI c=1 sm=1 tr=0 ts=6a96933b cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=5RRWBY4WAAAA:8 a=8WS1tjZTedTbqMPykTkA:9 a=bFCP_H2QrGi7Okbo017w:22
 a=drtMOSl5Q_Tsf-UZi3mY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3OSBTYWx0ZWRfXx5yZiPLqvgqH
 Eurjv+lL6h62PYVr6O1CqM6AOVfbYXQ/txh7BDKqrPphR73bb/7YpQgo9mQtfnwhA2IxvP/uJIG
 jAApbeyqVTAcvS27DVR9qjd27aIa1dg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3OSBTYWx0ZWRfX9Cg/Gk8fOdqY
 BrDrpiAYq+IxsvxrNtlCVP8tMD0oNm0T2H7LHcuC0vMwFtGthhiKcTEAzzCEJLnGg2J+QG6o2Uk
 MCAxeFccNhfJ3Wuz7RLuaCMgOwp400iY42W/aQnXsRnltKCq6yFDB/E6m4B0eeW/cA5+bTWvhvy
 KHbgw4BalxijZ8W+DR/zQtC04x2sx0lEHocSJR8Pbbyn8fFQHBcjb1Q+xELiMcSJrZejwVTB2LK
 f8DgggUzpRh8QsyiBf3nFB111cQ7D9Tf1ma7/VEuTU861XMuBrzVycCz32rBsNwq251Rb4QeK9E
 6cC/WZmAAeHVremXhh+F1JkLfL7k65R4qGXXC6TtTcAY+YlTqKT1YJG7nxLW9MfBAZOkBhVdFi4
 dK/Hj7TXZcmXvZiqGWbnEejLuVIADkHLuuvIL/tcAU7v0DqSHJGLRZc9hCuTEeZYN0uzTEpf40O
 aelKZbqNNn+AVC+D03A==
X-Proofpoint-GUID: n632opjIkpYcdhgMjrLvg1cAY8JbKsPg
X-Proofpoint-ORIG-GUID: n632opjIkpYcdhgMjrLvg1cAY8JbKsPg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010079

The station pointer is currently stored in both ath12k_dp_peer and
ath12k_dp_link_peer. Since the station association is peer-wide rather
than link-specific, keeping a copy in the link peer duplicates state
without providing additional value.

Remove the duplicate pointer from ath12k_dp_link_peer and access the
station through the dp_peer instead. Add helper accessors and
update the remaining users accordingly. Remove the unused
ath12k_dp_link_peer_to_link_sta() helper as well.

This consolidates peer ownership information in a single location and
avoids maintaining duplicate state.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Co-developed-by: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
Signed-off-by: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
 drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 -------------------
 drivers/net/wireless/ath/ath12k/dp_peer.h     | 16 ++++++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
 drivers/net/wireless/ath/ath12k/mac.c         | 11 +++----
 drivers/net/wireless/ath/ath12k/peer.c        |  2 --
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++++-----
 drivers/net/wireless/ath/ath12k/wmi.c         |  2 +-
 9 files changed, 31 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_htt.c b/drivers/net/wireless/ath/ath12k/dp_htt.c
index 68968f96b4f1..72069640bd38 100644
--- a/drivers/net/wireless/ath/ath12k/dp_htt.c
+++ b/drivers/net/wireless/ath/ath12k/dp_htt.c
@@ -276,7 +276,7 @@ ath12k_update_per_peer_tx_stats(struct ath12k_pdev_dp *dp_pdev,
 	rcu_read_lock();
 	peer = ath12k_dp_link_peer_find_by_peerid(dp_pdev, usr_stats->peer_id);
 
-	if (!peer || !peer->sta) {
+	if (!ath12k_dp_link_peer_get_sta(peer)) {
 		rcu_read_unlock();
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index bb5341b4251a..06f6eccfb574 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -195,35 +195,6 @@ void ath12k_dp_link_peer_map_event(struct ath12k_base *ab, u8 vdev_id, u16 peer_
 	spin_unlock_bh(&dp->dp_lock);
 }
 
-struct ath12k_link_sta *ath12k_dp_link_peer_to_link_sta(struct ath12k_base *ab,
-							struct ath12k_dp_link_peer *peer)
-{
-	struct ath12k_sta *ahsta;
-	struct ath12k_link_sta *arsta;
-
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
-			 "ath12k_dp_link_peer to ath12k_link_sta called without rcu lock");
-
-	if (!peer->sta)
-		return NULL;
-
-	ahsta = ath12k_sta_to_ahsta(peer->sta);
-	if (peer->ml_id & ATH12K_PEER_ML_ID_VALID) {
-		if (!(ahsta->links_map & BIT(peer->link_id))) {
-			ath12k_warn(ab, "peer %pM id %d link_id %d can't found in STA link_map 0x%x\n",
-				    peer->addr, peer->peer_id, peer->link_id,
-				    ahsta->links_map);
-			return NULL;
-		}
-		arsta = rcu_dereference(ahsta->link[peer->link_id]);
-		if (!arsta)
-			return NULL;
-	} else {
-		arsta =  &ahsta->deflink;
-	}
-	return arsta;
-}
-
 static int ath12k_dp_link_peer_rhash_addr_tbl_init(struct ath12k_dp *dp)
 {
 	struct ath12k_base *ab = dp->ab;
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index 3503840b0329..256fc79d714e 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -70,7 +70,6 @@ DECLARE_EWMA(avg_rssi, 10, 8)
 
 struct ath12k_dp_link_peer {
 	struct list_head list;
-	struct ieee80211_sta *sta;
 	struct ath12k_dp_peer *dp_peer;
 	int vdev_id;
 	u8 addr[ETH_ALEN];
@@ -159,8 +158,6 @@ ath12k_dp_link_peer_find_by_ast(struct ath12k_dp *dp, int ast_hash);
 struct ath12k_dp_link_peer *
 ath12k_dp_link_peer_find_by_pdev_and_addr(struct ath12k_dp *dp, u8 pdev_idx,
 					  const u8 *addr);
-struct ath12k_link_sta *ath12k_dp_link_peer_to_link_sta(struct ath12k_base *ab,
-							struct ath12k_dp_link_peer *peer);
 int ath12k_dp_link_peer_rhash_tbl_init(struct ath12k_dp *dp);
 void ath12k_dp_link_peer_rhash_tbl_destroy(struct ath12k_dp *dp);
 int ath12k_dp_link_peer_rhash_add(struct ath12k_dp *dp,
@@ -183,4 +180,17 @@ ath12k_dp_link_peer_find_by_peerid(struct ath12k_pdev_dp *dp_pdev, u16 peer_id);
 void ath12k_dp_link_peer_free(struct ath12k_dp_link_peer *peer);
 int ath12k_dp_peer_fixup_peer_id(struct ath12k_base *ab, const u8 *peer_addr,
 				 u16 peer_id);
+
+static inline struct ieee80211_sta *__must_check
+ath12k_dp_peer_get_sta(const struct ath12k_dp_peer *peer)
+{
+	return peer ? peer->sta : NULL;
+}
+
+static inline struct ieee80211_sta *__must_check
+ath12k_dp_link_peer_get_sta(const struct ath12k_dp_link_peer *link_peer)
+{
+	return link_peer && link_peer->dp_peer ?
+		link_peer->dp_peer->sta : NULL;
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..cdb795567e8c 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1382,7 +1382,7 @@ void ath12k_dp_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev, struct napi_struc
 
 	peer = ath12k_dp_peer_find_by_peerid(dp_pdev, rxcb->peer_id);
 
-	pubsta = peer ? peer->sta : NULL;
+	pubsta = ath12k_dp_peer_get_sta(peer);
 
 	status->link_valid = 0;
 	if (pubsta && pubsta->valid_links)
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 99bf5cf79d10..5ddd60e0a1f5 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1232,7 +1232,7 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
 	spin_lock_bh(&dp->dp_lock);
 	list_for_each_entry_safe(peer, tmp, &dp->peers, list) {
 		/* Skip Rx TID cleanup for self peer */
-		if (peer->sta && peer->dp_peer)
+		if (ath12k_dp_link_peer_get_sta(peer))
 			ath12k_dp_rx_peer_tid_cleanup(ar, peer);
 
 		/* cleanup dp peer */
@@ -7005,10 +7005,9 @@ static void ath12k_mac_station_post_remove(struct ath12k *ar,
 
 	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, arvif->vdev_id,
 							 arsta->addr);
-	if (peer && peer->sta == sta) {
+	if (peer && ath12k_dp_link_peer_get_sta(peer) == sta) {
 		ath12k_warn(ar->ab, "Found peer entry %pM n vdev %i after it was supposedly removed\n",
 			    vif->addr, arvif->vdev_id);
-		peer->sta = NULL;
 
 		ath12k_dp_link_peer_free(peer);
 		ar->num_peers--;
@@ -13292,6 +13291,7 @@ ath12k_mac_validate_fixed_rate_settings(struct ath12k *ar, enum nl80211_band ban
 	bool eht_fixed_rate = false, he_fixed_rate = false, vht_fixed_rate = false;
 	const u16 *vht_mcs_mask, *he_mcs_mask, *eht_mcs_mask;
 	struct ieee80211_link_sta *link_sta;
+	struct ieee80211_sta *sta;
 	struct ath12k_dp_link_peer *peer, *tmp;
 	u8 vht_nss, he_nss, eht_nss;
 	int ret = true;
@@ -13321,8 +13321,9 @@ ath12k_mac_validate_fixed_rate_settings(struct ath12k *ar, enum nl80211_band ban
 	rcu_read_lock();
 	spin_lock_bh(&dp->dp_lock);
 	list_for_each_entry_safe(peer, tmp, &dp->peers, list) {
-		if (peer->sta) {
-			link_sta = rcu_dereference(peer->sta->link[link_id]);
+		sta = ath12k_dp_link_peer_get_sta(peer);
+		if (sta) {
+			link_sta = rcu_dereference(sta->link[link_id]);
 			if (!link_sta) {
 				ret = false;
 				goto exit;
diff --git a/drivers/net/wireless/ath/ath12k/peer.c b/drivers/net/wireless/ath/ath12k/peer.c
index 80edebf0e364..0e894408e97f 100644
--- a/drivers/net/wireless/ath/ath12k/peer.c
+++ b/drivers/net/wireless/ath/ath12k/peer.c
@@ -266,8 +266,6 @@ int ath12k_peer_create(struct ath12k *ar, struct ath12k_link_vif *arvif,
 	}
 
 	peer->pdev_idx = ar->pdev_idx;
-	peer->sta = sta;
-
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		dp_link_vif->ast_hash = peer->ast_hash;
 		dp_link_vif->ast_idx = peer->hw_peer_id;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 016b0c38e51e..71b85394d487 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -3362,7 +3362,7 @@ ath12k_wifi7_dp_mon_srng_process(struct ath12k_pdev_dp *pdev_dp, int *budget,
 
 		rcu_read_lock();
 		peer = ath12k_dp_link_peer_find_by_peerid(pdev_dp, ppdu_info->peer_id);
-		if (!peer || !peer->sta) {
+		if (!ath12k_dp_link_peer_get_sta(peer)) {
 			ath12k_dbg(ab, ATH12K_DBG_DATA,
 				   "failed to find the peer with monitor peer_id %d\n",
 				   ppdu_info->peer_id);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa..2a05e03194aa 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -552,13 +552,12 @@ ath12k_dp_tx_htt_tx_complete_buf(struct ath12k_dp *dp,
 	}
 
 	peer = ath12k_dp_link_peer_find_by_peerid(dp_pdev, peer_id);
-	if (!peer || !peer->sta) {
+	status.sta = ath12k_dp_link_peer_get_sta(peer);
+	if (!status.sta) {
 		ath12k_dbg(ab, ATH12K_DBG_DATA,
 			   "dp_tx: failed to find the peer with peer_id %d\n", peer_id);
 		ieee80211_free_txskb(ath12k_pdev_dp_to_hw(dp_pdev), msdu);
 		goto exit;
-	} else {
-		status.sta = peer->sta;
 	}
 
 	status.info = info;
@@ -627,7 +626,8 @@ static void ath12k_wifi7_dp_tx_update_txcompl(struct ath12k_pdev_dp *dp_pdev,
 	int ret;
 
 	peer = ath12k_dp_link_peer_find_by_peerid(dp_pdev, ts->peer_id);
-	if (!peer || !peer->sta) {
+	sta = ath12k_dp_link_peer_get_sta(peer);
+	if (!sta) {
 		ath12k_dbg(dp->ab, ATH12K_DBG_DP_TX,
 			   "failed to find the peer by id %u\n", ts->peer_id);
 		return;
@@ -635,7 +635,6 @@ static void ath12k_wifi7_dp_tx_update_txcompl(struct ath12k_pdev_dp *dp_pdev,
 
 	spin_lock_bh(&dp->dp_lock);
 
-	sta = peer->sta;
 	ahsta = ath12k_sta_to_ahsta(sta);
 	arsta = &ahsta->deflink;
 
@@ -752,6 +751,7 @@ static void ath12k_wifi7_dp_tx_complete_msdu(struct ath12k_pdev_dp *dp_pdev,
 	struct ieee80211_rate_status status_rate = {};
 	struct ath12k_dp_link_peer *peer;
 	struct rate_info rate;
+	struct ieee80211_sta *sta;
 
 	if (WARN_ON_ONCE(ts->buf_rel_source != HAL_WBM_REL_SRC_MODULE_TQM)) {
 		/* Must not happen */
@@ -846,7 +846,8 @@ static void ath12k_wifi7_dp_tx_complete_msdu(struct ath12k_pdev_dp *dp_pdev,
 	ath12k_wifi7_dp_tx_update_txcompl(dp_pdev, ts);
 
 	peer = ath12k_dp_link_peer_find_by_peerid(dp_pdev, ts->peer_id);
-	if (!peer || !peer->sta) {
+	sta = ath12k_dp_link_peer_get_sta(peer);
+	if (!sta) {
 		ath12k_err(ab,
 			   "dp_tx: failed to find the peer with peer_id %d\n",
 			   ts->peer_id);
@@ -854,7 +855,7 @@ static void ath12k_wifi7_dp_tx_complete_msdu(struct ath12k_pdev_dp *dp_pdev,
 		goto exit;
 	}
 
-	status.sta = peer->sta;
+	status.sta = sta;
 	status.info = info;
 	status.skb = msdu;
 	rate = peer->last_txrate;
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d5160af60e00..9bed852f66c5 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -7373,7 +7373,7 @@ static void ath12k_mgmt_rx_event(struct ath12k_base *ab, struct sk_buff *skb)
 			dev_kfree_skb(skb);
 			goto exit;
 		}
-		pubsta = peer->sta;
+		pubsta = ath12k_dp_link_peer_get_sta(peer);
 		if (pubsta && pubsta->valid_links) {
 			status->link_valid = 1;
 			status->link_id = peer->link_id;
-- 
2.34.1

