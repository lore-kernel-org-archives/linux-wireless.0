Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7180743C078
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908581; cv=none; b=G+EFKnzmxxA9MWtUv76KRMjGCglPwwI0sDaiHu/+paLQEV7EJOwRsNdd/MR9dEOT5h5JU/vN5YBOLNvQkXZwhb00S8XqaBNJQtnJQQbZLCU1CrG0Q6v6TQREiJRbxsOTwbe2N973HXS/ZCKdvrqObTM5yCIKcdMsmc/N7bb5/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908581; c=relaxed/simple;
	bh=Ky1NaLmW1L4tCDSb3jb09Mafqan+Ag6fA+nxjr0s+Cw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d9ZeIUJOlIIA7eKrYxL8uYaRPruxzllL3DlKDldKDFVmAHBzoGzOkjx5/4YN1lnSZ73pTLdkcU1zhdKcctgChEO1QOYrOKzOqmhVDYbnDM7Q8Tl8nasaTsml2gY8F477w62myXwkQcnXq8C/4YnaXanRhOGqDX7SpwRf/rAY9F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K9Bn8QG3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iq7e42AK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K9Bn8QG3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iq7e42AK"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ODbFLM3487411
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HuAdqiDdNFYWjWTfl7xgWrhkU3MoDExevluyPmjhHwA=; b=K9Bn8QG3GNGyrn5D
	qqhySAoYk5JI4AAsV8PmSA3CDXjq71Kr2sSuqeEW4E2u3YHvmskmpfjM0EpAxtl5
	+QSpzviVNhHNBV+RQL/gXmmSvwGyQY+g78FrDdosvZsh3hKMGygEmFXdbDJopQPj
	jwtR8GztxZVJqNUrmgQ66SgNt46u2en4KA/xV/aLyO4cTMQjDip/OUQ3RIUBn37i
	ygzV4ctW0/Gwro7trq4IOnAf0kbTlkqCN8EmCbFosW9Dj6sgIrcrtTyMUr7vyUcR
	aILy8/VY5hLm6SolVlpjR+8KVW/b464DtvdQeBFTP7iJE74ZyxZztz7VtTU5Gxw8
	Dwrd7Q==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkqa0cg0k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:18 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e9fdc2870fso251479a34.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784908578; x=1785513378; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HuAdqiDdNFYWjWTfl7xgWrhkU3MoDExevluyPmjhHwA=;
        b=iq7e42AKBXrmGuSJONaja/Y1qQwtMHMzeN360mP7zTdmxL7TH2v2XcM+hZmbbpnrjC
         ktJEeZZHVPG4QwMnQL7NduvldTyD6H4RgwbA7kPr+DFgI77uVYvvG4KrAwp0V1naya1/
         sx9ANQqoO0enx7PnQcfmc2T5z524TZK53+zH2RX1M5SJiZsGoPPaKe/EpMq20reTJqrp
         PUmGMnQo85icnjtDVJmnp++eAN/4sffHulDe7f/jyHqF2X6ZR5XaUY9G5XQjAnq5cGn7
         znatBggkkpGGuoVzaSLf30a1umV9BimSYdsB9w0KgxTx9wvfXiedWmovj9JJg26VLrEo
         1Gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784908578; x=1785513378;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HuAdqiDdNFYWjWTfl7xgWrhkU3MoDExevluyPmjhHwA=;
        b=HoPeGI3dElS4+wr006QC1G3PECjqM2fyHthxnmhZ12t99TPPfa5mHwaoqApCoILpSg
         ay1Rr7+0cbmM2imc6yUtHsCAy8XeOgylXB2gsb11/HMovgXmHxfwzSaRMyGg9ivdTbC6
         ALH/dTYx3u1ilZOXZdj7VMKX+OcdygES6Iw0U1F9CrAJDbH4CMmtAEyU4HyrpCYlZi/K
         GgwQhoGystCNbdqzKi1NKEU+vs8dA116mSt4cyJ5urTpj0sLzL5+aTIzeGXjuNOrlYDn
         f57obL9v7+IXij6gnWTc7Ea+Q5XqO5V98TVI6W4cAu+CAjLoeYLg6AroAcKqTWfUWIIq
         qi3w==
X-Gm-Message-State: AOJu0Yy8E+lywdp94+qkzKTRVuwZXAjDaqjyxrnezxvBIdCc6NUqcBDk
	zAslBOzAzizSoIsrl9+s1Te/Apa0+TSwQniUtFmJEi38s9DdQR3ouM9yCPV5+RxYStsPbtNCAze
	EnRx0vtptGzcBKbLRna4dWVvcv+qmQbrfY15hXTR9p8X+Ly6SXIHG883LcQollfnpdyjXQQ==
X-Gm-Gg: AR+sD10UCQHqHHw9p7ffdMqCFn8L7DQppuy+x+m3mD69izXRybt4yICoTeCgH3U0lPE
	hL8CRAUm2j6fkgF3tstFAnJ76NAhGNG/Y7ECDG51tSUl+WDjPp90waCspNlAxZOUjITmwbqveft
	Zq2M9rOSr/TY9K1ZMx4vO6oKOS6BS5EwW0Y7on4T/J4j2hALG1wJ13fH6RKnb8QQmx7iRBv9l4i
	k6pJh8/K4WIl46VMXYly2pfL6kFfXnLvIHgfwxkKBmdX2Sd2OATGDpC77ybGxDJe1Z6By2rCWPK
	cRFE7mLAjqRJLsgrbyxA3A4AFDvVFa5RodIxk5ak3MT3OvZXSMphRs5zKJM2D8KbYhUIEVGXa23
	GvcW/nbsjAG3I3TNUxfHbDrvUBewl9X3+ZjM1zRSR3lAegFPZEJbq1cM=
X-Received: by 2002:a05:6820:f02c:b0:6a1:7181:6da1 with SMTP id 006d021491bc7-6aad3faa27bmr4236265eaf.18.1784908577762;
        Fri, 24 Jul 2026 08:56:17 -0700 (PDT)
X-Received: by 2002:a05:6820:f02c:b0:6a1:7181:6da1 with SMTP id 006d021491bc7-6aad3faa27bmr4236237eaf.18.1784908577332;
        Fri, 24 Jul 2026 08:56:17 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6aaf9385b35sm134591eaf.7.2026.07.24.08.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 08:56:16 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 08:56:13 -0700
Subject: [PATCH ath-next v2 1/2] wifi: ath12k: fix overreads in
 ath12k_wmi_process_csa_switch_count_event()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-1-02a45d7246c0@oss.qualcomm.com>
References: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-0-02a45d7246c0@oss.qualcomm.com>
In-Reply-To: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-0-02a45d7246c0@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: vt151qQXmoRWGcORGYlqQHJFkVkgEvrs
X-Proofpoint-GUID: vt151qQXmoRWGcORGYlqQHJFkVkgEvrs
X-Authority-Analysis: v=2.4 cv=e/k2j6p/ c=1 sm=1 tr=0 ts=6a638b22 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=G0XfPlja2fIICZ3D3WwA:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDE0MiBTYWx0ZWRfX5lUklUd61icm
 SWyAkSHG2hSfpoqM7GdGibnsLN6go7rsXKArKFgs8Rlp6O/S64+RJaLUOXi6jmyCnknSak1LRn7
 oBGJi43T4UGjG8nR6CS3LG1tG+ERth3Nxtqn7cM2NBhag1fhHgieANpntLGKtV/7Nwlj66rbQpZ
 T98wzyPaD+kV9vh19ZT6SJ7KzQXUYfwjHiA8YGRSP8yzSaB8ZM4Tthr/vG1xm3vioPckxukVmNs
 VKtiBces/4mibnotH4cZ4+6vTLXXcaO5u4h/zSqzy4/4uYs9aEL+zUx4ac3Ho+j6fUdvn4vGElV
 V8pvxvZ+NjVqZXISUBoTXmq1CmTUB72U4qbegy7NnTbVe0903oNQ6D2EascwGodbhmxzJGnaAl3
 dZZ3jXJkUdNdngvHAEuwb02Fr1X3xY5sqrTh5oiOc3yWyVWtS4VxZAKMKKQYe+9wAmRRprsy2dI
 BmMI30n9sDESackHovA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDE0MiBTYWx0ZWRfXyXnB0sxOdjha
 tzd6+MBj/IyZqXA9vkX82qh/gPMuEfsMlloL2NHWJIVvglUMcZU3tfsT2PoG8zyuiVvvAZ7Ozti
 PIZLXvMs3fjbAgNWpPP5TKcTsQR4kJg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607240142

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

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
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

