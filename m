Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A5931618C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784856695; cv=none; b=hYzs4l4BzsI4X4nGlvcZehEM3LFZ47cD+iWjuM2UAPnFQpe4AEwoghJ8uW3d0kSQkSRut3f/Ni5mrdjo/LogIXFRcOM1oNNzlADgKEVTWxJIg0DSilSEaR3Xg42mOkUyw288vrdZiowl7Keu45nTIkycZg4+TwZft7RAGDfwTLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784856695; c=relaxed/simple;
	bh=TD1OMp7b4XA2iZp/R7pxmK/m5k9FQunAW2XbbVd6r5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jr5ufdduI16A3tDM7yA34nwlzAqJyCnzKRojXeXKXjYiuzZVMCe8cy+oQcESFhdViZWDpOBFvh2YK6l5l03YI7y88Qx41QRYqppyfEA7xebVC3KWjmgFvnmm1uAemOZnsWs8N3d2GMygRfytwbWQxKXed+pipi9/u1nrNkaz6dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XNncgK7v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fp8kKNHT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XNncgK7v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fp8kKNHT"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLeMMh948305
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5SMXxutj/MIuag2+HC9usTCdJHe0gkRdicMpw/jumME=; b=XNncgK7vGyN12FIy
	Jfp1Uvjn/a1vIfzZKhxyGZNTDm8wt1OAbouoTB6LjbbOs/G2+zAqteikfF5HSdWQ
	HUkRt3fSpNWIiLrARYserte2y/7hX1/nPwdVSwkTAZ3LmNR1ntPwMK/DlkLQZQjc
	Mv96O4HWFvAuz7Y47MLWfgk91e/gfsgzgfvwXGnnbiy9u5H6gMxks0Ff20D4p4QE
	5sAMEocCCaOJpl1LJzQFutf+Zjuml4IklCiHlgi0s8I7oIcq0wdhyLHhZ2bHKTws
	9ZfZrHwRelldSqbYIr+JqH4U2R1pP66I5gpa43i/92V/BQP83laMATw5lpPfhSHc
	pJ8Qdw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke0kv894-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:32 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb92868263so1668009a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 18:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784856691; x=1785461491; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5SMXxutj/MIuag2+HC9usTCdJHe0gkRdicMpw/jumME=;
        b=fp8kKNHTc+GWVT2rQ8JoipXdeNM6vU1ndtzOa0QM2f/DlytxKwyXeMd3CYlXSqzF3L
         2eFwZhzRuAXEs7DG6UmUbWC9dgWkUl3v/i7ESV2D3ClAWvflGwRFGefet6uHThLvyTSI
         +xSzB7EVAC3iN8DaICr9qrAxgQEpA0Q81Fa2Ok63itkN3Lp3CFdX4QzXYW0+jvgLhUdg
         RyOUmuUwPIiRvaoLFTYKk64VPo0UOh5wSOTX0/U4eVXAc7l6/7aFz7HxH2+i4laDnanJ
         QjKfyayzSumjPQB4N5nyTjkw5do1VBaiD825vBnUSUypoIt4GnzIQ3+MB/4JSzdxek33
         IerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784856691; x=1785461491;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5SMXxutj/MIuag2+HC9usTCdJHe0gkRdicMpw/jumME=;
        b=iQi39+A8fKiKH9kTQl7DoYgJfnA4BG+72MZRcRFSQh5mvqCckMnVDwaLXCjKfscMVY
         UNZYVj4C8LkScJid7p7bxZSHpSN6ULk9sfe68Rys1n4WKj1znM80l2eGCsGNTva7JtjL
         05faUjbU6XaPR3DA+8x2k91Y2b+Rt9zorcz93piaj2bWK4yhkUFy4djJXGn/tx8GHQgh
         hGsKxZG7FVqMkQi9J7YFOWexkp39kN5oTa7hA0PWlXgSWKknbwmDCFDQAw8RQfVRDENC
         mZWu5XFFSq7kMmWivgu7+MSa1pM/pzYs7cdLAP2wlHAzGVkadxwSgCdKYMJIWHg8kq+u
         40sg==
X-Gm-Message-State: AOJu0YxLYvUu0/Rr6DBDRW4KKdCVv1og2/mkX2fiq23L/0Ej9PkiugFM
	tk2pb+xfSngRtdZa7U4QH9UXKaN3kLq53fo4g4LIjgTUcJ6YkJPrDfdSGpPghj2jlLDvw72VHbF
	1uIoprA9TSLdCvACoq3tNThir/Yu+VkjENdHWCIp1+60FRfrzda+7Ij4ntVfjRe4ICXnGEg==
X-Gm-Gg: AR+sD12UMeoc1+i8FZC5j9nX8A1wwT0WkSlf6mwfSqJTHTqNuw6vhDpocN3mtom1gnt
	vfXx6WmOzXo8AoBJelAtkpNKnobm+nHv2HQyDVt3YuNLpCLLdOrt9gMW0xS+az1M9RdqJKQ6wDI
	jLVuA+tz6Un3vVKwe69t/W40ljD3kEpyVO/m5VOJQmYUszL7S7J88hHRo0jtoGwMujrUETN7sbx
	m2mLbz0zEficPIopmMMTZBtppHbv20hiQd9Ea7e5h1M1xfUfTrl4KXsq3z9T6bGZXfAeKTJYY9F
	T1K0nSObh71oFaP0Njy7i6J8rEK6KUXEeBj9pr9Q5GnhKsDU3fiGGWEXXwWT/wJIPEUQrO4XX12
	t9zEVMLJ9wPEwfFxMIshjlvzrFVIJCgQPzRYoZzJpXKq2ZuD+RKl7L2k=
X-Received: by 2002:a05:6300:95:b0:3c3:a1ed:3c23 with SMTP id adf61e73a8af0-3c44b00675emr6588598637.23.1784856691316;
        Thu, 23 Jul 2026 18:31:31 -0700 (PDT)
X-Received: by 2002:a05:6300:95:b0:3c3:a1ed:3c23 with SMTP id adf61e73a8af0-3c44b00675emr6588558637.23.1784856690772;
        Thu, 23 Jul 2026 18:31:30 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df0ba0asm22655306eec.18.2026.07.23.18.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 18:31:29 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 18:31:24 -0700
Subject: [PATCH ath-next 1/2] wifi: ath12k: fix overreads in
 ath12k_wmi_process_csa_switch_count_event()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-1-c01ef10bc6a3@oss.qualcomm.com>
References: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
In-Reply-To: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: 6iznWa0RfsQpjWj3DMfBcwDQxQox6jv-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAxMiBTYWx0ZWRfX/fefhXiUxNwY
 yz/S4/6N5Xvbxlbeysa7M3SN/QeMyz+K7EUR8QPyBChzviEc3ifFDZ4B+gJaqrbKY2xXjdlAWDJ
 iAJVewQZtQ2ZDyZkbZV0R/jpEZePp7k=
X-Authority-Analysis: v=2.4 cv=S7DpBosP c=1 sm=1 tr=0 ts=6a62c074 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=G0XfPlja2fIICZ3D3WwA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: 6iznWa0RfsQpjWj3DMfBcwDQxQox6jv-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAxMiBTYWx0ZWRfX2RJef5/WyVXI
 0gjjO1AUEz6Un0tpHbG5gxpIKLHzyzDYa5gktIoFM1aPQ/jFi7US/wH9FFE0X66MCNHoiyQ/FeH
 eG2CBrT+bDyNdcnGvoAZ0G5iaKxBUKPFK40ofvpaTFbDBnyDDf9AYph//zgg02GhWIvLOFe4XJr
 KxnldHIM8QQSWIwhNlgFhufuVPlIYktWtrpEfJX4BLRQqldzMTGhenPYTi/SnIgM3wLP9euWBUW
 ubuiaWJRrjITs31VK40neOw/+6vkJODpZ4k+nfJ8e8HexrvLt5ZTkZMl4AOO8GvH4x7bOzUIs2l
 kx5gB8YDjf+DNqd5ju0429N2GTYHoSrUhrSXkw/7e9ORW5cKWmr3sFECuSFQ2/ceDNfngbHb1Bp
 uneQMx7cc9U3kj42dyV3US7hSJSvmoG/WfVGHIfjA5vuHuRcyl9i9q5bgXS0jAxou3xxfpSkZbv
 bYKVqISVRNu/w/OP28Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240012

There is no policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT, so
the parse infrastructure does not enforce a minimum length for the event
struct. Additionally, the num_vdevs field is taken directly from firmware
and used as a loop bound over the vdev_ids array without checking that it
fits within the TLV payload. Either condition can cause an out-of-bounds
read.

Add a TLV policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT so
the parse infrastructure enforces a minimum length for the fixed-size event
struct. Add a helper ath12k_wmi_tlv_data_len() to recover the payload
length of a parsed TLV from the header preceding its data pointer. Use it
in ath12k_wmi_process_csa_switch_count_event() to bound num_vdevs before
the loop.

Compile tested only.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index ad739bffcf88..62a86f2069f3 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -207,6 +207,8 @@ static const struct ath12k_wmi_tlv_policy ath12k_wmi_tlv_policies[] = {
 		.min_len = sizeof(struct wmi_per_chain_rssi_stat_params) },
 	[WMI_TAG_OBSS_COLOR_COLLISION_EVT] = {
 		.min_len = sizeof(struct wmi_obss_color_collision_event) },
+	[WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT] = {
+		.min_len = sizeof(struct ath12k_wmi_pdev_csa_event) },
 };
 
 __le32 ath12k_wmi_tlv_hdr(u32 cmd, u32 len)
@@ -374,6 +376,13 @@ ath12k_wmi_tlv_parse(struct ath12k_base *ab, struct sk_buff *skb)
 	return tb;
 }
 
+static u32 ath12k_wmi_tlv_data_len(const void *data)
+{
+	const struct wmi_tlv *tlv = (const struct wmi_tlv *)data - 1;
+
+	return le32_get_bits(tlv->header, WMI_TLV_LEN);
+}
+
 static int ath12k_wmi_cmd_send_nowait(struct ath12k_wmi_pdev *wmi, struct sk_buff *skb,
 				      u32 cmd_id)
 {
@@ -9057,12 +9066,19 @@ ath12k_wmi_process_csa_switch_count_event(struct ath12k_base *ab,
 					  const u32 *vdev_ids)
 {
 	u32 current_switch_count = le32_to_cpu(ev->current_switch_count);
+	u32 vdev_ids_len = ath12k_wmi_tlv_data_len(vdev_ids);
 	u32 num_vdevs = le32_to_cpu(ev->num_vdevs);
 	struct ieee80211_bss_conf *conf;
 	struct ath12k_link_vif *arvif;
 	struct ath12k_vif *ahvif;
 	int i;
 
+	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
+		ath12k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
+			    num_vdevs, vdev_ids_len);
+		return;
+	}
+
 	rcu_read_lock();
 	for (i = 0; i < num_vdevs; i++) {
 		arvif = ath12k_mac_get_arvif_by_vdev_id(ab, vdev_ids[i]);

-- 
2.43.0

