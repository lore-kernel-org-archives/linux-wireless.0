Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2131B4138
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117580; cv=none; b=nHaNDrL+zYaOnP5QtdEgqpvwunvJUxaUnMJWD07eZiOySBDc53MaYQbbuQWfHrhjD7rCcQMcAzzcJYV6NagvJG2Yif9Rt9jYV7LDHo8ZmfCxK13JADWXbRuwO4YBAMttcMDztsi3SY+X7M81/OXAKowxTnIHmayIbSm8Ehtvr00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117580; c=relaxed/simple;
	bh=lLKm0E8mIpVdV1SNCUzix8PqtAb+g9pfxC2WOlS/oQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kvz1Gse92tiQJ67tqYzLWkZxYiPrn39VmKwlf4AIr3ADkV7AH9H1nGWxnlT7xLrtdRiyRUwtz/rEu4mC8HKssUHdwmk9sNhBNyYl2ERQZ/jTzfixfjKFe0UmCvCkbHhr5oHdul7w0UdOzsdYNx3ERkOo+wljf0R6T3GD6zu1czU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W8gBrbN3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DjN8ram0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W8gBrbN3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DjN8ram0"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5IJxj4049336
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=AlMDsZo027h
	PD5J6UrX20XHsPiN+M3YMWIVFfgN9J8s=; b=W8gBrbN3k4rNQ2Wufe9wsrZj2au
	wntoORNi+bk1DQqRJN0ydwvFDICrDnjJdIH8Qgr+qtPxd105YFcQlk0D6NB2+uaI
	l9Zzu2h6uxG4sg/lb7pithjxIGXz1P2r4LA6wd89HRoSPrPXEo9/WFvHq/us196n
	26a97qi6uBPDjm2vwCW/Kch8sZXMY+ZdbdA7x3obPvr1la63ulqp1A+ztmIlJbvf
	jgp+78kLRXI3lpSrJZW+S3WMeH7lcpgSTzENASnuRJ8KZLJyXQgkpihpPF6JMejO
	eK69uJDgepAdPxO0qmJFFBBTLTh019cYUU1WJ8b7QXjFQ5vrz5IdCnbmv4A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfpsf59-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:32:58 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1456735a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117578; x=1787722378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AlMDsZo027hPD5J6UrX20XHsPiN+M3YMWIVFfgN9J8s=;
        b=DjN8ram0ebv/v1MbNFEoy1fFPkpPgO04VXLcV7bFD1FVX53FkNny/TvlYXYt1KFl/c
         zSwFp1X/uQU5knUn7c0Dg77893Et7fg6cD4w3trAt2ozKoTeLkplI+1mNFbUaiCNwmCB
         UhiYJ94EU6sb3a3fCTZrHXC2CeYqLdby9CLanxA5jB6pYKtWwipxiFyS+ya6JhQSiHV1
         HwLvj49ff7sQU8tG8XQSDG+bVyVkI0dcM9hoEheFg50UpyuvRHi8dn2eMjLh58SjpWTn
         E0N1wZgYlq8rII7nIPZ4q6It0OAG9eYbBHlmKszwxxce3VReVWqXj3CFM6P7g+36fKnf
         kncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117578; x=1787722378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AlMDsZo027hPD5J6UrX20XHsPiN+M3YMWIVFfgN9J8s=;
        b=AoNYtQopewpsrg/6zmxnQ8dMXIsbNuA7KbttXVTs1vVSSPyvLUn/0ymfbpW+FQc+xk
         ruhyssWeYPX0rDFvjjXkXtjjUua85Ftz8RsvR/lpdAinWsymK8wp05R6c0IY68QfJ/aR
         XE4QPF2aMJk/yQXmknluFB3JFEAjZk3uahhAx81CVzG6LkiFu4LGc2Nxy9m/dWegt2my
         jUffkqw9E94ga6mVOkN4NTeohkrzmXVh5+ZEe/1mw4rDu7Jtq0i9MakDfSuT7D08y4nx
         JpABpL7mYIzJptg9mIYlhJcgjTx3akgR3SNjkh08Ft19UsjiqRIiW2W66shifozD0fdp
         VcyQ==
X-Gm-Message-State: AOJu0YzdSe37rtq1/AraRswAj/GziGYScZCV96fcHho+jKMd7Sf/E6D1
	RpPCN9jF+y2WP86Bo/E1IoAqIXYvDa599tOUMI90dvYL/aVEp9fYnFNyqaAjCP9ejdseAY3+rmY
	rF6FbezZFDQS7kNp3ni/h4Qdi/qERG0g45V1/3t9O6lKV8h0DB7Lfbii5yCl3Al150EStoipqAS
	8bYQ==
X-Gm-Gg: AR+sD10TC7BSVO+oeNtkDE0AqUOICzCwkAYXmorXdVFt2g4oOQcQJQbSuTrhipsqWzj
	ctw4rf2lnnopOP0TgbKha0BuE3SFR0cGnsrlB+mc2vKhT71VQHswsiG+iDoKTDLRc3cT256Tv32
	Uv/sex7fIkGP6AsJyNHLGGZNsFPXeq4RPk7BqfuvJh4kvwIfeMRSgSX5rzuTi1c0c/lMFBjH9R4
	6Qd8d0fB2ZDeSYyYp/MlkL7KWrqBfxiBuLzqytaDig1a/XXwCbI6WdP+qfpQJRjVK55hOMYQd7J
	zqpSa6dXTCEDO3kvmZsG3rrrFEB+pZlB+Zlt8i5Oxkp7X/DPyDDmYgAfD2TuVFVSOpz+yj6wDll
	JCgOmaZKPwVEif0yzC4qnq6EmrYJR/f7Fj++Y6o3sfRK1HNU+859U
X-Received: by 2002:a17:90b:2d8d:b0:392:e5b1:d833 with SMTP id 98e67ed59e1d1-39581252d0fmr4072214a91.13.1787117578026;
        Tue, 18 Aug 2026 22:32:58 -0700 (PDT)
X-Received: by 2002:a17:90b:2d8d:b0:392:e5b1:d833 with SMTP id 98e67ed59e1d1-39581252d0fmr4072138a91.13.1787117577514;
        Tue, 18 Aug 2026 22:32:57 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:32:57 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 1/8] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Wed, 19 Aug 2026 11:02:40 +0530
Message-Id: <20260819053247.1420393-2-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: nTbn-62D0PvNGbxTKVyrGNGUYQjvDwSg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX7wUle8kem1ut
 cumuAxst/MuQZlw+kB7TEqAuGzsdIur564Bt0I1Hk0wq8TepruandiI93023VZjkHj8OrGTvRRN
 khSTi8OrPjNIb8dy4LuqenhmRQXAnOhH7wikXTY6EHYQBV/cJICogXopcB2lUz33j6sBaDg8P5S
 pQOtvbFJuXPygP2EoihfH59DXb0lo3pn04tKwBQit5v4nfA1SfJjB0tlPdhGs4QNSq7klr/rbnO
 d49jj1ISjnuhO9xS6RWmkEN+M6yTSf95i6t51J89B1wGGBz0OpjdE8ERkWfE3vzhWJxkqz2udfn
 PyOdEVYaRfkJz23vykpRtibF5HzG8bIAdnNxCUhoGZtZfEqk/3DxbN/REf6KneiJEAI/cs1XihR
 CHC/vuvWjvAsdyx7090Cy2cfbYGgOM9o+p6lOYnsVH/242yA+YaoJypynLaDC/ZIFkrYXsbWgcX
 M7abDccaggRHfQtQEKg==
X-Authority-Analysis: v=2.4 cv=aMrAb79m c=1 sm=1 tr=0 ts=6a85400a cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=l51fLghi-aCFcmm4dtIA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: nTbn-62D0PvNGbxTKVyrGNGUYQjvDwSg
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX+pJJiuLFR2r4
 PJkzKFJ651pHKM9Dc8wKEz+xvfRb/d8Ar1dzw/u3u7BkKYZJLL29yF4I+KneZzFQnlnwDKgCcvm
 MmDUprJee3SxQ5eaL4fDAn9oXOAg5qE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190039

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
are indexed directly by values read from hardware without bounds checks.
Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
MAX_TQM_RELEASE_REASON respectively would write past the end of the
arrays causing memory corruption.

Add likely() bounds checks before incrementing each counter. For
tx_wbm_rel_source[] and tqm_rel_reason[], add WARN_ON_ONCE() on the
out-of-bounds else branch. For fw_tx_status[], no WARN_ON_ONCE is added
since the switch statement that follows already calls ath12k_warn() in
its default: branch for unknown values, avoiding a double-warn.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa..3d635cac8f8c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -582,7 +582,8 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[wbm_status]++;
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -984,11 +985,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
 		buf_rel_source = le32_get_bits(tx_status->info0,
 					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
-		dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
+			dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		else
+			WARN_ON_ONCE(1);
 
 		rel_status = le32_get_bits(tx_status->info0,
 					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
-		dp->device_stats.tqm_rel_reason[rel_status]++;
+		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
+			dp->device_stats.tqm_rel_reason[rel_status]++;
+		else
+			WARN_ON_ONCE(1);
 
 		/* Release descriptor as soon as extracting necessary info
 		 * to reduce contention
base-commit: e07447e65447
--
2.34.1

