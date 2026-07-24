Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD8C318EC5
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784856696; cv=none; b=loJU4stg0ehNeZFI4XYgXXDbeRq8Fjas7tbUzjv83gftnmXoOBErCMqG3bB19rM7UiAF+LENw0hs2+xe6n8ZVy7nOW089aAOCngMbcUhfocF0GMWFrG/pBQWYoqRwH/gOHZK4eqUS94M/q63pxUoVjdwPYqSy1EtYdBGyomXJuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784856696; c=relaxed/simple;
	bh=Rh+E2ZN3ua6IyAeXqtWu4hX8gnsRqJQPvjrnnPEVYz4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RrAs/i3rz234YnOU5HzKYBpdPkHfNwKKnTjVYxgBOpAGDyx4ZFOXcB30sMwvp2woheqOXuMmxqgnQ9okxuDb7ra4Hmg69zFwuKxYIc4Mkm/9AH48Q0nuEQg2HU/zYl3IGvyj8r1qGJkiUzhIW+8SunvC6YAY48a390uczzqJdSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QCvoq+Qg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=H8PHOja2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QCvoq+Qg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="H8PHOja2"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLeZdB1237345
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	u8vVF6hHkGu1xxeXQmSUf7FgyLwedcYDTnsRmaxHtcc=; b=QCvoq+QgAd28XEsF
	1bijWBEel5NOwmESsCpjNRWLADJHd1iuAZHYFPdDPqYDyy1L0i2bx1Bn0cP9K0QS
	EP3rQZ9vp/q3hrmivt/a+2WWWhU7iBbCjRGLloHmaiVJPAB5RnOzjCcRZqQFVGW9
	P9q+LAB6Z0fLHZx33ocysxm9p6R3L6IqLp+bfFLeVuZWLD7uB/kTZv/4qzA1TMWE
	Na65oAHTZ9ywMSLJFENXXgsV1Ac/ZcDX7ff+LVszhkgUuIbWF3ItMmczCeEYGyQU
	eGxfjDW5PkoNlgqJKz/scDslDCt3s98qHnE/e1ut5hiHa1IMUc+kpHLRpOfKazW+
	nlOP/w==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkp5vhwmu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:33 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb7049fa552so1021567a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 18:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784856693; x=1785461493; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u8vVF6hHkGu1xxeXQmSUf7FgyLwedcYDTnsRmaxHtcc=;
        b=H8PHOja2bRJjxgs3Y0JR0Pt04HQeZm/aAnI1jbtk7Y1k3yD0nljNdpzqCgAf4wk8Ct
         RWiWYyvmTWx25fX6Wzq6cjwOWFV4B8U5MVljHB5l3FXUtOI2ZSA9MThHsMk30lCJbS9t
         oPnXb/w2wtTJhLvVAaaKMseXFnUzLqwexuzOFGBX/7H9pDfm/rjq9jj6YzUp83KIlU80
         /WAL0+otVpQFDQgOnf7kmUE2apzR7xaXm9osZrs6Ph05xI+bUYbLhM6bv6tyUInDqlIL
         UterHrkt+6/yQ+Ymx3e0w3zo+PoefB2kOY/W2mqV98u3qNKUMTjcSOwvQB5wnURMqCB1
         7EFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784856693; x=1785461493;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u8vVF6hHkGu1xxeXQmSUf7FgyLwedcYDTnsRmaxHtcc=;
        b=LlxqB2EyLWI53fwJjOEjS4Nj3JNOW7c0IjZJvoXWWu4vN1ahataO95TguunI7l74cP
         HfrzWm21ZTZiEX7IHryMqCugYBjK1Oxr8YKuBUvHAPU08pujCwzPJsUnj1z8x2By+/H/
         eC4YoEsA/Yuc2Qt1YSiXzggM6BRVork/nqWmuJRHNQdHZvUSTuyhamE7u/fz4Tk3pkGH
         p0h+tshUtO2DDCugFYs0mVIJHjQS97qiKdPUYYXcvfL9XVhd7fkV57syK7/v7Nksf1eZ
         TfNou/E9ktNWJR/Wiuoe6gwDuRGg3H3IQMp7e2A7BgP2puUkvYClPrDJ01ObYA9nftw+
         3Z/w==
X-Gm-Message-State: AOJu0YwzeQYr3KETa7Q1KPGadDerm6nlUJaQyCRbZ0ZHc4sJqbM6k/hH
	UhiZ8IRow8doloWyr8aoPAFZPzjXQpViKf4J401/64DOPjo7K2HZu7/XeyeBF10fPDRS84h9Qyl
	RcUZ/aPOlIhnNmYTRIV32HBrQFGybbwjrN6pH9Pww47oMJESJP2jE5Rh+iSRMURdO2W/Ntw==
X-Gm-Gg: AR+sD110KmzESL5fyLoILKu21iJmVc0GwZLXB/HGeTgnEhryTKFXHDRs/p9KgskMtGb
	eM7YwLGwNamzcyz3njQ+BHb/+IWTgzbA6xSQ2fbIC+F0vNEOtXkf1GP9N4SFd9KD+CexpVioBjw
	CueC/V9V7KV+b224EV7UnRQTYIffqN5GcGSf5LLIrsib08bLgIW05Fa6GQq9aml5EchohNnWzo8
	hQgqSv/cjv/y9lbeHj+kFdPYQgYw92UdWbZFcIIzzoYRtMYV6gCYjtUXGS9QSOFolLizEsa48yP
	KOQqqbm7vwK1Pxje/ikWUOBv0D2h9CrJD/+OIr1HXw8HKo3UIrjX1maWzI0aKFjT/cXUjOi9Wpy
	ZA/+fHCzd8vETOPZPsYWswTSWxwdI9800n7IadF37QNMiE4ZinvaiWv4=
X-Received: by 2002:a05:6a21:9182:b0:3c3:9df0:2d66 with SMTP id adf61e73a8af0-3c44afcf8bcmr6254464637.6.1784856692691;
        Thu, 23 Jul 2026 18:31:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:9182:b0:3c3:9df0:2d66 with SMTP id adf61e73a8af0-3c44afcf8bcmr6254435637.6.1784856692249;
        Thu, 23 Jul 2026 18:31:32 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df0ba0asm22655306eec.18.2026.07.23.18.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 18:31:31 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 18:31:25 -0700
Subject: [PATCH ath-next 2/2] wifi: ath11k: fix overreads in
 ath11k_wmi_process_csa_switch_count_event()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-2-c01ef10bc6a3@oss.qualcomm.com>
References: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
In-Reply-To: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAxMSBTYWx0ZWRfX+5PokSRUWzOS
 mXQEBWEDEK8+oRBzwpzvZn0Swk2S5pK6f9jwOsw0jWzm0twZrX4kwmMsgp7kpij2smvN7+D3kE2
 8yhRj0qM0p7Tj5ZIL3S9/8NRwVAO3cE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAxMSBTYWx0ZWRfX/YLiTrpJYGyN
 ehgup5IV1/9bIk8R/AUIeJN/Yn5zTWFuihB9qC7I/VzBEusRnNOtT/aiGc6R1CjjcgtAskVKhdm
 mteUGXXdrzO/nOK9mmjPB1SYQC3tQysPmglLdgZA2B38cIbAtjWcPCk8OchuJNXetxYyRQYiIaD
 C+O/zl0Fk4F241rwVxhgx62YPHizxIaUU/MgYtGM41k88DqjkO+hSNJUfc5A6PQeWr2JjTgOJOX
 DKW/8YTjcZIg1/v82RqJvnE7DUVgP4Ntsr1ZNcHnAL594+PD2huW6wwa6tvOMODi/pCtIX4n73p
 K6EPFcSlCqfzCih3XBM0yizilGmUYGiNGhejjD6zARenxDyHPMQ8nQtiq66q/2gSRS1R+v1i0Rf
 irF2bgFnkX/XXVppiwmLzwQ/lz6SyDuNHl0mIwS8kDJAHWtuH+IOQ1WrrRBmT4io6qUo1V4X9Nw
 iwaQlbhFLqpITqPQ1nA==
X-Authority-Analysis: v=2.4 cv=Z9Dc2nRA c=1 sm=1 tr=0 ts=6a62c075 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=hOGj4-57aE1FpqoUBq4A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: IirbrufLr3CeLQRHI1zoUS413WoxVBPP
X-Proofpoint-ORIG-GUID: IirbrufLr3CeLQRHI1zoUS413WoxVBPP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240011

There is no policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT, so
the parse infrastructure does not enforce a minimum length for the event
struct. Additionally, the num_vdevs field is taken directly from firmware
and used as a loop bound over the vdev_ids array without checking that it
fits within the TLV payload. Either condition can cause an out-of-bounds
read.

Add a TLV policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT so
the parse infrastructure enforces a minimum length for the fixed-size event
struct. Add a helper ath11k_wmi_tlv_data_len() to recover the payload
length of a parsed TLV from the header preceding its data pointer. Use it
in ath11k_wmi_process_csa_switch_count_event() to bound num_vdevs before
the loop.

Compile tested only.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index dca6e011cc40..feb0a0b29c81 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -159,6 +159,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		.min_len = sizeof(struct ath11k_wmi_p2p_noa_info) },
 	[WMI_TAG_P2P_NOA_EVENT] = {
 		.min_len = sizeof(struct wmi_p2p_noa_event) },
+	[WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT] = {
+		.min_len = sizeof(struct wmi_pdev_csa_switch_ev) },
 };
 
 #define PRIMAP(_hw_mode_) \
@@ -262,6 +264,13 @@ const void **ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab,
 	return tb;
 }
 
+static u32 ath11k_wmi_tlv_data_len(const void *data)
+{
+	const struct wmi_tlv *tlv = (const struct wmi_tlv *)data - 1;
+
+	return FIELD_GET(WMI_TLV_LEN, tlv->header);
+}
+
 static int ath11k_wmi_cmd_send_nowait(struct ath11k_pdev_wmi *wmi, struct sk_buff *skb,
 				      u32 cmd_id)
 {
@@ -8353,15 +8362,23 @@ ath11k_wmi_process_csa_switch_count_event(struct ath11k_base *ab,
 					  const struct wmi_pdev_csa_switch_ev *ev,
 					  const u32 *vdev_ids)
 {
-	int i;
+	u32 vdev_ids_len = ath11k_wmi_tlv_data_len(vdev_ids);
+	u32 num_vdevs = ev->num_vdevs;
 	struct ath11k_vif *arvif;
+	int i;
 
 	/* Finish CSA once the switch count becomes NULL */
 	if (ev->current_switch_count)
 		return;
 
+	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
+		ath11k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
+			    num_vdevs, vdev_ids_len);
+		return;
+	}
+
 	rcu_read_lock();
-	for (i = 0; i < ev->num_vdevs; i++) {
+	for (i = 0; i < num_vdevs; i++) {
 		arvif = ath11k_mac_get_arvif_by_vdev_id(ab, vdev_ids[i]);
 
 		if (!arvif) {

-- 
2.43.0

