Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601535;
	b=B/ULslDZUFK4CCRZaBmzhlYx6zvUKF6jx8qhWaJEumF3dwxx63puilMmt/faLXirY6U9
	 KAtc4BXP0yc3YdF8GAnEL0rSSrN/XcCU+Xnu4XT3LS604GlOwacdhVHoJGt+i60yW/b4F
	 hMUt5FFUV1s+FzNZqKazDuGzJBc2Qg77g/w4ZEJsPTVVBcJFmWrqBkkgc1p/Xr17ZmnwQ
	 Uy+xfeuqmfwtJ2JeetpkkKKp72dnsaEiTKdE1tYA8fWfYGfH6PbCyPQg8CnqMzU5NY5nv
	 Ucn3Gog/mQk1sFJ6NUv7ABRmH7ucIn/sa/QeYQwsrPLP/ImzKhOXDr/4V4fX6bTe9wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601535;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=zS6kutx/WsJidhWhliY3FrWRH4DgTRb0PEAupbAX4Q0=;
	b=un5IkESv/N96rU+KS4YRFc9EWSNyoHb2dmXmOuPpIrFzv07n9EclTE9wTLex3CvGF4+L
	 gGYEBNLbgGV4T3SeTv7g/eL4zsZmq/PKb67UpfX4aGbIGb4hYKWmBoMlZc77hMNYeUq0a
	 kuN6TOIlgVerd/Qg0E8RL/z+6DmO6lh1pGg+VjdHl9jsM9QAfkNgpSk7mtMPV11HFxIwz
	 bwYHHDyE47eQDq9cQmR8VU2yMjYw3PUXsx6e+96C5/F1zgJyB/dz4KhJCgj2d/0Krg8dn
	 pTh5kiZw32ozSkQCywF3fhZGfZHp2XFiFrMk2x0YOeShIode0h2xebzvAM0Rls3tlFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OUMIVqh7;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ed641LPe;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1049A606A32D
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1049A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OUMIVqh7;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ed641LPe
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vVbF2746307
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zS6kutx/WsJidhWhliY3FrWRH4DgTRb0PEAupbAX4Q0=; b=OUMIVqh7gqSBzHt9
	7lIdLuOSFRs2AbQyYdGUxpL11ebjMo9er+UY1Cyhq2qocJrSfW4IoTLKe4eFrG72
	8Pq8pqP5cWUXLpEXVs1r+JmcRsGrwro+W/D4xclPYjUTwQZVWRzaGMo8YVLA0BbA
	z2Ng+zDPlgr4paDA6RaQpLzkU36mKz0es+GvX8DireWZ/ZF5bXT9ZN7tGhR3acGm
	iQ8bg0c8T/lEW6Ld+dG5tdwuVpRUd3+KQYKPp1ILRyn1+t6lw5vSEr0ABoeJ4uJw
	TdK3WEXiFA+aCnsXsTNsMXz2Lhvv4NySypUUUunFm21L0rHRhx6BZbSMEMShIiDp
	3xp20Q==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn8dudfjq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:38:53 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ae73921fd1so2247963a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601533; x=1794206333; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zS6kutx/WsJidhWhliY3FrWRH4DgTRb0PEAupbAX4Q0=;
        b=ed641LPeHKtWSidR3Jzfv1Dr5AdFMUkmg5Z/EpZagDcYhKRYKLMI+/bv4NNjqPiAhU
         iLbzplrcGWC3Ntfb8QvmejUgGbAW51XRNoJIEXnylh3bjazYwbNFSH8PO60tSjXumXAI
         v7ujWW+1qNzoeLhfZ6PYFybO6M+JkOelM7fAJyKw46/po4f3UQroq5zcgoCsTg7Eh+Xj
         PcFhcjxLfPGpDiiHqmau774qe7wxejhoN+AkcLcuCM5oOO+peJl7xBd/hueiR/h74zxZ
         GsODxGF3piI+01WE2keN5EOuTcDfnWopyss/apHxXjFI9WhqQpZCMVJXOkq5jk/CkAV+
         DG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601533; x=1794206333;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zS6kutx/WsJidhWhliY3FrWRH4DgTRb0PEAupbAX4Q0=;
        b=bDhVpHvuU+Hzpy9PyUFyzl2xa6pXG4AaAuhoC8q8RkXzEKOpdn4qjZVnw0N24WDhGE
         o6LN/tnVXqNQq0LfNtbY1LNA2OR7cW+4IywAsvXG6BFoOzSsbjOFlWV3fxGZM0fWGUtz
         1VcQgS0mF6LvKyAa3IV8qW8azK2fbdLYnLBmWvsS8UGktzmfDncKZgBQTl/AyDW77Wpx
         2r7EObEyShY49V83ef90GkQqz04A/wUD+H0sSzi6dUDwvY7VL0SV/fgEGy1FV5mfw7Ke
         oil4GB7YwHRRW6oYOFAtEc3K5lNAtXDh+RxHv7Ibr7GpI9KKhUrIfQRHSpN8YQmM2NUl
         c2Fg==
X-Gm-Message-State: APuU4Z/1TAOMqt3vPVbWcLPlDU2EQdQuKZcaQNDojzeX7WgGZ1C6Bkbd
	ysIVGgw/DK5MStj07T/eCmYg9lxqaCnOYqCzei21h0+aTMl7iErdmJnzB5xz44eTZqmGaviEY+H
	DKMUAWplfKnspxzzPtBNTpT4kRd9YtcEx7DtvWrsw+3CV4CCYGtiK4r1ZVb8RL3BPXlj3U4nvYV
	1Jqw==
X-Gm-Gg: AYBFou037cvrXTeiseF4m3cT+9P4IRsBmOUQuF2T+PBfwKwJIRc95OFFEN8rUp82KT6
	kdqjSppSwtfKPOYGIiVR36S2qcjXiGK+VzEnNPANDsDg7+k6fYcLYGXVZ4uO6ZqI+9HwN4XebG0
	+bQ4QkydI/KdrYjNjY9a7CLlLivR+/h61AH8NOJg3gr5FH1Ft/cBYg5B3h5fDBuZ9Qjm3e+hhM+
	WvcycCHKlHQ47V8K6w91n5q6U8Uz7oGD/11nI0LXjpV2K3t940taBqv9y4e4A2jy4wr0mDlwcqm
	GrjGKYE1zgvcyWRm1qr6RcPATM0RRceytpDF5uyGMsedJxnpm/yAalXk1/Czfd58K2uCFbC2idt
	vL8wX8XybVdM7IDyL4bT3RU7Lash35GuVwL6QjkjCqvmH27GKTfkUkWlS071ftj6FLOdWdmBTFg
	Yx2xHhpwAhJ3qTnHbOSDPK6Rtxd9Mm
X-Received: by 2002:a17:90b:2711:b0:3ac:bc3d:6fe8 with SMTP id 98e67ed59e1d1-3ae89819919mr7210313a91.34.1793601532638;
        Sun, 01 Nov 2026 22:38:52 -0800 (PST)
X-Received: by 2002:a17:90b:2711:b0:3ac:bc3d:6fe8 with SMTP id 98e67ed59e1d1-3ae89819919mr7210306a91.34.1793601532161;
        Sun, 01 Nov 2026 22:38:52 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:51 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:12 +0800
Subject: [PATCH ath-next v4 03/11] wifi: ath12k: rename
 ath12k_dp_peer::hw_links to link_id_map
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-ath12k-logical-link-id-v4-3-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=O6esLx9W c=1 sm=1 tr=0 ts=6ae82ffe cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=niLHlN7IhEeuoKN5US8A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: XPWOmP73g2gouZqSm17gtnA0ppHyHN3-
X-Proofpoint-GUID: XPWOmP73g2gouZqSm17gtnA0ppHyHN3-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX0kzxUqPkJUTk
 b0QLrtF4FwDkU3zgUNgy0S1S7kTKxEDMDts2KjTJB+yQz5EhySdDR9FbydNOX1SrVVIqCMZiQBm
 9k3GpAcCJCde1dM+FMMqQCeo79DNYVzsuoThrgPchmfvQmIdOUnrSBFBVcDUILiikzfMea2V7TE
 D4GerrOx6BtinmSUDk1VDwnStXwllPmpkLQAUuLxuvZR5FbkiCZSH1bQBguCvFby+IkpkeyTOKI
 JT33U01Ol4fn4ZY4aVmujgNeYIRRpsEytIP68A2ys+30WYQNaw4xV+xJYIfWCnES4DNaHFj58jm
 HswFu2V4tmMNPUI/HsWnaaTlHm5YG4aLJUaF12kPhPyWYDGxLDkj2b63Cme+Lhd4mPCih3LXqRi
 CcR9Dg96pHLjmJ5tpeohHXehqnkdRinQ4FJWf/c1gsu3kK7SknwlSZdmjnVrO5j53DpopsIpQol
 E74YtxWeKGMvIYrlEcg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX2AD9SXxsKvA0
 7yFAOjCgvrmXjPaTdBTHYLoQTYUKG6tWrTgBarfjPXVfBCWyC7F1nOxiKLFa53OH+ZwgYc/8nna
 Ydq/DF1Z9jOSQkylpM4oN+6OrgEaUXE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

The name hw_links is not clear about what this array actually holds.
It maps a driver link index to the IEEE80211 link id, where the index
is the hw_link_id for QCN9274. For WCN7850/QCC2072 it will be the
logical_link_id, which will be introduced in a later change.

Rename it to link_id_map to better reflect its purpose. No functional
change intended.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_peer.c     | 6 +++---
 drivers/net/wireless/ath/ath12k/dp_peer.h     | 7 ++++++-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index 8dcb07773bd1..2826d6016ce8 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -418,7 +418,7 @@ ath12k_dp_link_peer_find_by_peerid(struct ath12k_pdev_dp *dp_pdev, u16 peer_id)
 	if (!dp_peer)
 		return NULL;
 
-	link_id = dp_peer->hw_links[dp_pdev->hw_link_id];
+	link_id = dp_peer->link_id_map[dp_pdev->hw_link_id];
 
 	return rcu_dereference(dp_peer->link_peers[link_id]);
 }
@@ -546,7 +546,7 @@ int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 	peer->dp_peer = dp_peer;
 	peer->hw_link_id = hw_link_id;
 
-	dp_peer->hw_links[peer->hw_link_id] = link_id;
+	dp_peer->link_id_map[peer->hw_link_id] = link_id;
 
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
@@ -614,7 +614,7 @@ void ath12k_dp_link_peer_unassign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_
 	spin_lock_bh(&dp_hw->peer_lock);
 
 	dp_peer = peer->dp_peer;
-	dp_peer->hw_links[peer->hw_link_id] = 0;
+	dp_peer->link_id_map[peer->hw_link_id] = 0;
 
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index d01ef1aea48b..b9c94d6366fa 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -131,7 +131,12 @@ struct ath12k_dp_peer {
 	int peer_id;
 	struct ieee80211_sta *sta;
 
-	u8 hw_links[ATH12K_GROUP_MAX_RADIO];
+	/*
+	 * Maps a driver link index to the IEEE80211 link id. The index is
+	 * the hw_link_id for QCN9274 and the logical_link_id for
+	 * WCN7850/QCC2072.
+	 */
+	u8 link_id_map[ATH12K_GROUP_MAX_RADIO];
 
 	u16 sec_type_grp;
 	u16 sec_type;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index c8e590e5e250..2a0141157426 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -2368,7 +2368,7 @@ ath12k_wifi7_dp_rx_get_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
 				       struct ath12k_skb_rxcb *rxcb,
 				       struct ieee80211_rx_status *status)
 {
-	return dp_peer->hw_links[rxcb->hw_link_id];
+	return dp_peer->link_id_map[rxcb->hw_link_id];
 }
 
 int

-- 
2.25.1

