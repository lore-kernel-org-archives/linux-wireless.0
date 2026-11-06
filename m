Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793941109;
	b=SjQMcu8jiGIya807/+f+VEfiAyBo98Ab+kBiFS0ip48W6Dc+5S2GDqez5/dX5mxp3lip
	 uMhNrhkUqlQUVFgvfJHNYxaYwRojlo3q7QtOsxPdokJ6imy+C1RGXLrW5ggkehcewVhqO
	 LKCQLjuAnBHtt82HH0WNCX2FiyzWoacFllFdWTR8jb0rtnmRu98MaFOiWt4W25kIBCsqz
	 LGOB1euq9AbvKFs9OLohhQlbthTXS08kgxa1k46F6UF+rmxjLKmvuZv8TS3hda6NlyAot
	 GuFagSTRlni4++nW5PSL9LDTbuDNp8JiAvfcsiL5uTVo8yP1s7P0RL64cbqgmIgizIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793941109;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=PwuKHcELMyLPFxVIV5lVQjxMlleCNVcLIZcMUwaPOrQ=;
	b=P3xp1TIBpe4WaHGanezZtxd60WKfLWsBx+y0ZLvjOEPZiHt7STvfrC7+WhgUGqbUeQzd
	 EtSTsfqnZBQIV4CmYeGHtsj9/E8ec75RqOkeC4Q5LKA/FBZU8iw0FrN2pbusVbPSVjlDo
	 ycCda0iwojRNGajZGc9eV2wOhzfNG2v7uYJCyjNDuQWFj7kxybYuyPL0lfYTyj2FbHlOa
	 5eLOwn0VYXpgPcQKgFio4Ulm0RWsVSuoapSkKN/a4BtHYujSxSWaoZDcMxej+/VoThufn
	 4B51XFSFEUrTE3fRzdqGcksD0BTxkY/XbBwOqGMyMhujI5wGfqwH6YInE4hOoHgNduw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MIALHroj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=isiNyX9R;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AA3606A32F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 04:58:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92AA3606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MIALHroj;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=isiNyX9R
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A64006v2264895
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 04:58:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PwuKHcELMyLPFxVIV5lVQjxMlleCNVcLIZcMUwaPOrQ=; b=MIALHroj1yfpVm2p
	HLE4hw9VpKzgRzXleimNdjgiWSV+JAVH0WZQhO6DfLn/z275/dvHZ+v8/SlQ70kG
	H81uTJnb00sYF2jMPd4UIYY0duBH5McYvoARzJZPczVKsqnQw1PH2Ke9OQDjuQrx
	Hn1SczV2hboQLnB9bk3qbALsb4CtDEFMg0DUT40vqFaVejCvE8Tz8/Mr++19/7zB
	/X9S2omUaitRcWgW96Ecf/WNKfTKBV1Nr5kUR4bCAu7wS8alEpOrffrXrNL/0ToQ
	gRnDP+Supuk1KJ4m9taSTUB+hteFXvYtmi6dbKeEOC6dCTpDA50CW4AqnOLsj+Jn
	heMqlA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9gxce-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 04:58:27 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3700be873ebso11832eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 20:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793941107; x=1794545907; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PwuKHcELMyLPFxVIV5lVQjxMlleCNVcLIZcMUwaPOrQ=;
        b=isiNyX9ReUOr4l/AD4C5hT/Q0q/Y1FkLjcTDGrGRqufVp4yAeIHkvGomobko8cjo01
         2SGNE4Wrld+JwKSq6wOXAGAZbANcVOMPs4X3pMimODzqzGsScIWnatCxjfOJOKO/w95o
         ZaWqRtPB0QFU94q6ygLbfxpLnPiER0n6nyG2dQI1R56KlywddVsjz21vbt0k1/xCLmti
         1uiCOH7VOyjtYJYgi2/TrQT8aUx3e1B1v6PSMzEcOVOgQZOeIEYpRfKnfrVOeuPqSLrG
         Q60tbPw4EOqY40f8xGIx4L3MsLVyADNtogn5Qo7C7UZctk3uAy8Z5j0HGUInnD84yQil
         vwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793941107; x=1794545907;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PwuKHcELMyLPFxVIV5lVQjxMlleCNVcLIZcMUwaPOrQ=;
        b=dUClTUhmqJNw/FI1v9hYZrRu6JSiACgK2K7Z2HsVGjGqzD+yDFJaPCOIzDxbWTyo2r
         W332qmg8d7aZZWAWUjhy/3TOmP9AQfKn1hpBIwo1AE1NX64f5Mt72X4coQjTwdKMSxDS
         Mk1r0yf20xoo7GVJzsSO0WM/fu+TuOPC4FTqkMomkfx4fJSp1LhIb7Pg+Pq1fAJtVEUg
         tbSZJ7k49I726E47SCEueugab3xYPJLGC9T8s/BnvbQzyB51FtYN0XeaVyAdUbWyB0d+
         4kdesh3nCFig3k3m3Il8VP7D9cQ2TZYyWTvs35WuldidgQfEqHctBVTYtzpvY5wLlqgE
         Z+jQ==
X-Gm-Message-State: APuU4Z+9OPByxkXL3trLBzG88AwULNlI3HAXQZVZGd+oFxpxfCDzsvCc
	tcId7haZ+Q1QJuGKLqMknEyT/njr8YaYaapp3Td71yqCMJ/rRSmkLeogvEaaqre6AdWQJcwngL/
	2Yoob6BpVUyh6uwl4mQeS+DI10akXf81jPFHf8amsQMvOmttAwOZF3OhGnCjV/IDullQ2/w==
X-Gm-Gg: AYBFou1b2hKU1FeBYByat78PSrCzPNnGPjAP/ycGC9yBdbg6TpGi32H/y3i2NF0e+0O
	N6VmLHk0fiYzfcCWd8lKqhKDdPPl+ReUMcETBJeCTe3QDQK/pzqOwgyCDpTCoRlospEgBcWeFn/
	krghiD/STCoBigIH+GxEquZRro0WwfXvIWo6+I+Txzf3TL+hob/XxH9CnkD/gEJMRkR3FGKYZAM
	p2HPZbXAbJKCkVb5D+UwfTN295NJcuHf1mRmzn0O3TPHoutE6bxNnMcAdQj3P4/flDoHFLbaVW2
	uLD+nhwxOCdpJIns1YKTORGAODK49MI+mi0DCl/0BD3KIp7AL5rZDOCF6jxRVC4n5QwVMP1e+kQ
	A3F1tgVg+ja2BEP2OikLyTdjG/21S5KxvLmLg8RbgPtxFnjIxH5T3m9v/ov1qR4OCoEH/qLd2o+
	ehEp3alYKdlUoDsLX+/fdwnO8ePX8DG7k670vyhGD2svVcs2FLc5dhqKxqBUjEPeEeqGqP5LGyg
	LJ6
X-Received: by 2002:a05:7300:b08a:b0:361:2a55:b94e with SMTP id 5a478bee46e88-36de695a231mr6085932eec.15.1793941106968;
        Thu, 05 Nov 2026 20:58:26 -0800 (PST)
X-Received: by 2002:a05:7300:b08a:b0:361:2a55:b94e with SMTP id 5a478bee46e88-36de695a231mr6085899eec.15.1793941106330;
        Thu, 05 Nov 2026 20:58:26 -0800 (PST)
Received: from hu-ramess-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8e3a47esm3021327eec.6.2026.11.05.20.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:58:26 -0800 (PST)
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 10:27:42 +0530
Subject: [PATCH ath-next 1/2] wifi: ath12k: Fix HE BA mode configuration
 for AP mode
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
Message-Id: <20261106-eht-ba-window-v1-1-622f2272e582@oss.qualcomm.com>
References: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
In-Reply-To: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793941100; l=2602;
 i=rameshkumar.sundaram@oss.qualcomm.com; s=20250120;
 h=from:subject:message-id; bh=mzoN3FdmoGcO25gjrPXpkBIbUBZJgWlfeD0OPgwSV6E=;
 b=B0OhH5oOIE9//pxYTDq/iUODgDS/RgAERSa4Lx8c9ck6ET9j+co5xKI2HqlsgbqhXvE4T3gdC
 qxcuzozRKVnCb3UuzV4ZrDeXC2LAvDznU6MImrNyVFGVnCY3cWYlGOR
X-Developer-Key: i=rameshkumar.sundaram@oss.qualcomm.com; a=ed25519;
 pk=CbWiiM4JikGBEWI7HtrEEE/Hwkk7TTcob0SwaFdAwKo=
X-Proofpoint-ORIG-GUID: k9DeDcUq9iWdc58gFPkDsIFUXFOfKHhG
X-Proofpoint-GUID: k9DeDcUq9iWdc58gFPkDsIFUXFOfKHhG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAxOSBTYWx0ZWRfX/NhfHJ/xAkMG
 UtIzlBylGij65+M7AeD5UOt2ELxXOX+yoSkXjoTIJKe/dcBF2wVbfuwb9uQyOkLcXiUsv9Mi7Fg
 SUPya8bw4jPmSYkQSnoy+urgAm28RSs=
X-Authority-Analysis: v=2.4 cv=XvNvqlF9 c=1 sm=1 tr=0 ts=6aed5e73 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=Egx7SfdSpjdNf9FE4GoA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAxOSBTYWx0ZWRfXxQfq3SfF6sDA
 7FnjkorqwIFPN0J1lPRWMFosgwxV/dwCTAFj61g79CrpDWWRAwOYHDU6ClUgMNiGLCFeBz3bF96
 lCp1dsCdQS3xUN96+srDIIeCnjVuUER6yVFNeOuIG6Mm5mW+nHhTevFF5HwRv7wTDBfpzuj3s53
 jlHzxrwhO1RHTxGdUyq1w1Hc2U5GVW1QtQoNwo2wB5a+K/qE7wNQN9Oj4ZiV5k674MeXTi9oVvu
 P1k6SiLdjZ2YZAIzRnXcPmRh7PLmkEmOw8yAfKia1nf4ht/MH2L2AOgeYcM1js2EnxkonDFtSm7
 biTNNZrYZBXWx3OjiHiXHYdngzdZww94p3LDSemFr04Hb3GOI0XJtrKBRFNx7rZYTE7cTq+6I28
 A2gtpGBB/UbraSA4C5F7icEpArHsU73XX1zJQhtcg/fkjNxB9YIEGcKw9LKtR+sjkQ84WUTjJcv
 +YDGrMmN7gNDZ1pyI7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060019

WMI_VDEV_PARAM_BA_MODE is currently configured inside the he_oper.params
check. However, mac80211 does not populate he_oper.params for AP mode,
causing the BA mode configuration to be skipped for HE AP operation.

Move the BA mode configuration outside the he_oper.params check so that
it is applied whenever HE support is enabled.
Without this change, firmware defaults to a BA buffer size of 64
(legacy mode) for HE associations.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 4f16c78b52a8..711acb32a6ca 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4888,8 +4888,7 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 		}
 		ath12k_control_beaconing(arvif, info);
 
-		if (arvif->is_up && info->he_support &&
-		    info->he_oper.params) {
+		if (arvif->is_up && info->he_support) {
 			/* TODO: Extend to support 1024 BA Bitmap size */
 			ret = ath12k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
 							    WMI_VDEV_PARAM_BA_MODE,
@@ -4899,17 +4898,21 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 					    "failed to set BA BUFFER SIZE 256 for vdev: %d\n",
 					    arvif->vdev_id);
 
-			param_id = WMI_VDEV_PARAM_HEOPS_0_31;
-			param_value = info->he_oper.params;
-			ret = ath12k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
-							    param_id, param_value);
-			ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
-				   "he oper param: %x set for VDEV: %d\n",
-				   param_value, arvif->vdev_id);
+			if (info->he_oper.params) {
+				param_id = WMI_VDEV_PARAM_HEOPS_0_31;
+				param_value = info->he_oper.params;
 
-			if (ret)
-				ath12k_warn(ar->ab, "Failed to set he oper params %x for VDEV %d: %i\n",
-					    param_value, arvif->vdev_id, ret);
+				ret = ath12k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
+								    param_id,
+								    param_value);
+				ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
+					   "he oper param: %x set for VDEV: %d\n",
+					   param_value, arvif->vdev_id);
+
+				if (ret)
+					ath12k_warn(ar->ab, "Failed to set he oper params %x for VDEV %d: %i\n",
+						    param_value, arvif->vdev_id, ret);
+			}
 		}
 	}
 

-- 
2.34.1

