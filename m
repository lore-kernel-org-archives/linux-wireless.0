Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D743B71DC
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790535825; cv=none; b=VfAoIAXijk3VSjD9vh0ljcMUphFJfzZTbF+J6Ur4RHo23D3RlIwUPv8A4ORi+ooN3ifkNgR0u+k92jPWKZNcKbdxVHMQFiBbjTLl9fh4HdIve2tHWJQdbE86qmDQoA4zuiOyTa0IrgOGNLGvr9JfY94DJt73r0Kl41/0rDxO9rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790535825; c=relaxed/simple;
	bh=Omlcu7XuTtDj/thOeBEYKmH75SWAloBPYdT6y47Iols=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=TxljPwtriYdETrQ6FSQX1F5wqHi3UGdTg5canHeQKu3Z+fsEtziUUXXCn737MfDwG4VMpU1L9uGW6GpavTiT8e6Vn2dRvzjvbPKpOPBTdJffgKoht+1CIthFIlxwFEWSdmi6nOrHAYU2Vi3RZLm0zltZEyXvXEiEIxknMrZcZSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BBIG8lj8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aIdmqx+A; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BBIG8lj8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aIdmqx+A"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68QMftDL1566098
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 19:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=7pu/3ON0/cCBPt0BqikF7H
	7Rl4I/09E3LOdHlSpQShI=; b=BBIG8lj8P7KOqukoAifuhSgO0SrwvXsZTXTtFu
	bL6pF3MuN+YE4cg7JsTjYGI/dRylcaokGGN6AMeGXoOIEdzmEEN6LFoMwalX5+jq
	6O3SAJEvkmdBSkuseMpX0uNcOAVWgZHlHjoUVl4n37DGXvSJ3iYIvsF+cgrv8943
	m4pBe8cp1uU1nJCAkzGB3UrF7Oo/BCzEd3yOtVDe3oYeHUhwsidZTngesGCBcMWQ
	u7UXUIFxrQ3y765zIwED7LZFaBOdM4tcMf1+japiFF44l6wAUUrr0t8dL/XLSVGs
	84fjC2UKTMvuEI3EBU7GfhskkDM7d9zBJTBdQF2Cy9/iBPAA==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gx5mwbjt1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 19:03:42 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1384427c3efso3520977c88.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 12:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790535821; x=1791140621; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7pu/3ON0/cCBPt0BqikF7H7Rl4I/09E3LOdHlSpQShI=;
        b=aIdmqx+AL113/EH11D5UJjsEycCIgwLSmHeGgpSaPv69/UAIc2/xEwqYQO6nxTtw1k
         BEmmiX538FzfxmuvXjQwS0/yDh/gp72kJ22A7B/HQgncKOHrjR8dMkUtB4JrxncG+j57
         bS0KBBUD1V9nKD8FHiriNCKHYJD7W377x2AP66N2rfqAmTQQBkdZ1xiCBQ2MwTA9D8Ou
         duCN+T8QZ4knKRPre4DkNETB3rpV7hoKQTCjGpON13aYfV8QO738tWUxXwuKwwdaLXTl
         tNsaLxjisQrjlPHh6J5KSnU2C9Cb4tQstckzKAnKLmFCl2+tP4cKahVE1XIpIC1lcyc1
         4DKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790535821; x=1791140621;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7pu/3ON0/cCBPt0BqikF7H7Rl4I/09E3LOdHlSpQShI=;
        b=T2Y+Dsy1gtIZMRcOKUBQ81wyrVA86syQEYgTQ0rW6+4sSbo2NQNEtlVZuqsI9sA6fT
         kk7ox/VySHB/zIOSwHaFqY+2w3yhLKNunosNmw/K+lfEMGK4qusPmExSkRYlt7KvIhsz
         5JVnCVEZwqu86EMOJWNiNBl6XY1g1+cY+OtLxY7R3mAdWINRCoV/C6mbLwDgUGl6ozGS
         hJo/zjk3XfXO23s74KBOlELOQ06e/5KMToNBUA2O/e0T4SliPiw7SwMjkYUERlvGmagg
         sYZFhwB0wm0aY1wHNFr0Gq31b2d9auf8GquJmhQ1KGhGWqolA0pPIolqKAfMzkAXeHlT
         gmtQ==
X-Gm-Message-State: AFuF++kXfF/TqAuSw3otT60LJfA0aZc2BiERKzSAagJ4nWCDSCUzxPH0
	QKGTy2MNMx1wttGycRh+3QlxfCdqdEjO/EaH5sbclxE9IJd3m3vwKPEITYSijxEsbXsliDnVDEH
	KwBH/iuvs3bz/w2Yl+w8qoF4Ax8gPtkG3rqYqbUtv8I9hCBXS3Rj+/E4HfC8zQ9azZKXGfyRfvs
	M7YA==
X-Gm-Gg: AYBFou14lQ7vga4gY1BGcjyjkxC3eQA4loDRF6qZs+ntcFwyuNTgnCE0oXo9rDazAn4
	RJP6B1segxmtg3T58nIblrfDcCOBSDYcpZZrNhb0EFFpgqvJnmdPKk/YRR+5p6onmdLNp9WQcnh
	xDygKcWRs/1phxBOkhqhYirNMip70RD/kJ/0WdVuWrHPgbbTrY+xnBRSfTBIqbRj7mFz9B15hPI
	DSOxTBj2Ky9dc8wcPtJjDOjwpsnTHi6pK/t6EzvxX4nxS2ucENpds9O2xrR6IeTShvWTNkqjUpQ
	RKus6NY5Lfv+irxVDEmbc+dVkZXV8gHh27MByknpPSQbFmolsTZ5xYHhD38B53KytaVPubatGuv
	cASEgbPR1ROR3ZFVqsbMlU5b2nDTzSH4pWSs=
X-Received: by 2002:a05:7023:a5c:20b0:144:c123:4036 with SMTP id a92af1059eb24-146d077b67dmr6179670c88.35.1790535821269;
        Sun, 27 Sep 2026 12:03:41 -0700 (PDT)
X-Received: by 2002:a05:7023:a5c:20b0:144:c123:4036 with SMTP id a92af1059eb24-146d077b67dmr6179619c88.35.1790535819659;
        Sun, 27 Sep 2026 12:03:39 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ad8e43d2sm23281813c88.12.2026.09.27.12.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 12:03:39 -0700 (PDT)
Message-ID: <ac4beb38-a504-4e0a-8766-ed6b854b66a8@oss.qualcomm.com>
Date: Sun, 27 Sep 2026 12:03:38 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: pull-request: ath-next-20260927
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: r8OAuADgjDD9hVas1i8xLWm-oDRP67WI
X-Authority-Analysis: v=2.4 cv=QvPLTlyd c=1 sm=1 tr=0 ts=6ab9688e cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=FX_wVIGubitqPvrcck0A:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-ORIG-GUID: r8OAuADgjDD9hVas1i8xLWm-oDRP67WI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI3MDA3NSBTYWx0ZWRfX85B/b99Ah3GO
 HOg37JLsuXTrT51E6ZPPZHkBqP754vunREqTZONhByljULEYo+yigvrFatvNps1geqLOC8HisuP
 EHxDPwm9BoLxQmM4PrZKkPAfgykVu39QeSlHAic3TNkt8BIMbAiJUf8lVQBAxEFQcTr4OGpwCJq
 VtdLJ7Zvg7Tj34p5eUcmCdUqMqVEapJUBPjCoR1PV2gi0JUr91GZoeK8RL+b8+x32QDPAoYQ+Jw
 ynJTEzpc8xFNPAAXPvKHfhLq+fWAiIF86gHRC4L33/Gc2B7t6MPwsyzBfTo1u4rD2zh3WYOd7s0
 myVT8FtwODozSXp3Xi//QRp3iyghrsRZTcqviwaFZ9khrml9zWkNWma0lI++hv2DpgYNz2G3mqu
 H/6vEMCiyXrIADEoy6vkWpwzcpCA5OOcSNvKsQhV2ZHdLtVoMB/77kclA4ob4DIoiij+FOswCqF
 Slm08bEwJqzA1XAy1Tg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI3MDA3NSBTYWx0ZWRfX6aTQu4PvxCgK
 xjbdpn3xbJreScZpnDmKzppS9PxE5jNxQQhvpuEe2oGGSfSpJ1821c8mHc93+laGMBDgShZyqtx
 +SithBxjGjEtrRjjxB1s3Y8RwTXQkLE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-26_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609270075

The following changes since commit 10cfa109c880092df32e396647b4afdca9be8350:

  Merge tag 'wireless-next-2026-09-21' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2026-09-21 18:17:53 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-next-20260927

for you to fetch changes up to 753baa59527f8e606c49eac25692b8b08918a3a9:

  dt-bindings: net: wireless: qcom,ath10k: Document NVMEM cells (2026-09-25 15:20:46 -0700)

----------------------------------------------------------------
ath.git patches for v7.4 (PR #2)

For ath10k, document NVMEM device tree bindings.

For ath11k, fix an error path resource leak.

For ath12k, fix monitor RX buffer lifecycle issues, properly align QMI
memory to meet firmware requirements, extend datapath device stats
coverage, and a few other cleanups.

----------------------------------------------------------------
Aaradhana Sahu (7):
      wifi: ath12k: move dp_profile_params to dp.h
      wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
      wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
      wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
      wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
      wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
      wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper

Aniruddha Mishra (2):
      wifi: ath12k: add WBM RX error drop statistics
      wifi: ath12k: add WBM SW desc fallback counter

Baochen Qiang (3):
      wifi: ath12k: use per-device max QMI chunk size
      wifi: ath12k: clear chunk paddr and size in ath12k_qmi_free_target_mem_chunk()
      wifi: ath12k: align QMI target memory to 64 KB

Hariharan Ramanathan (4):
      wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
      wifi: ath12k: add TCL ring TX buffer allocation failure counter
      wifi: ath12k: add device DP stats reset support via debugfs
      wifi: ath12k: track per-ring RX sent-to-stack count

Jeff Johnson (1):
      wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_event()

Kang Yang (6):
      wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
      wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
      wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
      wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
      wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
      wifi: ath12k: avoid double DMA unmap of held monitor RX buffers

Loic Poulain (1):
      dt-bindings: net: wireless: qcom,ath10k: Document NVMEM cells

Miaoqing Pan (1):
      wifi: ath12k: remove unused ath12k_dp_rx_h_find_link_peer()

Pardeep Kaur (2):
      wifi: ath12k: fix out-of-bounds access on TX stats arrays
      wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output

 .../bindings/net/wireless/qcom,ath10k.yaml         |  16 +++
 drivers/net/wireless/ath/ath11k/wmi.c              |   9 ++
 drivers/net/wireless/ath/ath12k/core.h             |   9 --
 drivers/net/wireless/ath/ath12k/debugfs.c          |  78 +++++++++++++-
 drivers/net/wireless/ath/ath12k/dp.c               |  90 +++++++++-------
 drivers/net/wireless/ath/ath12k/dp.h               | 114 +++++++++++++++------
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  15 ++-
 drivers/net/wireless/ath/ath12k/dp_mon.h           |   2 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  33 ++----
 drivers/net/wireless/ath/ath12k/dp_rx.h            |   3 -
 drivers/net/wireless/ath/ath12k/dp_stats.h         |  25 +++++
 drivers/net/wireless/ath/ath12k/hw.h               |   1 +
 drivers/net/wireless/ath/ath12k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath12k/qmi.c              | 102 +++++++++++++-----
 drivers/net/wireless/ath/ath12k/qmi.h              |   4 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |  24 ++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      |  52 ++++++++--
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |  39 ++++---
 drivers/net/wireless/ath/ath12k/wifi7/hal_rx.c     |   5 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |   7 ++
 20 files changed, 451 insertions(+), 182 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h
