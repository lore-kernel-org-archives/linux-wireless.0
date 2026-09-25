Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277B27442
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313059; cv=none; b=UuS+KvD1uh5KBiHn3XQ+SpbxxLzj1oZKO+x98yb0aOc72c/qJYZVAhGPiPQaTwOplIcajRNfLSQvd/FfghB6FJ6r688CKu98SfNBhuTPFuFUMDpxSS5Ur14hTlLSGF1LI6UTF2TPjjnxJENq78OsBN7i36gQpFbpaYpJKrdRwJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313059; c=relaxed/simple;
	bh=+Nm542u85wI9i8/YjhA4fzB7drP1RYxXS0BiYO05cwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C5wN7saQzPc4lckfwLPApY/ALD8blDxOV5oxMENz2qHXaQmqh5QX+RrGmTV2ULgEQ3h5ERbk0YCe1+ntMKlHRcPxwlCsuuM72bmEuA3tNIH/MKZyv6LwP057Ioz/HI8TrummrDSIr4k6wGOnXbgxImKzbUVNUgj2dFeKqTI0q2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fCIB1si8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Hho3i16D; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fCIB1si8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Hho3i16D"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4YbrX3532122
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=wVHTqP8zfo0
	aIiUJzfx87sJgU+I1m7auf3WAygPSkaI=; b=fCIB1si8FDu+06SeCamYHf0lbe/
	NgbW3vFl+uJ2dN/xO2WXZsg13gA6+hDhME7lLPGReDWd1SELQLF8G9bakIvJdYHL
	L0WqkkqUeKAcnyx0LtNFkGMStHkQTI85Yb+IF/h+zf/veJjoB5gCJNGj9aajCXgk
	IZbr+3m2opJ3C1yWzrPAIZnN4FeEk9/tKQwiDe9/mMCK6hPTD/4SEflGU3VH4Wsu
	E9mYdngnr9Tl7TVxeIn1F3v1dmBvZSBcTM017Kwg3EctOSHJpq1qSmaChBcRYeLu
	M/XQU+1YDn4U0gcK1D62mLeOSOnHM3FLU613djmbEIoMAb5d9qy/ARkSn+g==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw94k9tdc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:10:56 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-32b8c2b30c4so848693eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 22:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790313056; x=1790917856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wVHTqP8zfo0aIiUJzfx87sJgU+I1m7auf3WAygPSkaI=;
        b=Hho3i16DWgyv8KlPu5iiQEL35AJiw7rtgmvPWDgNwBid0F5UOw9Zsb73Zsz1tqsVr1
         UmNs7c0JwdynhBhDbFiGHqfi2SoOSqd2MpgP7ckRxZrleqXRYBZmo3tFiu7mtPnpZlsg
         rpixokhgoh3eeLHPoKegJG3F67ME5GTAEyH7w2yksYPiC9VZ0wzY6MrL8ZiM9uQA25Ik
         wIQQyZhoSA8rtWqs39QIKN4SdTXV0JjM9ztW4lUl1hwUpQcIJrzzuTsBQVQMtrK7AWtx
         VF4PYhizF3NDsiV9lxzlm/tL1lxQlHnMMOFlwpifPm6heWquflRbnGNy9H+QGwIzaeBA
         v1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790313056; x=1790917856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wVHTqP8zfo0aIiUJzfx87sJgU+I1m7auf3WAygPSkaI=;
        b=xKhoiIRN/RbPKdX0sSd7GB3IMp0K6BKhQf06IZK4t1lJZgs4yq051D+3u7ewJ4VH1Q
         uqrW5jit3h4u3AprWFJvD9PUX2TtjBqgaDXGhsk9i+idqZuJkI9a8ViC7nnTGqBCPoDG
         tZd8em+9SHvrzx21UHYMLXNeMeHWuOmbVoOG86itXGoa7DMKUr8CLAGBGzgaCIn/yAuu
         HQ/yBdQdDdpy+z5L3q10+XteyZe6svbktKO0NfltVm5qpfgUr+I7Op4BvbCh2OiLzbhX
         LcXVLOb4nWLnwoy7RbT/bs9H7JbR8WkBdtkKK0NWtF/f5HlvWz20svsabKnzZUwjrb3c
         Fyiw==
X-Gm-Message-State: AFuF++lzutDJGKH+8cyuEsTN4eSKnRG+Ab58M9a4D3N1AUhrmZ6GwcIw
	e7bdJo9eIMbqqgwVmEW7l35fKvpbYgPz0XKT6RV8qjBUujhf+gMY+fEA+pjAIVOhdOf175CC5mp
	QQZeQFXuznpOD+c7Aox11uoalOiOgairNONS8vneZ5IRjCWHwDJapxU2cTMUhlYAOxruZrw==
X-Gm-Gg: AYBFou35XxTCKjVbln25h60KxQfhn2aRuumqrwzyXxZZwe2qmfoZLEck9JU0id7XzjG
	Vgv3tVuJTiPOHW+XRV5sjlwe+eHgNuzLJr16VdDgpvxxplUrl7Bnw5OmA8N9b+yQl0rRxmS0G8G
	4QbsxKufBskN7Wj38Vneq8/HVecgZ0jH7GdTrtUZ1lkFnmiu8Qr3OpJpWlP0Ksn9Lagw0cAiZ9O
	J79KDYs03t3d9auxvZrFxNfySQGgKlV+1ncyll39DWKfZhiAy4RifLNIHtjcpYezQQPzjZtdCW+
	UAS/kjLFTbU8JdundCACTBEQsrSAB0PGm6sGyBv7HaVnHzVAT9xZZ/ZSdiXTNsgN/Vcx2yVuVfA
	2dCi9bHVqiqM/afeLWRq8ijJuTi/JpXC2wh3r/yOCJ+5TzrNI9+szIQZiPHUx9ZUyHmhG9nMlzK
	VgEjOETQTz18arAw==
X-Received: by 2002:a05:701b:4286:10b0:143:2968:564d with SMTP id a92af1059eb24-14503fde4dcmr3781997c88.27.1790313053922;
        Thu, 24 Sep 2026 22:10:53 -0700 (PDT)
X-Received: by 2002:a05:701b:4286:10b0:143:2968:564d with SMTP id a92af1059eb24-14503fde4dcmr3781901c88.27.1790313051374;
        Thu, 24 Sep 2026 22:10:51 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ac67c505sm2955163c88.5.2026.09.24.22.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 22:10:49 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>,
        Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
Subject: [PATCH ath-next v2 1/2] wifi: ath12k: store station pointer only in dp_peer
Date: Fri, 25 Sep 2026 10:40:35 +0530
Message-Id: <20260925051036.2838210-2-aishwarya.r@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=aaj0Dhot c=1 sm=1 tr=0 ts=6ab60260 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=5RRWBY4WAAAA:8 a=cu01E5ucpjk0LvgyI4cA:9 a=scEy_gLbYbu1JhEsrz4S:22
 a=drtMOSl5Q_Tsf-UZi3mY:22
X-Proofpoint-GUID: F8aTfyVUROyXiSR3xsNyoqEm2tHLa20_
X-Proofpoint-ORIG-GUID: F8aTfyVUROyXiSR3xsNyoqEm2tHLa20_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAyMCBTYWx0ZWRfX3MMfoqT18EG8
 MJ76gm9hfZR9ErrMj5sinuPjDAqVvUEChEw/5BNBpthy8BH8PlmsPfeTU5xH8uW7UXKRfAiaHy7
 2KKAktWq7T7q8Vkef/twYV4dfLoGuNjwj9dC4LZP234vR/joN+P8seRfzVuf0PakcCI2xEfscZ7
 iev43CEP5zoDJd+EiQyNcCVOWuw8xqRM/tFFRKg/zq9RPCS/V2Lk8Il3jPupJdUTvdkGCB3JC9A
 zBmW5HJp7GjkkrRMejo7LG7RGKfbAAmzeJ7exGdMg6GwccPw6y1u0s7YoKviIzqC0HNtjROQrxv
 QBx7FSfdzhBTXWVttBKSvgbFDcbh8d6XWOFeM6rwKMonfzcK9PXE4gCPTWf1YCs6HYwbOlQLm7Q
 Ppky+S4bkkVu8Al/thUJc81xS4utgVykVZOchJQYO3DguWxFk1AvzfY9yaOhZBy8aZzehUTma0r
 au0D3KXIdI/DaSiiIUA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAyMCBTYWx0ZWRfX+T6IsKacHAbl
 KTfNHsyki6wGy8T2RkmNhK0FTSLMCL58/g9JseOxcrnlfENACEBt7TkjsIVk4wN8+bCG1zfvVfX
 ziVR1lQu462xRFnya1KAcQFh5Ed+/kk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250020

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
 8 files changed, 30 insertions(+), 49 deletions(-)

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
index 41ac0a4072ae..af3b861aae02 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1383,7 +1383,7 @@ void ath12k_dp_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev, struct napi_struc
 
 	peer = ath12k_dp_peer_find_by_peerid(dp_pdev, rxcb->peer_id);
 
-	pubsta = peer ? peer->sta : NULL;
+	pubsta = ath12k_dp_peer_get_sta(peer);
 
 	if (pubsta) {
 		if (pubsta->valid_links) {
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index d4116ba0da08..c04b4e2709b3 100644
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
@@ -7012,10 +7012,9 @@ static void ath12k_mac_station_post_remove(struct ath12k *ar,
 
 	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, arvif->vdev_id,
 							 arsta->addr);
-	if (peer && peer->sta == sta) {
+	if (peer && ath12k_dp_link_peer_get_sta(peer) == sta) {
 		ath12k_warn(ar->ab, "Found peer entry %pM n vdev %i after it was supposedly removed\n",
 			    vif->addr, arvif->vdev_id);
-		peer->sta = NULL;
 
 		ath12k_dp_link_peer_free(peer);
 		ar->num_peers--;
@@ -13299,6 +13298,7 @@ ath12k_mac_validate_fixed_rate_settings(struct ath12k *ar, enum nl80211_band ban
 	bool eht_fixed_rate = false, he_fixed_rate = false, vht_fixed_rate = false;
 	const u16 *vht_mcs_mask, *he_mcs_mask, *eht_mcs_mask;
 	struct ieee80211_link_sta *link_sta;
+	struct ieee80211_sta *sta;
 	struct ath12k_dp_link_peer *peer, *tmp;
 	u8 vht_nss, he_nss, eht_nss;
 	int ret = true;
@@ -13328,8 +13328,9 @@ ath12k_mac_validate_fixed_rate_settings(struct ath12k *ar, enum nl80211_band ban
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
index ded7d56cd79b..eb69fe70c2b4 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -3367,7 +3367,7 @@ ath12k_wifi7_dp_mon_srng_process(struct ath12k_pdev_dp *pdev_dp, int *budget,
 
 		rcu_read_lock();
 		peer = ath12k_dp_link_peer_find_by_peerid(pdev_dp, ppdu_info->peer_id);
-		if (!peer || !peer->sta) {
+		if (!ath12k_dp_link_peer_get_sta(peer)) {
 			ath12k_dbg(ab, ATH12K_DBG_DATA,
 				   "failed to find the peer with monitor peer_id %d\n",
 				   ppdu_info->peer_id);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 7c12dba4cc51..449984adc20a 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -559,13 +559,12 @@ ath12k_dp_tx_htt_tx_complete_buf(struct ath12k_dp *dp,
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
@@ -634,7 +633,8 @@ static void ath12k_wifi7_dp_tx_update_txcompl(struct ath12k_pdev_dp *dp_pdev,
 	int ret;
 
 	peer = ath12k_dp_link_peer_find_by_peerid(dp_pdev, ts->peer_id);
-	if (!peer || !peer->sta) {
+	sta = ath12k_dp_link_peer_get_sta(peer);
+	if (!sta) {
 		ath12k_dbg(dp->ab, ATH12K_DBG_DP_TX,
 			   "failed to find the peer by id %u\n", ts->peer_id);
 		return;
@@ -642,7 +642,6 @@ static void ath12k_wifi7_dp_tx_update_txcompl(struct ath12k_pdev_dp *dp_pdev,
 
 	spin_lock_bh(&dp->dp_lock);
 
-	sta = peer->sta;
 	ahsta = ath12k_sta_to_ahsta(sta);
 	arsta = &ahsta->deflink;
 
@@ -759,6 +758,7 @@ static void ath12k_wifi7_dp_tx_complete_msdu(struct ath12k_pdev_dp *dp_pdev,
 	struct ieee80211_rate_status status_rate = {};
 	struct ath12k_dp_link_peer *peer;
 	struct rate_info rate;
+	struct ieee80211_sta *sta;
 
 	if (WARN_ON_ONCE(ts->buf_rel_source != HAL_WBM_REL_SRC_MODULE_TQM)) {
 		/* Must not happen */
@@ -853,7 +853,8 @@ static void ath12k_wifi7_dp_tx_complete_msdu(struct ath12k_pdev_dp *dp_pdev,
 	ath12k_wifi7_dp_tx_update_txcompl(dp_pdev, ts);
 
 	peer = ath12k_dp_link_peer_find_by_peerid(dp_pdev, ts->peer_id);
-	if (!peer || !peer->sta) {
+	sta = ath12k_dp_link_peer_get_sta(peer);
+	if (!sta) {
 		ath12k_err(ab,
 			   "dp_tx: failed to find the peer with peer_id %d\n",
 			   ts->peer_id);
@@ -861,7 +862,7 @@ static void ath12k_wifi7_dp_tx_complete_msdu(struct ath12k_pdev_dp *dp_pdev,
 		goto exit;
 	}
 
-	status.sta = peer->sta;
+	status.sta = sta;
 	status.info = info;
 	status.skb = msdu;
 	rate = peer->last_txrate;
-- 
2.34.1

