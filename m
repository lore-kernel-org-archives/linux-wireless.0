Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601531;
	b=WyMxP7HWoXZGvLD5M7sHLFx2o+UU/Xyz04zTZ5RtW7qot+juGNFNaZuIX1JtQ/lLfo23
	 WovvwjJjnN7Qedo4iDQoFfrlUqJRLN40idgMxrQXLJoajRRTyf4tbt0v59RSprQuE5j+u
	 hTVJAg2KOmVv5MuYi/nc2k0swFZHZ2Ua70uShL9FVIPYL22Vw912WP3aZ/k9CoqRIVtrb
	 nKWAHCHggjtLeNWabC8Vpv17ocdEZitP3SJCvPm8e/C82le1l55ZunlDr6L/K+sSXezOH
	 CfBq1EbFaBP3UD4rMROZohD3gZCKJtYuahLVs8Rk1SVVETze+q8VqhGd1EujWhMaqXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601531;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=OkDJiKq9UvkXpx5tpZc8Vu+HkAF1n11aZGZbN4YtcU8=;
	b=sl51BgBiKIK4OMzfSX8Xtl42HInTQOEZgN/PexgVIK84KaaMOJQWbV3eNu5prsvE5k9F
	 z16kCaxOGsLJK1S6rbxCKtW7/xxvdEWgk5B+rmkZ3A26S+ZfiFVMDZVLWVazIT1oEbnPO
	 rUUKHLajVIY9cuZ4RNJtisItB9Bz+nlPo7yWB1/op4hh51Nufi4bgYCqVlvk1Q5kpZPGd
	 5ofodnYXZ64IRDgExY/yVu4RLrMYC+xBpzt58sZYZqzEJahdC686t/ApqfjTtMwA9y8+q
	 eIt38uchN/fdlj8kZ6xe7p8ThQ8uee/NKWpq9pyIupwlPFHzBF1VVoUW3ePix9+cIAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FN4Q6ibA;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=i+TbdzbO;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B4C606A32E
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:38:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45B4C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FN4Q6ibA;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=i+TbdzbO
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vI0Z3324667
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OkDJiKq9UvkXpx5tpZc8Vu+HkAF1n11aZGZbN4YtcU8=; b=FN4Q6ibAvCLEdo7Y
	hBU4SZ4bB2e5KS+k0ZeYW17NNK8TQqCGGgHfPqpUKrYpB4ORb1XML9+L1/weS1Fp
	blE8EuTFUFr8NjL2XfZzn6OiG6ef78ZFBdBgTsAvEy78XrdCXuX8SE/r0w8DzGvT
	FHem23oD2/k3hT0f+NMCZLgy16TAq2G9Zqn14w5mOgo4RhA4tQGTvpEgamsuVqMc
	TqHFsr1gVTn+Em2qY9HB799FEcC9eIU/KPS2ZHF3gT2+8RjlOIwEeCLploj788th
	lX5uXswy3xTfZLpemKEigxF04I5ddERz61q4WnmRIFJl45LUneEyBjqrhHm0j58k
	mHx6Jw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7b6nmsm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:38:50 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad3fc547bfso3523907a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601529; x=1794206329; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OkDJiKq9UvkXpx5tpZc8Vu+HkAF1n11aZGZbN4YtcU8=;
        b=i+TbdzbOeYlOwIpX+/lTJSusGuEPnAonGdijCgBVQrmrH03DOLid5n6NaSN7oIKYSl
         vb3mVAV8EiONRgMhqTE+9/DF8lOVIZuzSVraIuDsYgmAvBHpgytcGp5mtmk1mVvoVcdz
         RINlcHMFjEkCTdk4K6RQZb02gL4a8eJjCXGP0DJPyM9t17rc9Q2tZ1Yrvh2rdxdZ5n6p
         YYEQlYRmzvYdnyecmONv9oscsnd9+kMh9DmDz4VPn6F0uMxJnonNo6tl2QxzBtXZKKxE
         Ig4hc5Imc1GrOLpyeYQLf5psTWiz9Nf+iPIcDGOkYcESe4i/IL5b7wY3YWfMjQF3nPIL
         hZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601529; x=1794206329;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkDJiKq9UvkXpx5tpZc8Vu+HkAF1n11aZGZbN4YtcU8=;
        b=EnAEbEdoo1oy75tuTCNzAax7YHGqIHgAiRI9wd8cz6qJ3MXj6HWht7dhV/pT3/jA7h
         jM4w8Vrkp9osdaC7YAYOQS6rtP1iJpv3H48sRAzSHH0J4JOIc2FNLCzB55+fjIORzsnx
         2unMGnceHXZRXs2N//aCMSBdMp+F7V/v+twC9P9kr3sfyJku456bgmL+6b07nuf0F8hv
         0BzRcgZiJ4SjvUQtIWds4YrulTJb6XcIhu7FtAQwdLRJpQcELaheavbWwbLY6vEC25+D
         NI9xzppSER95kmTqFGPOj6lpbwHMY/iRsdlNuBYfxCV/BO0ejv/+qkq3puRKh56JPEjD
         lkQA==
X-Gm-Message-State: APuU4Z9hr7Y6l+SWrlu/imo6B1EqWHXxGGasEuopDalSI8gGQeVfqd6a
	GtGOpp9Reikts2luJgplGSRrzTzUUX956pdVp09ZHWZrXg6Iv8k4uJfnAapCf6WddrJm5+A5zW7
	IOUdGIJ+z0QIO2Nc6oNk9w1r5YNfUeVmfS5Q5IkOYcQMgvGPjJjNooxu4z2Vo0iO4yAei5pwFWq
	N3XQ==
X-Gm-Gg: AYBFou3k1WjJ3bKThDHOGJALLYM4xoxW4wkj0790yCnxmDxcLncglI4HP8/25zVNY/p
	9zW7z4EoNjVKY6YeXSde7Zcb+5gczwLvadezhCoHE9phrNL+5DZnK7ePOQ7LVe6zxhHaceSfO8q
	Z7UcI/rADy9/b6SNf6/OrkXOAZ2bt3i4VqMT9IOPu++DwWVfnS1sREcxRl3Z909XfB0u2y9Cm90
	VDFhhqqvxjhJd8zY2Kdx9jmTOk3x5c1XQwzCh7/zL0ZMlgRlQYPYtqq4K4rfpDbY1xSjhdQfUbq
	NwzKVH29A5LHcLJQXOgyYVmutZLrW0WTcLEwZkPDhk3KKC4a7lqdtkT6+BOV/zJy40MJcoBBzly
	MWNKOTHLS74ExGbST2NKRbBEblt1/N/fxzEzG/HkP0K8dtWtdJxmrlr0pqS1JxseIb0A5PJezsk
	FfanagmBi/4gQrvFHeB2ILS1pi40Go
X-Received: by 2002:a17:90b:4c04:b0:3ad:8a14:bc73 with SMTP id 98e67ed59e1d1-3ae897b519bmr6563022a91.50.1793601529153;
        Sun, 01 Nov 2026 22:38:49 -0800 (PST)
X-Received: by 2002:a17:90b:4c04:b0:3ad:8a14:bc73 with SMTP id 98e67ed59e1d1-3ae897b519bmr6563009a91.50.1793601528635;
        Sun, 01 Nov 2026 22:38:48 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:48 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:10 +0800
Subject: [PATCH ath-next v4 01/11] wifi: ath12k: fix potential OOB access
 due to unverified hardware link id
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
Message-Id: <20261102-ath12k-logical-link-id-v4-1-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: NhuVtEQIH5exPfDDkV0V7WeLtnGGoSyI
X-Authority-Analysis: v=2.4 cv=QuvLTlyd c=1 sm=1 tr=0 ts=6ae82ffa cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=qtqQsJB7fzTjSEb7W4QA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: NhuVtEQIH5exPfDDkV0V7WeLtnGGoSyI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX/sa//5qoUwvA
 Kicuagqs7Tv0FstsQ0VBJ+LbYc01kIIzh1COu3OKJQJuYPeZQT8qL0v9UmzrYIhPZ42jqTD3JNq
 XWMYSeKbbYtR0Xti3RL/mi4jTjQ2Jis=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX7c9J1o3SYt2M
 Zh6awL+MbQYbpnra3ql2pVCLmUUqnqaiiOB/jquHvHDTwvNFGLYHPsEsrY5ZZ1/vqnt9uSrSpRd
 ny6CnTZ5nX4f7iD3mBy2mwsWzFh/2ID/vUaD/q0iDGiu/v+zNBNLX6uUNToFCgyod9G1idC6b80
 DSR4z7yTPZHMosFxXD+yWLxX3YUcci+T6nHe/z+LYlQe40DEjwj10thr6JaAVofZ4bFYkeKIM1n
 fjhI8UBeRi9yRE+2rW2arMXniXOXzEhytJlADW8Q5JSLMVkMbWG55ZIRgpQ3TYTRRf6kJFW5A0u
 57XW2d8YmitWr95MKfqEZqVcN4F8jKyP5He/Efp28ZUiu2pS0j5F03uhw6LH83p9akeKzlboeDJ
 3kb6To3osx+lAmUVNb8nX2cg4W4MtY2kQEy7A39H2z44jr7/jV29dppiwxhNoivgdJaRGji65t2
 FHVlFGculGPyMIvMU1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

In ath12k_wifi7_dp_rx_process(), hw_link_id is extracted from
hardware/firmware descriptor and directly used here (and also stored in
rxcb->hw_link_id which is used later in other functions) to index
ag->hw_links. ag->hw_links is an array with size ATH12K_GROUP_MAX_RADIO,
unverified hw_link_id could lead to out-of-bounds access.

Add the boundary check before using it. If the check fails, continue to
process next descriptor.

The same applies to ath12k_wifi7_dp_rx_process_err(), fix it as well.

This is found during code review.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a32c804403e8..c8e590e5e250 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -705,13 +705,22 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 		cookie = le32_get_bits(desc->buf_addr_info.info1,
 				       BUFFER_ADDR_INFO1_SW_COOKIE);
 
-		hw_link_id = le32_get_bits(desc->info0,
-					   HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
-
 		desc_va = ((u64)le32_to_cpu(desc->buf_va_hi) << 32 |
 			   le32_to_cpu(desc->buf_va_lo));
 		desc_info = (struct ath12k_rx_desc_info *)((unsigned long)desc_va);
 
+		hw_link_id = le32_get_bits(desc->info0,
+					   HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
+		if (unlikely(hw_link_id >= ATH12K_GROUP_MAX_RADIO)) {
+			if (desc_info && desc_info->skb) {
+				dev_kfree_skb_any(desc_info->skb);
+				desc_info->skb = NULL;
+			}
+
+			ath12k_warn(ab, "invalid HW link id %u\n", hw_link_id);
+			continue;
+		}
+
 		device_id = hw_links[hw_link_id].device_id;
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		if (unlikely(!partner_dp)) {
@@ -1469,6 +1478,11 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
 
 		hw_link_id = le32_get_bits(reo_desc->info0,
 					   HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
+		if (unlikely(hw_link_id >= ATH12K_GROUP_MAX_RADIO)) {
+			ath12k_warn(ab, "invalid HW link id %u\n", hw_link_id);
+			continue;
+		}
+
 		device_id = hw_links[hw_link_id].device_id;
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 

-- 
2.25.1

