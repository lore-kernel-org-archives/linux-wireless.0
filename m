Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB4B51C335
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 14:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789569319; cv=none; b=S5514Jene0snArS6jQpAYY8+0LWane9mcYr10VQBLgRT86XtzymZETNNRrcX5AezKapxG0EgpKbBo1Q7VPHKq+hzD96Cx4SBcBH88zYTSEZ5T+5hZBShK9tFbA5jHfxfzbxqCHEoQvaZYzvXZi7pSlT6dVjVc105wcGSod68J1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789569319; c=relaxed/simple;
	bh=Zi3mSLBQNZZo2v9oHiWFfl1yGQSv0KL/oPJSKS1MaNE=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=VjDwOYcP15mUjifAFaZuy0Vsbq7TuTkvOKhhXbpQeq25k2YAQ+4yPmQ1iTqRJXtKcrqp/qkMuL929z4CY7fnCpIxAxROTQsrdC6wCt+KKy8bzeV5zeqRgsZGWtJlg+DmsPc1rsImUFUQz7cTsYBOFwTQeaJfsC1C2g500+aKQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L0nQhZkF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Cf+tUNK3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L0nQhZkF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Cf+tUNK3"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEYbHI3902482
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 14:35:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=tK73FQp1Mf4ROUthjYwNJv
	g6RzgXr9daOQTchTpQz0Y=; b=L0nQhZkF76DbWVUbzThVh8vB7xUgbcm0FtGT/a
	rxlY1dSRPIUll5FY2PqxadXEkiCERctY65OxkZZUdACWNKpv/4GGVilCFPGiz+C/
	RwfqYUrYQ7wIeYMm7UnM3l72YIVjb/aeUOA2ZM91wqDfkMvykSkgqpyozJNhC7gz
	EnSHDx0P8Hhw+Ejv8nYrwTKqhkwgzTxC0nHGJY9FBwj61OOb6QHlKVD8JeGd6DSK
	nX/SRhPO9HpWZ/jpz7aqgb14tKWaREcF6kNUq0gaQg7hqxdkJYVXIhkz0UibmTm+
	vaKqVcizSf5bgONd1Zu6gYWYy5lhKC7DJli31FefwN9dUQSA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqpu2spdc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 14:35:13 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d63bad3d09so88167905ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789569312; x=1790174112; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tK73FQp1Mf4ROUthjYwNJvg6RzgXr9daOQTchTpQz0Y=;
        b=Cf+tUNK3H5qqV2PeTJvUmU13XpUMqpt5pYsZ/B9ooKx8ez8vclG+wueMM2709Zhgya
         hDxrcEnyTZ3/9AX16CZDnmVTLa9Wx+dJdmDXirFXWfrFrRHOtjoPRGGHb87Odu7/I4DO
         joy8NOCXeQVDZXvTRWya2PKxWO9qTuPYhsh8FA9ZchnIw7vxMyCYh37RxqF8aSpNeQRs
         26TZh9M4xIDLYj2e0tp4u+wMNNkq5e7sNe9oC1gcdavgiamPBrzQgQyxpyNhem+TFI4x
         UH5/6GMX37F/M12xIKvGwnlkb2wRNsCsAJU9HgzVrFbWy/vTGMuDU8lsxtRWIY3ftKk3
         JLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789569312; x=1790174112;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tK73FQp1Mf4ROUthjYwNJvg6RzgXr9daOQTchTpQz0Y=;
        b=1Ywwsmr1ooV/SBw6XwZpXepjTtmz7lqputgXDjWg8GD+flhJ2dqJqPpO3BeLu+aLhD
         LWQdSAwBEe7+ETz+UBR233eDrU72luovRIL+DdYCABkOPg8Ujdb+E6Zh3/a1qkX81gtx
         z5zC2ShOtjfRgzC9RUu9fouZLxOPluon0PHVSUlpwjlGEEuz9Tsulurxq8AUTP1Orol7
         Fphs3LJG95I3O2hlrwvhMw1sbCZWTIgU3Zy6mYs/HCt7asaaddAh46KbvYTqsHGRGwZm
         7uTpZ50IUzE3lsCOgROEiXK/AVUeTkUCRKlnwwels6PW/xvb5MZXgvjeWZgD/Rndj6rj
         P8sw==
X-Gm-Message-State: AFuF++ktaiRSe1lLXNkPPVS8CHXwP3sgGAXHoblR2rcTjbqa/1aD/o7F
	Oz9IfxFzOx+Jkv7uktbVla0ipK05QP6nXswRWTXcsMf2UA5H5DjrM6SjIKTBNmEYKc8/HZJuaGV
	Nl+rhQkKMOSnxQUK1thUdFW53SgyTlo+zGCAZJ/w3hkNGQoVyfpggtf55ZqOl12tH9tLtbit6Iu
	Z7UA==
X-Gm-Gg: AYBFou2EQawKcdHB6ehlQzGyqWMSJGPKNlvR+UmJkYsYm5nGsbSVZMpu0hj+B+tos4t
	zIT+dSuuTUGNe4+pviOX6hkOKNygBE5FYw6CUl65iNGDKy4U99gO2LitAywSY/R9Rb2jheMsF8k
	JpB09oQVneY51+x9Ph8akLk0MkHTDR3uZ+ewYB4cVQl+QdT8bMV3xbzgwAwQGFdNVuUplnRpD5J
	qlEmQE72o2+1PIhVva2B8zJI5QL99rS5usdLs5+8mBFRIrwDQrtgzZgz9fKRc2mQKHsHkoBlpWO
	NO7C/Nsbr/pHXkJ9WUHkylVezu37LRMem8+dDaFm1kF77g7bodZqKTTJy7n9DgmoKJwYcafgQaJ
	7WrD7oqOCgdbxaJSf1t+aA/GN6SsGC/pMMig2
X-Received: by 2002:a17:903:1990:b0:2dd:3ddf:b876 with SMTP id d9443c01a7336-2dd8cc8bc70mr59216705ad.0.1789569312194;
        Wed, 16 Sep 2026 07:35:12 -0700 (PDT)
X-Received: by 2002:a17:903:1990:b0:2dd:3ddf:b876 with SMTP id d9443c01a7336-2dd8cc8bc70mr59216005ad.0.1789569311628;
        Wed, 16 Sep 2026 07:35:11 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89eb7496sm13023775ad.38.2026.09.16.07.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 07:35:11 -0700 (PDT)
Message-ID: <ee7037be-6cc1-4bca-b732-42130483f469@oss.qualcomm.com>
Date: Wed, 16 Sep 2026 07:35:10 -0700
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
Subject: pull-request: ath-next-20260916
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: AK4PmKWWVhKexEkx9QK4L_HWYT4RA02i
X-Authority-Analysis: v=2.4 cv=NelzRGD4 c=1 sm=1 tr=0 ts=6aaaa921 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=7zb2UhBhSU3A8DwyPNsA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: AK4PmKWWVhKexEkx9QK4L_HWYT4RA02i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDE5NyBTYWx0ZWRfX2vCEw+GqO0j4
 ZDBUihFedXvSv6rm/h/2r3z9rs+SmtQIKstsN/ceym9x6Nw9JlUeEi4E5yTYvofif5ITd+VikbW
 HBY89jTIELKZU5Smb2DibBOdSzc6LTcmyBoXBF/fmJtu0M/bOD1Yj5YCwvt33sIvAaKYLcyiCkj
 otUtan/KtaF3fnWZGTUFWb6TzqfICMGe2XSuzeqyhbFqRQilQybl8rM1lEsdWnm//pgz8Cw/Xvf
 TQ0m8Oxk3SiqhF6lEcoELawtcOHognIru2H66BTSzu6wqJ7FOg5HB6Y+TFaUO6lYhzNme2VCedm
 AFvoEuKHU5wqCyVYoY0hitJsDVITOFkDdPgTPOLK2yUQtl5Or7KnBtB04oialCMglmzAxQqBgvB
 cDqDcPgNwOSwOdG/Ch406MViLOKobQx2A5XTkIlFKfj/AI2W+vQ7MyJ9J7T5ixbhjKKwKWRZcC6
 VAMzGS9JpLjUxb98YeQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDE5NyBTYWx0ZWRfX5szgbpEs6sf+
 nj0vLMm61Z8GuQZgy0l9sIXRtBCZruvxXwsNpqL/0xKtdBD+9g6WRItVFSeotMzBBuAg56PjlQa
 KBAQ7rXlFUQF7UrgkKE8OKaCb+lwiGs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_02,2026-09-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160197

The following changes since commit 1b78070aaef63512688aebfbc82365ef9d6660f1:

  Merge tag 'net-7.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-08-27 13:53:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-next-20260916

for you to fetch changes up to c3bace8584ca707e34ba837f65c2e9d566af4c2c:

  wifi: ath12k: add support to load shared firmware on multiPD (2026-09-10 14:29:09 -0700)

----------------------------------------------------------------
ath.git patches for v7.4 (PR #1)

Add mailmap entries for some Qualcomm Wi-Fi developers now using
@oss.qualcomm.com credentials.

For ath12, add support for the qcom,calibration-variant Device Tree
property and add more infrastructure for the IPQ5332 platform.

Other than that, just an assortment of cleanups and minor bug fixes across
the "ath" family of drivers that aren't urgent enough to go through the
"current" process.

----------------------------------------------------------------
Aaradhana Sahu (4):
      mailmap: add entries for Aaradhana Sahu
      wifi: ath12k: Free allocated CE IRQs on request_irq() failure
      wifi: ath12k: Free allocated external IRQs on request_irq() failure
      wifi: ath12k: add support to load shared firmware on multiPD

Abdun Nihaal (1):
      wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()

Andrew LaMarche (2):
      wifi: ath12k: support calibration-variant from device tree
      dt-bindings: wireless: ath12k: drop qcom,ath12k-calibration-variant

Baochen Qiang (8):
      wifi: ath12k: signal regd update completion when reg event is dropped
      wifi: ath12k: use per-radio ab in ath12k_mac_hw_register()
      wifi: ath12k: protect new_alpha2 access with base_lock
      wifi: ath12k: skip setting country code during registration when unchanged
      mailmap: add entries for Baochen Qiang
      wifi: ath12k: use kernel types instead of userspace stdint types
      wifi: ath12k: fix stale skb pointers after aligned TX payload shift
      wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor

Jeff Johnson (2):
      wifi: ath12k: remove skb->data check in ath12k_wmi_process_tpc_stats()
      wifi: ath9k: use rcu_dereference_bh() for sta->rates in ath_merge_ratetbl()

Julius Bairaktaris (2):
      wifi: ath11k: implement CE interrupt enable/disable for AHB
      wifi: ath11k: disable interrupts during firmware crash recovery

Kamil Bienkiewicz (1):
      wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332

Kang Yang (1):
      wifi: ath12k: preserve PPDU state across monitor status buffers

Linkai Gong (1):
      wifi: ath12k: clear dangling channel pointers on error paths

Manish Dharanenthiran (1):
      mailmap: add entries for Manish Dharanenthiran

Miaoqing Pan (3):
      wifi: ath11k: fix sporadic WLAN initialization failures
      wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
      wifi: ath11k: unregister PM notifier on QMI init failure path

Mikhail Lobanov (1):
      wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()

Nicolas Escande (1):
      wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()

Rameshkumar Sundaram (2):
      mailmap: add entries for Rameshkumar Sundaram
      wifi: ath12k: fix DMA unwind for ext MSDU descriptor retry

Sriram R (1):
      mailmap: add entries for Sriram R

Vasanthakumar Thiagarajan (1):
      mailmap: update email address for Vasanthakumar Thiagarajan

 .mailmap                                           |  13 +-
 .../bindings/net/wireless/qcom,ath12k-wsi.yaml     |   7 -
 drivers/net/wireless/ath/ath11k/Kconfig            |   3 +
 drivers/net/wireless/ath/ath11k/ahb.c              |  16 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath11k/core.c             |  10 ++
 drivers/net/wireless/ath/ath11k/dp.c               |   2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  19 ++-
 drivers/net/wireless/ath/ath12k/ahb.c              | 166 ++++++++++++++++++---
 drivers/net/wireless/ath/ath12k/ahb.h              |   9 ++
 drivers/net/wireless/ath/ath12k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath12k/core.c             |  23 +++
 drivers/net/wireless/ath/ath12k/dp.c               |   2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  45 +++++-
 drivers/net/wireless/ath/ath12k/pci.c              |  55 ++++---
 drivers/net/wireless/ath/ath12k/qmi.c              |   4 +
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c        |   3 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |  23 +--
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |  17 ++-
 drivers/net/wireless/ath/ath12k/wifi7/hal_tx.c     |   2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |   3 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  16 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 23 files changed, 346 insertions(+), 98 deletions(-)
