Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793941112;
	b=G70RgTkjHUxabfByANm60bkVq7R4q0B19g3Apy2nuHI4jrUO2+tXGQOmhQ0eSMIYn/Jz
	 83TFVuBIPluiQFkP8IsrbsYygZjxMwlhrq8JW5Vvcvzduc9E8dI+NeVyKL+G5Eoi3itPS
	 izJbwEs27ub1UqkKYjuvS/WQtQBb8WwOq/nylOuvzgtxxYZTgD1vaChBOlIVb08R0PnYu
	 FzwqqgXgzcwN2xCmISTbCnZidhKZk+iqPVWmBF74aa2kXlAxhaWYvvKlvrL6+PQStTHfm
	 rWtPho12Uac7/8n5BgqXJmV2Cke94kuhD7d/bxiL+eujpDbTo2dfH6HfR3X2ykW7C+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793941112;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ZS+ZPBExf8N6EoGjEt9fsjVijaVhiR7NVbU8PoRpNXA=;
	b=5M5gFjzAJdFiQBFcOZsabZgMSw13ir78xYK+GK2hmyO0AxTBwo5LOXaZlUxbGlQmXbiN
	 ifBcinnm2+2B751ivz0VbRW6tMNpq+30HO2xBs1TLBbfgyuMNaks59j9syGt7EL7zP+zO
	 ly0vjTf+6t6xY1OAY4w0rswFtSb40ASaxeDGiZypdA2PZXL8ZhRVl+CWQFUityTXA6tNd
	 LA6xkssyGFsID6YXq5NYPNCciCGJXZ/9C9/G8fiJZEY6rhxcJxhFZhkkti5IBBtkZjHFz
	 Ulj+KRke3LxY92WT1gBd+nUuaySoudBLmrxYmKw9Ml4pt/Vi0Rjs+9oAFyiRkBPRuwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=d3rJ3wnI;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IucSou4A;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11E1606D80F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 04:58:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D11E1606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=d3rJ3wnI;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IucSou4A
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6403px3775745
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 04:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZS+ZPBExf8N6EoGjEt9fsjVijaVhiR7NVbU8PoRpNXA=; b=d3rJ3wnIp4OYfRG2
	cEBP6HwzASjm7dggTDaU3TGUHSMc8uqAw2lDLhT77A65Spvo/Lt9rXIkuok8N2/0
	NBWAR882nFpYBqAdXm4YBBLe8cXiNXOARZcecyhFIdfkHMPQcUz+9u27bNn1Ict3
	TqFGN+6Xm9Vrsp1o548fE+vDAviPF8BAfomN29OvwSZfo7TjY3HN2aoUKNEj4wlG
	wIp6kMASNmfEOiO5unKheS7GDsSV71yIAruIMcj5wkFFl6LeWQUHgBG+oXe7TIoB
	6nAYA7pB/c0ZWnez8Y/Rn0FgGOi/BB8dt1QOAIxrthGuirizLyT6xn1EA129Eurm
	UDt1BA==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9ryw9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 04:58:31 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1383723dfddso563122c88.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 20:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793941110; x=1794545910; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZS+ZPBExf8N6EoGjEt9fsjVijaVhiR7NVbU8PoRpNXA=;
        b=IucSou4AsdIP802iRgVco/k05HQE8loT5yZKH7qefjMyNxQMb1Gv6u4yP175ZbfiXR
         jSPQ/RS4Jy+NC8sM5Ht8dd56Q1WDwEnPrc0mka4HV6SmHE3eIT8NSBXXxksPaHBVOAkw
         MNbq0BYwKuvOUKjr+T7wRPOTU8q3DpnHszmp7+8z2GOtcqr7v8o0VwD0UV3o+OQK1h3N
         j4tMnSOYlR67ZK3fj/UeVNDes+hJqozv1cGF3+QMn27l8shzlPW5JQCI8TI/Lk55TQVz
         VMhpZp/76KgdprpundNZJOEMwCXdQQH15X/sRIWPQwOzTDvvado1M+R9OmNOJj46ktVI
         xu6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793941110; x=1794545910;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZS+ZPBExf8N6EoGjEt9fsjVijaVhiR7NVbU8PoRpNXA=;
        b=YeilR12qs2N4AE+/zm1tZCOqJvsmw3a/TAusgZrxwmoo5UmNM0FnA1r0/pfwiF912z
         BhheMHyxnyRO25btsREb+9Oi7w+b3by3y3qvZ3yCJIGMTP5+tX8tzxyxeMmiNq1yAk9/
         9behRwS+SUhhPdS5B0PosLR+O7wYem/wrywG0UFTMiRWg0BdcV3VkPQNieu4I2Da2YOL
         QdAkrBjOjjIdgRMOcCjp61AZj/faaDkKx56bMpgRbEYr+0ACnAWNw9OTCA8S7R0oTCxe
         BiWavT27qUcvvX2rd6Tkk4VjxNohiTlWdIpx6jwM6QsPARqmKxzNHzJWBsqNZE7stq1j
         5g8A==
X-Gm-Message-State: APuU4Z9l1aTHOYG2kN8/PghK0/OevJMMHJWDwl2vsVkg14L08DuFq+x8
	M9M9oDZDW+QwT6+sKEFJPY5dEOnLFeMOzW3baKsOUHLHtkPMKiVu91poGN1q3W3au5mFUQwjUka
	C97dSIP4g08TZnRGaK0i0fpgBX+9DspopeR6MNT2DY/FL6NjrZJWkgy7XUQZbL0PscjvWMg==
X-Gm-Gg: AYBFou0PNfsVKOEGRVTQsqHTInXzdQZ3yszPc2ejFq/AJyie/gGiGKUIjjTVCH42nL3
	JYu3BidssqrXaSffhzKhvtm213Mhm/c9r9Uhx7PynaBhtEqM8DQ3KzqJHU1VfUi7uilBfP+G8P4
	85648cLWyvUq8cRq5QCfUw6cvcJvvnh++Xu5E+gze0uXq+/+db6BW3Cj0zpHmU0TZdf+ivU9I92
	gKGEOVjaUA3dJqm4cdBKdDLn6TkodqldSHHA+lGwQ4vMP9zaLDpe8WHzZmCGYgZaBQtcUbfR2kB
	xN60f1Fdo8D8kmcFgGfalOIc4SUxkhHmwhf15fR5LERDi9fDjN2bmUsFNiGkQrZW54D9W7/KeWQ
	LzQammSw82bjrxNyrtacrKvt4zeTN1CN0NnXKWT3jwm3mBui59rlgSXPx7UBinTnODALFjJF8Ie
	OOew/bee7zLaq0NvuvmrYPw7PZZZqckqcDAbpoeVoFlLKrKBQLaQns0RUStHx1x06RU+Nt6tcdw
	o/r
X-Received: by 2002:a05:693c:8008:b0:369:d486:457f with SMTP id 5a478bee46e88-36f73e72d61mr1900166eec.2.1793941110258;
        Thu, 05 Nov 2026 20:58:30 -0800 (PST)
X-Received: by 2002:a05:693c:8008:b0:369:d486:457f with SMTP id 5a478bee46e88-36f73e72d61mr1900135eec.2.1793941109700;
        Thu, 05 Nov 2026 20:58:29 -0800 (PST)
Received: from hu-ramess-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8e3a47esm3021327eec.6.2026.11.05.20.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:58:29 -0800 (PST)
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 10:27:43 +0530
Subject: [PATCH ath-next 2/2] wifi: ath12k: Extend BA buffer size to 1024
 for EHT capable links
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
Message-Id: <20261106-eht-ba-window-v1-2-622f2272e582@oss.qualcomm.com>
References: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
In-Reply-To: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Paulson Raja L <lraja@qti.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793941100; l=2431;
 i=rameshkumar.sundaram@oss.qualcomm.com; s=20250120;
 h=from:subject:message-id; bh=4swqYOm/vWgu5fj29xpSAZ2upc9FVcz3hlehWFqxrj8=;
 b=vTZPB0TRQ5gcBj/f2Cc4sgQMqu9JEOzJF64Te5bBVKPJwjJOugIWd7RPUAIOrqpjtUEpQL599
 Ic34wB/Fvl8DUaGlZiCbHlVC7V5fmll/XWf2XbewIDZnfH8uwhcmkqg
X-Developer-Key: i=rameshkumar.sundaram@oss.qualcomm.com; a=ed25519;
 pk=CbWiiM4JikGBEWI7HtrEEE/Hwkk7TTcob0SwaFdAwKo=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAxOSBTYWx0ZWRfX9E4dZcIfAedS
 KgcOBjQedHhr+3Xq+crnZw4oVsQhB6t+a4dHRX9bqJKPb8Jfzix65NePHiEgmOWd0ZALs/eGNEx
 pz5GJk1zrJ8j+IWj+xvnqlVzUnQqlzY=
X-Proofpoint-GUID: yTzAabPTz77__EXDbVVEUMLK-F0GXG6m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAxOSBTYWx0ZWRfX38RJ1LNY7HoK
 DyQ5XQAw9PzZqvBcG+LPk7SEP7smTI7w5krdAzJsRSiMJzy4c8SuUMm2/ahPsfZ0C+kl/EeJ0yc
 vS6EPSJRwUFbiaWon3gX4Qy3dZpyQNDSshLtASycdfErtXac8aRgSvbbJx2jZNwgvzzWXhRBXMW
 cHyWiVwNFdALV9to1K4Mn6B554Xxwv2T6sGTKOZAxlXasj6BUMCkhquc0DwFNBJeEinoVMQSyon
 hzjggr86WOumGYXeulxy2QYTHEOLkrloKtJV+RasgCvd2i/Il6rYDo6um3Xa+QiZERnkXej+0yC
 ggFkzyRn1GrsTV+HTn646XzaU1C6XbKcenWbjPXv2k++K/sK8179WYzklMrXDQrPmOkhrm5szkx
 BzND4nACaECaW4yqoO5DkovUFh7wyCtSN8VnhQwCovym0i28SRPl1MS6HW3EYIP+By1X2QxyjXN
 8bcSGOWC6vZKp0+zxmA==
X-Proofpoint-ORIG-GUID: yTzAabPTz77__EXDbVVEUMLK-F0GXG6m
X-Authority-Analysis: v=2.4 cv=ZIZCCn7b c=1 sm=1 tr=0 ts=6aed5e77 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=jeHpWAP0zc3Nfv8w7osA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060019

From: Paulson Raja L <lraja@qti.qualcomm.com>

IEEE 802.11be (EHT) extends the maximum BA buffer size from 256 MPDUs
(HE) to 1024 MPDUs. EHT-capable links are currently limited to the
HE maximum of 256.

Add WMI_BA_MODE_BUFFER_SIZE_1024 and select the buffer size based on
the negotiated mode: 1024 for EHT-capable links, 256 for HE-only.
Also include the return code when reporting BA mode configuration
failure to aid debugging.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Paulson Raja L <lraja@qti.qualcomm.com>
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 14 +++++++++-----
 drivers/net/wireless/ath/ath12k/wmi.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 711acb32a6ca..0ad019fd4918 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4889,14 +4889,18 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 		ath12k_control_beaconing(arvif, info);
 
 		if (arvif->is_up && info->he_support) {
-			/* TODO: Extend to support 1024 BA Bitmap size */
+			param_id = WMI_VDEV_PARAM_BA_MODE;
+			param_value = info->eht_support ?
+				      WMI_BA_MODE_BUFFER_SIZE_1024 :
+				      WMI_BA_MODE_BUFFER_SIZE_256;
+
 			ret = ath12k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
-							    WMI_VDEV_PARAM_BA_MODE,
-							    WMI_BA_MODE_BUFFER_SIZE_256);
+							    param_id, param_value);
 			if (ret)
 				ath12k_warn(ar->ab,
-					    "failed to set BA BUFFER SIZE 256 for vdev: %d\n",
-					    arvif->vdev_id);
+					    "failed to set BA BUFFER SIZE %u for vdev %d: %d\n",
+					    info->eht_support ? 1024 : 256,
+					    arvif->vdev_id, ret);
 
 			if (info->he_oper.params) {
 				param_id = WMI_VDEV_PARAM_HEOPS_0_31;
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 5d0afbf0bd0c..78f1ceaaf5ff 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -171,6 +171,7 @@ struct wmi_tlv {
 #define WMI_APPEND_TO_EXISTING_CHAN_LIST_FLAG 1
 
 #define WMI_BA_MODE_BUFFER_SIZE_256  3
+#define WMI_BA_MODE_BUFFER_SIZE_1024 6
 
 /* HW mode config type replicated from FW header
  * @WMI_HOST_HW_MODE_SINGLE: Only one PHY is active.

-- 
2.34.1

