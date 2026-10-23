Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774167;
	b=B52tjn3hKNXINh1cHpE+n8cwNBqp/JYKFtFI7FEga1CIkjKDA3YpyNm6Z1uyMwKmE1J/
	 DYDF/42FEbz1eITgGeHTk3aGzCMoLzj2/T6PSgh3tr6mmlyOwQeZN/VvXxqguyz1b+yrQ
	 7wGhNnNvPdba+4jkEWaRs9NWlv1W208ksqpIQPQZWypjC2K1gs6Gmvu7hjf69mNeTmsgD
	 izGnpTGoMcjI9ly9tdDSArdhDVDWFh1tnvvxfyaKcOryh7HCecmWygv3c1Fwd6VKFmVy+
	 26Z3bdYAJ4IgIAiTyqVkRL5UdTfQKZRIUZRjOpbDbdM1H7ZuCG0Qf7xRylGTiUMClEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774167;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9RCF1m9NWSgNdQs3SwsoxzUh3oApzG/UltaIaeVEyg0=;
	b=LWwPTWz6suIpChfM28+6ZdEiTR8ZT0WVwqTFf7hBPh0VIwZ4A8Gw+g4wHiYE8BXfroHj
	 Yx+UrXQDnDUBNNBnuk5oY2FiGQVvHL4OKEQySyHdstQ/9kA9NQTy4Fycwhbl0Xt6Q0gU9
	 u42vmHA5FfIQj1SRw7mWRAhes+mrf+nGZQGxLlChujLd0q++4BeCKbhbyMh15UfzwtgTc
	 jFTphOTDX4depRbb/bBPfwg7BbhUhpmZAfH31t4L3ySrHVLFprzuInEhGtz2SZ7cBGd3w
	 JviQky/dw9w2qgUcSap9h/rNLt1Q/aFvJfCpZt1mIW/nf0nmHRDO/LLGny/0jgUABQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pL2mg5k8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HR5MTvVl;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C699A606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 16:49:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C699A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pL2mg5k8;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HR5MTvVl
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NG41nW3812454
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 16:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=9RCF1m9NWSgNdQs3Swsoxz
	Uh3oApzG/UltaIaeVEyg0=; b=pL2mg5k81Sg3W12zu5X8a3wC5KrbeJbWXTHzIG
	UK82GdkPLJAcC1cRTj6SLsCeALzJb9waQGxSRUDQT2IcSqle3U6wiFikLb/sGnOu
	ryMrbsi3dfaX7gDfnGGWEx93HXQ0rucVsksEq0EOCcmuwJ8AB0DRZyFITZ+L/HNz
	GZ56RoYlAiM7F60kImVuXrjOqFMS7raMsSQpVwx8UPRNerC5R8CdBzBNcouf11/x
	7nwOD5chnSdGU9sdLsWS7NknCwJN2eEtihS/axPPE3FFN8SquyfPMxZxJ49nri8s
	U8GeFqhCL2ZL9/D3TRwxiBvYuH+CGxC1uvo1GA6xwLZ5u7mA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgas885k7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 16:49:25 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f37c94ceeso433034085a.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 09:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792774165; x=1793378965; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9RCF1m9NWSgNdQs3SwsoxzUh3oApzG/UltaIaeVEyg0=;
        b=HR5MTvVl+MfwEjVAI296HuNbTmiuYYAT3t5irb2tLxBDmrrX4mDLQiv1MI+2pUnnC5
         URumfOetndmel+d/O2GACRpaG2o9028+VXOnepJozaefiXOS5D5jbr74L+KEjyFCKDPv
         icDazobweUd2KN1SRu3gnisHx4NN+zj1JynW5PlAsUOlta30qilH177ydqd+9NBevrpd
         DAu0Ux5n6Z2bR0zEwKdgzxXJbqspKw8ESc5zCAcBpC21oK+LeND3IG49FpCePtvNPCqL
         UkpHU2gpumA/REeX5zJA8NgFTIiuqP2cSJhjgaszObffOozgU9O1+rwHfyBks12taAfC
         C4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792774165; x=1793378965;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9RCF1m9NWSgNdQs3SwsoxzUh3oApzG/UltaIaeVEyg0=;
        b=c9kFkIA7+6JF1IYFGPhp9rUlwgEfmE6laeHQibDsr/fm1arTTQqtfp3SYz1LuNjsV5
         rfVap+jOH5OtAryRqrl0FQwxK2BS5u7tMX+kiq5JxWyWk01rzDZRrIAkTLzTzWzH3qSn
         L++FakAWngrVLdp6ZQNUHM7fpvDQEi5RI4FL+iuOOvx814khBTC6Zn7owHRiPG5caOSm
         mQQ1FmHbvxFaO3Rh+lSnpF+uEGeDSQOnKdGD3qH+Q3QvtiQWdRkcOGLWiF1Hm1IyBzRb
         ko5WDyc8L5nuESNJ/c6PkuQ5c/AOevAK5TnbqHH1GnqNLMiws1gje1eZGQn4jwdqO1xK
         yP6A==
X-Forwarded-Encrypted: i=1; AKwUvBzwn9xhZ2dqplhmdw1P74p2RofcRXTm0wTCOZvxzx1ypsDLs3IUQ5XO+8Vix+OwirTeGvZDXa8ayAobd08L8A==@vger.kernel.org
X-Gm-Message-State: AFq9FYK0Un6aGOLnZr/UDXVeSpNa0zpHcfunEyo6KIwkESsktSPmX7po
	0kS2fy7cpGiOPEzoMUTJq650thY/Vjn1a3Y19ZYPwPYKAmQD3f9Mwt8eV/bDo114vh/2pnlMsRS
	mUnEfoEE+LG75Wo3Wh5OE83laGGViWwVZ+tYa7aXvji2idJ8Da5+fTL8+DPCwAn62W7Ajgg==
X-Gm-Gg: AYBFou35vxNlaoeHeco/wccYDOiCHK44tT0icrTq6NDh+bUnBYbAUKapRnOjGSgshwu
	hZouMIWvJfOxEXuHm3ZFfAHaLJSbcQN55w6Yp/Ld6DN4c0OKOu4Fg8te2OK+bZLnI9I0IPTJaEc
	A6HWpoxc3XTT5nBEjj0YCJ4ytVHIiDqd5J3Ynjq1NfwbXCHAv6kakxvKsTmLqukKgqtStEw+Md1
	qMJPYsTRHbFh3eG+9fUziUWVG7HTDSEEz/q3ZkcVMlUQy4C0irGMhTN0O2GJOB089s5R8JogFl6
	jwz5h9qrs/UXs9NQb3YZippkyUOr3pSn6rNRWzXj6Dw2MZJOsMTeRmqXq7LPvJcamf8TWHzMCH6
	wXgs86qg6WmI=
X-Received: by 2002:a05:620a:2622:b0:93e:fcac:a91f with SMTP id af79cd13be357-93f627aff9bmr947188685a.37.1792774164522;
        Fri, 23 Oct 2026 09:49:24 -0700 (PDT)
X-Received: by 2002:a05:620a:2622:b0:93e:fcac:a91f with SMTP id af79cd13be357-93f627aff9bmr947183785a.37.1792774163802;
        Fri, 23 Oct 2026 09:49:23 -0700 (PDT)
Received: from localhost ([93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3d416241sm888602f8f.43.2026.10.23.09.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 09:49:22 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 18:49:10 +0200
Subject: [PATCH ath-current v3] wifi: ath12k: fix DMA direction for
 re-injected Rx buffers
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
Message-Id: <20261023-ath12k-fix-dma-mapping-for-reinject-packets-v3-1-443f9e13bbc9@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5XOvQ6CMBAH8FcxnT1Djwrq5HsYh6McUJUW20I0h
 ne3IQ4OLi6X/HMfv3uJwN5wEIfVS3ieTDDOppCvV0J3ZFsGU6csMMNCZlIBxU7iFRrzgLon6Gk
 YjG2hcR48G3thHWEgfeUYAJmqXGnaktYiXRw8p71FO4l0CPToPdsozqnZmRCdfy6fTHIZ+aDlX
 +gkQUK1V7siY7mrSB1dCJv7SDft+n6TysJN+EVg/h+Bidg3Ki8Ii7ou8Qcxz/MbU30lP10BAAA
 =
X-Change-ID: 20261014-ath12k-fix-dma-mapping-for-reinject-packets-2eab34ca5acc
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA2NSBTYWx0ZWRfX1Qej548Vp+ju
 ZDtsRZFJ0DowpRR3PachA2/8fJBW9pabPW/v2oPhDDIrAOOxZy6NBC1PCPl1q/4CJc8iV6Qfb54
 QHnvpWa6tOkflywBf5071s36VqMVKvc=
X-Authority-Analysis: v=2.4 cv=OPqyTiaB c=1 sm=1 tr=0 ts=6adb9015 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=YorqWVoUjBA4MCaIIpoA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA2NSBTYWx0ZWRfXzOWRDcQBe6FQ
 b9b+rxuKH9Ev4HC1BiOse213LOQoIaGbLE/1VrLovo1Gm8Vkb2L9IAsafw08YbhA90iqKxxz/3H
 1JIxVYaUa/BiYfyxCC34B9DGm1Me+wVZGPZ3fDGSfCb+AZeqtv1RzZuWV/0T9Hl8tlNuPlwjkSV
 ++MQgFI5M7XNqCI2uk858V9SIYqqFkYvpq4f2qO0bM3tTtuIt44QamI6rgyG3OnWLnsR3USYxTc
 /PJEVSEJatgDtVJOfXF1g7nBjSSQvlp0PgYMzV69DSsQS+7a0GDZ7xVSkQ8OsVs9e8odWfyGlBQ
 eT6FYoTKwlV7UCXfpwL6wbjHQnMQ/s8nB5OTQI5ut9ak3BRjLyrjcyrGHtTwMufk+meTMde72fL
 nHkcCJofuOTTW9JGGwgYZma3ZvH9R/18TYQBzJZ5+GqvZg6roqKo1g8DtZ1ZZ8KWO2uULyAb5aT
 gy1KrIatS4vv6CxvmGA==
X-Proofpoint-GUID: Pch-UV8RbzDfRxYQW5_uNa0mihm5WWYq
X-Proofpoint-ORIG-GUID: Pch-UV8RbzDfRxYQW5_uNa0mihm5WWYq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 impostorscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230065

Defragmented MPDUs that are re-injected into the REO are mapped with
DMA_TO_DEVICE, but all the Rx reap and teardown paths unmap them with
DMA_FROM_DEVICE. The DMA API requires the unmap direction to match the
map direction, so this violates the contract.

The mapping actually spans both directions, since the host has written
the buffer before the REO reads it and the buffer is read back by the
host afterwards, so DMA_BIDIRECTIONAL is the correct choice.

Add a common ath12k_dp_unmap_rx_buf() helper that selects
DMA_BIDIRECTIONAL for re-injected buffers, identified by the existing
ath12k_skb_rxcb::is_frag flag, and DMA_FROM_DEVICE otherwise, then use it
in all the Rx reap and cleanup paths. Map and unmap the re-injected buffer
with DMA_BIDIRECTIONAL consistently.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 33322e3ef074 ("wifi: ath12k: change DMA direction while mapping reinjected packets")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
Changes in v3:
- Set ATH12K_SKB_RXCB()->paddr before err_unmap_dma condition in
  ath12k_wifi7_dp_rx_h_defrag_reo_reinject().
- Link to v2: https://lore.kernel.org/r/20261023-ath12k-fix-dma-mapping-for-reinject-packets-v2-1-9f436a26dd72@oss.qualcomm.com

Changes in v2:
- Rely on ath12k_skb_rxcb is_frag field and drop reinjected one.
- Link to v1: https://lore.kernel.org/r/20261017-ath12k-fix-dma-mapping-for-reinject-packets-v1-1-b94860e18ba4@oss.qualcomm.com
---
 drivers/net/wireless/ath/ath12k/dp.c           |  6 ++---
 drivers/net/wireless/ath/ath12k/dp_mon.c       |  5 ++--
 drivers/net/wireless/ath/ath12k/dp_rx.c        |  3 +--
 drivers/net/wireless/ath/ath12k/dp_rx.h        | 11 ++++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 17 +++---------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c  | 37 ++++++++------------------
 6 files changed, 31 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index f9b37d75956d..bca719b30281 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -5,6 +5,7 @@
  */
 
 #include "core.h"
+#include "dp_rx.h"
 #include "dp_tx.h"
 #include "hif.h"
 #include "hal.h"
@@ -998,10 +999,7 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 				if (!skb)
 					continue;
 
-				dma_unmap_single(ab->dev,
-						 ATH12K_SKB_RXCB(skb)->paddr,
-						 skb->len + skb_tailroom(skb),
-						 DMA_FROM_DEVICE);
+				ath12k_dp_unmap_rx_buf(dp, skb);
 				dev_kfree_skb_any(skb);
 			}
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 7d5be77b081f..8fca50b0f236 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -5,6 +5,7 @@
  */
 
 #include "dp_mon.h"
+#include "dp_rx.h"
 #include "debug.h"
 #include "dp_tx.h"
 #include "peer.h"
@@ -561,9 +562,7 @@ ath12k_dp_mon_parse_status_buf(struct ath12k_pdev_dp *dp_pdev,
 		return 0;
 	}
 
-	dma_unmap_single(ab->dev, ATH12K_SKB_RXCB(msdu)->paddr,
-			 msdu->len + skb_tailroom(msdu),
-			 DMA_FROM_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, msdu);
 
 	offset = packet_info->dma_length + ATH12K_MON_RX_DOT11_OFFSET;
 	if (ath12k_dp_pkt_set_pktlen(msdu, offset)) {
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..ac489d9bfb55 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -185,8 +185,7 @@ static int ath12k_dp_rxdma_mon_buf_ring_free(struct ath12k_base *ab,
 		/* TODO: Understand where internal driver does this dma_unmap
 		 * of rxdma_buffer.
 		 */
-		dma_unmap_single(ab->dev, ATH12K_SKB_RXCB(skb)->paddr,
-				 skb->len + skb_tailroom(skb), DMA_FROM_DEVICE);
+		ath12k_dp_unmap_rx_buf(ath12k_ab_to_dp(ab), skb);
 		dev_kfree_skb_any(skb);
 	}
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 0660db070e92..f6eda3a0f45b 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -187,6 +187,17 @@ void ath12k_dp_extract_rx_desc_data(struct ath12k_hal *hal,
 	hal->ops->extract_rx_desc_data(rx_info, rx_desc, ldesc);
 }
 
+static inline void ath12k_dp_unmap_rx_buf(struct ath12k_dp *dp,
+					  struct sk_buff *skb)
+{
+	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(skb);
+	enum dma_data_direction dir;
+
+	dir = rxcb->is_frag ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+	dma_unmap_single(dp->dev, rxcb->paddr, skb->len + skb_tailroom(skb),
+			 dir);
+}
+
 void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
 			    enum hal_encrypt_type enctype,
 			    bool decrypted,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 016b0c38e51e..1e0e089bc1b4 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2721,10 +2721,7 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 				continue;
 			}
 			if (!rxcb->unmapped) {
-				dma_unmap_single(ar->ab->dev, rxcb->paddr,
-						 msdu->len +
-						 skb_tailroom(msdu),
-						 DMA_FROM_DEVICE);
+				ath12k_dp_unmap_rx_buf(dp, msdu);
 				rxcb->unmapped = 1;
 			}
 			if (drop_mpdu) {
@@ -3137,9 +3134,7 @@ ath12k_wifi7_dp_rx_reap_mon_status_ring(struct ath12k_base *ab, int mac_id,
 				idr_remove(&rx_ring->bufs_idr, buf_id);
 				spin_unlock_bh(&rx_ring->idr_lock);
 
-				dma_unmap_single(ab->dev, rxcb->paddr,
-						 skb->len + skb_tailroom(skb),
-						 DMA_FROM_DEVICE);
+				ath12k_dp_unmap_rx_buf(dp, skb);
 
 				dev_kfree_skb_any(skb);
 				pmon->buf_state = DP_MON_STATUS_REPLINISH;
@@ -3150,9 +3145,7 @@ ath12k_wifi7_dp_rx_reap_mon_status_ring(struct ath12k_base *ab, int mac_id,
 			idr_remove(&rx_ring->bufs_idr, buf_id);
 			spin_unlock_bh(&rx_ring->idr_lock);
 
-			dma_unmap_single(ab->dev, rxcb->paddr,
-					 skb->len + skb_tailroom(skb),
-					 DMA_FROM_DEVICE);
+			ath12k_dp_unmap_rx_buf(dp, skb);
 
 			if (ath12k_dp_pkt_set_pktlen(skb, RX_MON_STATUS_BUF_SIZE)) {
 				dev_kfree_skb_any(skb);
@@ -3289,9 +3282,7 @@ ath12k_wifi7_dp_mon_srng_process(struct ath12k_pdev_dp *pdev_dp, int *budget,
 		}
 
 		rxcb = ATH12K_SKB_RXCB(skb);
-		dma_unmap_single(ab->dev, rxcb->paddr,
-				 skb->len + skb_tailroom(skb),
-				 DMA_FROM_DEVICE);
+		ath12k_dp_unmap_rx_buf(dp, skb);
 
 		end_reason = u32_get_bits(info0, HAL_MON_DEST_INFO0_END_REASON);
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 95d87dd67872..42ceb2c4c2e3 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -729,11 +729,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 
 		list_add_tail(&desc_info->list, &rx_desc_used_list[device_id]);
 
-		rxcb = ATH12K_SKB_RXCB(msdu);
-		dma_unmap_single(partner_dp->dev, rxcb->paddr,
-				 msdu->len + skb_tailroom(msdu),
-				 DMA_FROM_DEVICE);
-
+		ath12k_dp_unmap_rx_buf(partner_dp, msdu);
 		num_buffs_reaped[device_id]++;
 		dp->device_stats.reo_rx[ring_id][dp->device_id]++;
 
@@ -749,6 +745,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 		msdu_info = &desc->rx_msdu_info;
 		mpdu_info = &desc->rx_mpdu_info;
 
+		rxcb = ATH12K_SKB_RXCB(msdu);
 		rxcb->is_first_msdu = !!(le32_to_cpu(msdu_info->info0) &
 					 RX_MSDU_DESC_INFO0_FIRST_MSDU_IN_MPDU);
 		rxcb->is_last_msdu = !!(le32_to_cpu(msdu_info->info0) &
@@ -894,10 +891,12 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 
 	buf_paddr = dma_map_single(dp->dev, defrag_skb->data,
 				   defrag_skb->len + skb_tailroom(defrag_skb),
-				   DMA_TO_DEVICE);
+				   DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dp->dev, buf_paddr))
 		return -ENOMEM;
 
+	ATH12K_SKB_RXCB(defrag_skb)->paddr = buf_paddr;
+
 	spin_lock_bh(&dp->rx_desc_lock);
 	desc_info = list_first_entry_or_null(&dp->rx_desc_free_list,
 					     struct ath12k_rx_desc_info,
@@ -915,8 +914,6 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	list_del(&desc_info->list);
 	spin_unlock_bh(&dp->rx_desc_lock);
 
-	ATH12K_SKB_RXCB(defrag_skb)->paddr = buf_paddr;
-
 	ath12k_wifi7_hal_rx_buf_addr_info_set(&msdu0->buf_addr_info, buf_paddr,
 					      desc_info->cookie,
 					      HAL_RX_BUF_RBM_SW3_BM);
@@ -983,8 +980,8 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	list_add_tail(&desc_info->list, &dp->rx_desc_free_list);
 	spin_unlock_bh(&dp->rx_desc_lock);
 err_unmap_dma:
-	dma_unmap_single(dp->dev, buf_paddr, defrag_skb->len + skb_tailroom(defrag_skb),
-			 DMA_TO_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, defrag_skb);
+
 	return ret;
 }
 
@@ -1286,7 +1283,6 @@ ath12k_wifi7_dp_process_rx_err_buf(struct ath12k_pdev_dp *dp_pdev,
 	struct ath12k_dp *dp = dp_pdev->dp;
 	struct ath12k_hal *hal = dp->hal;
 	struct sk_buff *msdu;
-	struct ath12k_skb_rxcb *rxcb;
 	struct hal_rx_desc_data rx_info;
 	struct hal_rx_desc *rx_desc;
 	u16 msdu_len;
@@ -1316,11 +1312,7 @@ ath12k_wifi7_dp_process_rx_err_buf(struct ath12k_pdev_dp *dp_pdev,
 	desc_info->skb = NULL;
 
 	list_add_tail(&desc_info->list, used_list);
-
-	rxcb = ATH12K_SKB_RXCB(msdu);
-	dma_unmap_single(dp->dev, rxcb->paddr,
-			 msdu->len + skb_tailroom(msdu),
-			 DMA_FROM_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, msdu);
 
 	if (drop) {
 		dev_kfree_skb_any(msdu);
@@ -1367,7 +1359,6 @@ static int ath12k_dp_h_msdu_buffer_type(struct ath12k_dp *dp,
 					struct hal_reo_dest_ring *desc)
 {
 	struct ath12k_rx_desc_info *desc_info;
-	struct ath12k_skb_rxcb *rxcb;
 	struct sk_buff *msdu;
 	u64 desc_va;
 
@@ -1398,9 +1389,7 @@ static int ath12k_dp_h_msdu_buffer_type(struct ath12k_dp *dp,
 	msdu = desc_info->skb;
 	desc_info->skb = NULL;
 	list_add_tail(&desc_info->list, list);
-	rxcb = ATH12K_SKB_RXCB(msdu);
-	dma_unmap_single(dp->dev, rxcb->paddr, msdu->len + skb_tailroom(msdu),
-			 DMA_FROM_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, msdu);
 	dev_kfree_skb_any(msdu);
 
 	return 0;
@@ -1971,12 +1960,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		}
 
 		list_add_tail(&desc_info->list, &rx_desc_used_list[device_id]);
-
-		rxcb = ATH12K_SKB_RXCB(msdu);
-		dma_unmap_single(partner_dp->dev, rxcb->paddr,
-				 msdu->len + skb_tailroom(msdu),
-				 DMA_FROM_DEVICE);
-
+		ath12k_dp_unmap_rx_buf(partner_dp, msdu);
 		num_buffs_reaped[device_id]++;
 		total_num_buffs_reaped++;
 
@@ -1990,6 +1974,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		}
 
 		msdu_data = (struct hal_rx_desc *)msdu->data;
+		rxcb = ATH12K_SKB_RXCB(msdu);
 		rxcb->err_rel_src = err_info.err_rel_src;
 		rxcb->err_code = err_info.err_code;
 		rxcb->is_first_msdu = err_info.first_msdu;

---
base-commit: 045958acaa75205b31578cb22c4345e28dd2e4bf
change-id: 20261014-ath12k-fix-dma-mapping-for-reinject-packets-2eab34ca5acc

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

