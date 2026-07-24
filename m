Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7D441A54B
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908582; cv=none; b=Btpu8I0lp4XKQAehYTdSdvy9Gwl1kgvQqsZcHaKTynUQwJXpz7IJD9P2RuQTvvv1qLxJhyFhotALBio0PmvL2fsz8qRlwsqSsVf/qIZ5uy5U3erFrHcMxz/6cXTY1FHTZKVQAxbuWSR0RXJphV/bz/2BEmTJMyeIrLCz45Ho76Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908582; c=relaxed/simple;
	bh=LBgtkloE8/GuU9yJTLYgyOXeGRF1BLbvlP9EB1886kk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mL8WsB5LqgRYQAvGqocSGhN5Xe0+9BK7XH2jhDRSjItL4rVATiJEjth9y16p6CPL/DY5DlrATBGwkCJaqgrIxKR+R0ixyusN08GUwOvkl3pwvvoUMQdIN1bTMj72rJjEUjpn6yGu/Reif20k8JCr6MtztPdAuFOR3PNTTIHksvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SVYo7tiA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T2k8Omzk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SVYo7tiA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T2k8Omzk"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ODbG5l3178246
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SRwsegGQKk4SAG9Z4lzF8xh53Y8v5nzSjwOE25DwPT4=; b=SVYo7tiAI95+TcoU
	0beyV5ls8kb4o7GBtEC0KiPnW8jRk7R7Qj8/6vKiozh3nRNKcTDGGx9QTZeOC0wU
	at7W8j9pO5gaUmUzyQQ9WcYpLnXb7qLBdPMQIqNZNJ4ONPV4URXFqD5gz19VP7z+
	rCC17lfJ0gP/cE3xE6jzTlKRn+4xNoGgXfeu9M/E7wwM6e4rcvRrU+pfTW8M7TRF
	mb/aPVEcy0sKZEqV0qOf0DNHTCTyegdhs7uLApYPfgeav7iBV8Ms4LGlp1d/f5uK
	cdwFHVcOmcUywRwaSZcn26l3f19WE/qCIyPxWFm8XwzGrIDA/nTrFyR6Q0i9HiSF
	J648CA==
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fm5yah993-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:19 +0000 (GMT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a17dafd042so367703eaf.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784908579; x=1785513379; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SRwsegGQKk4SAG9Z4lzF8xh53Y8v5nzSjwOE25DwPT4=;
        b=T2k8OmzkggaI5+zErMleFCIujpkI7XRoRwcSl2YxGlocRxiADTIa9tHPEHhx78rKcG
         Z1O3Z/wQNdjvEg5gfXBXU1gCOSeCFWFrt+d/yozVAD9iOseuMkgTY5LXgIk9U34/cCKx
         P0TPINclT83yhUv1Do4s9sgw0K8MkelKpMRMqlkmcatuzTn5rRny5TZwFohSY0k//ntI
         5XFnZeuWXkE6eigMUbbiKPQNxp9MVpfTIpCLVuWxnQOy77DYUsPh718JAQ/e9wUE/Wl9
         /zRUieb6Lo9z1cIJ1NOp9X/MiVdP2i9Y0TbFacXjirC6oNZCSvrxpC2MwjgDQCFngETR
         psOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784908579; x=1785513379;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SRwsegGQKk4SAG9Z4lzF8xh53Y8v5nzSjwOE25DwPT4=;
        b=eNv37M8M0O4DPgcGog3jDJb/iv71dg2Gjclz9LbsP7heH3Vn8YhtEyt1x1fR2RgzG5
         Jx2wP1MIUyem1dPk2IfYo0hkNbSQTDHwjK3N5rXtl72TGc93IAenmbSRdDA9IXQ1XJHR
         IrxzqJR37seSwQP3YYo9quvlZ7F9mpexlfzqGrzlQTQtJ9dJr/6VhtnpezYMhAGZkYp0
         N30Jxa6V3jbR+OLhsDLckzk7xWoVFOjYSfm6T7EnAC6bSd81feaLwk1EhXVl+c/JGmwk
         VzC76xgWQOxtJqgv7qGd/IqXXhykTyJE9SYJMexNZhLQnT9uh2Pw7BYn+za2dhYk1pNH
         RSQQ==
X-Gm-Message-State: AOJu0Ywi55l+N8hLW5OeTV4q4sUDAjKdN8c2mYqCopHWEkEBuBo9ax5Z
	s/WXrgCTQ4TyUwxbcHv5zjMWY49ZFZfHix20tv7jFBZByobuU9hdML2Jzc3OF6ViVqVDyo6kZ47
	clgl/BAvv8dN9djEYn5Md1qHGrPBRTU82Uq0Cil1UpE5g8oEFpD4xB+ngOadGlLZBOqB0KQ==
X-Gm-Gg: AR+sD11Qi37DWVRGVgVkK7YX+Dx0K33gixPu7dHnnh5j9sCKH3GmGWHScSG2jAOg+lQ
	WNtyjauhD8ZP7+jwTKPM21im/JMR4bc+WPW86ls3O8zM54OT9gYglc2+Z5uaC8NjJn4HvLJxcu3
	aK7Aj1qzPIMFaC2TI+wAdMzKTYO6GMGyGlW/aPsaorPDhvs37iFgubQcMFpQsVWSS2C+5uN1QaZ
	LqNKKLjQfOcvHohg7OX77TakbU9gtp38eBwQvB2tEab+b4VRI67AQRYxHLWFsptqmkqeD27IPPH
	oWQAU3WA0mesxWoR9Wx0GYUZgmfcl7EfLu/w0H9FJvmLs/Zm/SfHYhJk6nT1MdPmb1zM1+YLxyP
	4pvDcHWz/AsTT3YbjQq/CgMnNj5u9IbJJLsgjI10Y6794HRFE884k1ik=
X-Received: by 2002:a05:6820:a05:b0:6aa:2fbf:bf4f with SMTP id 006d021491bc7-6aad4148874mr3737942eaf.44.1784908579073;
        Fri, 24 Jul 2026 08:56:19 -0700 (PDT)
X-Received: by 2002:a05:6820:a05:b0:6aa:2fbf:bf4f with SMTP id 006d021491bc7-6aad4148874mr3737914eaf.44.1784908578674;
        Fri, 24 Jul 2026 08:56:18 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6aaf9385b35sm134591eaf.7.2026.07.24.08.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 08:56:18 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 08:56:14 -0700
Subject: [PATCH ath-next v2 2/2] wifi: ath11k: fix overreads in
 ath11k_wmi_process_csa_switch_count_event()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-2-02a45d7246c0@oss.qualcomm.com>
References: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-0-02a45d7246c0@oss.qualcomm.com>
In-Reply-To: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-0-02a45d7246c0@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDE0MiBTYWx0ZWRfX9H8+wxBqFOuq
 VYTuphTcjKKOMnoxrWuTiDIe67Vim++mgYYQ5XBGZ2SJqHihQbJPcOKoVFV9hXmWyLmTwvdihs9
 Wt8bJl8/aEGJocFPfzHSSVvYeGfvYps=
X-Authority-Analysis: v=2.4 cv=Rtz16imK c=1 sm=1 tr=0 ts=6a638b23 cx=c_pps
 a=lkkFf9KBb43tY3aOjL++dA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=hOGj4-57aE1FpqoUBq4A:9 a=QEXdDO2ut3YA:10
 a=k4UEASGLJojhI9HsvVT1:22
X-Proofpoint-GUID: Or3WmEOJNDvT47pb5Y3PtEw8uvjlDQxE
X-Proofpoint-ORIG-GUID: Or3WmEOJNDvT47pb5Y3PtEw8uvjlDQxE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDE0MiBTYWx0ZWRfX3auKx8Cm6zvd
 ckP4rSBsD4y+1dMVv+YfmllJAoi0PUMHLX75yXuYWpRIBX0jmgJHEAy/Dw7wubW/OnkLVtmxpus
 P/py6hqcmvzI1CC6V2NtBwmg1xqfSIzSbr7Qimyqmi6BHmOL3dHnAV3SQf+s7Dd/LAAuhSrct9Z
 qNGw7vFxXI4e9iXQBUJkch+6MkeKzOOxhunYS0iIZDn5Vz/F8cCLOfK17kIxzyStZt05Qeo7ixn
 U8AWluMJWm9ITUu2T/Ag6tf9sZopFDpIaH8BONHWlnJ8vUpuajT8gYXIg9t2kWU/lvJGNZYPJJB
 4ow1yowUszj1ftD3B8Olt17Vvz0Aoc1G9ZS7jTOKFMQZECws7SlDcRqTikTaZqwgwjUMRVlEunk
 VyXqByGXLyvYJuUB5TGthiv+HzF+GWunNXBDeCJ4USfOFTACLMb1EY88qFX4hLUcIVxtd+qm2pW
 W35GzJYI9t9xYIdyOPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015
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
struct. Add a helper ath11k_wmi_tlv_data_len() to recover the payload
length of a parsed TLV from the header preceding its data pointer. Use it
in ath11k_wmi_process_csa_switch_count_event() to bound num_vdevs before
the loop.

Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
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

