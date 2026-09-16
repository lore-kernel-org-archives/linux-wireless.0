Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95583E559C
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538655; cv=none; b=Jt6w2MD6uBlAOBFP4ceAY1DomLkx1djJr5U65eJrUp0t10yP9vaYocyYcZzBWGhpffeNyUHeHbrBMaxgvtqlRzkd5/abTDeaJ/NG/0USZog5ImagP0Chunz2Qb1glD2+rqMLQ3KArp6M3bPRkruOb2JEXtrYLWuNE2ZUWe0FfQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538655; c=relaxed/simple;
	bh=T2pbghNqpV4s59oUA0kTtMAtuzZ10hP69HQ+/6wpu3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY5m9vpdEcdAkUDVMsrLlmGPYqP5bJMGahQQxwfL+lrmVYbTaLtWeg9UHtTfUyEtOEtqaaX4J3SLWqgadkWvNiQDiLPdkd10gEk2XQ43vy6rSpCQs7D0NjKPKx8cynR5BhKZeObhLVCwQTiE4i/hJp+4S5ASW07wPAnln8cr61Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KiQeKjE7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M6d4144l; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KiQeKjE7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M6d4144l"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLYdQA1668136
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=6xDh+kY0qmX
	tiEmiZZVj2diTcpt9RQlrVZATeQZcObc=; b=KiQeKjE7px+sbWTQ0BtRyh0NP4d
	flxBovjF58lue4dFIw/qeoQlnat1ag49XcNFoNeilna2hiYS8wOATr5TBjpwSNzr
	68ky5vLnwWSiePPX5AHoeFUziYQnsqd+1LLV//GnvTIx6QvLkDfueII88yvwwwy2
	JnfmCTGja4XssOgWoq1sSwMkUvtu0/cW8DwXmHC8rhXjvUBSCUGKcQ0thM/FmtvN
	mjF6bHylC+efjil/23M3gnUOI1NgIAR0za1RRyEJldhijU5btF9kk/iiwwcSO1u4
	1pXPofvbGXcH/D4pxoLDxNYUqO7FqSTaKmQaOxXuLMJ3hZGFsrOy+DLkO9A==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gq6kc47bf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:12 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d959904658so93919045ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789538652; x=1790143452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6xDh+kY0qmXtiEmiZZVj2diTcpt9RQlrVZATeQZcObc=;
        b=M6d4144lY+gPnHaqta3jxJM5LnRiufsIpIi08njtWEispz5KOGcAgHTUk3uE9kQofr
         Ldl9ztq0IQQ/TBVm4MDZ81WEA7k7i++xVv6+7ZhqCmmyV6p5hdjV0AQZ9kj6KF76JIrk
         YPvOG528mdPuBpcF61t/RIOD+56rArWgEHkZ0wmQya+mBKuk1acOtLslFO8lodnpahzy
         cJ1Jo4PZ7Fzpk1d2pT0pfj+DKJwNBBIE8/qEw+swDH/qccjV0cwryPWcSoi2m8j0bAWz
         3VNSXOLkIaz7wafRLkf4oxt0Hi/mXZP7s7KAp1LlCLLwtYP8wmu8/UpVEwwV4Dq3tkW9
         5eVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789538652; x=1790143452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6xDh+kY0qmXtiEmiZZVj2diTcpt9RQlrVZATeQZcObc=;
        b=QM8kMauQB7S2YFjBkxSrN1fyGOqeSo1LWAOOl7vdDuYA9+701eQfJEsoxKj744CULG
         XbavwjcZIfyIdbyLZbGYEAKAJemhpgdCEQdTiQI1f7HmdamebuEo8DFkTlrX6KhFFYy5
         8GVzDUAwsoWVZlnfpG/8T7mcAlfM7ETbo9r0vXGVjSOitybUlpsOFwvuSD9XpwcpU4Au
         C2SsJMzGWbYjLIEuEwva06OVmufxJ3uPAV2qGqcN2SlQyBf5aXMDFoN4rr68WAmCq4Uz
         LwditJLW4mD1OaE9AH95weKkBQOsFpGVDWGRhenB/DGrnLHBBJ9/hmztMyDml1gasA7A
         fH2g==
X-Gm-Message-State: AFuF++lDBZfTYKSbHngHA0BqjJ0eI2bNbhXONGyhOpTvW/5J+C2YegCE
	1PidHRMASALgwtEys6UxwexNiv3a5irnR0s5mZPS9byDDaQRDbideptgUGeMGO/l/Xsp09pcgak
	9pcmeppWtj0g703Lovq/rMZVpW83xJnds8ELVgGz4c0ZmtdLId3nY0299Veh7MEK6dz5kKfPdxg
	diXw==
X-Gm-Gg: AYBFou1qa0TItkVTAR/Zx70qHdlpi4jm/rdY8SCTYYke9U/mjBHwnjxGU62o/h2GH5Y
	lUzIwRun10JY2jJRQMm9ToyazvnXGi2Q8gyAUAijSPvc51bFXyyk/f8AWvW3iz7KwLe0M2Kp9Mx
	+03CrLv7PTyiZFrS7wbbqrJY9NyHtj6bKgIT7uMQVoqsx+cRaRKTQKLqAxs60hbpwYeK2Om0Jcp
	I91JrGNKcqp8ZODK9+Yq+yiXDBdd/FEmbLWDjWt4gN69DlI+p7VWGSoTw/EmDT0Vnlvc1HWTHCn
	OyqSjupL/feG+zAN8l07o0lEWefFWJkZCyENRmmbIl6m2ZR2raBsggRlpEicNkSB6wA6MzufASM
	zYbD9vozH78a96XYZhEyNdiDRIkcrtNuPNd//SJbrdgasK8q3Ir5m5QgBz6qb4ZhVIeKKybwpvi
	odhiz6PS+U8raaKg==
X-Received: by 2002:a17:90a:d407:b0:39d:fcbe:fe00 with SMTP id 98e67ed59e1d1-39e1e52242amr3911461a91.22.1789538651991;
        Tue, 15 Sep 2026 23:04:11 -0700 (PDT)
X-Received: by 2002:a17:90a:d407:b0:39d:fcbe:fe00 with SMTP id 98e67ed59e1d1-39e1e52242amr3911369a91.22.1789538651450;
        Tue, 15 Sep 2026 23:04:11 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7a7a1csm2661491a91.15.2026.09.15.23.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:04:11 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next 1/6] wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
Date: Wed, 16 Sep 2026 14:03:20 +0800
Message-ID: <20260916060325.854-2-kang.yang@oss.qualcomm.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
References: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX2vulewzl4xon
 YcsPdH8P/vYTM0r1tzky2UHEb7mmPCrxbMk6wH2N4hctscHOBZIFyJ2dM3u/bhwE8GIA7APBd3Z
 VGSDmBWpqUCXrW2Ib2LPnV+7sZ1NQ0w=
X-Proofpoint-GUID: bw7QbrHo7N8gR72e-XLLeDAxbOYknWGg
X-Authority-Analysis: v=2.4 cv=ZINCCn7b c=1 sm=1 tr=0 ts=6aaa315c cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=BY1CvHwyOBe5klBsCfUA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: bw7QbrHo7N8gR72e-XLLeDAxbOYknWGg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX/qhPtlVSsGpF
 NB5kGdkN3EApZC6Jf55ykWEMWZyyrSYYKl67MmvIXfRh6WkQHZvvCSmgyG9finSqb4g8SvjGNBK
 yrUBAvsnaWj4O0JMrp0+sIEH3dRqIhcL7xO0x6K6DbM2Yu/ZKsGSbUXMJBYKm51oR2F+C+b6ijG
 uWJsPk9Q0Pn4IOqOCIiht0nvtSSc0mYGhiq52VCXrXMCiKaXClWakpEDofOdKqzguX99lGqjgav
 EwtkcbC6mdyZBtm8kJeuwBuoOyzw8f0FvgE5eFh5tnCl380hW6yslGrCJX0QTEPM35wndFdT5S/
 9YgBjFP2x+F1CLlW/3b8Es58b39AN2sYhKIZyPF9Q9GR1CJwScXkdmopSlo/r3e7XrjRg06nQTr
 QTKhIXbrjbEH2xXMENe4HOf/uk20PpazLhmInJuC56nHZm9hNfaGJRAr2rXvAuWX3hiAjphy5lM
 b7op6/bvZC6lCIjxzrQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160076

When rxcb->paddr does not match the MSDU-list paddr reported by
the link descriptor, ath12k_wifi7_dp_rx_mon_mpdu_pop() sets
drop_mpdu = true and continues to the next MSDU. At that point
the skb is still attached to the descriptor via desc_info->skb;
the local msdu variable only holds a copy of that pointer. The
continue skips the rest of the loop body, which would normally
DMA-unmap the buffer, free the skb, clear desc_info->skb, and
append the descriptor to used_list in the next_msdu block.

The descriptor therefore stays in_use with the skb attached
forever. The skb is never DMA-unmapped, delivered, freed or
replaced, and HW does not write into it either because the
descriptor is no longer posted to any SRNG. The descriptor is
also never returned to used_list, so
ath12k_dp_rx_bufs_replenish() cannot allocate a fresh buffer
for it and the RX refill ring gradually drains.

The skb is still reachable via dp->rxbaddr[][].skb and is
reclaimed at teardown by ath12k_dp_cc_cleanup(), so this is not
a kmemleak-style unreachable leak. Nevertheless, both the
descriptor slot and the skb memory are wasted for the module
lifetime, and under sustained mismatches monitor RX stalls.

Remove the continue so drop_mpdu remains true, execution reaches
the DMA unmap and dev_kfree_skb_any() below, and the descriptor
is returned to used_list via the next_msdu block for replenish.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index ded7d56cd79b..ed6686746605 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2718,7 +2718,6 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 					   i, (unsigned long)rxcb->paddr,
 					   (unsigned long)msdu_list.paddr[i]);
 				drop_mpdu = true;
-				continue;
 			}
 			if (!rxcb->unmapped) {
 				dma_unmap_single(ar->ab->dev, rxcb->paddr,
-- 
2.34.1

