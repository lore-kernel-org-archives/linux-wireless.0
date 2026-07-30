Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8719F2E9EC7
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785392300; cv=none; b=SbzBFIGUn/7vyqkSfEBXof88rFdPsqrbKhB6MOaIYMGs+YXjQsV9niAJiq6U/W5syfHwZT8TBoxqH0wyQrwxGkRmaDfTPOSvswrqGZOTkZmed5CLq9no7lq9FKQnRIkfv6W7ge0pWkEOpt5b0fDyuwE/UOzkFYYBfzD/qmT9rpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785392300; c=relaxed/simple;
	bh=31QV8wTv12fQYDnioi57GnlfPzl6pjwGhBbteDJXQxU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dm9M4eIw7E4i4W5Yu1u82Hj65FWi1n3dWhOhlfz5We22LxanhGyiAIdh6D7vNRfM4iHvuEEegxwrUqau2hZDQM00KeX9GleskT13+4luhiycQ+hjYDcbYwgJjjl6oz4n9ztB3CdNgmIwOA+364oOZs20kSvF7x8I+HDd2m3fkMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FvFmw+n1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h12g98Ab; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FvFmw+n1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h12g98Ab"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U61VvX4012998
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OTV0lOko+NiXhECP6eCpyev8Ziy/a1d8Ju+nHmASDK4=; b=FvFmw+n1gyzjB3j8
	7Epdq8B9SSl4x9LjLiZqmAPxq/gOdcQL9V04nz51QgeRbeTxDrGop1MP2snqTmcV
	PRYN2Z76g+pKA3j9RaE2AvwkxcrC4XA3atGcpv87ePKYkR8097ckt3rnJTHhppvk
	N/GKVzNIRcKx4Kg3mSijgTB33uyJxCEU1+R0nfKStGsX4PHmOxGdXjrKZTfZdWo3
	ZhVM+E4cv5IXugsWCUTs4pREz5F2a9zVlFnguKTbVxq4d10OwgTbkNjPkgy7HjoZ
	SwwYXi3MDjklFcmv/01oY1oeBFLv70SSX8cpf9GMzxvCAhbrvfOzKfseb9Xcdt4q
	svPPIg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr0yvr2f0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:08 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so2232761a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 23:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785392288; x=1785997088; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OTV0lOko+NiXhECP6eCpyev8Ziy/a1d8Ju+nHmASDK4=;
        b=h12g98Ab+L01YkbAoWJs/hnMl0Q+GWSjvEJQXMOKVY7hGmmyF5YHni+Pbtp4fZ0d97
         E+O+itsIpxdslbRPmpsP6w99//I62QJSc54t8tgHgewZjAm1nDDmEicswYABmRCdUnjz
         yW8hCKp4tS6GHzRGHG2qkyx5FckTg99h1hNlVCY49yYwmmLAiSvOJQzCkHQ8XKc6STxm
         jrcxq4NPFgfeT06dRfRFzpNtG/qkt2U7nT8O8n37jFvwndV5tEAdO15daCTRFrbALRG3
         gWfO2va9H6cc3FJ6tsX1yrvE2ql8mjuveF9j8BHw/hLJf5UY8hBWXZWQwvAmsxIhFYg2
         vC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785392288; x=1785997088;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OTV0lOko+NiXhECP6eCpyev8Ziy/a1d8Ju+nHmASDK4=;
        b=LAKRkpv6O+/OBz5N2pvb2L/rqiwxZjtfVri5KXhTe10qHeFktLeH11D9gGWrm+Dr4L
         9gIjpLJQZ4FME3oRM0grdO16GiBuwWd3ERIbhPDQpJdhUOPsc+bK7e5ApdfpYsM/gVy9
         Pnrd7PuNB/b+8XbQlg2kdKLArTxexr/rk8x8l1IJgWthkQ8x90mfdVjyhZwejs9rG6zW
         vfUXlRKM0kwipPhPNnYgtzii8cwDx/bYomy+sSZK5KUDqyJru7xcIeJ397SBGoE9o1/J
         AzHS0E5+lH0yXatUtjy4m18w1Ryt78OxH2Q7vIlb+qe1D5kW9i1wWVFipiJ96YiJfbOS
         rloA==
X-Gm-Message-State: AOJu0YxijYMm9ZEfpFbtzFLPwWB7ScwXPQCOiu9x52U6Jt9JB5yBznad
	XSxLxlGOl1UCaF5QcVxwsaOWknqF4JjbwOeBoRIKrir4boVNpu4pZ3D+l+VYcrOqv6zP75T0Gqq
	c0RgoWdK6IxpdFKtXbofVjlswgZ6/NfA1HWhynOOpC7znDQX4EQJRNMOwY6FQxsqieYAKWQ==
X-Gm-Gg: AR+sD13aeQheOyIOhcvHoCH/SfcLOzrwuZX8akXat/XPz5OBpC+ED1Z/zhq8QwowKlo
	4LPHPZ7EFzurUoKXPlw2VYKgUuyaLZdfLGFIny3ap0qp+Rq4DsY/uRMSCi1W9i7gI4PtDP/bQCp
	oORVdJZfPOBA0B+2Qirc7vVinqzX3z+C2YJWSmUWxB9F1AdpT3Ch9wD6SGexJKbzne4q95MQh30
	WaHBelGItFadicSvYsBO8RJ/4ZgUwJUKhMu3QB+x2MVkw235dDDnPmeEEcMkApCeaWsulh5ShKD
	FYatx9raUR+S4b1CfXxmimPUJnH2H2zJW6oQ/wRGJmTsDOns+dQ6mew3BN7Mjp6/X4xqG5UiuDT
	LbHpUh6JYOVe0avwSKxeP+OKnx0J5hdulkQYy+Zqmv9Gj8vZZJQvBxQ==
X-Received: by 2002:a17:90b:570d:b0:38e:dc4:3f64 with SMTP id 98e67ed59e1d1-38f9c04cb68mr1142870a91.38.1785392287717;
        Wed, 29 Jul 2026 23:18:07 -0700 (PDT)
X-Received: by 2002:a17:90b:570d:b0:38e:dc4:3f64 with SMTP id 98e67ed59e1d1-38f9c04cb68mr1142834a91.38.1785392287278;
        Wed, 29 Jul 2026 23:18:07 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b928f09sm457254a91.2.2026.07.29.23.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:18:06 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 14:17:42 +0800
Subject: [PATCH ath-next 3/3] wifi: ath12k: align QMI target memory to 64
 KB
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-ath12k-align-qmi-memory-v1-3-0fef98dda614@oss.qualcomm.com>
References: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
In-Reply-To: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=FfsHAp+6 c=1 sm=1 tr=0 ts=6a6aeca0 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=qS1--j5BNTmtoKFDeJQA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0MiBTYWx0ZWRfX2k62e7256FxB
 40AhfE3JztmFFFUtSafZgXP1wSHXJuxtbUaG01iFuXMajRhGNI+Gf2cGG1ci178gFDDh3L2GE9s
 rZLmAcUb3FzXBlNA0NtAJsCam7PCyYRSxsJ1TdURGUYKWM6zu5n3YMVyHZFtOR9LT8BBUwtr+bG
 F5VIdKAqX0kQ10ZnlpMF0cEOreWgl/x+izbZ2KTFsoFfnFzMDhQwUNt2E8yqKJ5LB4kH+fM1LuH
 4oDRapeCH8n/+K0n/YX93bHkQTE8wO4GGLLGFlPEYcyHsp4kUJSo/+dxMteE1ir/3Qs0Wg/n7eA
 9U2RO4qrCAaRo433atnescosqPmC/FoBwP7X/PMAPFGbVWFSKsMJTC4tqcWFdy6M6FpwfCDO1BP
 x2Tpawm2f21lQMlQXk7R8lVwOzeJiu8+6m2xiIxalSi2yU40D8gX1kdstN2ms9B2EPXgv0HqAlB
 GrUNdMHDH8sZ3RtGlDA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0MiBTYWx0ZWRfX2aOdl8qVRKFM
 NB+OAYMKVhrMZVgbJr+X6ezJ+OiG+xkm33s9gAFM4nS+AhVf+gAtBwCu1cLPc0dV56L9Yk6YuGC
 Zmki9ZVfcpJ832m4k3bXhhKD/Sp3BDM=
X-Proofpoint-GUID: luffrVuCRSLk5lzJTd24nNYgus8Lzmm-
X-Proofpoint-ORIG-GUID: luffrVuCRSLk5lzJTd24nNYgus8Lzmm-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300042

ath12k_qmi_alloc_chunk() allocates the target memory chunks the firmware
requests via dma_alloc_coherent() and hands the resulting physical
addresses to the firmware. The firmware does not require every chunk to
be aligned, but each unaligned chunk consumes extra TLB entries when the
firmware maps it, and too many unaligned chunks exhaust the TLB and make
the firmware crash. The firmware team recommends aligning the chunks to
64 KB so that the TLB stays within budget. dma_alloc_coherent() only
guarantees page alignment, so a chunk can end up unaligned.

Align the physical address handed to the firmware to 64 KB. A natural
allocation is often already 64 KB aligned, so try the exact size first
and keep it when it happens to be aligned; only when it is not, free it
and over-allocate by SZ_64K - PAGE_SIZE and round the base up. Since the
DMA allocator already guarantees page alignment, that padding is enough
to reach the next 64 KB boundary. Record the raw allocation in
paddr_unaligned/vaddr_unaligned/total_size so the chunk can still be
freed correctly.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 79 +++++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath12k/qmi.h |  4 ++
 2 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 03ec2057ca27..bfb5b6659f21 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -14,6 +14,7 @@
 #include <linux/of_address.h>
 #include <linux/ioport.h>
 #include <linux/of_reserved_mem.h>
+#include <linux/sizes.h>
 
 #define SLEEP_CLOCK_SELECT_INTERNAL_BIT	0x02
 #define HOST_CSTATE_BIT			0x04
@@ -2583,20 +2584,28 @@ static void ath12k_qmi_free_mlo_mem_chunk(struct ath12k_base *ab,
 		mlo_chunk->v.ioaddr = NULL;
 	} else if (mlo_chunk->v.addr) {
 		dma_free_coherent(ab->dev,
-				  mlo_chunk->size,
-				  mlo_chunk->v.addr,
-				  mlo_chunk->paddr);
+				  mlo_chunk->total_size,
+				  mlo_chunk->vaddr_unaligned,
+				  mlo_chunk->paddr_unaligned);
+		mlo_chunk->vaddr_unaligned = NULL;
 		mlo_chunk->v.addr = NULL;
 	}
 
 	mlo_chunk->paddr = 0;
+	mlo_chunk->paddr_unaligned = 0;
 	mlo_chunk->size = 0;
-	if (fixed_mem)
+	mlo_chunk->total_size = 0;
+
+	if (fixed_mem) {
 		chunk->v.ioaddr = NULL;
-	else
+	} else {
 		chunk->v.addr = NULL;
+		chunk->vaddr_unaligned = NULL;
+	}
 	chunk->paddr = 0;
+	chunk->paddr_unaligned = 0;
 	chunk->size = 0;
+	chunk->total_size = 0;
 }
 
 static void ath12k_qmi_free_target_mem_chunk(struct ath12k_base *ab)
@@ -2621,14 +2630,17 @@ static void ath12k_qmi_free_target_mem_chunk(struct ath12k_base *ab)
 				if (!chunk->v.addr)
 					continue;
 				dma_free_coherent(ab->dev,
-						  chunk->prev_size,
-						  chunk->v.addr,
-						  chunk->paddr);
+						  chunk->total_size,
+						  chunk->vaddr_unaligned,
+						  chunk->paddr_unaligned);
+				chunk->vaddr_unaligned = NULL;
 				chunk->v.addr = NULL;
 			}
 
 			chunk->paddr = 0;
+			chunk->paddr_unaligned = 0;
 			chunk->size = 0;
+			chunk->total_size = 0;
 		}
 	}
 
@@ -2641,6 +2653,10 @@ static void ath12k_qmi_free_target_mem_chunk(struct ath12k_base *ab)
 static int ath12k_qmi_alloc_chunk(struct ath12k_base *ab,
 				  struct target_mem_chunk *chunk)
 {
+	dma_addr_t paddr;
+	size_t size;
+	void *vaddr;
+
 	/* Firmware reloads in recovery/resume.
 	 * In such cases, no need to allocate memory for FW again.
 	 */
@@ -2650,29 +2666,56 @@ static int ath12k_qmi_alloc_chunk(struct ath12k_base *ab,
 			goto this_chunk_done;
 
 		/* cannot reuse the existing chunk */
-		dma_free_coherent(ab->dev, chunk->prev_size,
-				  chunk->v.addr, chunk->paddr);
+		dma_free_coherent(ab->dev, chunk->total_size,
+				  chunk->vaddr_unaligned, chunk->paddr_unaligned);
 		chunk->v.addr = NULL;
+		chunk->vaddr_unaligned = NULL;
+		chunk->paddr_unaligned = 0;
+		chunk->total_size = 0;
 	}
 
-	chunk->v.addr = dma_alloc_coherent(ab->dev,
-					   chunk->size,
-					   &chunk->paddr,
+	/*
+	 * Each unaligned chunk costs the firmware extra TLB entries when
+	 * mapping it, and too many unaligned chunks exhaust the TLB and
+	 * crash the firmware, so align the base to 64 KB. The DMA
+	 * allocator only guarantees page alignment, but a natural
+	 * allocation is often already 64 KB aligned. Try the exact size
+	 * first and keep it when it happens to be aligned; only fall back
+	 * to over-allocating and rounding up when it is not.
+	 */
+	size = chunk->size;
+	vaddr = dma_alloc_coherent(ab->dev, size, &paddr,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (vaddr && !IS_ALIGNED(paddr, SZ_64K)) {
+		dma_free_coherent(ab->dev, size, vaddr, paddr);
+
+		size = chunk->size + SZ_64K - PAGE_SIZE;
+		vaddr = dma_alloc_coherent(ab->dev, size, &paddr,
 					   GFP_KERNEL | __GFP_NOWARN);
-	if (!chunk->v.addr) {
+	}
+
+	if (!vaddr) {
 		if (chunk->size > ab->hw_params->qmi_max_chunk_size) {
 			ab->qmi.target_mem_delayed = true;
 			ath12k_warn(ab,
-				    "qmi dma allocation failed (%u B type %u), will try later with small size\n",
-				    chunk->size,
+				    "qmi dma allocation failed (%zu B type %u), will try later with small size\n",
+				    size,
 				    chunk->type);
 			ath12k_qmi_free_target_mem_chunk(ab);
 			return -EAGAIN;
 		}
-		ath12k_warn(ab, "memory allocation failure for %u size: %u\n",
-			    chunk->type, chunk->size);
+		ath12k_warn(ab, "memory allocation failure for %u size: %zu\n",
+			    chunk->type, size);
 		return -ENOMEM;
 	}
+
+	chunk->vaddr_unaligned = vaddr;
+	chunk->paddr_unaligned = paddr;
+	chunk->total_size = size;
+
+	chunk->paddr = ALIGN(paddr, SZ_64K);
+	chunk->v.addr = (u8 *)vaddr + (chunk->paddr - paddr);
+
 	chunk->prev_type = chunk->type;
 	chunk->prev_size = chunk->size;
 this_chunk_done:
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index cbe5be30053a..afa380f5e934 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -101,6 +101,10 @@ struct target_mem_chunk {
 		void __iomem *ioaddr;
 		void *addr;
 	} v;
+
+	dma_addr_t paddr_unaligned;
+	void *vaddr_unaligned;
+	u32 total_size;
 };
 
 struct target_info {

-- 
2.25.1

