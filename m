Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747524;
	b=eA+A3+kzbvhasa2gt8yus8jcUeMtSjM/xKmbofzGTmyTksdQEHijZXgWa6Krx9okslpQ
	 fgpDohQU80Bk0wQ6NrsiEYWeu1LmZIJMQz49QQlRxZj916JG0D+gZp+EyQOYz/MLn3IVP
	 m7jJ6L1W43sGqtO/14d77pIPpbDVKNz6PaT0FeRiKeoNlxY+a/kvVaLkDzAQZoieue4oT
	 X7Witax/fP/iwp8PpaSD+k/cgM83o8I0WuLVfrSS0whrrJHLBaGc1mIuECQoc4EdpmCoA
	 XrA+cXO0bSFgIKaKQnhtTJtLT+kZxZSfwj6OpgAbqdCkMzCphAl5D560Ppx8hxXEZcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747524;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VoFMso2yvUX5PaRdAsKXUVu2bU4ltHM3lwiHv04CD+E=;
	b=zgKVnRRR+jZkr9lf/RQMqPX1TuFDSMZ1ATJTEgQIZkskpfF5ShL5d6aIJRVQ36nZFAJH
	 q241pBSWBLuV+Nn/D+deagr5QiLXYS0KTURwxyLutXB5vaWvmPAh5UX/npd6UpEoOtnI5
	 KHbqXpGAiKM7xSdLIYPPhZYzfUpW19fkpxrlbz60hEx4t0z0sO2MYI6q4p8a3KepeN77F
	 BnJS0wavxAF1V1qy27JBqkylPVGUFF3OZTzO3qyYG18L8XpYnpj0HBpQf+OtlaQEPRIwF
	 1xOGG5gPAdn3o/2t/OidHZOASkq2mzmIRlGxGCi+pimfkhEQt7R8/kNH4lmwr+AsoDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gFVdDrnu;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kNJ0MVld;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A76606A320
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 09:25:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40A76606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gFVdDrnu;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kNJ0MVld
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7FNYE3168100
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 09:25:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=VoFMso2yvUX5PaRdAsKXUV
	u2bU4ltHM3lwiHv04CD+E=; b=gFVdDrnu8Thwnn0N4hUnn7QKeH/FmjyN3OHRPc
	zDuUe2+NtGfy5a9125M9MqAhcxA42OpWwrLMVNDhgv8AhFOmWQS01WUIe2N4pf4c
	+WnRlb/r+TYBTSpWiCHpm7NMA3tZ32YJ3VlgECoSjBBAsWvE5xirDMpm252PYx07
	MyhPk2+9IjO6KW79SkoGp9OikIktHw/qsMeUxed+0fzQZOO36W0hODb8hM9AjNAf
	aX1wea6mpxBPVxMaIp0St5qKjeIYzTybrz5EgTBCfHRAEwKcYo/cFEsHRZoW3Pj7
	Y31ZNFiXFjxadZuMWeVNw9MxJDTwjoMDnsJqWZFWrnzCAGNA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmpax3n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 09:25:23 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cb71b1443so142754385a.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792747522; x=1793352322; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VoFMso2yvUX5PaRdAsKXUVu2bU4ltHM3lwiHv04CD+E=;
        b=kNJ0MVldnk3zBcpIXqwy2eXfSDxpg+5/hTQOCLByvJXXMDtzvIXBNKZAcusIEiMoyl
         j3KgFn2fCO8d7lJVXw6ElY2yq/bkv2s4RR3vKai93I3W1PLhhp4TN8RRvu2mTHDwrCnz
         WTl2lVxDRRkUVP1TNvvlbujggxhmS9FWCIyfLEOQdEW38R+C2pgCjwHrRaUjq/Qju9I3
         wDURhUqXanqyfEgJuzIrZICvv66rP8zKb2o4zuZ0HphmtgohplTSp78okjbnAfZSoSsw
         tbwT1vp9wZAL/g8FapuoscjnH5J7T2lHftO1yM25ZLKixCEDglrLog20onNPXqheiCeX
         BOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792747522; x=1793352322;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VoFMso2yvUX5PaRdAsKXUVu2bU4ltHM3lwiHv04CD+E=;
        b=clMH4p+V/9f32HnnijOIb4CSLMg87EBux25oI7ZVaBg8jyTmvOYsT7JAM/vCCxnb3a
         722ljqRJjs/5MS83upRlUxaoyZq83XX46neqST6Pyjio5oLT9kDIV5ewIT9Cgg/64GKE
         m9kxWDTQIbo2E1lXNtDPffqkzHR3k0UFhh2ZWZwjsU/vxiFGQjCZBuvn9UBRrt46bHON
         Y3ux2Up8YRhY4cnlcBDxo9Bkc36NIdHVeDf0Zci6Q62X4nsxktWoBHhbNCtqK5yp4Tbm
         Oxk+A3HWqrdHnsoUQfuicZMGg/C0xMqnF0x0EMOfhNd9LjsS79nzHI3XEDhMrEvejFbV
         yrtg==
X-Forwarded-Encrypted: i=1; AKwUvBwHdXpO0Hf5XcBPu486YD/mZK6yqrD3m/a59Bc/gS3HKun7f5qaEknF5e3SC0JYk1qKH9w8dEG6GtGWjGROVQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKzD1m4Vd5tX3IVZjl23fScJmn5BMIvLUA/jqoYTBf0dap2ili8
	qYyRYMf8jfQonKFdgkgalv40PZV0PYaGgHbJ7FyI9tGw+t4PHYECbuq6KCWPsRdRt1RJvP1o5Ag
	869owAAQsFidLJ45b49yh4uW7iSe6R/OlHvGgeilGgQCoVGxrmQ9lJgW4mvjv1+ifQfMx9N1Skv
	rNzQ==
X-Gm-Gg: AYBFou2rBiGumLQSSLUbbnZCxr51aPX28WK3CcuplZejnkfnSz/yTxBjwg0Rsvp6vuC
	VtUSc3PZa1dgN8KKixJThEihjTCPte5He1kydAcmRPn3P8UFZ6kpCWg5tovqMokPIQaYbvDvJwC
	8CCveyv+zO+vwHDjx/crfLy8vZKPDUQcCuJrDjpl/lOBB5yy4i2TLZVPQNXg4SlVw29W34CgqfA
	5+fF9PcK34C7shqtJ1X+GPsZmRNmvI7xP1n6ZGL7PjA6QxRDKAbh6MaJYqPzHhFfsij9OuSdwNY
	EywOL8Zw/FosAvmN0s0rLL8l2ecZx2L7pAniIoKkKzhu7xsRRtZt74EAu0QFqrnHsqzES7Av4zm
	JkPmki/QDeGA=
X-Received: by 2002:a05:620a:17ac:b0:93e:f9ba:690e with SMTP id af79cd13be357-93f6f571723mr306867885a.3.1792747522093;
        Fri, 23 Oct 2026 02:25:22 -0700 (PDT)
X-Received: by 2002:a05:620a:17ac:b0:93e:f9ba:690e with SMTP id af79cd13be357-93f6f571723mr306864685a.3.1792747521525;
        Fri, 23 Oct 2026 02:25:21 -0700 (PDT)
Received: from localhost ([93.144.6.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a211b89beasm54538205e9.5.2026.10.23.02.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 02:25:20 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 11:25:11 +0200
Subject: [PATCH ath-current v2] wifi: ath12k: fix DMA direction for
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
Message-Id: <20261023-ath12k-fix-dma-mapping-for-reinject-packets-v2-1-9f436a26dd72@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WOTQ6CMBCFr0Jm7RBaEdGV9zAshjJARVpsC9EQ7
 m5DvICbSV7ezzcreHaaPVyTFRwv2mtropCHBFRPpmPUTdQgM1mITORIoRdywFa/sRkJR5ombTp
 srUPH2jxYBZxIDRw8Sqb6mCs6kVIQFyfHsbfT7hCHUM3OsQlQRbPXPlj32T9ZxB75Qc9/QReBA
 utLXhYZi7Km/Ga9T18zPZUdxzQeqLZt+wKNwCOk+gAAAA==
X-Change-ID: 20261014-ath12k-fix-dma-mapping-for-reinject-packets-2eab34ca5acc
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzNyBTYWx0ZWRfXz6C4rzlP49Db
 ofJeSUdA24F2YK/4Ahkb+8mAKDfLMhD8jY2ON3eAkJvzX+PNcdOVkmKiOz9Vl/D14U1HdYRgmHd
 DhoA66Xi0Fpm7UVz6wYnKkI7xwjb5Lk=
X-Proofpoint-GUID: n3NjC_-_kaQ52QMfnlLNf4iuvu-OlkvX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzNyBTYWx0ZWRfX2WAjrTHCZjSJ
 SKcyMNgGSuTGCIXNxGx7lfnO5wUuus0GSjHgMr3lnJRraJ6bHEG+AWBjOSBcThI9qJLpz0/LMqc
 B3aG9wvoheaoLprVlH376LvhqOP59wB+7BjpclCmRsBN+atnXNCQxeprljYsxYlVseLedYQnZTH
 vuhMuc546FXUA+DispldxyY4db7Dh8J/8wfk2l2WDF769U2Y7qDnTVPtq2pOkocpZg2z4xPvhJ9
 hDRHSBiinBGlS/scAuKxQrl6BLqAxv0J1lej2bG7GwLVnGewMUJhWQc0Sgez4bUlWVmD6AifzDv
 f5tVrlPgfQqMFvBkz68WNWo3H4sYTXQG83BtpOA1722j2Sv7622DHGNWSm6ivGNLd0u3Xt+d795
 6ythnwMmw3aUjoDpDxA9xYbyNr8gWAgGI5Kk2xs/FkJh5VVMQHoHDR94S3vquclIvcMzUubrebr
 8Oydch+ui4pP1yyQOMg==
X-Proofpoint-ORIG-GUID: n3NjC_-_kaQ52QMfnlLNf4iuvu-OlkvX
X-Authority-Analysis: v=2.4 cv=BdBNQbt2 c=1 sm=1 tr=0 ts=6adb2803 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=05IDL4l0V0PuMRtRylAA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230037

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
Changes in v2:
- Rely on ath12k_skb_rxcb is_frag field and drop reinjected one.
- Link to v1: https://lore.kernel.org/r/20261017-ath12k-fix-dma-mapping-for-reinject-packets-v1-1-b94860e18ba4@oss.qualcomm.com
---
 drivers/net/wireless/ath/ath12k/dp.c           |  6 ++---
 drivers/net/wireless/ath/ath12k/dp_mon.c       |  5 ++--
 drivers/net/wireless/ath/ath12k/dp_rx.c        |  3 +--
 drivers/net/wireless/ath/ath12k/dp_rx.h        | 11 +++++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 17 ++++---------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c  | 33 +++++++-------------------
 6 files changed, 29 insertions(+), 46 deletions(-)

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
index 95d87dd67872..7fcf31aadf49 100644
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
@@ -894,7 +891,7 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 
 	buf_paddr = dma_map_single(dp->dev, defrag_skb->data,
 				   defrag_skb->len + skb_tailroom(defrag_skb),
-				   DMA_TO_DEVICE);
+				   DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dp->dev, buf_paddr))
 		return -ENOMEM;
 
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
base-commit: dc6e3cef4322996e131c618295be2b3c2fc5cd1f
change-id: 20261014-ath12k-fix-dma-mapping-for-reinject-packets-2eab34ca5acc

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

