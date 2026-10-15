Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E3148F832
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 08:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792053912; cv=none; b=nHz75OVYvXFVdmVwUhFtwQFoV4ZNrbdEqwx+sT8PBtT+O6nRyexLv0E+auwOkBnNY/a4UMsMNQH80vzse6h8qLPjGor4F31ILYX39zrEHUJJkGwPngMBl4sZk53JHfDRY0z9ocLSQJBxBd53q0U+QXIHqwO40MmWF0dn6ZWeulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792053912; c=relaxed/simple;
	bh=EVS68t6RBn+B45mj11dCne5s4xFPpdeBBIt84YE8qsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q7SLAZOULQJejJy/XGH1LjRgrw0Bi5velq+tMmuZJSkmHf0r2PkpEG10kSe5Y9TJigaw7ebAJrUrwMrHQYItGPJOZ1hwJxRBGGsiOP4PJfDE+SOmp/9fs79ai5TwsER+2aLcC1UJksZIy3U8UBjcKFBv0XwvqKqUEilwViDGelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YcgP5cpz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jyktkZNA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YcgP5cpz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jyktkZNA"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F3wZSA1889493
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 08:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=mz0bzaFxUOs/yhflal5pNZ93HwpCHwYdrX0
	Fgd8LfFg=; b=YcgP5cpzLCkMETzZvTod7PKLJ+oG/nW8QuwP2/E/X+e2Lh7T03Z
	hmFkks/+kKwv7pNqapUAYfsZZlAuYqTZNHCcTEoft857osi5nsURmMLYvt8v6/0j
	6fyPShZELoOFuom2ZopO+Bl68QnO6zmK27+a/nmQjxVQx+RK7wP/WBKJhi8HqGnK
	b5PKfMXf7ISTukDQekaswWwNBnVhEhDWQtgy7eLYRg7DmrTJwRsAVliiuwJheLIl
	zQo87mijw2naBZDBt+ceW/3y5KHF4RkKeGWPSE8Rp2A1CttsfMqXT57q3dmDi+Hg
	3N+gzbVkKS7h1OjwFUnhdX3rBpkBDsgvCWg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haqda12gh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 08:45:10 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-359b81ad4e8so2774222eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 01:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792053909; x=1792658709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mz0bzaFxUOs/yhflal5pNZ93HwpCHwYdrX0Fgd8LfFg=;
        b=jyktkZNA+IcPsHyNE2qcmDyicfkTbJg3QJKnHFNWQshzpuNLrxdxPEzCjcAas07y0r
         x9yCeyG9NGlJDGeRbWiSfZqfNkNH4tNL5QUBMLjjK4Smdxrz1bBHJmjbThwSfIROmCTH
         EUaz6iVyEXumquxugWNRLdzk78Q28ceBSpo9rL27Hfs9LlejH7FdfjQgRHeATTJNwM8m
         yrCz4lJNuPqw0IU6d4Llk0dzJxu9MPRm0vNTGpgisRnKmM3v8iwch/jAvJDxFYwBdq9P
         Xl2U4nhxRP4N3uwV/7r8dWSuke+4ABGv6ieISu5AuyCbNqwAKum7Mqr8UoO/n/QvdDoH
         vTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792053909; x=1792658709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mz0bzaFxUOs/yhflal5pNZ93HwpCHwYdrX0Fgd8LfFg=;
        b=XxBqePDwsBKwbrQvihof8rwcrdq5iHn8/o9da1gw44aFDatsC9jI7sf0Yt7dWLEYsJ
         3HxT245M/HznHUSSIyO/hzAC9BkCXFTMgtw3qn8NkQk6xjzMQLuieOHhpHYP+nTHJ/PH
         5u6gRgUzf7x1QoYlu1uQQKe5bpNJ0JS/vxJyd0vpSRMJMPx/ELIB4J7um5458cQF/Vbp
         i5qVRK5eni48BEhuAoImCWO5XRvPFP2q5RRklh4UkM3vHUSASisIEf94LO8cdIIIHPni
         rgVC4X2XLgfmGdvo9pkNTT/Y/k0IsMGntNFORZlBNJoJYgLskJCwqpRd/3Ob0Y8CebaG
         D1xA==
X-Gm-Message-State: AFq9FYJKY64tkgrhthGTl2ap3DIXAmftqy+L3ub8g8cb70hvVXCaudYf
	2yXoO4JjpaY6537zsgeGJ1pbAtJ38SCUKiQXlj0xg2TIWwJcJfwN6hjvXOKfvEitbLT76EPPuOE
	cl4A5yV2PpMNbUCGWWGmf/EP07wN9o5voocpG6UXqGWBlmLosam4W7uieY1q5cXnvxjs+dC73lB
	FyMA==
X-Gm-Gg: AYBFou1MP8f/QduvFjfAm1aos3jLRey8X57biIhTPD6+8agazON8yePqtdw6sGwr7vz
	giCB9uUnynHMY8AMfeAHVkDW7KqrJTJbO5v+t/Q33VtvIjIUfF6qmi8kL0VAC5grR7ySJtAGeHc
	t2SQ8iXjl0AsdijXOoCDzZei334tTXy8g/Uo7EwnIvd13a/fmUYye/4r6RM/c9KspPu0g9qtSmq
	sw+vOq4wx8rTQ3QsgoqaZ3gKBQ62z/AFvapUppMD/BDOhBKoRacKJCZ/5+oqvFvEZe326j4qafC
	IPCSCAiA3RHffrzs+9V9RN5qtQESxRnRIWc0knmR4/Vbd6bWXYFWyQK8zzufaj6RQhl/Wzgnko+
	77v72Bz09ncMCUGUg6YoaKRa8ZjHnBXLdzQYtkUATAozO6NLpCa1FRBvUvT7/8pZZv7GmTOmRqI
	yfWRjo0q24Y0bK6CyU
X-Received: by 2002:a05:693c:42d3:b0:35b:17b9:ebc8 with SMTP id 5a478bee46e88-35b17b9f562mr15075930eec.19.1792053908976;
        Thu, 15 Oct 2026 01:45:08 -0700 (PDT)
X-Received: by 2002:a05:693c:42d3:b0:35b:17b9:ebc8 with SMTP id 5a478bee46e88-35b17b9f562mr15075898eec.19.1792053908340;
        Thu, 15 Oct 2026 01:45:08 -0700 (PDT)
Received: from hu-ppranees-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm64646942eec.12.2026.10.15.01.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:45:07 -0700 (PDT)
From: P Praneesh <praneesh.p@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, praneesh.p@oss.qualcomm.com
Subject: [PATCH ath-next] wifi: ath12k: fix IRQ disable imbalance in AHB ext interrupt handler
Date: Thu, 15 Oct 2026 14:14:45 +0530
Message-ID: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAzNCBTYWx0ZWRfXzjOJhYfDLpT+
 czyEGIyWr5xWgaKScHMPxC7SAzy9wwRj5h0K+B90HpRqCPC7TQdjk0AA8ezGzx2Sf5+en945C7F
 NTm70YDojQ/IvszOMJrHZEM7pdwDUbA=
X-Authority-Analysis: v=2.4 cv=K9u3jCWI c=1 sm=1 tr=0 ts=6ad09296 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=NpINWkwEc0pFvE3pZ_QA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: 7TH8sBuxHgBh7kPqcAb3iqkCglwLLBx4
X-Proofpoint-ORIG-GUID: 7TH8sBuxHgBh7kPqcAb3iqkCglwLLBx4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAzNCBTYWx0ZWRfXx0kbQnq8bTnw
 4vfnFf78li5N+OlvYa2HRvhAPFRMlF67tInsHUbBScYCHmCBDcZ5rbRcMwwwPiOJ68d0R3uwh9i
 cE6okL5zivFXpNmsBdlsKvtvxfco/gB8ZDDtagXra33qi62zUqpvf2UAX5r3FO81R3OAisactRf
 +RNpGmsgI9kdQLRrymeIql5B9ps1uqkRY39fcvs9ZLVQVlC1l1ZFcxw6eZFgzX1A/WAiA4cgp2T
 A9njtWl0NyxuJAu4VNe99F5BXQK7dKu8Ukx23X2mi8ZcyXWap7hxne1qR3Ns2aV6xMBvKwIMUTz
 T2xnin7wQ9sofVKqbBf/0qZx+M7M8NlHBevjya1P5xBoOSt0aP8x2E6ZBg0LqgeOrBJirsZueH9
 l5xTyYplLQ97SrRG1buju+Zhv211nedyTT6yHIEHtmunQ+X4TX7eM6yEVXT5ye4EVCLNMJzdxKb
 SfIkgPGjCL6clEirwrg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150034

On AHB platforms such as IPQ5332, IRQ group 3 maps multiple hardware
rings to a single NAPI instance. Each ring is assigned its own IRQ
line, but all IRQs in the group share one napi struct and one poll
function.

When two IRQs from the same group fire simultaneously on different
CPUs, both handlers call ath12k_ahb_ext_grp_disable(), which invokes
disable_irq_nosync() for every IRQ in the group. This increments the
interrupt controller's disable reference count for each IRQ twice. The
single NAPI poll that runs calls ath12k_ahb_ext_grp_enable() once,
decrementing each count from 2 to 1. Because the count never reaches 0,
all IRQs in the group remain permanently masked by the interrupt
controller.

With no further interrupts, TX completions stop being reaped from the
WBM release ring. The pending TX descriptor count grows until the WBM
idle link descriptor pool is exhausted. Once full, TX ring allocation
fails and no new packets including management frames can be enqueued.
This causes stations to disassociate with reason 34 (DISASSOC_LOW_ACK)
and ath12k_mac_flush() to time out:
"failed to flush transmit queue, data pkts req N pending N"
where N equals ATH12K_NUM_POOL_TX_DESC(ab).

Fix this by using napi_schedule_prep() to atomically test-and-set
NAPI_STATE_SCHED before disabling IRQs. Only the first CPU to win the
atomic operation disables the group and calls __napi_schedule(). Any
concurrent handler that loses the race skips the disable entirely,
keeping the reference count balanced. Guard the enable_irq() call in
the poll routine with the return value of napi_complete_done() to
prevent an unbalanced enable if the NAPI instance was re-scheduled
before the poll completed.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.7-00587-QCAHKSWPL_SILICONZ-1

Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 2c55aae06dd0..e5bbfca2b2ac 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -602,8 +602,8 @@ static int ath12k_ahb_ext_grp_napi_poll(struct napi_struct *napi, int budget)
 
 	work_done = ath12k_dp_service_srng(dp, irq_grp, budget);
 	if (work_done < budget) {
-		napi_complete_done(napi, work_done);
-		ath12k_ahb_ext_grp_enable(irq_grp);
+		if (likely(napi_complete_done(napi, work_done)))
+			ath12k_ahb_ext_grp_enable(irq_grp);
 	}
 
 	if (work_done > budget)
@@ -619,9 +619,10 @@ static irqreturn_t ath12k_ahb_ext_interrupt_handler(int irq, void *arg)
 	/* last interrupt received for this group */
 	irq_grp->timestamp = jiffies;
 
-	ath12k_ahb_ext_grp_disable(irq_grp);
-
-	napi_schedule(&irq_grp->napi);
+	if (napi_schedule_prep(&irq_grp->napi)) {
+		ath12k_ahb_ext_grp_disable(irq_grp);
+		__napi_schedule(&irq_grp->napi);
+	}
 
 	return IRQ_HANDLED;
 }

base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
-- 
2.43.0

