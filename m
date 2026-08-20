Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9053AAF55
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204917; cv=none; b=DQttBlqA9swiDy1JDeq6kXuoE5vdrJSbi0YGAenAEgzqOsKYx2QIOPLTkV4bm41ieIWUqFWWwb6XGf8juqHFML6SIgSHgwvA/Ok4wYvEVeyvT8FoGlA6LMzWOcKm3c7ZpfXmP42WW4Uk7+CwZk7ow3EqZGTIRuhqnKBOP3EPpfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204917; c=relaxed/simple;
	bh=bgz3YMFJCNC2hGam2bWyj174a0Fv/oHSvxyWy19t8hI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m5LjuXQ0bTYYVyxO8RxpWLpjHSoN7SzXCOEnENIkgcnUGtLpsEmC+vq9iGoA499XKBy4XmAAnTRH6gS4m3icXHmqMzTx5Rhf0dieMmX5TxDtd2xfpULye62j+CyrpdKf7CmePbIRGok8xc4nuEooRtCODuD2lU0f7TM1vE/pTwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KIN0yVX1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Tjq52Vby; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KIN0yVX1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Tjq52Vby"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K5gRoI1438609
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=fLcz+D0Oh2G
	4V1hvVXrVJp0frMjSMXjzDS9NCvnUauo=; b=KIN0yVX1cHQuhTedcQy8DDM0/pr
	Y8DK+44y7s1Ig8voflMLMMNoqzT9YyEuAmswoaDmzbQh4xBmegp+hMZV8ymjS/rN
	BIDD1gs2MQ7l73+7LewGNHhYrI1A3ZBILG4jpHmuxiz31iUOmLMPxIIJDQA++HfM
	qt4IGT1IivUguJTIV/E2qSfoOb/8G4udouuD4DszT4tB4ShFpYjHEKdoLHwJYTdC
	wEDDuQcmtwjJN+H4lsAa6nN+rriabOi3ftyCZMYlP+IxXlZI2ZvS25LhTsjCQpL3
	bUn+GklU6P+mziu6TbsRrwWjuqICqcKO1DbH/kBYLRzQjB4ltZvsWW7jXAA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5daa3tss-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:35 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso1848356a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204915; x=1787809715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fLcz+D0Oh2G4V1hvVXrVJp0frMjSMXjzDS9NCvnUauo=;
        b=Tjq52VbyzRUtJiDaUI+wsxnb6cdE5Ip5HcnmCaQdpHWasspJRPQRhr0VUNLR9as5wt
         BMB65htGUtMz8+3Lh4si6CbHiO75P8JyoHgTkvGeL8N8tEoWIBOxhpi9Y+B6+34WShgE
         JTC7wDuHERQvJLScI8YkbJMU440eJGvJSJX98RDw0//0eT/8W6HO9Bbsh/a09blpWjTi
         zfEEZXDSNI0VYxvfGN0znbGw0xHXomzj3ujEZz7FN2MZDdRyFR+XBN7+IyZERwwSEhjy
         qJtgupDpir0E/rYV9lpq8esb2591uzSs5tozx0bFUucOiaj7shg2nU6T9ZDTTZKNOVnB
         MzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204915; x=1787809715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fLcz+D0Oh2G4V1hvVXrVJp0frMjSMXjzDS9NCvnUauo=;
        b=XDg1/nyFZP2AN01nSNInOB0wGcCDh8bX+sRLUraSbtpqi6zjBEKbS6vV2Gv6FjmqM2
         6RFtqy8TZk+PCtMFJITRT4BS8+lx6zwFoiTUl/A8ABzr5LG1nJI8L3ZJJr14938VBsx8
         ++0AsUSCRqg17eJrUI1eD6KXtW3+3zeo/J3vjbyp+PE9VOttrv+I0RiT4aXVU3odPcGJ
         WZIpXN5+AFmIoJK0bmbZKYHOwWSSuJ2VsfPDqp5I0rfA5ASR5ChFmMLIdTEi0Fhc2AuM
         3msAcuxSrajWH1aW1K2qtR9SlUxj9UtxpwcwGDcfb0G5/dZt4/A7sMEGd8OP8sagwWqY
         /heg==
X-Gm-Message-State: AFuF++mYYRbvbr3BNoXtwM1xSITXFS6n7Fg8SAGaG16OKZjrByDGuOnt
	4veKA86y35UM69jVVmc9rkuLCPdTojESQSMjV7KXlNXmX6P3z2zOcodnFHaot30JTxErM1QTn7o
	d+U5/tTFRPMIpTaKWgbJ3a91QYlXybGHdE+LXLlUekSWjyl7TZmWGhVjplkQZB2OYnn1fzg==
X-Gm-Gg: AR+sD11L9kF+I8F7HEp91ZYQvOH/thqlOF9gY+N+Xwm/UCGemCm2fB/ohvddGUAjhDX
	422H7e0BPQY/oeKWMkxV5wvr799XojWXmf6WeQrLVHpCYJhAhxng6UFWQ0L8FJyFNj5isx5LYyK
	TEMl/RWSsVgqm2nrwJxnOuWURMwXFdwF3QVvgy9h3CQbTEi2AaARemte6uLb1byfYD472h2h4BS
	AuNzHGeDVxusgN24CkJ3X7PeN07I7Z6hiXTUhDPWQpvAytz5gxbnn6cPIZqk4/DcvMv8m0RJ6MS
	AgpVeroUKE3nBnlYfvWhCMe0kU+eAmSziS0Ux3mgjXM6YjucGHn86rSHk1zSn+cElH4/xobep9K
	kuBnJasOiSB08VtM+8QUgrZ/rWzofXyN+rRqb0c51dhX7rOg/J9TsLxXFypsqlrcdYJq22KrYse
	ZRtqSTyomp04EnURCsX7WAyeo=
X-Received: by 2002:a17:90b:3cc5:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-39580f3bcdemr19869636a91.10.1787204914742;
        Wed, 19 Aug 2026 22:48:34 -0700 (PDT)
X-Received: by 2002:a17:90b:3cc5:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-39580f3bcdemr19869545a91.10.1787204914342;
        Wed, 19 Aug 2026 22:48:34 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:33 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 7/7] wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper
Date: Thu, 20 Aug 2026 11:18:04 +0530
Message-Id: <20260820054804.3222296-8-aaradhana.sahu@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=fv3sol4f c=1 sm=1 tr=0 ts=6a869533 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=Xy6-sK4-8b3VWbcdOpsA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: 2lXlZe4cOZMs6PxmpSH5LOGPiWoAm-Km
X-Proofpoint-ORIG-GUID: 2lXlZe4cOZMs6PxmpSH5LOGPiWoAm-Km
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX/Npwgt0M5lm3
 1s8ZnksEbpI4XyQxphqgSumXH7wvWNwijHAImXtyh3gQNch3HkOMKHgRJKPrO/XILeEnygww5J2
 xyn8v4+Y4dZs4OqrT8lz3HpBytTOJhs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX/CE0EzU3bFpH
 sT92xTgW0elQBiP5RLyk/KzaJmu3Ki4p31cLd+xZmRbr2RBOIjv72oHzVARsRLdgF+QwAm/48xf
 tVfNF1czstLo3O9N9FLc+7sXU4rWlN/Qc7YPcbIwgay1/hTHM4RVZfi0t+tyQkghrW9yoBLbvJQ
 rxVVPBDwpXiSA6vcMRWugCxzRUQQBEzCJPlJVY2UYaxIhkCTYja6Mre+hMssbE/Pki1Pqwyiir/
 Fktg+mJYc5TiAZfXQPup4AGav1e07FnbHtD7TwsfmT+AwhSSa/B/5yq92ImsN83MFKdrRZq0Frw
 UFSA3ORriYFbUNb4vjlwGPw3EUUpgQtnCUgRN6cP/pFCBdg+hszD+5XfHNnckjkXn3mXMtGlcHC
 j+gj3p6Ypvi0xknV9zyzrdpoeHsqXLZguQXshJtu8SBAHPa9ujbRql68/203nQ81AkY4Uur4Syb
 NjphOVUxQb+5nrqf0cw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608200040

Replace DP_RX_RELEASE_RING_SIZE macro with ath12k_dp_rx_release_ring_size()
static inline helper. Pass the DP profile parameters explicitly to
improve type safety and make the interface explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.c | 2 +-
 drivers/net/wireless/ath/ath12k/dp.h | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 417d960bbd07..779529d189f8 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -488,7 +488,7 @@ static int ath12k_dp_srng_common_setup(struct ath12k_base *ab)
 
 	ret = ath12k_dp_srng_setup(ab, &dp->rx_rel_ring, HAL_WBM2SW_RELEASE,
 				   HAL_WBM2SW_REL_ERR_RING_NUM, 0,
-				   DP_RX_RELEASE_RING_SIZE(ab));
+				   ath12k_dp_rx_release_ring_size(dp_params));
 	if (ret) {
 		ath12k_warn(ab, "failed to set up rx_rel ring :%d\n", ret);
 		goto err;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index c8ca3ab4d5e1..ff62773cfa9a 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -206,8 +206,6 @@ struct ath12k_pdev_dp {
 #define DP_REO_DST_RING_MAX		8
 #define DP_REO_DST_RING_SIZE		2048
 #define DP_REO_REINJECT_RING_SIZE	32
-#define DP_RX_RELEASE_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.rx_release_ring_size)
 #define DP_REO_EXCEPTION_RING_SIZE	128
 #define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048
@@ -716,6 +714,12 @@ ath12k_dp_num_rx_spt_pages(const struct ath12k_dp_profile_params *p)
 	return ath12k_dp_rx_desc_count(p) / ATH12K_MAX_SPT_ENTRIES;
 }
 
+static inline u32
+ath12k_dp_rx_release_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rx_release_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
-- 
2.34.1

