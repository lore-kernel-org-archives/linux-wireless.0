Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267759;
	b=YxWqmNhJbqtZKZjBbtEq0USQ+qKCnAAbuWysgk4I2eMvUWL+rfWpNjaxwMOC2YD5sFGo
	 97wCTOyWNogfwlo9o6yL2NlqmRGYXp9ebqdGZQMFAaRh5ZqcRVMIoVs8M5gBuWG7Mp/Am
	 /ImIzx/kXbWdAOYywZmaudoRuNd/IQW3FvkeAdH7iPBtSmvyZJA4tAqdJQQIuTRvp7sLD
	 xxvmSkXTyzjyqSt2N5rUBUFksp4sLe3zWE6P0x3H+SqFClCV+xG2nao7qUob/Kk3C53Iu
	 ROuTN1FwE5SJwMJ86M+WjO2tV9Rdu2zLNojJGUegzlMLJXofvfGqCoVycrDbXgtv8dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267759;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=dWwinrMGwUDykZ7hC59tjMQpoDgfX6I4YnFKofnefH8=;
	b=y7SWGfDppH+SIFrjhz8PIL1QxyKJ8EC9J3DjgSQDb7yZ7570S+O4RWy72GNZrY8agwKt
	 HbE4FiP8k3AjS3OA6lDu0vFivgKQibzeEODQSV23zALD1MrvBwa2hP0icTBU/rwPT9YkK
	 rwS3jBaU29iXbn79gg7ffGUvwHdHKA9sdQo4GgU6HC1LFkd5Kbm9+2SZ3rqvmeeUlT7nD
	 9BVb6IjWyeHBJam7tLDbBHu3NI6G0KIX1wqB3NEcTZgk/IvvDtEGxGbye7x+ga7XM0cWT
	 zyDYhKRNEn8AYHNv3pXwTEwEagXRxMb7sLw9utwcEiAg4sFb1YOFvuRQ322Ifkfmpyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UmEh678b;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="BGI/peog";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5360A3829
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:55:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AF5360A3829
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UmEh678b;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BGI/peog
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69T8vDkK2725251
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=dWwinrMGwUDykZ7hC59tjMQpoDgfX6I4YnF
	KofnefH8=; b=UmEh678bDp5OX9wnxKYvIjKO6xg6Fja0ARclWaNfIzt+w4kO5RO
	ci1vF4q5cdKDTRCGLueIM4YkJE7KVvhIgcpE1Q8oF4AXRcADrvCdA5poCucRcDNi
	17LgEQPARmNmgBF/hF+1t2GYGpcPVBzGC0gELGEhEl+Bh6bn6fmlCqoLNC9boXha
	sGfZL+gkC5dRP225gwfWdqBV1J0EaQ4ktcrFrHefKS9jEeT0XrZzLiCmysDMEpyR
	ilCA/BKRMmZ2TIcwEPYgBvqIipbke/coiZx8bNhVy3KgjBR49FRyg1u9HkIU46iW
	lniF97MpMOcPsRffAfM3YCSrPGvWJiYwWVg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hky5s94aw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:55:58 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4ac5feaa4so1292478a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 02:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793267757; x=1793872557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dWwinrMGwUDykZ7hC59tjMQpoDgfX6I4YnFKofnefH8=;
        b=BGI/peogyJgcx8K3G1yIFrJh6ASsEGv2GalMA5s7dh2/s/O9IV3JkWDd5UzfgUtZMp
         VOVCDE6PbXhOdkejj6u9IuBtPrsoO52CGIabbEgAdPqorKV5RVrTKDKR57i6i+1fgeu/
         4O4oVtAg0F8M0y91Uq4AUEz7CfnkzW3+eApMzkFLbYoJyhqBWKjvqBSDeqVQw7KVtGaY
         4yhTwOp/XezpU18No7Y4YRr/T/ViNEo1XQLPAtRHDN37EjA2mp0cAgajqQzdM8sy8FjA
         WdNXANslP1BCC7yjxpJVmF6N1MqtY0QmRz4HfzD3Krbg7ztajl8CKo1ns+HgW2zOYvoj
         6oKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793267757; x=1793872557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dWwinrMGwUDykZ7hC59tjMQpoDgfX6I4YnFKofnefH8=;
        b=b4+JOOFNDKP02OfLwB3E9aeejZeNIaY+YQqyMQZdr11f1MI2BfhIG74uNKs0xrvz1R
         h//kA6p1AsdJCfZdybIJCV/iSUSQuH8sZUwK3gJ5Edy+6HyKyWN8I0PORxFIdqk9trgf
         +lSqxaWS6Za+B95IZUl/iO6wxqgOmsWtS+w9UjIpcE5RICUXcxXif4Ga7wbQSaZvJkRw
         UMEh96ImI6MtDRgZsyRj/9M7ps3LAoWsyBBY0dFrXD2W7yt2EUdbAwjzzQXU/m3OlK/e
         xUiLirHar22ue2UNAWEkktuIdutZdxlFC45cDpoQLP1Yl/W4KXJ9MKs3hX0tWtVjTOzJ
         lCJw==
X-Forwarded-Encrypted: i=1; AKwUvBwMakIIwldkAlwHpFVw/WvuNzxYbytuYVF1S5FjZ3iqbIuBXwfVNsLq+xHE0W743oq0jUqUmPwUrHppOyrJNQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKhH0016r1XTAgO18M3wSYwXwhk6khbtRxFnF5KPvu//pURgzGP
	pBvtIX5uk423oT11GJL39kNiGnkArpNqda2UXYoVwTI2nzA2w2izT4KOD3EMMoHK9OY/2Us7yFe
	aaiBhYy2CpYGaAOAfDVjtLTQdzkN3Tt0couA3JLRHWjoesundkedxkYahro/ckkV8RoRyNg==
X-Gm-Gg: AYBFou1QY7IHg1KxmijpHjtq3DPdnDd/v/aYqaK2jmdnZeNGW3j9y1p95nvM1AO58Ve
	sH2DxSA+6ZEn/vixCn4CLewPhU+C1zA+fpjSf4XqUCVeNH2YGGb6Ltl6gWSAKjoJNbv+c6r7bt5
	NVj6anaLhtGQwwPq1K0JZLbRJG0z+b3hZO/HaGb6MjJRaGNGtiwb1EmVQxJDFwJfDJIzBdJLAxN
	/6M0ko5OIOMsZfyK+thLXDqfKoJb02i6FKrDWmxslC7eMhd80Iin4hX86GD3Hc5WyBjL8qapEJC
	+5+UPg8iX9K8WYm7N16I4sAFx+HsbwqVlwiyAvpd/QzE9+b+m9cLyDJ5vRRAARbneR3/nkW1gOF
	LwabD2KZecfsVf6OXK+42FZu3fmIDdpbzFwYAE0OCt+zUQPRWnJc1lpWXcXfLQly0rjfOPYK+z6
	2GcTHx6lDNCGLApSJfyG5xMTufaos6p09/
X-Received: by 2002:a17:90b:4a8d:b0:3aa:6b5d:9fe4 with SMTP id 98e67ed59e1d1-3ae57f9a498mr3842303a91.12.1793267757000;
        Thu, 29 Oct 2026 02:55:57 -0700 (PDT)
X-Received: by 2002:a17:90b:4a8d:b0:3aa:6b5d:9fe4 with SMTP id 98e67ed59e1d1-3ae57f9a498mr3842279a91.12.1793267756496;
        Thu, 29 Oct 2026 02:55:56 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e874bebsm3641564a91.14.2026.10.29.02.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 02:55:56 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Yingying Tang <yingying.tang@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH 7.3.y] wifi: ath12k: Increase RXDMA buffer ring size for default memory profile
Date: Thu, 29 Oct 2026 17:55:41 +0800
Message-ID: <20261029095541.685879-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAzOCBTYWx0ZWRfX1lYz7qMnPtmZ
 LRZUaU1/RNgY3ivaok4oJrpiCvuNl9yvjD2Tmm8cwlD6XNSWoLPvvVv+R++/qLK+qopCkBw/LAv
 mlgnt0GiJEPo34mzjY8DPSLbWiSU3MIfRkRU5SbnWRwR+CZeltyKyx6Pvn2PE2MRLh5aKjz5dO2
 rjDpZQCmMdPXKFd9bPgb25g/wX3RY+ytQv4eAt/mwOLH8+YKMAPJtmrzE84+p70ovB2vMDQFURK
 hXGFk6vc6A+XNAA2GYmvHvGfY6A3tezfrirhcVEjbcMCcH1Q42rMkEt0xZOOUitPTNFCd85YW36
 kCMe1wKE2xmIDQr0CHqK2XdmcTQp9JVpuV10CjLRxupKJ7ycsfwk3Hmg8lu5RYR46NFHbseJcYa
 uSS3uz5SqZ/QnsZzefyXkz2bAGLOhTIjVXZrYe9wNs8iVPZncT9KgqMAcWrVLkM725pautorQcG
 zfQgTcYvjTeOCuM1W+A==
X-Proofpoint-ORIG-GUID: kKueGYN5-r9FJGaBHPx0h9Fw1dym0p4t
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAzOCBTYWx0ZWRfX9TtCHFXm/DIY
 fXA63PH/WGEaQdj+tgBQ6qG68/3NZo+i1GduEzhPwigVLjOQpkt015SXNSEkdXhHIUSHO82HCLg
 YBXNypr/Cv8ZUIYF0u5Uyjo974K/wGc=
X-Proofpoint-GUID: kKueGYN5-r9FJGaBHPx0h9Fw1dym0p4t
X-Authority-Analysis: v=2.4 cv=f/vdl+yM c=1 sm=1 tr=0 ts=6ae3182e cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=-8uvzrCIQl3F6d3rFMcA:9 a=3WC7DwWrALyhR5TkjVHa:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290038

From: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>

commit 15f7603b69a83a0acc7fcc8992ecbea6110f9424 upstream.
commit 643f0bf936176c114d5631da7547e991b5d99f10 upstream.

The default RXDMA buffer ring size of 4096 entries can become a
bottleneck under high RX traffic load, resulting in reduced receive
throughput due to limited buffer availability.

Increase the RXDMA buffer ring size to 8192 entries for the default
memory profile to provide additional RX buffering and improve RX packet
processing efficiency.

This increases memory consumption by approximately 9-10 MiB and improves
RX throughput by ~20% with the default memory profile
(ATH12K_QMI_MEMORY_MODE_DEFAULT).

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261007-mpp_ws-v1-2-739b1fb87d24@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Backport rationale:

v7.3 contains 58aeb412495a ("wifi: ath12k: change MAC buffer ring size
to 4096"), which sets DP_RX_MAC_BUF_RING_SIZE to 4096 while the RXDMA
buffer ring is also 4096 entries. With WCN7850 hw2.0 and the older
firmware WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 (still
shipped by Debian trixie, firmware-atheros 20250410-2), every WMI
command then times out once the interface is brought up:

  ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
  ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
  ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
  ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11

so WiFi does not work at all on affected systems. With the RXDMA buffer
ring at 8192 entries, v7.3 works with the same firmware. Per Baochen
Qiang, the RXDMA buffer ring needs to be at least twice
DP_RX_MAC_BUF_RING_SIZE (four times also works): WCN7850 has two
hardware MACs, the firmware sets up an rx_mac_buf ring for each, and
both fill themselves from the single RXDMA buffer ring. Newer firmware
(WLAN.HMT.1.1.c5-00302 and later) is not affected.

Reverting 58aeb412495a is not preferable, as that gives up the
throughput improvement it provides for newer firmware.

Adapted for 7.3: 643f0bf93617 ("wifi: ath12k: Make RXDMA buffer ring
size configurable per memory profile"), on which this commit depends,
is not in 7.3 and does not apply because the profile parameters
structure lives in core.h here. Fold its rxdma_buf_ring_size field
and DP_RXDMA_BUF_RING_SIZE(ab) accessor into this backport. Values are
as upstream after both commits: 8192 for the default profile and 4096
for the low-512M profile.

Fixes: 58aeb412495a ("wifi: ath12k: change MAC buffer ring size to 4096")
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c  | 2 ++
 drivers/net/wireless/ath/ath12k/core.h  | 1 +
 drivers/net/wireless/ath/ath12k/dp.h    | 3 ++-
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index b0107cde99ff..b25202effb00 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -54,6 +54,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 32768,
 			.rx_desc_count = 12288,
 			.rx_release_ring_size = 16384,
+			.rxdma_buf_ring_size = 8192,
 		},
 	},
 [ATH12K_QMI_MEMORY_MODE_LOW_512_M] = {
@@ -68,6 +69,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 16384,
 			.rx_desc_count = 6144,
 			.rx_release_ring_size = 8192,
+			.rxdma_buf_ring_size = 4096,
 		},
 	},
 };
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 93fd227b4d19..6941cd41551d 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -934,6 +934,7 @@ struct ath12k_dp_profile_params {
 	u32 num_pool_tx_desc;
 	u32 rx_desc_count;
 	u32 rx_release_ring_size;
+	u32 rxdma_buf_ring_size;
 };
 
 struct ath12k_mem_profile_based_param {
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index bef0f2ba0560..53f7cd990892 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -202,10 +202,11 @@ struct ath12k_pdev_dp {
 #define DP_REO_REINJECT_RING_SIZE	32
 #define DP_RX_RELEASE_RING_SIZE(ab) \
 	((ab)->profile_param->dp_params.rx_release_ring_size)
+#define DP_RXDMA_BUF_RING_SIZE(ab) \
+	((ab)->profile_param->dp_params.rxdma_buf_ring_size)
 #define DP_REO_EXCEPTION_RING_SIZE	128
 #define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048
-#define DP_RXDMA_BUF_RING_SIZE		4096
 #define DP_RX_MAC_BUF_RING_SIZE		4096
 #define DP_RXDMA_REFILL_RING_SIZE	2048
 #define DP_RXDMA_ERR_DST_RING_SIZE	1024
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..d1f0ac152dd4 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1702,7 +1702,7 @@ int ath12k_dp_rx_alloc(struct ath12k_base *ab)
 	ret = ath12k_dp_srng_setup(ab,
 				   &dp->rx_refill_buf_ring.refill_buf_ring,
 				   HAL_RXDMA_BUF, 0, 0,
-				   DP_RXDMA_BUF_RING_SIZE);
+				   DP_RXDMA_BUF_RING_SIZE(ab));
 	if (ret) {
 		ath12k_warn(ab, "failed to setup rx_refill_buf_ring\n");
 		return ret;
-- 
2.47.3

