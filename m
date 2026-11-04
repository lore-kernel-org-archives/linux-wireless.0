Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754662;
	b=RojUTiX41u8rJKtawe02ku/Djw/e0SaTiREJfq6BxnzQh3/dXYul9JTq2BXQEr+EoMKI
	 vL05KofdFLrJ1e8dUZGHSgTpNEhWVheOi9oVY8oHy/KWh6JboHFpMXSg1yIApaul7hkpG
	 7wp0ZOR2kE0SPPVUeHtFQ4uG/Q49i7Y5L5InUNPDPUjId9oqDhus6CAMxmHFg7+CksU4n
	 lnht+8n6tQJfsmLFQoiLUEh2P2C6VR5kI7CWxYsxH5EBJLNnHCQmaoR/BSIR3TTQIJY1/
	 yTioPp65gaIdIpPgCkL4MmOM3hupFJE9K8hAGnQWq9HXdhfHU8mxmSbm70bdAkUareg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754662;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mdMqrqYmZYMbZHP7GOIz5k4MhWocLVLSTzSlsjp6QQQ=;
	b=n13rFVzwHJ8grPm5Af7jaOuo2wXVgx0bdaCNciM/1o0pCi/5gDHWaU3m6VIEkw4bER+R
	 yenShRffOI8tfyw/pGA5XKeLNTfGhmgJOnF1Jh+K9T3Neg3KGZ/0wzpaLzGsrAb6oawxA
	 tz4ej8YzpxtIZlVUtdSwSf7t8n56F7TRY/CQft3cpBA1qP5bTJUFZjtIYrqpCjNuNIRLV
	 Dcf4vZbCDg7ArmK8dS8J89IKJV7iJShdH1EKzYQOROsyHCTp93umj73ndRcNXN0sP95Bm
	 Wf2e3QKe+iwem2eVfRoP4mI681WkDdl9ymBdVzTbNIlvdJ9bTKSBOvHsThb0ViE2MKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OoxFEsAN;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RCxRtkIT;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77116606D814
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77116606D814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OoxFEsAN;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RCxRtkIT
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RD673335329
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mdMqrqYmZYMbZHP7GOIz5k4MhWocLVLSTzSlsjp6QQQ=; b=OoxFEsANc5Oaa+sw
	kmCqmm0LIE1twR/DNSv5P4Uh3KP9DHbkQlhcj3sxyN0tULNk20vLQ+V0lIjC1Sgh
	/8bBTPHs30D+183dXKeryEU8Co9sQvqbP++SFWGMNjvKwuax0Jw8qba9jD7OzHAS
	LyEjRpknFdhXnEn/B9csrTpJrsCAIwf24f5EcnBoiOPxKRUdbcl9Jgri/O2KBfQN
	ZApFCQQiryzhU5buTaTQCos7yuLSFwchciHDtyZjKftytWXplGCR4k+8p58mYcK6
	VjSxRb1MXLrN+EG92t5ApRp3hBkdh7quAPzFBMtuItNH2Wp9WcJv3qP2AkmkUgmb
	4bG1SQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqmjbsfac-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:11:00 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36ca254ca2cso264920eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754659; x=1794359459; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mdMqrqYmZYMbZHP7GOIz5k4MhWocLVLSTzSlsjp6QQQ=;
        b=RCxRtkITDspA65U72tZOgaWp37g244MdqNXmrHuBMjCEdKmG9qzgQKeSbO/6Y8P4u/
         mGS/UbfFkMWmGJAMC0aYIl+GaQeFuaWO+eo0+x+je4YT4VQaBgMkCo1t1VwKVNftK/3u
         FxJpfb27MNbzHp5mZlqh2sTMzUG61UAbFJ/XUxK3H21MByOZhM7DKBpyXufGiR6mmE7Z
         GhuGsoG3VyQlQuEoNlMDQBjL7xbnIzCNtdiUsZDtb3D+js09a+x6BQ9D88C52zubrQ9y
         1fWD3fSxKdT0W/FUi9GnFIbK7pcSc7M44rg0dVPDRlc6Ww+3MmLIBe4apl4AXLQ3gHi4
         kZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754659; x=1794359459;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mdMqrqYmZYMbZHP7GOIz5k4MhWocLVLSTzSlsjp6QQQ=;
        b=FXVELgmqX0rtgVFSW8GdqzrUF2XwYqzCrS+5YEZ6ZmejJ0BNWTj6OiamoozYOJPt2l
         T5iY2TiMB5U3EEXqsu45RY0JPd3ju4VwYsQ2OHSmdkipyDY1IhuTgJ/pN+q5PH15fQ4S
         EjSUBaK8he4Txi0T2csfvM05pkIgb6XPwQIvEypFGNF33eNstixAQuDv/5jl28fkHFLb
         dQmZBqw2XbkR/qT3G5jp6BSCB0TkqLwX7dlcshGBKrhRfxIm+Cf5HpjZEn/6k9IWawEN
         65TbbfwSoky3zKBWT/jiq/CUJVuLhypw4VOAaDYXQU/dCNRJBg1vP++3qGH3tU61/ENs
         1aVw==
X-Forwarded-Encrypted: i=1; AKwUvBzLyTPD3vxiEpQUHMP9pBHYzt72ZdLyyLFUsPQnB8iTXaLAUNp/g2+w9Yvu0mDJKkodyRnIjuFQ6GdyZv99Bw==@vger.kernel.org
X-Gm-Message-State: APuU4Z8hyPRZOnw0trz/ExxA8c7jW3KoM4xduc5GLSNs4Qz4SZKt9Npc
	ZHOPiTBtl2afDCnmwJ4iIcYCiuQvjkCDdXn7+68tHnU49cIu07kvMb/h8HLQs4EB+L5te9hiGEL
	QRjMu79FCPU9a9LxrBpkcygUrU+sYPP2n9sFZwLNmIOr9oPKG+ejc0pQyeWPkAwU2fXNutQ==
X-Gm-Gg: AYBFou3BkEs+ILUE7I69+Xt/W9Y37m9lotF3tlWQ/VrQ8veF89BStBBb5hJHDaPSH6m
	ZSyOnOo2PO3flHxLGwBc8MIOcYnws8fXxstH7uNNOUy+HQa5ADFc4IOF+P80h62jMklQBc5wzBJ
	NDEVuJQ43uMfghjEvS4bZxolcffK9RhS1jBMQ0on5Tmid/ZwlnHVzGTl5J4h4XdSFdqf50wXBXt
	FDnxqEjAJbbNioE7wJhKADrzt90W5/oKvrjOo7BHGFYDSWgCaZum6kfuLB4hjie0uAbdnBdAazh
	KtjdLnLJph9922F70ijuSoxVdIb1u/GtFqbQiCsraWkSq//x+9GTJvanmPYgz3FwOS2bhpI/14B
	2fQfCm9YxD7Jn6hnuyXg/H+s28JabuAjHag479eKRfS1uDQ6OiESNN6xFNyBcjEsIVXq7365cLp
	MZ7/gOZrUOmXJl95Q7oGTNq9JEAN8xbA//oHMr
X-Received: by 2002:a05:7301:6492:b0:360:34e4:39d2 with SMTP id 5a478bee46e88-36a423312fbmr20105933eec.10.1793754659439;
        Tue, 03 Nov 2026 17:10:59 -0800 (PST)
X-Received: by 2002:a05:7301:6492:b0:360:34e4:39d2 with SMTP id 5a478bee46e88-36a423312fbmr20105905eec.10.1793754658842;
        Tue, 03 Nov 2026 17:10:58 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:58 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:55 -0800
Subject: [PATCH ath-next v3 12/13] wifi: ath12k: ng: wire RX TID REO
 operations
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-12-861adf04b516@oss.qualcomm.com>
References: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
In-Reply-To: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-GUID: ZdG94jkuejfUF1yq0nCzd4zHANwrk0k2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX2buJQUkgqgym
 DcbHCEAeMpG2x3pDSya/qlGA52ebBaQ9Sey9pjd/xmED41U85daJDVn9i6lGFWR8xN9ZuyY79C9
 YmbOMBcg286awtj26qiN7gaF37EQ1VSILcbM59O3uBRln3HN18TEu6YyxnmFI48/lCko07MHMQv
 WPktPQ+32lvMW+626POnD4BkyZJ/UG8e0J7u7ZPOhMyt+81MCxa133dY76I9LFhwJvS76JoQysW
 X1/rJrmyGPFEDr7JNM2ZU3/AvUwrl4YCReM23bKDz0ekTtxgjjnCiJ9hggNs8co+cVDqrJQLImo
 ogs3Te4AkQLe/KA4XVNG4t1VKU0sw1OqnvZ8RNb/Hc+Pu4d9b/4sTsIepjX7TM9mywmcdbBhYvr
 KlXB61Bplg1yL90tntVBfUBWL4YYUIEp9BqNt/ju/B06yzr2/DNZwlvGCp/BwUG65HmnsWR5kki
 nB9Nf1+ItXZUelgKkUA==
X-Proofpoint-ORIG-GUID: ZdG94jkuejfUF1yq0nCzd4zHANwrk0k2
X-Authority-Analysis: v=2.4 cv=NMhAaE6g c=1 sm=1 tr=0 ts=6aea8624 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=bm8WxbACC0oYRj511PUA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX8F2J+jAVZSek
 1dKQO6B5qqw6vTUCGTiVgZMqHmOfixXoj0Wcco9tcrFjSJoft+daXdXw1lBwd71tr9+x82ykkiD
 cVj8Qcyua5GfsTtKavZY+gjykabqRp8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040004

RX TID setup fails on Wi-Fi 8 while the architecture hooks are empty,
so common peer setup falls back to paths that cannot program QCN9625 REO
queue descriptors.

Install the Wi-Fi 8 RX TID hooks, initialize the REO command/list locks
used by those paths, and enable REO queue LUT support for QCN9625. Expose
the single Wi-Fi 8 REO LUT through the expected ML pointer so common qref
programming can use the same address table.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k
Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi8/dp.c | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hw.c |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp.c b/drivers/net/wireless/ath/ath12k/wifi8/dp.c
index e89826f33206..1e636e79fc32 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp.c
@@ -197,6 +197,9 @@ static int ath12k_wifi8_dp_reoq_lut_setup(struct ath12k_base *ab)
 	ath12k_hal_write_reoq_lut_addr(ab, dp->reoq_lut.paddr >> 8);
 	ath12k_hal_write_ml_reoq_lut_addr(ab, dp->reoq_lut.paddr >> 8);
 
+	dp->ml_reoq_lut.vaddr = dp->reoq_lut.vaddr;
+	dp->ml_reoq_lut.paddr = dp->reoq_lut.paddr;
+
 	ath12k_hal_reoq_lut_addr_read_enable(ab);
 	ath12k_hal_reoq_lut_set_max_peerid(ab);
 
@@ -215,6 +218,10 @@ static void ath12k_wifi8_dp_reoq_lut_cleanup(struct ath12k_base *ab)
 				  dp->reoq_lut.vaddr_unaligned,
 				  dp->reoq_lut.paddr_unaligned);
 		dp->reoq_lut.vaddr_unaligned = NULL;
+		dp->reoq_lut.vaddr = NULL;
+		dp->reoq_lut.paddr = 0;
+		dp->ml_reoq_lut.vaddr = NULL;
+		dp->ml_reoq_lut.paddr = 0;
 	}
 }
 
@@ -519,6 +526,17 @@ static struct ath12k_dp_arch_ops ath12k_wifi8_dp_arch_ops = {
 	.dp_op_mlo_init = ath12k_wifi8_dp_op_mlo_init,
 	.dp_op_mlo_deinit = ath12k_wifi8_dp_op_mlo_deinit,
 	.service_srng = ath12k_wifi8_dp_service_srng,
+	.reo_cmd_send = ath12k_wifi8_dp_reo_cmd_send,
+	.setup_pn_check_reo_cmd = ath12k_wifi8_dp_setup_pn_check_reo_cmd,
+	.rx_peer_tid_delete = ath12k_wifi8_dp_rx_peer_tid_delete,
+	.reo_cache_flush = ath12k_wifi8_dp_reo_cache_flush,
+	.rx_link_desc_return = ath12k_wifi8_dp_rx_link_desc_return,
+	.rx_frags_cleanup = ath12k_wifi8_dp_rx_frags_cleanup,
+	.peer_rx_tid_reo_update = ath12k_wifi8_peer_rx_tid_reo_update,
+	.rx_assign_reoq = ath12k_wifi8_dp_rx_assign_reoq,
+	.peer_rx_tid_qref_setup = ath12k_wifi8_peer_rx_tid_qref_setup,
+	.peer_rx_tid_qref_reset = ath12k_wifi8_peer_rx_tid_qref_reset,
+	.rx_tid_delete_handler = ath12k_wifi8_dp_rx_tid_delete_handler,
 	.dp_peer_create = ath12k_wifi8_dp_peer_create,
 	.dp_peer_delete = ath12k_wifi8_dp_peer_delete,
 	.dp_link_peer_create = ath12k_wifi8_dp_link_peer_create,
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hw.c b/drivers/net/wireless/ath/ath12k/wifi8/hw.c
index ed3ac770e754..a7da8b3a44cd 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hw.c
@@ -211,6 +211,7 @@ static const struct ath12k_hw_params ath12k_wifi8_hw_params[] = {
 
 		.current_cc_support = false,
 		.ring_mask = &ath12k_wifi8_hw_ring_mask_qcn9625,
+		.reoq_lut_support = true,
 		.num_tcl_banks = 128,
 	},
 };

-- 
2.43.0

