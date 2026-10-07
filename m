Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57674756BA
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 09:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365082; cv=none; b=WbTkGs2AEnMgCugl8Nto9i6SA006Gb2yfL5wHfKEV6QtL6fQ+4PXmhzPjYuQgek1iTDdes/XozZ+5XF6gkUBL5FTcZr34ubATm60XNZIpaQv6PnRckjDQEgJ+xS2mmjNAL2gq0aPHj1grBJ2FqxPOl1didANICb9EPC2mdaPlcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365082; c=relaxed/simple;
	bh=o7DsTDE3bTvEKve7noO0BHvqsH21eTnNSgVIMwnL7zE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U2WnKMLdefcOBdEaZ04ZMRc2ctoaxiw+OZWd9MkSaxweVoYTSAepCtaGLtm+Bfy3PsJuMPXLTiw4Wcer6wIvbbEMhm5NvuDkWbvf8/ZoJo6MU+pD2Rnmx29IkgLu6+EQsLq9rOoxjGZTwjiHFEy7Vft3/FCVYNpQj8YVSOaEZtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O5UkXP2B; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YkzNDdgH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O5UkXP2B";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YkzNDdgH"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6977jfLn3811202
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UJgJ/jnse5alnP+vj4hLzcWYhPhvr+j+Eu4oWyU7/RA=; b=O5UkXP2Bh9fi4LHB
	pFzTd1hhEsCs0exA23gxG/t4AT9D27mcohtSKCvL1ZV1kOJq2uuBPHTIua0spwW0
	olHI84MWY3vikd36OBisaLeN3FMop0Kxfv3rDJDz2WrtSYWDSYDZmOtzLbtkkMOJ
	24PA2bMbKLV0l0JCYXi77NmCwae7YENCM6cyStej4Rs8yyeMT3qUl4pZCr7hpIbj
	ZlPfGvHDX4VGX5zfeKM+DqUk8dJpgEPXlMBpTiU6bKkAFUAMBoYzPaSaPPOkExF+
	PYPppktYo9otTpvLUFWVkn+mMUTc76Si9WpHtOtUf8TDuCxNG+HT5TG+VHxCjLOW
	LRhWbw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5gvrrjvn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 09:23:59 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8886059d3faso7920540b3a.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 02:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791365038; x=1791969838; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UJgJ/jnse5alnP+vj4hLzcWYhPhvr+j+Eu4oWyU7/RA=;
        b=YkzNDdgHkktLKjQOup+xTZfwKHd9kBmgv/TxIrMLh2LXR0za50IhLrK5GEyzif7NgB
         1qat53gvkv87QQk3ZOQr6bRhYw0/CXYVFlBb9kcptOTDy/9ZHYLCsPAy31nApbvGh2Oj
         i8wIt5bvPIh+gn/ZWjno42P6AGeJ18DPH/xGhPmH4/6QHJTjyXUBL6Kqfd5EfiT3m802
         ZbpPy/A3ID8ISroRBcgihKSXC6PWZVvKIOlU4PJqpj7OsB3VluiRXEOt86WVUSnDZxCz
         +xlcNbmRdJA+Bm4DPal7N4dZ0YcrKJuJOH6FSyI5KSEp21PL1Ylf+3l9IPGWTAXUjlHs
         cduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791365038; x=1791969838;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJgJ/jnse5alnP+vj4hLzcWYhPhvr+j+Eu4oWyU7/RA=;
        b=Q2Hotj8jI7Jm34YfuJJg58ykcF0S85UL7dAgnNc8Zlte20wxbCZm64OO1cObQ83JzK
         Z6ugB6MzlvdMmv7+KG1XbBovXv0SvmiTpsPUuZ17OcwiylYvS0Ohz+udRNQoU/jtKHk+
         jTM10q/icl7TBel1jecuvCq9BTnb2VmeUS1jy3C/YWjCOU3j6lLD9XpbydJjZDkrAAJ+
         8c8qVFFbm4Dy8XHihk2zC9RBAnODh3gF+OmLHWYz1Yi1WhVNjUjLkJGbetptoJ6mq0aV
         klguCjFXrH79lfjnYoaStfrHiunFNt/VIMVs+O07rJ2PebRY9xrDqdynkjtP98F+8FWY
         Lpww==
X-Gm-Message-State: AFq9FYIHEG6KoX21H8iQoXaMr3/UDX6d3WCtzQeCtHbpbOzvkiv/kzvD
	z5xKh2fEvk7vhZImxwq1LvyfmGfZGDr/hX4i9kOVrOd8e8E3vVSRJyNuNHib5M2DkGK+/UvYW8E
	h7hgRIjOiW5s6vM29SXXl0P5aEMdr4ZXUS63oktrrMSnqYE+W3/K68WBgi9e98rOus/Iq/A==
X-Gm-Gg: AYBFou0FA5YJ5Gl/J+kpRW7joPGXumZC0IvRB+b/nIKr619q1zCBHOqpUGXjzyp3/Ff
	6vORSD2bNTU1dhlhqE7owUfT4q+LTSdslP+Kd25Xm49JISWUYFT0PeE6OgPNf7fnOE5dIofrWB8
	r6amy96x0NrPT8t/F13kaLTYyn9SiJE/1nqMk8z6M6fKtiFoTBFlkSGrYCtnLan1i0MWHkZTJl/
	r9QhtMMJERnRtywWpLn5drJnpxEfQmXP9k8Bd30VKgms5V+XLg+mP9sqbIMyeZSx3knoXh2bTVm
	7Bre4Et8LLzK26n2B8JFybNLKmB6U3TaO7qPz6d4hvyL8HZSR3xayx0PQG0DT48Qj5P14Wj3/U7
	sin2xNv49chpPbBr56ruJChRigfRV1pwrg4AcBhxw3CyhQGUBRPpr8vfgdHeE3OKO0dmP8nHAph
	qXnyJJ4Ovmm3PD0qwXg+77GG0=
X-Received: by 2002:a05:6a00:3317:b0:874:708d:b627 with SMTP id d2e1a72fcca58-891b1290986mr1402183b3a.28.1791365038381;
        Wed, 07 Oct 2026 02:23:58 -0700 (PDT)
X-Received: by 2002:a05:6a00:3317:b0:874:708d:b627 with SMTP id d2e1a72fcca58-891b1290986mr1402172b3a.28.1791365037974;
        Wed, 07 Oct 2026 02:23:57 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89271257af8sm119128b3a.41.2026.10.07.02.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:23:57 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Wed, 07 Oct 2026 14:53:33 +0530
Subject: [PATCH ath-next 2/2] wifi: ath12k: Increase RXDMA buffer ring size
 for default memory profile
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-mpp_ws-v1-2-739b1fb87d24@oss.qualcomm.com>
References: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
In-Reply-To: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=W66txhWk c=1 sm=1 tr=0 ts=6ac60faf cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=b5TSSxGLzCK9vQyPxlUA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: OSXo_2tuhJrBnellOkd1SNUd4mTSijiG
X-Proofpoint-GUID: OSXo_2tuhJrBnellOkd1SNUd4mTSijiG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAzNyBTYWx0ZWRfX/1hnTMc+tM1l
 EBdicH11SRAAx5c4/zXC0OWJ41phXMTCzziRxMhGCioCkQBdCv0lgWVTvHWfq846YY/4ItcwW3m
 3k5eT/OIwKuVv1FAIAyJsVWgkxh7Mg/GrmGCvqLaVOFiaFPqfPQpv+eUYuWQpymlPoNFWqJCKXj
 qTTs9mhxXRuYG3Cr2Q3aMmBEmlFqYqOZImztSfEmcC7fFLp0UkuFnRa2/DfOQYqPk8cz9Wa1o1g
 +DhSP3uoQ4qBmVPlH9tx8R9pS1V8QFaKJzxF6oZ5fWJLOytSfaXGAyLm+1Vp1zRAlcT5wSg+GIp
 UpUI7233CcK47lLc/1K9QQZFoGKgLRnFeHpZLoZT4g48eRq8PLgzE+9qkfLIs9c2EnpT01s17oX
 JejJ8oFM9ZgUZluSq5GyHgL2yOmYI2OLUdFOu7fKV2nKpvGhUYmzL5Zw7ZcsH3BrXgGBD77Jrg0
 g0VgvPsXFunYW3UvQCg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAzNyBTYWx0ZWRfX1RSscFCbyya7
 CXPbz0CF1AMEKOiuJ0HfM/qYeE6kFMT2qe2N1QQQ/aXuboe29k+hmRqHIGZemKio6zc4Oe/+io/
 5cyYY8KBAIyy4leG508RLjC4oAKAhmY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070037

From: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>

The default RXDMA buffer ring size of 4096 entries can become a
bottleneck under high RX traffic load, resulting in reduced receive
throughput due to limited buffer availability.

Increase the RXDMA buffer ring size to 8192 entries for the default
memory profile to provide additional RX buffering and improve RX packet
processing efficiency.

This increases memory consumption by approximately 9-10 MiB and improves
RX throughput by ~20% with the default memory profile
(ATH12K_QMI_MEMORY_MODE_DEFAULT).

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 764e646d0090..a70590e1d821 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -54,7 +54,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 32768,
 			.rx_desc_count = 12288,
 			.rx_release_ring_size = 16384,
-			.rxdma_buf_ring_size = 4096,
+			.rxdma_buf_ring_size = 8192,
 		},
 	},
 [ATH12K_QMI_MEMORY_MODE_LOW_512_M] = {

-- 
2.34.1

