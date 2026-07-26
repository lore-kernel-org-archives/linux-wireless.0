Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D323630B0
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785106933; cv=none; b=EC07HpM88wg+aPtbzMETTqda/Y9mw8CCN5wDVB1JdZfy8bZbZpPUwH4FWeiuC9rRLOgqzJwKQhWO30/hV1cJNMPuV6lG8AIZSJgZcNMbfA950SNzSgYoa46KAbTukAsBAlyCFbf/Nh8ove7xgoZZYBJCg5WoZK0G36ZHjeJGsjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785106933; c=relaxed/simple;
	bh=lnvNJLoQExS9jX+tKoOaCxdUjOBcAo5qCKf/hBmrcpE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=m2dPR+tcTK1dALXd51T9IIFFwUCT4+36UN6b3c5khLYoYDySXbb+knl17WFlhje3fx5CTPWXnHEF5VGfcisRzr16L5GAeQSxTb07Kn9UBt/GHZ4VffewZeSwkVWj0GErXjvlfq61CcULY+8Zo06uPgBaTxfvoepcSJ3MRoPRXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QgK58Fzh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YDrJQuyi; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QgK58Fzh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YDrJQuyi"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QJwQHM1474319
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 23:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=72mK5vmFBeU3BL53fRubhX
	r2I1zqsrOqaPq3cLhIFMc=; b=QgK58Fzhwl3mD+um8QLzbKw3WdGJhHCSs2Scpr
	y7GrsuE+/ybiu2YVSrF1p7q7Zniprfehl2fazHAkyCXAunqJO9ddoWpCrrUFePEg
	/QMVqS13WoDQaYULXVlaQHB25BkOmICgFcl743XOnHAv19O85yj9Ts+A/F3zU3PB
	RqznrzPPTLLR6oBUW+FSWAZ+mh41ltIz+22nfU7vAI0rLANAxSsK/O5k30b3gzFN
	mdZ5ZY5Vu7hqRpygpJNimcy4XzDBOFZv7nCyo+kU7FSnfI+z/pE/jt86nBdBUuju
	yqimOZOn2Q/UE0JnMrni4oyYMjakLLKAlj+2iJc2oUUX0AIQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnweuphs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 23:02:11 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso2946758a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785106931; x=1785711731; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=72mK5vmFBeU3BL53fRubhXr2I1zqsrOqaPq3cLhIFMc=;
        b=YDrJQuyil2Z4HGazCUbzAd6Z3xRs4VLLU0Z22+QHH+kYen/HI88diUclB6akhnmlNH
         sN7iakqGUveJvnXVFEPeFJGXGeoavs3FhSIiSHLzzAbx+7WjOLRh9NinF4PgKtG8w/oe
         aTjP7KJK36YNvgIDP/mMM1seypP8QqQDD9g3BaxyYtdlbQaID99kIITcIwRe41tcNoJP
         aoyVyVbCYavJTWEHsCqcyarnvk7wvJ4IoZe3mwMz31ZkMLNdaSi9PFGrelV0owezmIek
         1xDRiJbcKxbePGH6eQYPuPCcDBnGqkuyjOsNsrF9QyqQpYPRRdYynHVsdNoayLC19cVU
         7oEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785106931; x=1785711731;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=72mK5vmFBeU3BL53fRubhXr2I1zqsrOqaPq3cLhIFMc=;
        b=X62zL14maIt66xchcciIDPcFkFLeqPTlQk/x39zPKt0MtphvOkqwr6Pwo8aV3IvbnV
         chEoRl0JOdcIJ6L64+OKSzFC5lUXWfPRKLo+6JI7lDh5jPB8UFdsc+AYKhhfOgb0PWgz
         KkQUh54B8igXNpic/+c4jPfhHZdL5FrtGwTxEb9QEtmGHTvUToJAPJGYPh1/ANZEBbC4
         k6lzZqb+qLFlvwlK4LND7mixPBH3XsEEEmcPdpXOFI3IVfUbKXw8zehyF0KASc+w/By9
         Qqdyze3INKYz3bdlxJtXYgF22xWvj+mZQrWRCo4y/K89/mcTwe7D4CAHaFJtoSDRdush
         CmhA==
X-Forwarded-Encrypted: i=1; AHgh+RpcmvBjLsPPLmSl5by2z+/GAwSHMxh1F+ERQKEjEzJ7P4dSJnw4itd7JFWH7zcSLuBdGXc9JVnPwiOf3To/Ew==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx64hozwBnKqNC2pjkXvE7F/HTpSg5o1EHXmPlGnB5EthcSuvfQ
	wAK05kdpXYUHlw6njYVhpexnEiQ2U1wFw5nQpjyFxDKOJBKgD0peiuF3GuvdAeAeUtn4OX/MP2U
	wbXcuwtXqvtjQyGQ/SYTRJjf7B5FSHMCQtqvfFViRD790p2oHh4DUwx/i0ocPs989t28y7A==
X-Gm-Gg: AR+sD10JmqvGtnjl0XmqA8HmhE0MLJrwl/RYTwXhkBQ0YRgUlu7XKkG4IXBFBfv/jJc
	VthnI4yDxJ2KO0kCLScC1guePxiiEf6zU45xI3LGaIAMIbujdPpP+5rC0kEYAoVLFLmaEapcZO2
	HBYFXRNxowjqdBlGh5i/ESrJZp6g4RKc99aW882CaLOlOR4ht6lF4wdlo0SCSQvaujn8zdBGRDV
	/CSLAATdAcGPummDuxlBDA/gyifmsxIBrgNv4qXUEit02l3SuKklmCnGHzmJ2x0pFDY8jFG1Tbu
	DCOX0Kqkt7hje/DDW1UWNRQDLb75CmNfSAHiovJHynBJDwhjoXoWx6oodcWa5xK7M1Ema033WG/
	2Ftu/FxiHhbIP5a8SI3EDMuCYDkS6CsHK38yoQZy8+8/QKzaQrDMkAPU=
X-Received: by 2002:a17:90b:1fc4:b0:38e:7297:a931 with SMTP id 98e67ed59e1d1-38f298a5ffbmr5097921a91.43.1785106930275;
        Sun, 26 Jul 2026 16:02:10 -0700 (PDT)
X-Received: by 2002:a17:90b:1fc4:b0:38e:7297:a931 with SMTP id 98e67ed59e1d1-38f298a5ffbmr5097900a91.43.1785106929760;
        Sun, 26 Jul 2026 16:02:09 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc593b57sm34621746eec.25.2026.07.26.16.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 16:02:09 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 16:02:07 -0700
Subject: [PATCH ath-next] wifi: ath12k: validate TLV length in
 process_tpc_stats()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAO6RZmoC/5WOWw6CMBREt0LutyVtBUS/3IchpJSLbXgUeytiC
 Hu3YQf+TDI5yZzZgNBbJLglG3hcLFk3xSJOCWijpicy28YOksuCXyRnKhgh+/oz2nr2TiNRHWZ
 dU1CB2IAT0wZ1z7CQGtuGX0tRQhybPXZ2PUQPiBtswjVAFYmxFJz/Hg8WcfB/ZYtggjU8z64Cu
 1yfs7sjSl9vNWg3jmkMqPZ9/wGAb6JI7QAAAA==
X-Change-ID: 20260720-ath12k_wmi_process_tpc_stats-len-check-e62cedb09818
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIzMyBTYWx0ZWRfX5KmFaPvQBbOx
 DF5+1x/tSRew1EILQWknDWuJPSQR4/hxM6WCBWH/veUuD0IzM6pdO+5q9sFLcs4fdDJFGJjYmm+
 yqsLKABptuU1GBc4Z00tGF5/CV823512R2Wc8UW1AzY6YtJmjm3SQ2Sr4hyveHh25ef4jSJz1tf
 0ocUHREFCeTfFoAoZHVA7n2m0TqMsyEots0EpSzb/BlnqzIkU3rpmHPap7yAPBB2QPmPmyXYNZs
 Bb6yg6p9Dw4VKPGmtvi6HY+3tMYlGHJTHYq+e4uKoCaSx8kVwk89nZ+RL8qgIoMvpGOeZQyOTPE
 i9c5X2kwQ8hZ1Qep8y9I4D4p2YbwYIO01Jq7zf/8CtQydDF9mrJ3Wg/7qHUxcTp2LL1sTEtRwF/
 Cpz5cwglIQTgZoLFwl9tC+PrGGYB6KtHrazzFFRuzCnzShfOi8IvDSBQpBX0gNXX/H02aozBU1A
 +7DvWUYC5Z03Uwh3CKA==
X-Proofpoint-GUID: INjk4ZPN8Rxv-LR6k_EFm8hZxcEinF_r
X-Authority-Analysis: v=2.4 cv=S77pBosP c=1 sm=1 tr=0 ts=6a6691f3 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=ZCk0Dni79M2Isg7ApyIA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: INjk4ZPN8Rxv-LR6k_EFm8hZxcEinF_r
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIzMyBTYWx0ZWRfX+6iVpqIg+mR0
 LhGql5UrAtJA6mI4SCf3H6qIIU9KItI72BQ5iJPH4ZxFB3OZWiTS9wUGv0jzUSvNregLsOAyNbh
 5avAsVawjDE0MdeC7t2bRLlXquKQFbM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260233

The outer skb->len guard only confirms the SKB is large enough
to hold the full fixed_param struct, but the TLV's own WMI_TLV_LEN
field is never checked. Firmware advertising a TLV length shorter
than sizeof(*fixed_param) causes reads of pdev_id and event_count
beyond the declared TLV payload.

Add a check that the TLV length is at least sizeof(*fixed_param)
before casting and dereferencing the pointer.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 672eae237ac6..8caafb4cb86c 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -9962,6 +9962,7 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 	void *ptr = skb->data;
 	struct ath12k *ar;
 	u16 tlv_tag;
+	u16 tlv_len;
 	u32 event_count;
 	int ret;
 
@@ -9977,6 +9978,7 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 
 	tlv = (struct wmi_tlv *)ptr;
 	tlv_tag = le32_get_bits(tlv->header, WMI_TLV_TAG);
+	tlv_len = le32_get_bits(tlv->header, WMI_TLV_LEN);
 	ptr += sizeof(*tlv);
 
 	if (tlv_tag != WMI_TAG_HALPHY_CTRL_PATH_EVENT_FIXED_PARAM) {
@@ -9984,6 +9986,12 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 		return;
 	}
 
+	if (tlv_len < sizeof(*fixed_param)) {
+		ath12k_warn(ab, "TPC stats fixed param tlv len %u too short\n",
+			    tlv_len);
+		return;
+	}
+
 	fixed_param = (struct ath12k_wmi_pdev_tpc_stats_event_fixed_params *)ptr;
 	rcu_read_lock();
 	ar = ath12k_mac_get_ar_by_pdev_id(ab, le32_to_cpu(fixed_param->pdev_id) + 1);

---
base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
change-id: 20260720-ath12k_wmi_process_tpc_stats-len-check-e62cedb09818

