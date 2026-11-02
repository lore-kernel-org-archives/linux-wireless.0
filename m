Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601534;
	b=qG6gjpmUQCUN79V+7+T5TdPUf4yzi+OZfcFDYA7fyFN3kezs6O0bk69sMZTctd5uhU+T
	 Mhuybl7fj/aaC4Z+9Rdo5D6G1f1toHFRF54FVBGrSwPF5qgMtQ6Rw+lU15WiAlAUHmTqw
	 0T4SlBWYl+3AcrB282vJ1ZxnA+ciXtJ1jlC9W6Ez74Zzy9SnUMuTVahATkTHNlJ1JOdio
	 kD6x5vY7QWb9O6jgvI3RsYTANkYaAMMjZG75L6h/MVf9tCyuzKcOwEXZn5mc2GiPKrnvh
	 6aXcOBXos6i2E/OT7i+loBq9RER8bLLIvNKGySBW3SUu45Vek//kUZBw7D74SIiaHqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601534;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=PHCVFrHb7uDt80OnEuSQYeSutgkDBDLYcdWFEQO/hts=;
	b=UQJFzfvRUrxqzm5FlVNGFF8gCd9M38boCA4WI8ivvQLJnUeTP7nQz/hCrCqWXCV/JPvB
	 THiScsKsEYQP90H36sSQwbhyFWHku/mw5ZvikxsmST/9DCKdUPrmzxiSBCFvYgEN0CGxR
	 P2xBOoSeDiT72/hOxuyKmH5P5QVKChji0LeQ1/2kHgtEe5GmelKQfMkvDL+ZNMr1yS/v5
	 kchlsOBfBOYys/xd6Pcj7u741OKq78oKkp55M5stTU3jxd3z2XpjWOPJ5g7fbTcK6EVb5
	 qv042EGbW74/7KCO+g/tVrqU/h9goUGEeKuZnYQyhMU8Zwok74j4rGEsuRO1dBMj1aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aJ97RANC;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Oeodej5M;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73576606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73576606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aJ97RANC;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Oeodej5M
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vHDQ3348851
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PHCVFrHb7uDt80OnEuSQYeSutgkDBDLYcdWFEQO/hts=; b=aJ97RANCeHwGxx7g
	fQN/+JMGehMboHfQ4S+8SIePlKhEkiNxtECBMsXS5aovnckMEWO73775ym+l72gi
	hOG/4tsHbhpfL6XGosBuCONMV2EZ5qDXhJYdulj2f9YfAIvGLOwJ6wsNN9nD2nf1
	wQ3/DuR1/g/O07gcb8xdOpqD/m4BY+WzetqOhJnZS7y+LtYup4Tm47e0qvLuKVms
	1WX1dGnE0LxwObndS4AzqSKSU+EHnTynN+B9DCl0oTY3DZe8kQ5hmUx6++OqoYJk
	LTQTHwtjz7hHciOszuYDCkfgAAJWjQUl6XiY1zIcxoG69exaHQUmCwACPsMeox62
	x8auuw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7wxnhyh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:38:52 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ae1d132d52so2344267a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601531; x=1794206331; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PHCVFrHb7uDt80OnEuSQYeSutgkDBDLYcdWFEQO/hts=;
        b=Oeodej5M1iDXUQFQw0SBbk7/Qpnyr3/gFM+gMT/h1JvuVWIGKxTO42F3Z/hMyGcCtO
         C90oZqQpqnCfK2oEkOJikL1SGjGYgl6+bD1pdJ4fFNbKHbfjxTp3PzJlltHFDlGTBCS9
         svn/xLyKS1vBng1Y13jbMJ7h0orQknd2aFH8zP7MU5NFPLzDLd2D+MkAYsyeeEs8Hoso
         bkCJuICqqwq3Vwog19NtiJhpZiXrNb4D2cOvTgHjFCe1tpYg/sKwQ76/v20v2L9N9WVT
         48eP/e4FvFAv1U+B1gN9GfMAXK0r8z3TaoNcKL7LGZTVKFe46kcRB8PbOvGWYS9lcFkd
         MbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601531; x=1794206331;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PHCVFrHb7uDt80OnEuSQYeSutgkDBDLYcdWFEQO/hts=;
        b=2qQ9nyJiA+ifHA3mW4SZCLZ0Q5epr2dWElg+FDqdnGsKZKM+F2lv/Hsdt+gKC4a+x5
         m4+9+lCbg4JfBMYvNgdf2sC2vTqqFVCxgYJp6g5zH53nuH+4FMOMmsvPgu7rTX0XQE7b
         +oQ3XnYkNDvjrmlhZluGBd27bVrxLpAFtzFpYHbfuGGhGvzGdk1+V8LyWmWybumQ2+nS
         3TS2pC3sllOt0yWyH821LDXV4NNJ5rzdcy49FdFg6hF+b5XzAbNrbGFwGoTEonkvOJvA
         t2DwPWuF6ipIUS9W4LhtEHxk9rShEU1m8w1K3puaynZIfrEsVfdoEE3hLmOWziW7F4oy
         97cg==
X-Gm-Message-State: APuU4Z+ga4LgBR1W64YqX5S4kj0xDf0pRHaonC4HaONurcFunaOJjV66
	FvIY3s+MSmuP7CY0cNzTlhWRe5XnEbfUQ/y4Kusd2JKR4rP7kSKIIUse5CeZ/0bL9nXShAiD7b3
	7WgxntDOGdiQeTur57fAgNhYU9Ph6KJMHg5xkrRyurjZ9Bxm/uEfMdwOe7MZfysBH5mGEsKyTd4
	2BwjbJ
X-Gm-Gg: AYBFou3yFSLihlyDFBlD1nNrGLS96pJY7FHR6gglcz3rgGga5UITXbJokQpsvGPt9G7
	/gDPgrRHsgqJOMXUM+y4CJstfdSigGz5y3ndqvgSTZZy7rf6NsI6XcYBo3+ea9Mvs6Tcoj1r2/5
	G79d7zEY8wbIva0kYkMiucN1y2JMfAaDKA5bE0IUs4cO2S9AWZyeCfhuOKNJlZTDBK4TYwfCIgN
	1fd8TlRQiMIm3YZJtTumSry4yOkkc2Hq65uDfzWYA5V2TIZ/jzy/NFXGRDlQM36xKDZIDJ/IP57
	/LP52/8j8TQlaj8SYA4IPuYRkRHuxLvNLnCzSl6B7gj61rpT4vmNzOn+eL7RxjaqWIPZXS5JXFb
	zVAvzR8mXZ24/g4exutiXFmjf3iea+lJvHAL75/3c7RAm+8i8PHGuDU20wpr1DxJHleD9k5ml8q
	JrSNSnLRo6PLNpMhyLFZCfiZZX1sEm
X-Received: by 2002:a17:90b:17c1:b0:3ac:7556:8ed9 with SMTP id 98e67ed59e1d1-3ae8970e52fmr6645533a91.10.1793601531162;
        Sun, 01 Nov 2026 22:38:51 -0800 (PST)
X-Received: by 2002:a17:90b:17c1:b0:3ac:7556:8ed9 with SMTP id 98e67ed59e1d1-3ae8970e52fmr6645519a91.10.1793601530423;
        Sun, 01 Nov 2026 22:38:50 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:50 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:11 +0800
Subject: [PATCH ath-next v4 02/11] wifi: ath12k: skip hw link id match for
 devices without hw link id support
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
Message-Id: <20261102-ath12k-logical-link-id-v4-2-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: ZzptAWnRa_4Lpxfshyz4MeCYmFJeGLoJ
X-Proofpoint-ORIG-GUID: ZzptAWnRa_4Lpxfshyz4MeCYmFJeGLoJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXwhF9gTNDgPED
 DW8skdjHnGHoKaScFG9reeMtVrwVUBWzVkgpcjmBbb7XwAzO8liXtb0IT5U3I6mOWQIcVS0Idbx
 Mf8oD/5xWKPaNAk0hjkHvDECgRVVtK8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXz+S4IX809QWl
 ic7i+tZlUTv1jkdQr9HqNuL3780gdF6UjUyvD+lUG5ZC0sm+uvGf/KT5NntsZGhYmoi4K1IrPmx
 uFb8pCDJP8yx1S8+kvVeCsd0/AWCGbYCXVs6uv54I1LDLNme2/i3b1AFx062dqT1G2SyucjblHF
 flhZrG/o19g4RdWswiFwyMU8zN1xwRr4Nc4oMBukz33GfrtHu5LI+x1ww6DI3bnsKF86IpDWmgu
 yfFyqZ/6ki4qDrI+cf9hcYf6REZqarZUkzd43w7x+cPp0QbVvBSrwyGM649efPwMTfWqAsMLi6h
 Lgl12w1wbhFVxEIQPI4ZQgls3Hjs1Wz6DNMbxY/JODxbwY4U0lu+sx940MzJXlpwyXEWnF/vdUU
 CdTptZSeh+e1yZvJnV3uDfmS6FBoQIjmc3IBdOZG26vVlKFPj34FhdVsZrHl3GeAH+/IeJ1l3ov
 pF/xdTbQk+U1Y+CEqBg==
X-Authority-Analysis: v=2.4 cv=JLquIMKb c=1 sm=1 tr=0 ts=6ae82ffc cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=LRBYoqMme8RW9p2yMIgA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

ath12k_dp_link_peer_assign()/unassign() maintain an address-keyed
rhashtable of link peers. To handle the split PHY and roaming scenario,
where two pdevs share the same rhashtable and an address may still be
present under a different hw link, both functions compare the stored
hw_link_id against the one being assigned to decide whether the existing
entry belongs to this link before adding or removing it.

hw_link_id is only used by QCN9274, IPQ5332 and IPQ5424; WCN7850 and
QCC2072 do not use it and rely on the logical link id instead. Also such
devices are single pdev and never hit the split PHY/roaming case, so the
disambiguation is unnecessary; keeping it would also break the logical
link id support added in subsequent patches.

Add a support_hw_link_id hardware parameter and, for devices that do not
support hw_link_id, add or remove the rhashtable entry directly. Devices
supporting hw_link_id are not affected.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_peer.c  | 48 +++++++++++++++++-------------
 drivers/net/wireless/ath/ath12k/hw.h       |  2 ++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 12 ++++++++
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index 06f6eccfb574..8dcb07773bd1 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -558,25 +558,29 @@ int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 
 	spin_unlock_bh(&dp_hw->peer_lock);
 
-	/*
-	 * In case of Split PHY and roaming scenario, pdev idx
-	 * might differ but both the pdev will share same rhash
-	 * table. In that case update the rhash table if link_peer is
-	 * already present
-	 */
-	temp_peer = ath12k_dp_link_peer_find_by_addr(dp, addr);
-	if (temp_peer && temp_peer->hw_link_id != hw_link_id)
-		ath12k_dp_link_peer_rhash_delete(dp, temp_peer);
-
-	ret = ath12k_dp_link_peer_rhash_add(dp, peer);
-	if (ret) {
+	if (dp->hw_params->support_hw_link_id) {
 		/*
-		 * If new entry addition failed, add back old entry
-		 * If old entry addition also fails, then nothing
-		 * can be done, simply proceed
+		 * In case of Split PHY and roaming scenario, pdev idx
+		 * might differ but both the pdev will share same rhash
+		 * table. In that case update the rhash table if link_peer is
+		 * already present
 		 */
-		if (temp_peer)
-			ath12k_dp_link_peer_rhash_add(dp, temp_peer);
+		temp_peer = ath12k_dp_link_peer_find_by_addr(dp, addr);
+		if (temp_peer && temp_peer->hw_link_id != hw_link_id)
+			ath12k_dp_link_peer_rhash_delete(dp, temp_peer);
+
+		ret = ath12k_dp_link_peer_rhash_add(dp, peer);
+		if (ret) {
+			/*
+			 * If new entry addition failed, add back old entry
+			 * If old entry addition also fails, then nothing
+			 * can be done, simply proceed
+			 */
+			if (temp_peer)
+				ath12k_dp_link_peer_rhash_add(dp, temp_peer);
+		}
+	} else {
+		ret = ath12k_dp_link_peer_rhash_add(dp, peer);
 	}
 
 	spin_unlock_bh(&dp->dp_lock);
@@ -622,10 +626,14 @@ void ath12k_dp_link_peer_unassign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_
 
 	spin_unlock_bh(&dp_hw->peer_lock);
 
-	/* To handle roaming and split phy scenario */
-	temp_peer = ath12k_dp_link_peer_find_by_addr(dp, addr);
-	if (temp_peer && temp_peer->hw_link_id == hw_link_id)
+	if (dp->hw_params->support_hw_link_id) {
+		/* To handle roaming and split phy scenario */
+		temp_peer = ath12k_dp_link_peer_find_by_addr(dp, addr);
+		if (temp_peer && temp_peer->hw_link_id == hw_link_id)
+			ath12k_dp_link_peer_rhash_delete(dp, peer);
+	} else {
 		ath12k_dp_link_peer_rhash_delete(dp, peer);
+	}
 
 	spin_unlock_bh(&dp->dp_lock);
 
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 52558dd126a0..b5fa8e224ca5 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -240,6 +240,8 @@ struct ath12k_hw_params {
 
 	bool host_alloc_ml_id;
 	bool advertise_iface_mac_pool;
+
+	bool support_hw_link_id;
 };
 
 struct ath12k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index d3ae9e987fa9..b073282e5525 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -448,6 +448,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+
+		.support_hw_link_id = true,
 	},
 	{
 		.name = "wcn7850 hw2.0",
@@ -544,6 +546,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = false,
 		.advertise_iface_mac_pool = true,
+
+		.support_hw_link_id = false,
 	},
 	{
 		.name = "qcn9274 hw2.0",
@@ -636,6 +640,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+
+		.support_hw_link_id = true,
 	},
 	{
 		.name = "ipq5332 hw1.0",
@@ -722,6 +728,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+
+		.support_hw_link_id = true,
 	},
 	{
 		.name = "qcc2072 hw1.0",
@@ -819,6 +827,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = false,
 		.advertise_iface_mac_pool = true,
+
+		.support_hw_link_id = false,
 	},
 	{
 		.name = "ipq5424 hw1.0",
@@ -908,6 +918,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+
+		.support_hw_link_id = true,
 	},
 };
 

-- 
2.25.1

