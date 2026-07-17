Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E851ABED9
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784252591; cv=none; b=boOgJHoABifBx8bQgUnoEhYepCSlN+QphB/VN04NNkwC7N5PZNZfa/PLm4IngEj6saqtgeZzhKiIQygAVhIMBfC4V0Ky+Rc14I2SE+TZCK3OQj6CBcTXuPF7sjGj3VsyIYD9jepouT69s2OsfnDt6BYU2MTUGgflLd9rkFWl4h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784252591; c=relaxed/simple;
	bh=Xdh4HC0w1virvnvUP2J/JqG/iwNNhMzb/vtgJvs+dVg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nVTeCWFsm7HSif9byNS17JiqDF5FtTsSDb507rMA10xbEx9zQ6qi+8Y36kO5UIgIhxoSquq3Kq+EjtPheHcvO3r2F2HnFSZid6Z+40oAye/FfZb3p8wbdJ3On3or+q237VnEjMX1yEwNg4b3uxXPaaXpGN1CGH9DzsHv6pTuDxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jlh4gPsr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GmgGHpRh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jlh4gPsr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GmgGHpRh"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GNIhnP4050315
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=lgYtWm8u7UuQscHOeb+mbfETys0daizIPaf
	nM922E4M=; b=jlh4gPsrLWIhH0ukZ6RWhPa5x0Qu3EZeqSTMRLTf7bJlxkdhE8O
	RplMDymr+kECc27DwCL5AzcjxjrilfOXo5D0JeXWYeKegca+ogaKDZEKOTnDSdIl
	MjCkqIh1DEbQaANScv+KBg9qqkxY9Pc/pqGKwSDJzUA5V4C88JCot+2bTFVxPD1j
	oW0Owm3SisZPsTnDnnyd8ixlsosGqgBtwuYqjRmumDQFxRDNAjH34aMzCiHsPxET
	CppzoSIfx+wUTPtfF7/LT2IBBcn1DZU8zNCbqU9CDVuLqmyJ9B5mymgntBfC2XwB
	kVnpHTKuDHxu2hk5JnshYJbPDPl93dfTqJQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff1wea33g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:43:08 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb48f41343aso495513a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 18:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784252588; x=1784857388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lgYtWm8u7UuQscHOeb+mbfETys0daizIPafnM922E4M=;
        b=GmgGHpRhvSlfJxEK2npFwEItvA9A8IzLrr8QyCocZeglzKrJCIEVAC0kZoGQgFmViz
         cGnlRlbmqnaZ6noDBIlXnYj8KeTXn4ESPsh+/K6mpQCv/LfXTCeC4QzRXdltC7QRQOsa
         EsH8JTZ/dIn3TZSz5+8StkSjIhJBvUXRXkkuxG7dChbEqa25nf86oDGamgGHX5PHCPab
         zghU/8Qn/9clc7uMcL/Izf8a7biseHjGPrthXXg3GGM3A+02l8PILybDzlrBFA3ibQ9k
         sfSmVnE0e4vjsq/+Kyre8DAkAMFHvPucLHgvmiwU+j1dveogtJMyaE8cpkbseGewM+hU
         25Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784252588; x=1784857388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lgYtWm8u7UuQscHOeb+mbfETys0daizIPafnM922E4M=;
        b=IId0BNv/hwO0ywv04aQzaeZhiT7D80NRN+rWGkNSqck0tz6oLrDDP0FjTiU54oSoxr
         I9nzwAja9eAy3r2bp/dFkLKksC8Upk9VM5rsNEp/TTn/roNNRhLS951RUkoBXNN3vT1m
         q1yMUG8rJ4bO6eaTxkRJWXw75UszXyJR34gB3t/KdmY3IqHkM/vHypvflp1DKWXAjClW
         rbiG/V/fKA0PecyQ4Ake/NFuRhu1shZZhp2X7lBFgWTZ4loj+aOZAS3G80bGqmp0GA8I
         aHEpVi/BI0DoiR8LcTAmEW9VzjvomI4m1VWDs7nBDB+mEADdGVhI0tE+NiBxW1IQ6gL+
         uymw==
X-Forwarded-Encrypted: i=1; AHgh+RpBAPP/Uu0hpUHVqVaQ6g7XmM+ywU3KFP+HpW66K0g/lwtXJhJ2XSsBgWtmnxMrSyuxF8Of6jydABdsSdIV0g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcXx2t4ycPrN+NXRqBsU/Z3B0G07DZLIlYlbM4P6lXp1NSuULH
	4uW017jBjlm5LB6IUhcmgEVeypKiZrZIc+NQL/555hK+MNtxYfXR7C4L62Tx9z//Ibw/aAORJe7
	U0Bx+/ed492qHeaU3NPJWrBYhgnutfFRnHxAHgA8PrpckfZ3jaOEv5adruP1VFqOYikkA6g==
X-Gm-Gg: AfdE7cnNPl4zkDsjxCfNwawYHsVMBC2OWZrwj2bXHGjxCCOeKNUHm7tegiF9fgrj1Hh
	nQEKG3Zp19levpp2jxhua18jj61UIlO9NGo3gjUi22gEzXE9qB6nT14JN6xb8BqEXr3eZrmV948
	RWMCSx5An5wbW82pOmHsHqOwJ1AV1knhJdMNWCnobSDkqU40/h25sD5P4AP1YATzmKzNwYlYtpl
	N2RqrrPDZPbDFpD92973La88m79PZWmo0/Y0qdTfEUJCgYGIH5VcKvOKM+9J4M0YKnMAsFmu4Mf
	vZ40GgYAqSXZuDxKwFxPHz6GjdAZgv0Oz7l32BymjEjw1P7cRulcq9c00u4X+Rt/aJmt3ic4Ncg
	ummDWnF4HrGKM3esTkmFwDRcksDY5GdOR
X-Received: by 2002:a05:6a20:729f:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3c38d8cffa8mr6107708637.5.1784252588125;
        Thu, 16 Jul 2026 18:43:08 -0700 (PDT)
X-Received: by 2002:a05:6a20:729f:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3c38d8cffa8mr6107686637.5.1784252587696;
        Thu, 16 Jul 2026 18:43:07 -0700 (PDT)
Received: from hu-daizhuan-sha.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429ff04absm898423eec.8.2026.07.16.18.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 18:43:06 -0700 (PDT)
From: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, daizhuang.bai@oss.qualcomm.com
Subject: [PATCH ath-next] wifi: ath12k: Set DTIM policy to stick mode for station interface
Date: Fri, 17 Jul 2026 07:13:02 +0530
Message-ID: <20260717014302.284034-1-daizhuang.bai@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAxNCBTYWx0ZWRfXzkeD7Rh/wjfw
 XvtaINtFF5BaxC9pKDT7hw9I/enVaGkXSZ8QmnMwfileDAgT9eSFwctb6dxZXgWmGJUdnGBVkVu
 jU6t8ZxIlf8+IJplyEge1D+qNA+Oe/gWn9UC1Oupb4a1SgZ07vj4wEGZ+WQ9WfNBHrs8iULpuS8
 SogS1TYv/D1C8J09HNHz3Zc7y5cZZGiJxXZTrXfyTudGgnUmu5Eo91EE9hIQKj0460KNnim/7PH
 rwNF+Z4K9i3/i7hFgPNZZhrfbzDYBTVuRntH35vmJjf10SVIKmu+QKGdcLiKqGpaG6Y7OXUxmO4
 +wyCWKkbYJcb9cyRvzboQT6vCjDiR/O7AJ2w8ORfE5VOsfWlWPDfquAclGH//7O43j6BAJ/Zjyl
 yBJjTBgiceYQHtKKE1Ig5hJW8NskKE9pXgp2kzUDDc4N7X5mPZIK/64nl4Q40CRInGwMQTiqK2I
 Y2dUhJgvQ2AY1L+b6Cg==
X-Authority-Analysis: v=2.4 cv=JJ8LdcKb c=1 sm=1 tr=0 ts=6a5988ac cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=ApbYuknxaN76yxS-R38A:9 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAxNCBTYWx0ZWRfX1M0icPhcXJBt
 aJ92Hx9TAT0bO+HMTjYF8J/QxaXghw5aHYHF6TQHD4+OhvFms0KbAJw067++o/WhToajSWdi1Rq
 Fzy+jAamPDT9AQuX6XTK554bd1j5rRI=
X-Proofpoint-ORIG-GUID: -fwVyEVw9P5-aAmVkzvnFkoklWZk3Df0
X-Proofpoint-GUID: -fwVyEVw9P5-aAmVkzvnFkoklWZk3Df0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_08,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170014

Currently, the station always follows the listen interval regardless of
the DTIM value. The DTIM function does not work as expected. The default
value of the listen interval is 5 so that the STA wakes up every 500ms
when power save is on. This can cause a data transmission delay.

Set the DTIM policy to DTIM stick mode so that the station follows the AP
DTIM interval rather than the listen interval, which is set in the peer
assoc command. DTIM stick mode is preferable per the firmware team's request.

Apply this only for STA vdevs and only when STA power save is supported, to
avoid affecting unsupported targets and P2P client vdevs.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 11 +++++++++++
 drivers/net/wireless/ath/ath12k/wmi.h |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 16339469c24c..706104168650 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3985,6 +3985,17 @@ static void ath12k_bss_assoc(struct ath12k *ar,
 		ath12k_warn(ar->ab, "failed to set vdev %i OBSS PD parameters: %d\n",
 			    arvif->vdev_id, ret);
 
+	if (ar->ab->hw_params->supports_sta_ps &&
+	    ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
+	    ahvif->vdev_subtype == WMI_VDEV_SUBTYPE_NONE) {
+		ret = ath12k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
+						    WMI_VDEV_PARAM_DTIM_POLICY,
+						    WMI_DTIM_POLICY_STICK);
+		if (ret)
+			ath12k_warn(ar->ab, "failed to set vdev %d stick DTIM policy: %d\n",
+				    arvif->vdev_id, ret);
+	}
+
 	if (test_bit(WMI_TLV_SERVICE_11D_OFFLOAD, ar->ab->wmi_ab.svc_map) &&
 	    ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
 	    ahvif->vdev_subtype == WMI_VDEV_SUBTYPE_NONE)
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 51f3426e1fcd..0145cc477944 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -2330,6 +2330,13 @@ enum wmi_slot_time {
 	WMI_VDEV_SLOT_TIME_SHORT = 2,
 };
 
+enum wmi_dtim_policy {
+	WMI_DTIM_POLICY_IGNORE = 1,
+	WMI_DTIM_POLICY_NORMAL = 2,
+	WMI_DTIM_POLICY_STICK  = 3,
+	WMI_DTIM_POLICY_AUTO   = 4,
+};
+
 enum wmi_preamble {
 	WMI_VDEV_PREAMBLE_LONG = 1,
 	WMI_VDEV_PREAMBLE_SHORT = 2,

base-commit: 913998f903fb1432c0046c33003db38a9e8bedb1
-- 
2.43.0

