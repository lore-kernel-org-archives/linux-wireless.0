Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754652;
	b=z0BxL46uUyW+f/vP49v+iI3BvbnbKXyktb0CcgqFtTbRbHzBhRS/YAEaS1tFowoTSD5v
	 5zw9SxMhOdd3EdIxtUsCpGjoXJZsr4t9hBOmOh41IPjNIQEEeV2KkbXn60aDltvJDWAPB
	 F1t37UDbQmmz84kR4Vnryf3+FvDp+Tp7zNjXG/DXhynieIB8qPbuj/s2kbOExcZ84y1mz
	 0nA7XJ/kC5YzZCifVdGgynA3gZh9VU4uGb26Mi+0uHVGDoGD1D9FlDNo3+qASDW4Lp4Ee
	 caFl5arFn3GLK7jqOzhHsGcRsjCyho0+/C31Kg27yjt0WRzf0SFN6DkScdpnNpYqDZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754652;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=D8YIDJHbFc9oxfzY+rT0pm1nf2Xr9+0RAa6mrgtbcJQ=;
	b=O/UYS2b2PxlCyIIF+lo7ed5JX3gdalYymKB6ixu6Rtxnj/zjMOSRJnxrzFseMJVyJ0Qp
	 y9u4JhDgxefFwxxJXBj22n+8tWXqgTbHwjMSv7cIomx3a2e7SXbsUKQ4y2Geb70AIeUMa
	 i6r9xeDbI2T+L2Pim8kizkidoYHUrhUEu6fSoWYRcgMz6k24eVr3SwoDePIWEoiOfgeDR
	 2Go9LwTslksbg/7R5CeSsHhmg+LtHutTQEqXqcyaL3FpWurGvi7u+XjqU9Or2VKDUuYzY
	 8nPXvh5OlcD6tyUtEETfZn17aLay+Bq+73yiScKOp9nuDX7SA6V6SAIi9L/jVkaUE7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fM6UyPYB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=aY2WOPRX;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F00606A32F
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04F00606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fM6UyPYB;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=aY2WOPRX
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40S7F94071492
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D8YIDJHbFc9oxfzY+rT0pm1nf2Xr9+0RAa6mrgtbcJQ=; b=fM6UyPYB2V2z0iYq
	qc1CwSIjDpeWo4p5H29X67tRSeQcAVdE0vwWdKI/BJUYhZOdAc4pXaqkSWgXfaCA
	o8s4FBSUnp+efxxl/eN0TTTTHaWpSGGqsTOyhJ7MhCCHvSsrhTGKfvNZqQ3z2saK
	5jr3IFKANFXiBCwsQYQUHy0BVPymT0dBUiUeySdwCscIv1fvF2VrWBCGneLIroBp
	H598VDAx7PSZKZ5CXk04prEQmFPOYOZs9b1qILIB/FagLP71McGc27EtUHPkwexa
	Am82oW2JMLkzcb9egd0aeYBGfrjqFjKvNO+69fcXi3CeE6ETU/+wCbyDxTkp3A1t
	eHs+mg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqh2bjm57-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:50 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3662e7a9299so546947eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754650; x=1794359450; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D8YIDJHbFc9oxfzY+rT0pm1nf2Xr9+0RAa6mrgtbcJQ=;
        b=aY2WOPRXRPb/8lT7GX8h5esVsmJytEsJ7VztRlJ99AMDnJJcYdU4f/pKrx6h39VfEv
         2hB3EDytPanNK8DtlLqUKpuRak4eq0UaZPD1IbP4AxLjyqr2PrruGStBiaLcaK459nds
         URTVrgreE8Usd32Bh32PLsXT/Dm+pyzAC2ny97KmMAorSqhRITD6raLmyey3OL6QRRAL
         Z1FElKoHzHkTC0hgVuPfIJWj+ed52DvSPkr0ncEsBUk91bqJWgZiGWw0oLoEd3/WroSg
         tul5OlkOOqBoUFKo/5siIxZg2mPXXWQ4kpV138FftgohjglqfVjWIf7AnAmSdz9V/7mq
         kQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754650; x=1794359450;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D8YIDJHbFc9oxfzY+rT0pm1nf2Xr9+0RAa6mrgtbcJQ=;
        b=H/ssYTHQCohor4XZ3QRbL50aAEvmrHubMt1Z+22QdcnpaPXKmZDwM/c03rnESUSkfs
         Ka5Q+5eoHnhZHzz0LF8BJhnz6hc8iWKRU4UTBAM1J75zefXplTLV7/sick2O3GV6eCSw
         Sl5gfBo2TsxD4HyEEfz3j7RuCK6VoUzN8c2m8Lti8Cs4nPFuBvroQ176BLe1vBBBDZAw
         k8GN4FxOQN7eUF1KOOBXwLyP3xIewFvNFT73fXtPOeAjQX3sy1MRMrOWQGV+eNEKmACj
         MFmJU0fdUZmuGjEqyP/xnz9MQAnhaSBGKk+3AuyuoLvrfa5jrbeSjRzEmou6JCa5dABE
         lxTw==
X-Forwarded-Encrypted: i=1; AKwUvBzlC+haZmLB7Xmms5iXK/3M/IkzZ17sHc+nrTneeelS1jnVJlcFTZ4JzlFexvljjCokU+X+znJl1/7oh1DKKg==@vger.kernel.org
X-Gm-Message-State: APuU4Z82yaIHKXoqRNVjxUSJ54pfE1PWbflPXp+cI4JrXulPsOgPcnj1
	9kNu2r3lRxh2u438BuDOig8BglC9r2YfPyCxWEzDvXHQ5c6vLYiYjbrmeht7pVIdRvK5V9XYm3w
	ZPwOoEv5fXn6ZULuIGvZStJroL8uGU4CERaCPLHfqsP6Tg1b8zv6j0eNJIPDfYyqFe6ECbA==
X-Gm-Gg: AYBFou2QdgYL39V+fY8Qeh/fsVPENPlCntxhLWmF0IsfmSYl8cbtxh7iBspmOKsj3dR
	VDKD1olFuBWNllhirCKlEM78LLhFOjJn61vRyhnpG5ty5rKxr5u/imGo4lXTiVYnj3qqr1MTLeD
	cQ01o8Ds/7Y4hRSSt88IaDnFeb+e5ygBO+V+WRVEj0zbQ/Iq/Dh8DX8U+xoqerzLuP4t0ZzT3D5
	Jv50xi2JzoaUzLX5ZE986wzU4tfgVlhwQNhnnKeHyxJst6b8hCVndLaHCHzXRGbucQcVbNlR1Gh
	4r2DfDZBSj5u8ntp/wFUL3bdE+JaY6IrO9Ln/PYRcCCwVCEid0Y1MteounhnykdhljwiFRsjbLU
	gyy1EBSsYhtdfrNg/SwByRM5zgB9YuJSxZFu4wWfzdH7krlaQuLEB1g3218vnsavwcu94bGJkOp
	0BHvIQiRV0A+eTrep6ylqbujLsnEzvrEHqojuy
X-Received: by 2002:a05:7301:18af:b0:36c:9b35:5d45 with SMTP id 5a478bee46e88-36c9b356dd1mr3626628eec.25.1793754649742;
        Tue, 03 Nov 2026 17:10:49 -0800 (PST)
X-Received: by 2002:a05:7301:18af:b0:36c:9b35:5d45 with SMTP id 5a478bee46e88-36c9b356dd1mr3626604eec.25.1793754649242;
        Tue, 03 Nov 2026 17:10:49 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:48 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:46 -0800
Subject: [PATCH ath-next v3 03/13] wifi: ath12k: ng: allocate REO command
 context before submission
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-3-861adf04b516@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX+izhGw+9LXbv
 S4T66qUznCSarOpVFEzmcBSwTh11A9sLaSsqCVv1rJ9ReHCZb9lEegILb56os0pZCm1pXtFuxz4
 W0cjEK08LUMXUbrXqqiuJQ9++5UnUYY=
X-Authority-Analysis: v=2.4 cv=Xs1vqlF9 c=1 sm=1 tr=0 ts=6aea861b cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=tQMSYTo8XKOll51RSuoA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: YNgKB7DPvBagxEPt84-u_KZPruJbtrhc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX0TA8YVsj0mZG
 DF5CoHxC/Qd4JjlagrLtTsjWtsnTshTsSCWBJ+2c0pHVuAvlqHrNjs7GGy/qwTjmYpJ4Aog/zd0
 9qUNBwaQIUBycpddBpqHlH6vNhKuALTIwwk+GFI5LVZqWO+RQtB4Z8QNPtrh1MZzo8eEhK9CMUI
 4eJyRXJvj3aXbaGoNqXE4CZhb8KCHalfhduN0nAbuwnnPuQWdsrAUaSKDMXnl3apUNSspT9xiv+
 0psXPCvYz8BLt7YN7ZOv4NdlRi03G8E68Vuqt9Kie+J2p5sEnalYVA+9yCUnWw+Ckxu/AJe6und
 SJ/BwCU/SFJylpFUXOIACinGlHdq2Avq5lJfwrlskYz5Bx28KlNcwkksTLzhs78VQrDhmkIHWCZ
 7usHROOSbnR3Vb2nYW4tFepuCvdp2PIdfWJCTMMwlo7uSm1r/YSaNRW8MeKNlAFkOSMMpiepk6c
 VQ8S5LQXSP3OLNxYjfQ==
X-Proofpoint-GUID: YNgKB7DPvBagxEPt84-u_KZPruJbtrhc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

The Wi-Fi 7 REO send path submits a hardware command before allocating
the software entry used to match its completion. If the atomic
allocation then fails, the function returns -ENOMEM even though the
command is already in flight. The completion cannot be matched to a
callback, and callers may retry an operation whose first command was
accepted by hardware. This can skip RX TID cleanup or issue duplicate
queue operations under memory pressure.

Allocate and initialize the pending-command context before writing the
REO ring. Free it when hardware submission fails or returns an invalid
command number. Commands without callbacks continue to avoid the
allocation.

This changes only the Wi-Fi 7 command sender; the Wi-Fi 8 ring path
already allocates callback state before submission. Found during code
review.

Fixes: 52c555680bae ("wifi: ath12k: Move arch specific rx tid and related functions to wifi7 directory")
Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k
Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 35 +++++++++++++++++----------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a41049e7b425..d3ed2134818a 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -148,30 +148,39 @@ int ath12k_wifi7_dp_reo_cmd_send(struct ath12k_base *ab,
 	struct hal_srng *cmd_ring;
 	int cmd_num;
 
+	if (!cb) {
+		dp_cmd = NULL;
+	} else {
+		/* Can this be optimized so that we keep the pending command list only
+		 * for tid delete command to free up the resource on the command status
+		 * indication?
+		 */
+		dp_cmd = kzalloc_obj(*dp_cmd, GFP_ATOMIC);
+		if (!dp_cmd)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&dp_cmd->list);
+		memcpy(&dp_cmd->data, rx_tid, sizeof(*rx_tid));
+	}
+
 	cmd_ring = &ab->hal.srng_list[dp->reo_cmd_ring.ring_id];
 	cmd_num = ath12k_wifi7_hal_reo_cmd_send(ab, cmd_ring, type, cmd);
 
 	/* cmd_num should start from 1, during failure return the error code */
-	if (cmd_num < 0)
+	if (cmd_num < 0) {
+		kfree(dp_cmd);
 		return cmd_num;
+	}
 
 	/* reo cmd ring descriptors has cmd_num starting from 1 */
-	if (cmd_num == 0)
+	if (cmd_num == 0) {
+		kfree(dp_cmd);
 		return -EINVAL;
-
-	if (!cb)
-		return 0;
-
-	/* Can this be optimized so that we keep the pending command list only
-	 * for tid delete command to free up the resource on the command status
-	 * indication?
-	 */
-	dp_cmd = kzalloc_obj(*dp_cmd, GFP_ATOMIC);
+	}
 
 	if (!dp_cmd)
-		return -ENOMEM;
+		return 0;
 
-	memcpy(&dp_cmd->data, rx_tid, sizeof(*rx_tid));
 	dp_cmd->cmd_num = cmd_num;
 	dp_cmd->handler = cb;
 

-- 
2.43.0

