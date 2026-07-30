Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F869358D32
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785392301; cv=none; b=JH0pkxcwKUkP8H6uml+NiHn0JoUBluZ3L5t9tuB96olNcVwMjDRdmkXIo1+b5K1ywd/ORqYiX0mqziJj7AE74F+01XWvT9hgYHQJVhQHlzLRmQeUvbXcnKUzQj1hmISk9XDutnZBxIoLZ/5s75VMyA5boalnnVMnzx9i6mrrh3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785392301; c=relaxed/simple;
	bh=LQp3zBxixKb82ohdx+IJdAwHSaPeDM9PDh0bSftoXoQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BSbDUBIO0Z1jo1vq3BIQtDDcXh4FEBdm9u98y8FMs3zRf+L8NiYMHZ+VjSsrq9t0Ttvp6OGd4yNTscCbOpu25c0Q+WG1NO6X1+Ju7FTVk3wOkFGUjEtLuR7us4sZ8MrWR21jXOIhRCBuXA/Fb9L0I+Vxte4bceBLe4v5JmBUgOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Zq9T4qG7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LQGB4NEC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Zq9T4qG7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LQGB4NEC"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U61P1g4012499
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EEb0MOs/8FE5mm4uvLgNppvWg6JqEKTTlkOk6lur7yY=; b=Zq9T4qG7l3qTdM51
	TgrTeecsAk8J3VVlcyb7CjE2mHHMEE71fQMduTYbMoQfa2/G6EoQgeayEblZ1Uf5
	9ICwe3PN59Jk/J64VFcy8mlH1nBk+KcqlTGQmwew+bHnnnv25mmXYQJFIe7gryAO
	f3SHI7qVILf1ER16SxZwalwFsaQMIvk8fuBnB6FwAshoaUVpgc4RAkKf5WYRG0VZ
	wamBdG3jj0WP3YMBPYRC5iOLLB1ez0nwbUp3zJaiJwQJOSKhyAfDW9LQoQyD9UHd
	1MBJxOYC/CNXKtUGyrmXN1LjlbY+PREhvQrgJuuPPf/6QtZsNH+T3Ymjsf91fddv
	Zp6pRA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr0yvr2et-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:06 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so2060801a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 23:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785392286; x=1785997086; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EEb0MOs/8FE5mm4uvLgNppvWg6JqEKTTlkOk6lur7yY=;
        b=LQGB4NECTJKYbwiTKveItYALLDmcbiJ4SNDWpOVCBy/1tGtW9dHfHlxH069S7uGyYR
         aWQRr5Jjkv67gyo3FDLqboDzIEj+vNn8Nfz1n6QS/8fz2bsDGJAZZrb588dYNHNnHIWS
         MqhH+rFuWOfsmnCy8buZtXZPW3u6ttC6huRZKOuErcBVvW2cSsxVCnkFxJO0q//no+M1
         Ofw2GHwFfYpra9dkSBp+HtFM8BcP+4zlbV2GP2Oc/w8KuBRdTM9XI/T6GEuRVS/zeO7p
         aYGO1sgkxWryCRfQUcVzPeG/D/GTNyNamu3fkRiY5bqIakllVMSD/XTL2+tGRP55YWwb
         bINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785392286; x=1785997086;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EEb0MOs/8FE5mm4uvLgNppvWg6JqEKTTlkOk6lur7yY=;
        b=crMeH99Vs0h521Hh2Ft0wpYw/H9g07gNztmXZr0+L7uZnO+Vuusakpe1kvr1L7SsoU
         5i42mbhNy5owvDs5FrBEV3u2mX7U4OpdB2ivzwTDVcQ11ZKtoRGkt6qQ78vMG7NW3FNM
         aAjZFaK2mfYiVimYmScbIDvdBsm1KqJ7oSRzJkN/sOjB4LiKDthrlQEQ9Uvlg+AN6U1J
         zQ9p4h3zy3nQGC3XVKnyM8K0UCHhcoWAc9GyaFAV+l5k4Tm15zd3kiuhSVwjcrOOQtXS
         GGAN3asnm37g4F0RJ3y+gnfDS03YxfehZAT+RncJ26BJIT9LAKykr3Gmhlwh3OvasvLa
         2wKg==
X-Gm-Message-State: AOJu0YwG5T8HtHCCo3F05uIH9v+MBd09eTYhPWnwzRPAw9zuh9uqK8+7
	rYAwD+OErjjWOhBYFPnVeoc0DvbH8NloQy3ZeGEY1mbu70WAg6BW7Mtw+OnTKGehDwCclJPhIFC
	VK5hAHfZsFDwgmPPN83ReTuZ0JWxYTVQ3P/UntpwJFVe/2jbjjHLj0OG4HB0vJ4r76ODgKB5nWJ
	VPBw==
X-Gm-Gg: AR+sD134v8vDreNzZQYrC0e8K3hEMlJ/BsiPUrfHJt76HvE2zHuEoDK+SudliFPEH3r
	3zHiqAfaXj7f5mVU3kzAQeobzqXG7Bo99fUXhy2Bck8TVC5smpHyA5PVbbYTAegHvy+Ga6vU4u1
	+4nWSuH8KpGmNBxVT41xWdwDZJx5IhaRtxTW/OTpsON4zWqSff0u9O61zVj8jcXlFDWSUDiubaZ
	2LU3PiCybl6YVm63bLSA8Y5kQUkMlurJypit+euSnzd1gUi89totgRhOzTBmFcxzCxstUA2asQY
	coqUg9Yo0GT/EtcdzxfQ1KdpPHClvJ/vCAzcezgbJ8J/9bIF6e3SQooRv7zH9+EksbNC80oFY5/
	Bl+s9qI4BgDM5UttX6TTxqcU3rre/kZ49h7rTRiFvPfGHc1VNj1r6Nw==
X-Received: by 2002:a17:90b:540d:b0:38e:3a8:2374 with SMTP id 98e67ed59e1d1-38f9c031b2bmr1220172a91.30.1785392285895;
        Wed, 29 Jul 2026 23:18:05 -0700 (PDT)
X-Received: by 2002:a17:90b:540d:b0:38e:3a8:2374 with SMTP id 98e67ed59e1d1-38f9c031b2bmr1220145a91.30.1785392285119;
        Wed, 29 Jul 2026 23:18:05 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b928f09sm457254a91.2.2026.07.29.23.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:18:04 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 14:17:41 +0800
Subject: [PATCH ath-next 2/3] wifi: ath12k: clear chunk paddr and size in
 ath12k_qmi_free_target_mem_chunk()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-ath12k-align-qmi-memory-v1-2-0fef98dda614@oss.qualcomm.com>
References: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
In-Reply-To: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=FfsHAp+6 c=1 sm=1 tr=0 ts=6a6aec9e cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=h1d0zKgE2UDthXC_IGMA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0MiBTYWx0ZWRfX3wT791NbiP+g
 Fum+ZL733UcABSKzMvOnQfdSmu/SQyxTFqvnaB+WZJJ48AcitkYaS83i52Yl6m4ZS3pB0NJTnkS
 Stjz6bP6UbCx9Pgjz3TEx+Yz8Eg040E75T65HccYuMOWnrbSw+eQskSnHQxTRdjI6SkjI3huwt7
 x7VpMo6xxWPWiFfi/KN4JWmxcfkz/6AJtU8Lvz+IUMnU13KptyXWD51zmtVFa074S85tmaEvPuU
 CZN/ZeK/IAYMGutQ3wIwtLVJKvN7B3qEfZzdOHmyo7xvNhlW3G94YQEtW9AoNOM9xyn7cIz6U4o
 v2z+mttH/7voo5x2dzINJr5gsdAkhzWHwvYaP9tyjz/nqqyjI/yVhpFSe+oYXdC3n1KySkuEcKF
 StYzndKVc6zR9bI79YBcOnC8B8MfF0VeCrbVXH3iCvC86g3LmWSrwwHxsS9ddRTlpe1rZiNhOVP
 hU/wxB7WtzLHduyKClQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0MiBTYWx0ZWRfX04Sm2ShIl1bk
 y+uIS9j6ZVVXHWnc2hML5RqL+lBX5ccO3mtnTLxmkq5RGOJQISG+pTgeJaTYJ5LfwA/vqG9qAie
 fHRR8F0xz+3e4xAPTvFqXlwLOLmZ8Gw=
X-Proofpoint-GUID: XNMTJAu02TP9BvfeW6Yng5921BObVE2h
X-Proofpoint-ORIG-GUID: XNMTJAu02TP9BvfeW6Yng5921BObVE2h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300042

paddr and size of a chunk are not cleared after the chunk is freed, which
is safe now since the code checks vaddr only and it is properly cleared
on free. However, leaving stale values can mislead diagnostics and future
maintenance. Clear both to reduce such risk, this also aligns with
ath12k_qmi_free_mlo_mem_chunk().

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index f96d847ac92f..03ec2057ca27 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2602,27 +2602,33 @@ static void ath12k_qmi_free_mlo_mem_chunk(struct ath12k_base *ab,
 static void ath12k_qmi_free_target_mem_chunk(struct ath12k_base *ab)
 {
 	struct ath12k_hw_group *ag = ab->ag;
+	struct target_mem_chunk *chunk;
 	int i, mlo_idx;
 
 	for (i = 0, mlo_idx = 0; i < ab->qmi.mem_seg_count; i++) {
-		if (ab->qmi.target_mem[i].type == MLO_GLOBAL_MEM_REGION_TYPE) {
+		chunk = &ab->qmi.target_mem[i];
+
+		if (chunk->type == MLO_GLOBAL_MEM_REGION_TYPE) {
 			ath12k_qmi_free_mlo_mem_chunk(ab,
-						      &ab->qmi.target_mem[i],
+						      chunk,
 						      mlo_idx++);
 		} else {
 			if (test_bit(ATH12K_FLAG_FIXED_MEM_REGION, &ab->dev_flags) &&
-			    ab->qmi.target_mem[i].v.ioaddr) {
-				iounmap(ab->qmi.target_mem[i].v.ioaddr);
-				ab->qmi.target_mem[i].v.ioaddr = NULL;
+			    chunk->v.ioaddr) {
+				iounmap(chunk->v.ioaddr);
+				chunk->v.ioaddr = NULL;
 			} else {
-				if (!ab->qmi.target_mem[i].v.addr)
+				if (!chunk->v.addr)
 					continue;
 				dma_free_coherent(ab->dev,
-						  ab->qmi.target_mem[i].prev_size,
-						  ab->qmi.target_mem[i].v.addr,
-						  ab->qmi.target_mem[i].paddr);
-				ab->qmi.target_mem[i].v.addr = NULL;
+						  chunk->prev_size,
+						  chunk->v.addr,
+						  chunk->paddr);
+				chunk->v.addr = NULL;
 			}
+
+			chunk->paddr = 0;
+			chunk->size = 0;
 		}
 	}
 

-- 
2.25.1

