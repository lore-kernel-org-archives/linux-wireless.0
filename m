Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3DC3E51E8
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538661; cv=none; b=cisvQwA+uZ5LboIUDvOKWfJlhylLUkO5BurHNpCuXcYoalsl7baW2HwaE+SAfbkoU2rcB50iW/x9U2+4o6BTB46nUK3uIG5LUV6YlQdUrvNjX96L+S8wR/o1QhdqppoTWSdLGvhuIiLf383iwFW+QUWp9T/gX5yeBCqKsYN7HVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538661; c=relaxed/simple;
	bh=zICB9g0kdaRKUuHNaImq/lrfP+cWeocKx40Cl2AKjx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCvAQk/YjNEZweKstHWyhNhy6Eoya5ZPKPXkfeenpzl7/1f1qHtGIB0EAkkIvNA468+1zeYDihl3Sk/01pTpnQIm2Yf0ZXFEknw4EDwDU/OQq9bJNylLkXqcZbCwtTxJLM9uYsjvgQ157HVG+bkZCs7lLkYGej4QLNxNsCjovUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SfI99rfZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OTfxgE1e; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SfI99rfZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OTfxgE1e"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLYdFM1668137
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=4QyvUaaE8YM
	fvWBqrKhh9GFjtADA1d/bO5m6tOf1cEI=; b=SfI99rfZs96D1h4XSDvB2jSF09P
	vYILRCP/aVYjMZRRc1PhGSh9h1T+wIqRD+N+4FEsb/GDcWFT4wtOikOrCCQub1LA
	+6AFrncGA/8+jNq+nDz79EEJYcJiVWIRGG9Skp0Xz5xQ6E/aRxlCer/yLM9RnNQ7
	vKmYuyaOwsb+vSqNL0/BvLYlJ0J3ryX3QMWtz6E0ZO3zxVPKdX5i0qxJjEbvg/o+
	GdgCOAe4/Zu6fOnZa+MRSVgjG1SOXBBwqD7WKqgMLWv+HfajF8i6QPKJvPmXUFVU
	Egmd4uJb7/smrgAC43gAlhwwjkp4KZSKA+5lGUsIfnGVAzCR+RLv2+mPCuw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gq6kc47bq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:17 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so10381437a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789538657; x=1790143457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4QyvUaaE8YMfvWBqrKhh9GFjtADA1d/bO5m6tOf1cEI=;
        b=OTfxgE1e1gHE4Kq3BOfaQboyQN6WpvlpBCpuoyxreO7g1fkTMBaW2mr+0+rebohwJF
         +zxj4bHhCbTVXl4iItF7qr0zSPK81c6Rbp2mmA/Y4Uzsceoyp+OrkVUgWvHbFQhE2nh/
         cA/Lgza0XlCx3YlE02KslD/sEpOO+2OifXtMEQ3pQZHm4N963xBFtMSJfLTfU3WTLYF/
         6XTYmlAVjz72Gujm9VzU+UVqUoyrAiq4fHAX1YU5398MPWskezLtgZjAfjQ83uN+yTyv
         MKV8DOT1Ipqm/T3qQ49GW70nT3xjD7GXkJtcrrowM5yWEmO5jwliK7FBLoAyNnOFvZcT
         cylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789538657; x=1790143457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4QyvUaaE8YMfvWBqrKhh9GFjtADA1d/bO5m6tOf1cEI=;
        b=Zhfa48JTMfDSH2Ut4EpvO4BawFlU8LwDeMS7FjLOi7uM/RJIdgVM+kNju1elJNkiaF
         Cy3EjMhlvbL5Wot/m0/RwmKn6fLiF7GsIMW64rmtTcpbmCcVSlqzhg0rTKsC6GDQBAqF
         JeeJbotnylgho5jTTEx/b09WT8TuOUgGZOvWzJj3cAt0r3RshvrH4omcF5zdzr2AFRTW
         kUg7n5WUDFJhysRYEjQtAOuTJg50ID1Z9qLX9DTMqa/I4UhMlj7F55+RIc1YGC6Zvsfr
         VNp3h+ZUMT73zBxyuCDxQnboUdueoPLtp+o+r6KuPdKK/wx0Z5Vl1WYI1UIwokgekE4Y
         gthg==
X-Gm-Message-State: AFuF++l5kgfkfmPXEAx0UOpOekMKxV9bKh1sQKc+zOi3jOiKOwM4J6Rb
	pr4zsMa40BNOuK4OE/0hQYetCrspyQXgqac6zjVM3iIyYpPcpJEiyYkHQhqV1PrZ3aMjG0/Yjfs
	lxGnKpi+teVHymdKLH7/J5kMm4WUt0NISC83a4dt6miF9rgvN3VGQuc1oykY8N3qAQTISYw==
X-Gm-Gg: AYBFou3B4A1gfBpB+Awru8OR3Y/9SPH/rQj3CZWJfK9Z4PEF/XHnobinjE9v84TVkiO
	YsLGqDGXdLZ5QBhIIZ9lh1rhVx5FrzVgOPhyW1cbjN49FoRzIjRaOAgSAgN8X+ou4u/hNQ+cEut
	Za7MUr7rW3eS8tzenMxkFvafLB82YpaYErzjN8/wlD5/DUIarZeqqBx2ugSrcgAw4ybJq+GySxi
	HrIZ7L6DOEbiJtMyUc6oVdi5lvm7aOr7NPGZAsRNuJIMW26okyi7TwUkrAGbGlWxG/5+Jtoex9+
	LkpNOO4jr+r2hFguxc+y8sXfz39rlSVZSkrZByPW+yMDV5eZqvNBrrA0PJkr0waBTyyuk8DosKx
	DaF8KgRF8CPRBLHSGvK/JPQwpLHbW54RCKVdFm0kksWxIg1zRakBfzqfLajJyX0pzx3IZ9VjGRJ
	vGLDEZhbtXB4RR0A==
X-Received: by 2002:a17:90b:380f:b0:395:7fff:a08f with SMTP id 98e67ed59e1d1-39e1df8d6b4mr3376446a91.0.1789538657059;
        Tue, 15 Sep 2026 23:04:17 -0700 (PDT)
X-Received: by 2002:a17:90b:380f:b0:395:7fff:a08f with SMTP id 98e67ed59e1d1-39e1df8d6b4mr3376388a91.0.1789538656621;
        Tue, 15 Sep 2026 23:04:16 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7a7a1csm2661491a91.15.2026.09.15.23.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:04:16 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next 4/6] wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
Date: Wed, 16 Sep 2026 14:03:23 +0800
Message-ID: <20260916060325.854-5-kang.yang@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfXw59nRxtxPN4S
 dy+4srN/OkyeYV03OfyDDbMRDz0fc70MB4q4geASHJtNros6e4OLRegNMw5GnXTzYKn3/jyNwZ9
 7weaOTGMw1HnQDq2IVf7qMxhZUx2/b8=
X-Proofpoint-GUID: SRJqr74cgXRxqC_rb_perbK_BnD5FROx
X-Authority-Analysis: v=2.4 cv=ZINCCn7b c=1 sm=1 tr=0 ts=6aaa3161 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=kt1foGEeEJUqbVQOj6kA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: SRJqr74cgXRxqC_rb_perbK_BnD5FROx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX/HwFzK7YSP/l
 1QUOmi/0OhM7BLLgubulL0YBrMwiJSy13PD1w3obBJ/8GFLulVnJtSQXWVqpTmmldvKTkHHTu9u
 aZVbnon+Yx0MrY5VJ72D4fixeCEe648LTRnRvofeW3bwROgAdseXZ2+HrlzxuRXfmrTQv3gIXJJ
 tSwqmSXlqbCKndTdOMOubCtg2VhlCmlxf9maGapf8VaYhsCbI91woG7KjUZ0nBckJoXSQt4At5o
 +BJc4EUen4k3PGWmLYCxebpFObI+sSiRPDT2O58DdU0sSlmPA1FNCHC/oKoryLgkM3Qem9krKwa
 PnxsLPUqGtczMVTJ7AEUMwV6XO4sbqVb7iDrZUbYVBrDP3tgsI0POkOANZaAJ3Q3ibI7MpmyZ7z
 0hgjXCaV7rXN8mIDPX8fWLqdueEUN/IiSPpKTGPPrrKmchBi92Vxfp2DdGp+xv4hodj+u6lw6Te
 vklXxoymwiPDWw0lkig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160076

ath12k_wifi7_dp_rx_mon_dest_process() allocates a dp_mon_mpdu with
kzalloc(GFP_ATOMIC) for each delivered MPDU. On allocation failure
it breaks out of the reap loop without calling
ath12k_hal_srng_dst_get_next_entry(), leaving the destination ring
tail pointer parked on the current entry -- the same entry will
be peek()ed on every subsequent NAPI schedule, stalling monitor
RX until the mon_dest_ring_stuck_cnt recovery path resyncs the
PPDU ID. The head_msdu chain accumulated for this iteration is
also orphaned since the break bypasses both the delivery and
the cleanup paths.

kmemleak reports these skbs in field testing:
  kmemleak_alloc()
  __netdev_alloc_skb()
  ath12k_dp_rx_bufs_replenish()
  ath12k_wifi7_dp_rx_mon_dest_process()

dp_mon_mpdu is used only within a single reap loop iteration and
is passed synchronously to ath12k_wifi7_dp_mon_rx_deliver(); the
callee does not retain the pointer. Place it on the stack instead
of using kzalloc(GFP_ATOMIC). This eliminates the allocation
failure path (and the ring stall it caused) and saves a
kzalloc/kfree pair per delivered MPDU.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 8fca777041d1..1e29c13ad66d 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2827,7 +2827,6 @@ ath12k_wifi7_dp_rx_mon_dest_process(struct ath12k *ar, int mac_id,
 	struct ath12k_base *ab = ar->ab;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	void *ring_entry, *mon_dst_srng;
-	struct dp_mon_mpdu *tmp_mpdu;
 	LIST_HEAD(rx_desc_used_list);
 	struct hal_srng *srng;
 
@@ -2893,18 +2892,16 @@ ath12k_wifi7_dp_rx_mon_dest_process(struct ath12k *ar, int mac_id,
 		}
 
 		if (head_msdu && tail_msdu) {
-			tmp_mpdu = kzalloc_obj(*tmp_mpdu, GFP_ATOMIC);
-			if (!tmp_mpdu)
-				break;
-
-			tmp_mpdu->head = head_msdu;
-			tmp_mpdu->tail = tail_msdu;
-			tmp_mpdu->err_bitmap = pmon->err_bitmap;
-			tmp_mpdu->decap_format = pmon->decap_format;
-			ath12k_wifi7_dp_mon_rx_deliver(&ar->dp, tmp_mpdu,
+			struct dp_mon_mpdu tmp_mpdu = {
+				.head = head_msdu,
+				.tail = tail_msdu,
+				.err_bitmap = pmon->err_bitmap,
+				.decap_format = pmon->decap_format,
+			};
+
+			ath12k_wifi7_dp_mon_rx_deliver(&ar->dp, &tmp_mpdu,
 						       &pmon->mon_ppdu_info, napi);
 			rx_mon_stats->dest_mpdu_done++;
-			kfree(tmp_mpdu);
 		}
 
 		ring_entry = ath12k_hal_srng_dst_get_next_entry(ar->ab,
-- 
2.34.1

