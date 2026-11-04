Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754654;
	b=ra1NuAj8wwZjZVB48X3U2OG73xmEYZpXc2ly9fNZZHZnCULcWSasGh/HJQRmOeedxPjH
	 ziO4oTzPF6ybaLNVukG+eEk5HQCxTsBcbxPbk6z17Ccu5pV+l6JawdfyETUwlUs39eBEn
	 XRe/dL8U/tShkq7aN+VtcGNA8zAg/O+X5pOwKBLs3EM9LfY2DYBCmJP8Tt5aFgR3qFq1t
	 ZYTzbYCd8wmytF+7rnZQsoF2hkH1jUjnBaZMLKVvt/y/0FqFLGovdKWz65UK12VVTloKD
	 Tt+FQJyXHpZUlFN3lRUIXXqKbsVfehIzSRBHuSwZSQB5MH3vj5ISnXLVzFpf0UXUoag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754654;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ZeIn1MrgS24TvCofj0XFOV1dJGcpjgPbDoMcfrUlYXg=;
	b=Jpxzl72UaRjugnZBj6eBI41Ftg1ExeS8OIMRKOcI5pI+CkxCFkKivBT2paez6oeubSKA
	 yatR5V0wQmalKODP1lBMOc5oofrKBWfQvMjQ3JQLhOIZRF4Qg8HA6OJ5VJFMa392bD/qZ
	 1d1LjnOIyJ10oxi1gU3TfPlu4pS/zRXMbmaq7bygw5hAdc4Q6Hb3tO0Gn9zKvm9VamhHY
	 AiZZwoZQBnWaNcttS44x0XOgrRJegmqm+SBrrh9msaW5uQiWBo/M2Le/rA7LPSAk86/tC
	 aZfPrEMeTA/AXzqzFNXqQdRd4x25P/KzoXuikCDGHrd7S4K7mSxsEfFPptRe71IJduA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FBVJK5I+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UKe9gWir;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585EE606A33B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 585EE606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FBVJK5I+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UKe9gWir
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RLWv838527
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZeIn1MrgS24TvCofj0XFOV1dJGcpjgPbDoMcfrUlYXg=; b=FBVJK5I+Q8fGm6le
	NVlLD19JBuhIsRQ+Zeo+2S7AeuE4BF3pZmleJXdllJIR31nYZW90jGpiERBG6JEV
	jToNovW4713Y9TLz7i7Y0d2SRflQWXbByxj3Giw98Z57HxBMRWZbQIvtZ55jYrBN
	nvgOsjXt7yFuApWBaPQQnI7vJluzKGOSGb9rHV6bMWYcrKSEE16ghU/hyPSVacXi
	S9DBK86+NojNBkZxlhSpnmsRY5RvO++z0JPUoNWbNjgzQhCgG4rxsyu5pxZbe2tX
	9WlQtEjMStPBBMhm4b+Zzu7k6kHqUBxOb8i0xay2uqkwfINq/zgo1oPndtTaA48J
	b1p2/A==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8ms9f8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:52 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36ca254ca2cso264783eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754651; x=1794359451; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZeIn1MrgS24TvCofj0XFOV1dJGcpjgPbDoMcfrUlYXg=;
        b=UKe9gWirfbfth600nEVJOgGnKiOm8aEOv1frF8QWO7PhzAaXyHmHb3Vjl1w2ttj6+S
         RYNh+AHE/bCk1hYZH7CWL/FicsVEm1kfSAt2UYA2G6DDBQYGx7SPwcyoeQ9hH4hvaNC0
         jxYGcp/9trfiMBH8o3UXxY572VycsQGtzTU23CnOhfkoQ2JtmX33k35nu68V7mAj4AC0
         H5v2SvgRp0O+kLMWOAgX+1HVic3morWxgt5ZcOvkyCrWsZcLQ7MeWZOxO8K3yIaRKOZb
         TwJcKpqZZS+GqEQ8ZexG+DsjWyqnCS9d/bZQnJYKHXTrWKpUEKl5t61t/ShQh30ftjGF
         +HCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754651; x=1794359451;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZeIn1MrgS24TvCofj0XFOV1dJGcpjgPbDoMcfrUlYXg=;
        b=lCIL7SEgljBF7AzVjN5/QU+oWweaml1G7tfyHqxr4KaUff5bENSLiH9et7dTOnVVDS
         4PquogQjl0u8y6dk+R/t1JZjlC/PeNfEvwtqv557Imwqoa0Iybh5TGVt6Nhw3ocYrTYg
         QgQZG05cFMQJbyIBG2g76jYpwrvZY/RKZ50wy3Qi3zr6ojpNU4m7PLnuaoK4F2sPKiby
         wy3p/1PmI9380lc2QMWVcQfqMJE2RGXd7rcXwBzUp+Ntc+VlH3aF3f5N91E59REUeHVi
         Cjrb48ylXNVrJoTXKn95Kcc27QRZOuc/hMUlrGEzhhKrhYBfkqkt+PTFeikvGcD7TKvG
         6jzQ==
X-Forwarded-Encrypted: i=1; AKwUvBykhtFK68rWPmflFIYGRVGYRVRyePEvxgcgxydjTBJSGgCWLRgOm7OSz4QNi/QPa/DC6JdiTzXwGOXRZ01hyg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Nudbn8KtK7lVAFGvMGCC9vMbNdbULOz/9Rsrzu191/LSRB7LD
	mSCXkhJys1Dfi9sQiGJ7S2hlSCEAET3X93Fr71S7NbQ/usV4eBvEaH7NzZs4u5EOu3He5zW4GkY
	Rw2/3Zne/ZGnn+i6pay+sGPJLGHI8TT0BJZNt7Xdf+tTauDxdrcFUZ0adWrOf1gHJs+CeuQ==
X-Gm-Gg: AYBFou1+xtRTRb5m/tenXhYKi+e001j1nyn79FWoKSzs1dkJkVKcKiQIetzbMvjL9tD
	iArNYhDlnMO2oSAK45SzDCJTlYNicSJBl0fvGsEqq0+9NdBY4MnLczByZ/R1ANO9Jm5MqpfDo9d
	GaFUZkXJyf6fDiOY0/CgvWCFs4wfmPy9GZULDcXxAi9fsxVlKF0VVEY/gOOZBQpwxqd6qQxPKpG
	BhtTRvdfXgwz8u/yrOmI9BHteoICQMRz/1KPhnaPq+18uMdJxThLYvNvPYxtS3RPEj8uNtU5K3F
	KsixUqWyGxfIvwVjiubQECDU1l0W40LfamXuU3A3mMmIJehidwUVCIN51OoC95rZAgmYscNELMF
	FkSKfa5RdtaaPgE7qh8wVw+FoxIWeM+lKYTJoM6LszKWPjERZJr3otAM6GhsU8ltHlgCDBz4IWN
	3eT54mjXZxFffsnrKbe/6MPVQ+5RXrEBVAKv3t
X-Received: by 2002:a05:693c:8811:10b0:35e:da0a:75b0 with SMTP id 5a478bee46e88-36a423be72amr22130961eec.25.1793754650818;
        Tue, 03 Nov 2026 17:10:50 -0800 (PST)
X-Received: by 2002:a05:693c:8811:10b0:35e:da0a:75b0 with SMTP id 5a478bee46e88-36a423be72amr22130922eec.25.1793754650175;
        Tue, 03 Nov 2026 17:10:50 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:49 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:47 -0800
Subject: [PATCH ath-next v3 04/13] wifi: ath12k: ng: refactor REO command
 framework for extensibility
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-4-861adf04b516@oss.qualcomm.com>
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
X-Proofpoint-GUID: lzooouiBJjdLC25ogMF39vu2pXbu7hXw
X-Proofpoint-ORIG-GUID: lzooouiBJjdLC25ogMF39vu2pXbu7hXw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfXwI3P2l/vFhiz
 pdYfwX+Ll5bEm1kv4WoO20p69FZJNlBoOOW/0ugtTCeB0+iBpExd7WBLIgWLTzjcX7tzxvCU6X2
 z+YDbKyodZrIz4acccGrAZJLNsgHpgLfOOtyZanhVORjhItKodeys68Bxm5FTIcPq8IRbSjIU1f
 reBHen9izWvzRGvkk4WVhptOW0PyWJHsbr5MQXMeXd04dKC9zxGX9xZMiAxb0NIOwSWtfAD34oy
 YEM7HGqb2hdFg68WKhER38M4oenI/J4tnXeZpQDei5zvSxmyrh+Wyc/hVJLX0T+pbJzTsaVcsk8
 RPxvr3eamYxiduFMAgUqygCLcqFrf+sg4Do8sWOxJELP1dzCj2874CZBA+jjftL+qO8bKSGRmZv
 o3T0BzAw9wo9VapiYhLxnyoTbQ+WWFevSox+SVCkCBNuEESvo09zc1oM/tGf5+IFnJffM2lqdXj
 w829w7Qa7TDQ1AaeH/g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfXx4A1emRUpC/T
 QYMx/HVHFTTdseo7M1Gzn792w+7WB0GVcYvGiivIvyRnqtyyd6jeryIwUTMVMbDpmy2U2EvByBp
 hnXbKcPEeggT7rOyAsaFKgT3gU4d3jg=
X-Authority-Analysis: v=2.4 cv=HbWB3SE8 c=1 sm=1 tr=0 ts=6aea861c cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=KoL9yByyTrP1EbH8B7AA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

The REO command framework passes an RX TID context to completion
callbacks and exposes only a command-status enum. This prevents callbacks
from inspecting command-specific hardware responses and prevents other
context types from using the same pending-command path.

Pass the complete struct hal_reo_status to callbacks and consolidate the
status container shared by Wi-Fi 7 and Wi-Fi 8 into common hal.h. During
command-list teardown, synthesize a HAL_REO_CMD_DRAIN status so existing
callbacks retain ownership of their context cleanup.

Generalize the send API to accept an opaque pointer and length, and copy
the context into a fixed-size union in the pending command. Validate the
copy size and adapt existing Wi-Fi 7 callers and Wi-Fi 8 bookkeeping.
Command encoding, ring selection, and hardware programming are unchanged.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k

Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.h          | 11 ++--
 drivers/net/wireless/ath/ath12k/dp_rx.c       | 30 ++++++---
 drivers/net/wireless/ath/ath12k/dp_rx.h       | 12 ++--
 drivers/net/wireless/ath/ath12k/hal.h         | 87 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 25 ++++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h |  4 +-
 drivers/net/wireless/ath/ath12k/wifi7/hal.h   | 94 +++------------------------
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c |  6 +-
 drivers/net/wireless/ath/ath12k/wifi8/hal.h   | 87 -------------------------
 9 files changed, 149 insertions(+), 207 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 6bd7ce41fc8d..9dba68f78808 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -27,6 +27,7 @@ struct ath12k_dp_vif;
 struct ath12k_link_sta;
 struct ath12k_dp_tx_msdu_info;
 struct ath12k_dp_skb_ctrl;
+struct hal_reo_status;
 
 #define DP_MON_PURGE_TIMEOUT_MS     100
 #define DP_MON_SERVICE_BUDGET       128
@@ -437,11 +438,11 @@ struct ath12k_dp_arch_ops {
 	u32 (*tx_get_vdev_bank_config)(struct ath12k_base *ab,
 				       struct ath12k_vif *ahvif);
 	int (*reo_cmd_send)(struct ath12k_base *ab,
-			    struct ath12k_dp_rx_tid_rxq *rx_tid,
+			    void *data, size_t len,
 			    enum hal_reo_cmd_type type,
 			    struct ath12k_hal_reo_cmd *cmd,
 			    void (*cb)(struct ath12k_dp *dp, void *ctx,
-				       enum hal_reo_cmd_status status));
+				       struct hal_reo_status *status));
 	void (*setup_pn_check_reo_cmd)(struct ath12k_hal_reo_cmd *cmd,
 				       struct ath12k_dp_rx_tid *rx_tid,
 				       u32 cipher, enum set_key_cmd key_cmd);
@@ -660,13 +661,13 @@ struct ath12k_dp {
 };
 
 static inline int ath12k_dp_arch_reo_cmd_send(struct ath12k_dp *dp,
-					      struct ath12k_dp_rx_tid_rxq *rx_tid,
+					      void *data, size_t len,
 					      enum hal_reo_cmd_type type,
 					      struct ath12k_hal_reo_cmd *cmd,
 					      void (*cb)(struct ath12k_dp *dp, void *ctx,
-							 enum hal_reo_cmd_status status))
+							 struct hal_reo_status *status))
 {
-	return dp->ops->reo_cmd_send(dp->ab, rx_tid, type, cmd, cb);
+	return dp->ops->reo_cmd_send(dp->ab, data, len, type, cmd, cb);
 }
 
 static inline
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 1773d44a4cb4..47a7ec58446a 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -392,8 +392,11 @@ void ath12k_dp_rx_reo_cmd_list_cleanup(struct ath12k_base *ab)
 
 	spin_lock_bh(&dp->reo_cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &dp->reo_cmd_list, list) {
+		struct hal_reo_status drain_status = {};
+
 		list_del(&cmd->list);
-		ath12k_dp_rx_tid_cleanup(ab, &cmd->data.qbuf);
+		drain_status.uniform_hdr.cmd_status = HAL_REO_CMD_DRAIN;
+		cmd->handler(dp, &cmd->u.data, &drain_status);
 		kfree(cmd);
 	}
 	spin_unlock_bh(&dp->reo_cmd_lock);
@@ -401,14 +404,20 @@ void ath12k_dp_rx_reo_cmd_list_cleanup(struct ath12k_base *ab)
 EXPORT_SYMBOL(ath12k_dp_rx_reo_cmd_list_cleanup);
 
 void ath12k_dp_reo_cmd_free(struct ath12k_dp *dp, void *ctx,
-			    enum hal_reo_cmd_status status)
+			    struct hal_reo_status *status)
 {
 	struct ath12k_dp_rx_tid_rxq *rx_tid = ctx;
+	enum hal_reo_cmd_status cmd_status;
+
+	if (!status || status->uniform_hdr.cmd_status == HAL_REO_CMD_DRAIN)
+		goto free_desc;
 
-	if (status != HAL_REO_CMD_SUCCESS)
+	cmd_status = status->uniform_hdr.cmd_status;
+	if (cmd_status != HAL_REO_CMD_SUCCESS)
 		ath12k_warn(dp->ab, "failed to flush rx tid hw desc, tid %d status %d\n",
-			    rx_tid->tid, status);
+			    rx_tid->tid, cmd_status);
 
+free_desc:
 	ath12k_dp_rx_tid_cleanup(dp->ab, &rx_tid->qbuf);
 }
 EXPORT_SYMBOL(ath12k_dp_reo_cmd_free);
@@ -444,18 +453,22 @@ void ath12k_dp_rx_process_reo_cmd_update_rx_queue_list(struct ath12k_dp *dp)
 EXPORT_SYMBOL(ath12k_dp_rx_process_reo_cmd_update_rx_queue_list);
 
 void ath12k_dp_rx_tid_del_func(struct ath12k_dp *dp, void *ctx,
-			       enum hal_reo_cmd_status status)
+			       struct hal_reo_status *status)
 {
 	struct ath12k_base *ab = dp->ab;
 	struct ath12k_dp_rx_tid_rxq *rx_tid = ctx;
 	struct ath12k_dp_rx_reo_cache_flush_elem *elem, *tmp;
+	enum hal_reo_cmd_status cmd_status;
 
-	if (status == HAL_REO_CMD_DRAIN) {
+	if (!status || status->uniform_hdr.cmd_status == HAL_REO_CMD_DRAIN)
 		goto free_desc;
-	} else if (status != HAL_REO_CMD_SUCCESS) {
+
+	cmd_status = status->uniform_hdr.cmd_status;
+
+	if (cmd_status != HAL_REO_CMD_SUCCESS) {
 		/* Shouldn't happen! Cleanup in case of other failure? */
 		ath12k_warn(ab, "failed to delete rx tid %d hw descriptor %d\n",
-			    rx_tid->tid, status);
+			    rx_tid->tid, cmd_status);
 		return;
 	}
 
@@ -832,6 +845,7 @@ int ath12k_dp_rx_peer_pn_replay_config(struct ath12k_link_vif *arvif,
 		ath12k_dp_arch_setup_pn_check_reo_cmd(dp, &cmd, rx_tid, key->cipher,
 						      key_cmd);
 		ret = ath12k_dp_arch_reo_cmd_send(dp, &rx_tid_rxq,
+						  sizeof(rx_tid_rxq),
 						  HAL_REO_CMD_UPDATE_RX_QUEUE,
 						  &cmd, NULL);
 		if (ret) {
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 3a369dfc8ea5..f523ac48747f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -59,12 +59,12 @@ struct dp_reo_update_rx_queue_elem {
 
 struct ath12k_dp_rx_reo_cmd {
 	struct list_head list;
-	struct ath12k_dp_rx_tid_rxq data;
+	union {
+		struct ath12k_dp_rx_tid_rxq data;
+	} u;
 	int cmd_num;
 	void (*handler)(struct ath12k_dp *dp, void *ctx,
-			enum hal_reo_cmd_status status);
-	void (*status_handler)(struct ath12k_dp *dp, void *ctx,
-			       struct hal_reo_status *status);
+			struct hal_reo_status *status);
 };
 
 #define ATH12K_DP_RX_FRAGMENT_TIMEOUT_MS (2 * HZ)
@@ -284,9 +284,9 @@ bool ath12k_dp_rx_h_rate_common(struct ath12k_pdev_dp *dp_pdev,
 struct sk_buff *ath12k_dp_rx_get_msdu_last_buf(struct sk_buff_head *msdu_list,
 					       struct sk_buff *first);
 void ath12k_dp_reo_cmd_free(struct ath12k_dp *dp, void *ctx,
-			    enum hal_reo_cmd_status status);
+			    struct hal_reo_status *status);
 void ath12k_dp_rx_tid_del_func(struct ath12k_dp *dp, void *ctx,
-			       enum hal_reo_cmd_status status);
+			       struct hal_reo_status *status);
 void ath12k_dp_rx_process_reo_cmd_update_rx_queue_list(struct ath12k_dp *dp);
 void ath12k_dp_init_rx_tid_rxq(struct ath12k_dp_rx_tid_rxq *rx_tid_rxq,
 			       struct ath12k_dp_rx_tid *rx_tid,
diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index f175b5361080..9c0d1dfac8d3 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -1169,6 +1169,93 @@ struct hal_reo_status_header {
 	u32 timestamp;
 };
 
+struct hal_reo_status_queue_stats {
+	u16 ssn;
+	u16 curr_idx;
+	u32 pn[4];
+	u32 last_rx_queue_ts;
+	u32 last_rx_dequeue_ts;
+	u32 rx_bitmap[9];
+	u32 curr_mpdu_cnt;
+	u32 curr_msdu_cnt;
+	u16 fwd_due_to_bar_cnt;
+	u16 dup_cnt;
+	u32 frames_in_order_cnt;
+	u32 num_mpdu_processed_cnt;
+	u32 num_msdu_processed_cnt;
+	u32 total_num_processed_byte_cnt;
+	u32 late_rx_mpdu_cnt;
+	u32 reorder_hole_cnt;
+	u8 timeout_cnt;
+	u8 bar_rx_cnt;
+	u8 num_window_2k_jump_cnt;
+};
+
+struct hal_reo_status_flush_queue {
+	bool err_detected;
+};
+
+enum hal_reo_status_flush_cache_err_code {
+	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_SUCCESS,
+	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_IN_USE,
+	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_NOT_FOUND,
+};
+
+struct hal_reo_status_flush_cache {
+	bool err_detected;
+	enum hal_reo_status_flush_cache_err_code err_code;
+	bool cache_controller_flush_status_hit;
+	u8 cache_controller_flush_status_desc_type;
+	u8 cache_controller_flush_status_client_id;
+	u8 cache_controller_flush_status_err;
+	u8 cache_controller_flush_status_cnt;
+};
+
+enum hal_reo_status_unblock_cache_type {
+	HAL_REO_STATUS_UNBLOCK_BLOCKING_RESOURCE,
+	HAL_REO_STATUS_UNBLOCK_ENTIRE_CACHE_USAGE,
+};
+
+struct hal_reo_status_unblock_cache {
+	bool err_detected;
+	enum hal_reo_status_unblock_cache_type unblock_type;
+};
+
+struct hal_reo_status_flush_timeout_list {
+	bool err_detected;
+	bool list_empty;
+	u16 release_desc_cnt;
+	u16 fwd_buf_cnt;
+};
+
+enum hal_reo_threshold_idx {
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER0,
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER1,
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER2,
+	HAL_REO_THRESHOLD_IDX_DESC_COUNTER_SUM,
+};
+
+struct hal_reo_status_desc_thresh_reached {
+	enum hal_reo_threshold_idx threshold_idx;
+	u32 link_desc_counter0;
+	u32 link_desc_counter1;
+	u32 link_desc_counter2;
+	u32 link_desc_counter_sum;
+};
+
+struct hal_reo_status {
+	struct hal_reo_status_header uniform_hdr;
+	u8 loop_cnt;
+	union {
+		struct hal_reo_status_queue_stats queue_stats;
+		struct hal_reo_status_flush_queue flush_queue;
+		struct hal_reo_status_flush_cache flush_cache;
+		struct hal_reo_status_unblock_cache unblock_cache;
+		struct hal_reo_status_flush_timeout_list timeout_list;
+		struct hal_reo_status_desc_thresh_reached desc_thresh_reached;
+	} u;
+};
+
 struct ath12k_hw_hal_params {
 	u8 rx_buf_rbm;
 	u32 wbm2sw_cc_enable;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index d3ed2134818a..379b33fc8029 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -137,11 +137,11 @@ int ath12k_wifi7_dp_rx_link_desc_return(struct ath12k_dp *dp,
 }
 
 int ath12k_wifi7_dp_reo_cmd_send(struct ath12k_base *ab,
-				 struct ath12k_dp_rx_tid_rxq *rx_tid,
+				 void *data, size_t len,
 				 enum hal_reo_cmd_type type,
 				 struct ath12k_hal_reo_cmd *cmd,
 				 void (*cb)(struct ath12k_dp *dp, void *ctx,
-					    enum hal_reo_cmd_status status))
+					    struct hal_reo_status *status))
 {
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct ath12k_dp_rx_reo_cmd *dp_cmd;
@@ -151,6 +151,12 @@ int ath12k_wifi7_dp_reo_cmd_send(struct ath12k_base *ab,
 	if (!cb) {
 		dp_cmd = NULL;
 	} else {
+		if (WARN_ON(len > sizeof(dp_cmd->u)))
+			return -EINVAL;
+
+		if (WARN_ON(len && !data))
+			return -EINVAL;
+
 		/* Can this be optimized so that we keep the pending command list only
 		 * for tid delete command to free up the resource on the command status
 		 * indication?
@@ -160,12 +166,13 @@ int ath12k_wifi7_dp_reo_cmd_send(struct ath12k_base *ab,
 			return -ENOMEM;
 
 		INIT_LIST_HEAD(&dp_cmd->list);
-		memcpy(&dp_cmd->data, rx_tid, sizeof(*rx_tid));
+		if (len)
+			memcpy(&dp_cmd->u, data, len);
+		dp_cmd->handler = cb;
 	}
 
 	cmd_ring = &ab->hal.srng_list[dp->reo_cmd_ring.ring_id];
 	cmd_num = ath12k_wifi7_hal_reo_cmd_send(ab, cmd_ring, type, cmd);
-
 	/* cmd_num should start from 1, during failure return the error code */
 	if (cmd_num < 0) {
 		kfree(dp_cmd);
@@ -182,7 +189,6 @@ int ath12k_wifi7_dp_reo_cmd_send(struct ath12k_base *ab,
 		return 0;
 
 	dp_cmd->cmd_num = cmd_num;
-	dp_cmd->handler = cb;
 
 	spin_lock_bh(&dp->reo_cmd_lock);
 	list_add_tail(&dp_cmd->list, &dp->reo_cmd_list);
@@ -216,7 +222,7 @@ int ath12k_wifi7_peer_rx_tid_reo_update(struct ath12k_dp *dp,
 		cmd.upd2 = u32_encode_bits(ssn, HAL_REO_CMD_UPD2_SSN);
 	}
 
-	ret = ath12k_wifi7_dp_reo_cmd_send(ab, &rx_tid_rxq,
+	ret = ath12k_wifi7_dp_reo_cmd_send(ab, &rx_tid_rxq, sizeof(rx_tid_rxq),
 					   HAL_REO_CMD_UPDATE_RX_QUEUE, &cmd,
 					   NULL);
 	if (ret) {
@@ -253,7 +259,7 @@ int ath12k_wifi7_dp_reo_cache_flush(struct ath12k_base *ab,
 	if (rx_tid->tid != HAL_DESC_REO_NON_QOS_TID)
 		cmd.flag |= HAL_REO_CMD_FLG_FLUSH_QUEUE_1K_DESC;
 
-	ret = ath12k_wifi7_dp_reo_cmd_send(ab, rx_tid,
+	ret = ath12k_wifi7_dp_reo_cmd_send(ab, rx_tid, sizeof(*rx_tid),
 					   HAL_REO_CMD_FLUSH_CACHE,
 					   &cmd, ath12k_dp_reo_cmd_free);
 	return ret;
@@ -321,7 +327,7 @@ int ath12k_wifi7_dp_rx_tid_delete_handler(struct ath12k_base *ab,
 	/* Observed flush cache failure, to avoid that set vld bit during delete */
 	cmd.upd1 |= HAL_REO_CMD_UPD1_VLD;
 
-	return ath12k_wifi7_dp_reo_cmd_send(ab, rx_tid,
+	return ath12k_wifi7_dp_reo_cmd_send(ab, rx_tid, sizeof(*rx_tid),
 					    HAL_REO_CMD_UPDATE_RX_QUEUE, &cmd,
 					    ath12k_dp_rx_tid_del_func);
 }
@@ -2302,8 +2308,7 @@ void ath12k_wifi7_dp_rx_process_reo_status(struct ath12k_dp *dp)
 		spin_unlock_bh(&dp->reo_cmd_lock);
 
 		if (found) {
-			cmd->handler(dp, (void *)&cmd->data,
-				     reo_status.uniform_hdr.cmd_status);
+			cmd->handler(dp, &cmd->u.data, &reo_status);
 			kfree(cmd);
 		}
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
index 9d9ffb6f835f..0cc5510ae824 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
@@ -39,11 +39,11 @@ void ath12k_wifi7_peer_rx_tid_qref_setup(struct ath12k_base *ab, u16 peer_id, u1
 void ath12k_wifi7_dp_rx_peer_tid_delete(struct ath12k_base *ab,
 					struct ath12k_dp_link_peer *peer, u8 tid);
 int ath12k_wifi7_dp_reo_cmd_send(struct ath12k_base *ab,
-				 struct ath12k_dp_rx_tid_rxq *rx_tid,
+				 void *data, size_t len,
 				 enum hal_reo_cmd_type type,
 				 struct ath12k_hal_reo_cmd *cmd,
 				 void (*cb)(struct ath12k_dp *dp, void *ctx,
-					    enum hal_reo_cmd_status status));
+					    struct hal_reo_status *status));
 int ath12k_wifi7_dp_reo_cache_flush(struct ath12k_base *ab,
 				    struct ath12k_dp_rx_tid_rxq *rx_tid);
 int ath12k_wifi7_peer_rx_tid_reo_update(struct ath12k_dp *dp,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal.h b/drivers/net/wireless/ath/ath12k/wifi7/hal.h
index 471b6ec3591c..065392c62263 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal.h
@@ -446,92 +446,14 @@
 #define HAL_REO_CMD_UPD2_SEQ_2K_ERR		BIT(23)
 #define HAL_REO_CMD_UPD2_PN_ERR			BIT(24)
 
-struct hal_reo_status_queue_stats {
-	u16 ssn;
-	u16 curr_idx;
-	u32 pn[4];
-	u32 last_rx_queue_ts;
-	u32 last_rx_dequeue_ts;
-	u32 rx_bitmap[8]; /* Bitmap from 0-255 */
-	u32 curr_mpdu_cnt;
-	u32 curr_msdu_cnt;
-	u16 fwd_due_to_bar_cnt;
-	u16 dup_cnt;
-	u32 frames_in_order_cnt;
-	u32 num_mpdu_processed_cnt;
-	u32 num_msdu_processed_cnt;
-	u32 total_num_processed_byte_cnt;
-	u32 late_rx_mpdu_cnt;
-	u32 reorder_hole_cnt;
-	u8 timeout_cnt;
-	u8 bar_rx_cnt;
-	u8 num_window_2k_jump_cnt;
-};
-
-struct hal_reo_status_flush_queue {
-	bool err_detected;
-};
-
-enum hal_reo_status_flush_cache_err_code {
-	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_SUCCESS,
-	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_IN_USE,
-	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_NOT_FOUND,
-};
-
-struct hal_reo_status_flush_cache {
-	bool err_detected;
-	enum hal_reo_status_flush_cache_err_code err_code;
-	bool cache_controller_flush_status_hit;
-	u8 cache_controller_flush_status_desc_type;
-	u8 cache_controller_flush_status_client_id;
-	u8 cache_controller_flush_status_err;
-	u8 cache_controller_flush_status_cnt;
-};
-
-enum hal_reo_status_unblock_cache_type {
-	HAL_REO_STATUS_UNBLOCK_BLOCKING_RESOURCE,
-	HAL_REO_STATUS_UNBLOCK_ENTIRE_CACHE_USAGE,
-};
-
-struct hal_reo_status_unblock_cache {
-	bool err_detected;
-	enum hal_reo_status_unblock_cache_type unblock_type;
-};
-
-struct hal_reo_status_flush_timeout_list {
-	bool err_detected;
-	bool list_empty;
-	u16 release_desc_cnt;
-	u16 fwd_buf_cnt;
-};
-
-enum hal_reo_threshold_idx {
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER0,
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER1,
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER2,
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER_SUM,
-};
-
-struct hal_reo_status_desc_thresh_reached {
-	enum hal_reo_threshold_idx threshold_idx;
-	u32 link_desc_counter0;
-	u32 link_desc_counter1;
-	u32 link_desc_counter2;
-	u32 link_desc_counter_sum;
-};
-
-struct hal_reo_status {
-	struct hal_reo_status_header uniform_hdr;
-	u8 loop_cnt;
-	union {
-		struct hal_reo_status_queue_stats queue_stats;
-		struct hal_reo_status_flush_queue flush_queue;
-		struct hal_reo_status_flush_cache flush_cache;
-		struct hal_reo_status_unblock_cache unblock_cache;
-		struct hal_reo_status_flush_timeout_list timeout_list;
-		struct hal_reo_status_desc_thresh_reached desc_thresh_reached;
-	} u;
-};
+#define HAL_WIFI7_HASH_ROUTING_RING_TCL 0
+#define HAL_WIFI7_HASH_ROUTING_RING_SW1 1
+#define HAL_WIFI7_HASH_ROUTING_RING_SW2 2
+#define HAL_WIFI7_HASH_ROUTING_RING_SW3 3
+#define HAL_WIFI7_HASH_ROUTING_RING_SW4 4
+#define HAL_WIFI7_HASH_ROUTING_RING_REL 5
+#define HAL_WIFI7_HASH_ROUTING_RING_FW  6
+
 
 int ath12k_wifi7_hal_init(struct ath12k_base *ab);
 void ath12k_wifi7_hal_ce_dst_setup(struct ath12k_base *ab,
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
index 0eea810f68fe..b75e65091995 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
@@ -71,7 +71,7 @@ static int ath12k_wifi8_dp_reo_cmd_send_ring(struct ath12k_base *ab,
 	if (!cb) {
 		dp_cmd = NULL;
 	} else {
-		if (WARN_ON(len > sizeof(dp_cmd->data)))
+		if (WARN_ON(len > sizeof(dp_cmd->u)))
 			return -EINVAL;
 
 		dp_cmd = kzalloc_obj(*dp_cmd, GFP_ATOMIC);
@@ -79,8 +79,8 @@ static int ath12k_wifi8_dp_reo_cmd_send_ring(struct ath12k_base *ab,
 			return -ENOMEM;
 
 		INIT_LIST_HEAD(&dp_cmd->list);
-		memcpy(&dp_cmd->data, data, len);
-		dp_cmd->status_handler = cb;
+		memcpy(&dp_cmd->u, data, len);
+		dp_cmd->handler = cb;
 	}
 
 	cmd_num = ath12k_wifi8_hal_reo_cmd_send(central_ab, cmd_ring, type, cmd);
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal.h b/drivers/net/wireless/ath/ath12k/wifi8/hal.h
index fc5df78be051..81bcfd6d0f43 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal.h
@@ -896,93 +896,6 @@ enum ath12k_hal_tx_pkt_ctrl_config {
 	HAL_TX_PACKET_CONTROL_CONFIG_MEC_NOTIFY_TX_EXCEPTION,
 };
 
-struct hal_reo_status_queue_stats {
-	u16 ssn;
-	u16 curr_idx;
-	u32 pn[4];
-	u32 last_rx_queue_ts;
-	u32 last_rx_dequeue_ts;
-	u32 rx_bitmap[9];
-	u32 curr_mpdu_cnt;
-	u32 curr_msdu_cnt;
-	u16 fwd_due_to_bar_cnt;
-	u16 dup_cnt;
-	u32 frames_in_order_cnt;
-	u32 num_mpdu_processed_cnt;
-	u32 num_msdu_processed_cnt;
-	u32 total_num_processed_byte_cnt;
-	u32 late_rx_mpdu_cnt;
-	u32 reorder_hole_cnt;
-	u8 timeout_cnt;
-	u8 bar_rx_cnt;
-	u8 num_window_2k_jump_cnt;
-};
-
-struct hal_reo_status_flush_queue {
-	bool err_detected;
-};
-
-enum hal_reo_status_flush_cache_err_code {
-	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_SUCCESS,
-	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_IN_USE,
-	HAL_REO_STATUS_FLUSH_CACHE_ERR_CODE_NOT_FOUND,
-};
-
-struct hal_reo_status_flush_cache {
-	bool err_detected;
-	enum hal_reo_status_flush_cache_err_code err_code;
-	bool cache_controller_flush_status_hit;
-	u8 cache_controller_flush_status_desc_type;
-	u8 cache_controller_flush_status_client_id;
-	u8 cache_controller_flush_status_err;
-	u8 cache_controller_flush_status_cnt;
-};
-
-enum hal_reo_status_unblock_cache_type {
-	HAL_REO_STATUS_UNBLOCK_BLOCKING_RESOURCE,
-	HAL_REO_STATUS_UNBLOCK_ENTIRE_CACHE_USAGE,
-};
-
-struct hal_reo_status_unblock_cache {
-	bool err_detected;
-	enum hal_reo_status_unblock_cache_type unblock_type;
-};
-
-struct hal_reo_status_flush_timeout_list {
-	bool err_detected;
-	bool list_empty;
-	u16 release_desc_cnt;
-	u16 fwd_buf_cnt;
-};
-
-enum hal_reo_threshold_idx {
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER0,
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER1,
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER2,
-	HAL_REO_THRESHOLD_IDX_DESC_COUNTER_SUM,
-};
-
-struct hal_reo_status_desc_thresh_reached {
-	enum hal_reo_threshold_idx threshold_idx;
-	u32 link_desc_counter0;
-	u32 link_desc_counter1;
-	u32 link_desc_counter2;
-	u32 link_desc_counter_sum;
-};
-
-struct hal_reo_status {
-	struct hal_reo_status_header uniform_hdr;
-	u8 loop_cnt;
-	union {
-		struct hal_reo_status_queue_stats queue_stats;
-		struct hal_reo_status_flush_queue flush_queue;
-		struct hal_reo_status_flush_cache flush_cache;
-		struct hal_reo_status_unblock_cache unblock_cache;
-		struct hal_reo_status_flush_timeout_list timeout_list;
-		struct hal_reo_status_desc_thresh_reached desc_thresh_reached;
-	} u;
-};
-
 void ath12k_wifi8_hal_init(struct ath12k_base *ab);
 void ath12k_wifi8_hal_ce_dst_setup(struct ath12k_base *ab,
 				   struct hal_srng *srng, int ring_num);

-- 
2.43.0

