Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601537;
	b=rzs1REz2z2mvQDEYEjI2Fm9TYNsdCQpax5Cnt5zia9mLkIrI6Mn4O9BtMV/A1Eoy61gN
	 xzEvDD6M5+tb1GlUTjFV1Hnqy3YdNDa0RKLm2QHkos/8Q04m04BD54j5PwX/aQp2cuj1D
	 qGoayphDQw+6bwUBn83Mva4yiWzSCjh/ufhOuMpbFzGCShuc1zPoEOQ0Q00eRlVoIW7QN
	 jQKafR1EARe+9bI3BkyaryAQZDyp5eDa6A+PIjPpw51zpI5qe/VdmENwUnXwJCfyc0Vh0
	 XSrtyIex4xo3DIuIKzQSiy4X2LR3Mp7rvyFrJWFcOZFbzKf33Vi1tH7AqtLVW3hweYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601537;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=EhwhSdlF3yFYJXucMT5j2zuOq9XHAhyaRCLARs3Gals=;
	b=h9I7h4I4Pu7/Ch31F64Sh+/Cg1WtX+6tJiu2zlrVZ5RrgN5uINpwGgaxil7mot9y5Jzn
	 pbfbyLZZubHiMTpDSsqoChDmGBnxuKP9QcfmEm8WW0TAi0lF69ZaDWxSBQipfpUh/h86Y
	 rUgPGpRNcPXUk1WoZLzhotiXmJAvah27lH4IHhVGVdGV+ue2BY0tELYdRs+5YPmBBReZi
	 T+svtUnaPNrcSffqWG05KMAAyo/2nInk+O/XeuLz4Mb2VS04yHGTJu//LFwIXgjGq/EmI
	 7ulK4ZZi+PhEHZSKuF9yTjZjyQbzH51sqlNA2h1XrZ/U96nvsv60ept69RfUQe3CUeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=h36JKFC6;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=X9pkRfeB;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE67606A331
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:38:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFE67606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=h36JKFC6;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=X9pkRfeB
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vHDR3348851
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EhwhSdlF3yFYJXucMT5j2zuOq9XHAhyaRCLARs3Gals=; b=h36JKFC64uIVfOLN
	7LWaJlBSUJpe2StFNqxFv5/zSHBVRXztoBISEhbcIwyXgZdcWqUkISnkW/AEvkt9
	JlG/Nd627QDAIxTgWIlvvr7KtgnxQAK42WiEKA6jmBTojMQ30qSr0H+4hzfdt3EM
	w9CzO+65a/49fxeVU0t6SQQZWZJCK8dt+zB+I9UZYAl1qFsxR/qPYeHt+ZFgK6Ef
	lIeaNWpNASUdn+jPy5hRQ/kECsYdx7UFpIpsNGI4EPChbUf3zwU323cHjSqIQZNs
	4AZJDSWGB4bjO9fFZNNc3A7PnVmftWVcKGQaFBpLV8wE6qUQbCvAZf9hLRUB70YP
	MWpe8A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7wxnhyx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:38:55 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2eb361b86dcso15967945ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601535; x=1794206335; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EhwhSdlF3yFYJXucMT5j2zuOq9XHAhyaRCLARs3Gals=;
        b=X9pkRfeBqNSPxOTKyyPXYlUjW73cwQg+fJAmVu7EVrB8/waBoG1Oti5viHPtc7+0Xn
         Iw55PkgDpj6SPmXVtlw3/gHqfyDrWIUjlTF1pZbcmlYm6evlI2zb9Ty3+tfrq8tZzjlh
         ThvSP6zBP6wbvDhh5l9M5/hAL9mcxWZmgFwkDaD+VA1Qdyl/bISzWcHTGPKGUTp8uDsW
         M+if7T6Gi3B2XYo5PnwO945REfSwZRHeHmL/y/+TVdDegLh2jpdzwBtf2MvwG5K1zPHD
         z4SRpYMknD512d1Ng/xRZszql9agMbrI76JEJwqaVMwQZHt5vAsfdnqUPnfj5gJIUMVX
         YiVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601535; x=1794206335;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EhwhSdlF3yFYJXucMT5j2zuOq9XHAhyaRCLARs3Gals=;
        b=A+svqFhKxgrWDdYhGFjfux6KKDSFgMZxcBjsE/Ui8147cLqCjwzH9evS6imkzydHt3
         ajMGxo+nORUQAPjiUhbbTzeNiwn100g/O7JXDkXc4Ng1YR3Rt75BN4B3LYR/MbKFKTnY
         ntihXBbTxpXc2UA5H71vHyvVmbMHDMCSSUdgAAd/SpvgstYdusHmQRxVd9oH1eb8zNhv
         /HO+q1zdXK08IwlPeozzn6y8VJ8EJnpVGgD+NGJw743wYWG14RY627X6vi34QMpUtgIC
         LEJIjpoHW8QzSFb2ffPAiX8M1EClIzRde9VEqFKCzT+Pg+4bSGD8ZOrgbg+ewZmAqBbW
         Aieg==
X-Gm-Message-State: APuU4Z9M6TcZqVLVEwhsLdoO1lEC4TCF30i8mzm+YR6XrD5DfsOLm9ap
	bZYfZvIoklt5gwYzeAtBCVH+k6xiWNG+boJIpRmyz7rg96AhGxR1nEgE60sG4HgzFZmYqiaPsvI
	DS0D7wxh069s3zJ/SPeiItXyw8V4GQ3k1IlG9JlR20UnravWVf8JFd4HWqfP0+QtMr19K9vDppb
	IrmNRQ
X-Gm-Gg: AYBFou0gTn/fxXE6Y6ddqVMmYk+nsqzCZ/qgQ+PdCcVfUnEBW4yjinpWCwpJQCrMlBj
	jitt1sMIlNB9ztk7/C82vt0MZh36ydKgxt+Lcls3X/Ozak6IqbfvvfFGZKmNdTaUKzeZs6DZKiP
	b8R/1k5kZjWSs/CY04CjnEcDrqHd/EhXeyJ/X0m3P+NGOvMgF+p/yzffSi1aToNEHJDDvRldzYs
	XhAXOiuKAB2r9X3zndnQWmEY4LcpWZbqwtZiw2DNxymLZdaPcT8RDvzi5gKGpBBedOmWzl+fnJM
	PUfj3wtaxEX33ZdPHHichTwWnqBXajAA3nS7HpVUCgVLx2q8Kn8wFbWFEWKMG8o4Fpll83Z5g/7
	9WoRNbvX9xNjssO0uzpBFcGPZ6mrp9BnGG3F3f0W+NkbxrsneHUWTCOzDg20Mjq5tN00vVxxfWu
	brbIQ9aJVacgSITaMUNaVonPrlThQR
X-Received: by 2002:a17:90b:2247:b0:3ac:7c4d:8be6 with SMTP id 98e67ed59e1d1-3ae89836523mr7184114a91.40.1793601534627;
        Sun, 01 Nov 2026 22:38:54 -0800 (PST)
X-Received: by 2002:a17:90b:2247:b0:3ac:7c4d:8be6 with SMTP id 98e67ed59e1d1-3ae89836523mr7184104a91.40.1793601533882;
        Sun, 01 Nov 2026 22:38:53 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:53 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:13 +0800
Subject: [PATCH ath-next v4 04/11] wifi: ath12k: rename
 ath12k_dp_link_peer::hw_link_id to drv_link_id
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
Message-Id: <20261102-ath12k-logical-link-id-v4-4-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: votbkrHYOBl7QswmRq7zYL3l2FnCmYDm
X-Proofpoint-ORIG-GUID: votbkrHYOBl7QswmRq7zYL3l2FnCmYDm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX8c9dBBBDMOU5
 DRfT7uTs2WH33ITgt/nYdL5Z5pfmQz4T0exavXrpi7emIEi+npfGd/eKu6zWVVQFrln+P6/zkPT
 7wXBMcikaRX1cvF72xwJct096mEuiLE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX6WQOIeTdM+X7
 AMVCGlfMVyyh5HbZSvTJNvLpBhL+CsY8VI+EydC85KPwv12z28q98z8RbWsptDQ/qic05cTLtMs
 XmER+ukst65v4YhdhVoTgJ13AijtpI1UzJ+UKPlcV3iVc3Zw2C3c7wMUFb4Do5YKZt1IfrFx2OF
 nyt48+ROF0zhDolL5EOOWcV4bfb1XGT9JzNaBMIIboY05d2Ljh7yDKqgExbwAuMT2xL1+lIzim4
 NXL+j0T3bZ6+fR7txLpCHLeUVzwYM3yJrEPJ5ct3huGHJOkcH515fL2s+7pDnv0ITe/+4VaUMlc
 PCyt1MUyvpprVRb9hueCR++sXY106MaOHAgXMoAtegwAlL47WFGtXvl5vHjB5dm1NJUHL6ZsfhQ
 cJ+17LcMXtDgBkwXAR3/cgVUpniQn6woybx8zZRq47HXz3pFhCgL9OryO65WOIyZ1xqrzY5d0He
 E6ibqVqika1dJPkqiuQ==
X-Authority-Analysis: v=2.4 cv=JLquIMKb c=1 sm=1 tr=0 ts=6ae82fff cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=NxgKQpyHIDudPh6FZjkA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

The hw_link_id field of ath12k_dp_link_peer holds the driver link id of
the link peer. This is the hw_link_id for QCN9274, but for
WCN7850/QCC2072 it is the logical_link_id instead. The hw_link_id name
is therefore misleading for the latter.

Rename it to drv_link_id to reflect that it is the driver link id
regardless of how the underlying value is derived. No functional change
intended.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_peer.c | 10 +++++-----
 drivers/net/wireless/ath/ath12k/dp_peer.h |  7 ++++++-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index 2826d6016ce8..f73dad49e42b 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -544,9 +544,9 @@ int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 		dp_peer->peer_id = peer->peer_id;
 
 	peer->dp_peer = dp_peer;
-	peer->hw_link_id = hw_link_id;
+	peer->drv_link_id = hw_link_id;
 
-	dp_peer->link_id_map[peer->hw_link_id] = link_id;
+	dp_peer->link_id_map[peer->drv_link_id] = link_id;
 
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
@@ -566,7 +566,7 @@ int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 		 * already present
 		 */
 		temp_peer = ath12k_dp_link_peer_find_by_addr(dp, addr);
-		if (temp_peer && temp_peer->hw_link_id != hw_link_id)
+		if (temp_peer && temp_peer->drv_link_id != hw_link_id)
 			ath12k_dp_link_peer_rhash_delete(dp, temp_peer);
 
 		ret = ath12k_dp_link_peer_rhash_add(dp, peer);
@@ -614,7 +614,7 @@ void ath12k_dp_link_peer_unassign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_
 	spin_lock_bh(&dp_hw->peer_lock);
 
 	dp_peer = peer->dp_peer;
-	dp_peer->link_id_map[peer->hw_link_id] = 0;
+	dp_peer->link_id_map[peer->drv_link_id] = 0;
 
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
@@ -629,7 +629,7 @@ void ath12k_dp_link_peer_unassign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_
 	if (dp->hw_params->support_hw_link_id) {
 		/* To handle roaming and split phy scenario */
 		temp_peer = ath12k_dp_link_peer_find_by_addr(dp, addr);
-		if (temp_peer && temp_peer->hw_link_id == hw_link_id)
+		if (temp_peer && temp_peer->drv_link_id == hw_link_id)
 			ath12k_dp_link_peer_rhash_delete(dp, peer);
 	} else {
 		ath12k_dp_link_peer_rhash_delete(dp, peer);
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index b9c94d6366fa..d2752b35ba0f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -99,7 +99,12 @@ struct ath12k_dp_link_peer {
 	/* peer addr based rhashtable list pointer */
 	struct rhash_head rhash_addr;
 
-	u8 hw_link_id;
+	/*
+	 * Driver link id of this link peer. It is the hw_link_id for
+	 * QCN9274 and the logical_link_id for WCN7850/QCC2072. Only one
+	 * of them is used at a time.
+	 */
+	u8 drv_link_id;
 	u32 rx_tid_active_bitmask;
 
 	/* link stats */

-- 
2.25.1

