Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772223803E1
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204907; cv=none; b=ltn8XPeKdnhmPmDsGx2MarBX0+PPL15PE8TFoPvDftgjSZTzdN2+BiP5vh6tlWWhEQZSZ5A8j5+UvEc5jbs5Zswnyck0KoqqyhbKxyaRH+WhJZb9wkRow1jx3gBIaHRr+u6VlojHtKinbTUaEX8UkyeOiQg5/ln6nPp8dwXuBRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204907; c=relaxed/simple;
	bh=ktwYKAaXrtvpPYfoh3Tz/NRqJXgsw44yavLcwPuQvvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DP6JRHWhIJkPGQB0a4L0WopAMzKMjBD5qh195qeukdO8gxBkBfus/R++mkCU+4jsPQsZqVRih/ftAMISR/RpDSaVnlHKow4B64bqmTotI/D+tsWyVqqyzKntozZ2v3AQNMweXQzEOh7rV0AT9ljGCcwbQGQxdFBRmv+zrZK6B1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FIoEGM77; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xgg9Py8g; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FIoEGM77";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xgg9Py8g"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JL7pRM1006385
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Bq7UXOZwZ1u
	Zy9x92HjJlrEnqrzL1xgS3ZN4+KV7xU4=; b=FIoEGM77baqq64KV4wLGiSTQPf0
	l92sIqXmB8FixzmW4jK8UOW/XTKItdWSc260+8BnOR0l8GJZOpbH+apABehZskcu
	vtTCsDXV+s/o0FEwXKEpA4FgpjksVHcvkUdR1utsQjC/B+/KYuSfZzpL1DDenp0h
	ot+D8L+wRE7JCwzBuAW36nDrQItx63e5GfFs2spxpM+n/HkKPqZ3lLcQRyv1a7Dv
	4MEYm55bmkICWpNq1xyS02Ep4ueNmnURrSUXETkXTr02t/MNnAX2ZXt01j1yNtcv
	QzBr1MvuF2SaFKqfxnXofk50e47ljzbgq8GdVSzkeRQjQTI3AdnwKOQicbg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5esc3ah8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:25 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so3019040a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204905; x=1787809705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bq7UXOZwZ1uZy9x92HjJlrEnqrzL1xgS3ZN4+KV7xU4=;
        b=Xgg9Py8gm+xeXp0s6md6SGW0VeIPq4/Jq+KYIcUa4Yz/okuX41zBl1bkJyfhkDycQ4
         CzAUb0X4jH8Q+mjMFhZCzZQLb6B4mBpuOxcoGzrs3TmpNKUm3IVrRaOwOaTnY2MOcy+6
         BzZEm+ceGfWgNrMoh8I07Y/6TGEhqwMyojTIvQcFeZ2EtQWiDm1+ad+sVHBQWhuZbT1H
         SZ4F2bfBarct8419q64CCMW174qlTyQ3FJ8LbaSIQ2y2CIjBGyL5VJ57DOtELVpGXnND
         arCI1CkmNzhHDzAhQpQV1NRpIW8Clv6o0UIQZJ0n+xKlIGssYMrqqQdMh2cNw9ig1pST
         mi0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204905; x=1787809705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bq7UXOZwZ1uZy9x92HjJlrEnqrzL1xgS3ZN4+KV7xU4=;
        b=TZvEIWltDZpifSH67pcDaPcn06ef/cSjpmNYWC78NrqAkp5Mfo91brQaRahyN9v3Aq
         nk4ErGva0+UevbGgV8WDCV/42Eyes1VrezADjmdPAHpBxIQb/ZwkdxYhvrpDtE+Qfkb2
         3EuAVmcqkmdn+OOLK5ZefmhfZ/ASyE32foYbVNhV1zxztNNZfDZ/NeWmw9DUHMqdhfY8
         db1wthP7Jeo6fcbQOnTwnqXrSJ4tn2O07Th2nASecnN4wRmucDuNTCdh9YukWfuDtcR0
         VoVgEfrHRq+Em2sEmXTVqt6F57AGULVtjZAznDVP3ZBQ5tlXMSC1cpwwfkaIDRYVRqo5
         o4fw==
X-Gm-Message-State: AFuF++naMLEPxjwVALKxmSWlVGS4GSX0tWU2LCET+U3cOuHaP5/aTSum
	J4N19CFHWu0hhwtsOZKyANLYz6R0+weLaxIi+IiEqoPp/kB26waamgef82en7kNwnJMp7FadnQJ
	gdxuUTkID/x5i7EuIYbbR0nFm+jpqPwy+eyYXqdtIcOGIgKUTah2sy6izgKuaj4HgImuXYw==
X-Gm-Gg: AR+sD13qOTG3E758oMdcZu5qJjlPb3cV8h5d/tLDIReM8r6FGbvids32xAuC+u8IWu/
	5TGtKhAraHUO7SxewWGVz86bo+ikLW+VHs/pUAYVwgPJQ5+VmWpC/WUAE7LshcjpGW3KmiuBpnK
	79IayWgVbQufUhD8dA9VpuFrHuUhnTMUvTQtTP1CH6Beffe1LWLgxN7HTbZtzqy1y0XNK/zIcD6
	viivht1h9HZF77ccV8NmiAdwfDn37vWjvWwP/+H9hwTXVPDMt6q5Lo4wIy8yM5vYsG4S+SuJt2q
	OPeGPh2pDhsiRfJVJSgWpo0ljURf5TjwXlEgNs7GuGBw+LJPXSdwOPu4zgDjfRfbLlh0zqvGHU5
	xqYtj4UXSA0t+16G97gBTfqw8O22vYHSHkens2MxsvlcSAgMUiESYfHV4w82kkxlWNvnC8Bd6Gi
	o40q0SOaVxjdrTUkMn4AJ2oak=
X-Received: by 2002:a17:90b:4a4b:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39580a4d03cmr18309272a91.2.1787204904694;
        Wed, 19 Aug 2026 22:48:24 -0700 (PDT)
X-Received: by 2002:a17:90b:4a4b:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39580a4d03cmr18309212a91.2.1787204904267;
        Wed, 19 Aug 2026 22:48:24 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:23 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 4/7] wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
Date: Thu, 20 Aug 2026 11:18:01 +0530
Message-Id: <20260820054804.3222296-5-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: yBw_Q1KpTL-oKpARVuDlRmN078Q0NPNX
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfXxAiCGgMopv/P
 b24JobQ+a6URN9niWDsS4GVDGgPdrJ5kx3P85sqiaDdifrhYh8LVpr4nrk21M3VOuEHJwbQbIXS
 o/zVtllvG5TgTBIpuTEVoyJQ75SK+mk=
X-Proofpoint-ORIG-GUID: yBw_Q1KpTL-oKpARVuDlRmN078Q0NPNX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX9mmF4gY5/i9j
 JLEdEbYH7ZV2PS/2GbBVrY8CzprnYn/fvnK9ykLBtWcP2X98nDJD7MJRfPoo3YtHvKHASmAFAQv
 N9AqG1j4+THbPHdYcPHMQWt+JqNJ0qM99bhy2+kdSbO/JLIs9IsypICf9jKTxa5bW68EZ27tDX5
 N90RFc1ufJkgfaB0sYgYBIoNockM77C+s3P9o/wCq4L4eMzST+0ebAphwItHQf0wR0oBMK4KvMP
 ge6HYETacqIVgRRKBoJvKO8DhrgrMZ6h1gVvnAOZNPVE4kRt3iV2KoS+WWn48ac5IvGe9ndbWOu
 GmAOvk3WYE47jBwBT7n+0W3J+F/6ARCEt9AWzSpvhvXIi6uqyyB58TAbhKEW3N6A6ob6rBNECE7
 Qmu+tzQAGDb26A9KjDtKYMebUx9alhUf1HaeWBrbIJtH2XTwKy58kKL6sWR0SJ45580crEcqE/g
 NcKxGEVae2AIjG0mXFg==
X-Authority-Analysis: v=2.4 cv=b6uCJNGx c=1 sm=1 tr=0 ts=6a869529 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=1JRayCiR9ps1Tcsuw3IA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608200040

Replace DP_RXDMA_MONITOR_DST_RING_SIZE macro with
ath12k_dp_rxdma_monitor_dst_ring_size() static inline helper.

Pass the DP profile parameters explicitly to improve type safety and
make the interface explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.h    | 8 ++++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c | 8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 9081655eae77..a7cd2535866b 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -216,8 +216,6 @@ struct ath12k_pdev_dp {
 #define DP_RXDMA_REFILL_RING_SIZE	2048
 #define DP_RXDMA_ERR_DST_RING_SIZE	1024
 #define DP_RXDMA_MON_STATUS_RING_SIZE	1024
-#define DP_RXDMA_MONITOR_DST_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.rxdma_monitor_dst_ring_size)
 #define DP_RXDMA_MONITOR_DESC_RING_SIZE	4096
 #define DP_TX_MONITOR_BUF_RING_SIZE	4096
 #define DP_TX_MONITOR_DEST_RING_SIZE	2048
@@ -696,6 +694,12 @@ ath12k_dp_rxdma_monitor_buf_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->rxdma_monitor_buf_ring_size;
 }
 
+static inline u32
+ath12k_dp_rxdma_monitor_dst_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rxdma_monitor_dst_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index efc419d41d21..31e7d47f7734 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -330,16 +330,20 @@ static int ath12k_dp_rx_pdev_srng_alloc(struct ath12k *ar)
 {
 	struct ath12k_pdev_dp *dp = &ar->dp;
 	struct ath12k_base *ab = ar->ab;
+	u32 monitor_dst_ring_size;
+	u32 mac_id = dp->mac_id;
 	int i;
 	int ret;
-	u32 mac_id = dp->mac_id;
+
+	monitor_dst_ring_size =
+		ath12k_dp_rxdma_monitor_dst_ring_size(&ab->profile_param->dp_params);
 
 	for (i = 0; i < ab->hw_params->num_rxdma_per_pdev; i++) {
 		ret = ath12k_dp_srng_setup(ar->ab,
 					   &dp->rxdma_mon_dst_ring[i],
 					   HAL_RXDMA_MONITOR_DST,
 					   0, mac_id + i,
-					   DP_RXDMA_MONITOR_DST_RING_SIZE(ab));
+					   monitor_dst_ring_size);
 		if (ret) {
 			ath12k_warn(ar->ab,
 				    "failed to setup HAL_RXDMA_MONITOR_DST\n");
-- 
2.34.1

