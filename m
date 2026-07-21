Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF624582DD
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677606; cv=none; b=BA8FSYc3m+rJCF+Pm/rvFnJLJYhIEZ+iBd9GQpclIw2mv34YSp8piWn1eLXrsRU58Jf4ipcQibWoNnwoaWMqbl5pnrRdTVyO7m/ZW44Sj5yZr5fzL9s4tbqxBfBaQxGZcvzD6YVG7yYGqZMChMMzurLCIs+h5HUDDpdZ4aPU/Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677606; c=relaxed/simple;
	bh=wSQAZzDooQHALx0s6Hxksl+cgvvC1nn1GguSIrYuzEo=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=iPVqUdfnjPCDR0fkgfBMW2zzWWVPsO25Rri3qxE0EhATI/YIoir77DRKQEji8ADATa9pdJiyTq1UFytqjSoQfDHBE1p/gI4JrRiqRXW3XgcMbADn7IDNbBfuW1wwiu+8+APBbMrISbV1KRg6jeYlygrKNL6VLLeRnJsGTqx/jy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b9osd8Yl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UAQ/+oNp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b9osd8Yl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UAQ/+oNp"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LMZIRf2812345
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 23:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Zwbc3ZwNB95OyYbvd9mIfm
	FmpdIbDNip3CDUKn9MSPY=; b=b9osd8YlwiBsSsIMn/kZwdZFVq2e+l4AADReWC
	gK6o9FNwnZ7PgnDxJHC3f0inf+o2FfwFYlp7mNQHfoT+K9ukHDEGPwqCweDABEWe
	9Hcgq08WI2PaQ3bThQ03TCHLzqkOfFxm7EuqKcl/Vd2eRsIgPR/9otVRIPhQfksz
	Okxy5wcybr5781sgN5KAse7j5nx4zlx8aK8QQOlzWgfzTNOfAxR5eATvgjBMjbE4
	qR+QEwSbBdTwQimkpIxGu8ghG4OGTnCCDrNhUoZOCvKOW9nTrxwUFlQlxlzC4gWg
	/c41dNPZrm6cLHr/+HpGtwCjxi6r7h6cUd/iN0CC5eDlLvBQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjd5e1ass-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 23:46:43 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb835525b13so1990202a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 16:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784677603; x=1785282403; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Zwbc3ZwNB95OyYbvd9mIfmFmpdIbDNip3CDUKn9MSPY=;
        b=UAQ/+oNpZibtbE+/HZ5d5HuNifqCF3COnYjOS1oyF1K7RDE0/Rrt9tGQCL1qydUoPL
         yVrAiIdlBY2e1KBBGgMxh3ngyJmLzNf9RWm7++8PPQ6lhPQKfN/RFxlYdfgvNuf6bcfe
         EtOSTmezJK+EFmS7GK1Raa0HxE+H2dKmEN9U0yeQwXk8briysr6uRLLvmHGfxXg6ujFG
         mX/mNCqgB/ypsE0PPBWo+1yqC9yXGkFqKYllwrixs9aM4wfI4DSwElrV3yrJA1XV6I5S
         x5w0Zgg+TQ5zzwmpvuNP7ln4upwWT2HLadDuyMuar3vqDWWvBp5qqXz/nh7XORUql2fA
         YxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784677603; x=1785282403;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zwbc3ZwNB95OyYbvd9mIfmFmpdIbDNip3CDUKn9MSPY=;
        b=mdoY34FZOGXFvd/KgfdI0ZbK0/gXpn78LaJJxIU7zmDO1IZQgLozypyR9QaKr65/PJ
         OnUsCnomnGAfYkyMTi1yqw4GUrYoEw/G6N3yBzj1c21B8owVwS7IMLZF/tJ6OcKO8F/R
         GGRb6Jfnk0jOGJBUgWiSY9OMeaKHeaHpf+M5NtLx0Om4BXfOR/4J2Hv9X4oEGoYdcphB
         13+Sn6Tpj0F+Uodru2PGaS83v+znjZDGBZYCscHFGtTOaZINzF63kQ8fKJt6YQP8BfmZ
         hVSbKqJOzDoWf97zDAoG5xDVZK2rYAJVpkM20KoQgPcTV7rOyvXjkjD7EOgtXRMBMBBV
         OoRQ==
X-Gm-Message-State: AOJu0YwbaqXY1TmhOQ6yEDhrSnZJfam4kpQgaO+/I2opBljvVAjDvV8o
	ZcRsLk1J/qo9CZqONSYaO7r3EJqOjJBcncgrrrMi9DSk7X65vrnfZf9nsqc5VYGByLq4K69oQOI
	nRPtNH9xo1FE5aTd/7FhQ6CPs2yMOzA+Jqtafr7Dxn3dgJvRWvNagv2qOKfTLw0e2DnSzwvSQWu
	mJtQ==
X-Gm-Gg: AR+sD11iJkNxj1/uy6+WZEwbJkv0dPX1IyPP5Vuge7CDp3S38TdUMABIuEe9l8dTUXS
	38M4QxKso8aSS9bsPMhMctptiUXo4nia3j3IVm87egTbW3eRiMJ177cdHcwdn3vrwVTLVmpEt5s
	rANU4K3lcOs67bu8FrM+kRm1Ka4Pv8ByXp2WIFteY9NNbDU1nD0DY0SENQs2Rgz8hC322zDbgo8
	e1xk/TU4tQog+GAFgtQK+Mn3cNH/VhZdEsoS9lhQmM8H3Z55iTFn/sOsZ28r0FAvhSDwW+ZIX+Z
	2Ul6BQy830mnMsXdhPY56zSiBQY3l9FxxHFALlk8Y9Lf/yaBmIZ/4oNK9lSdVvxcZpVt2AaNvCk
	C9j7hQ48Y2edgBUNNfoELMHdubETXx0Z0sAG+
X-Received: by 2002:a05:6a21:2d4b:b0:3b4:85db:1bed with SMTP id adf61e73a8af0-3c3ad9d1b96mr22906811637.45.1784677602694;
        Tue, 21 Jul 2026 16:46:42 -0700 (PDT)
X-Received: by 2002:a05:6a21:2d4b:b0:3b4:85db:1bed with SMTP id adf61e73a8af0-3c3ad9d1b96mr22906781637.45.1784677602134;
        Tue, 21 Jul 2026 16:46:42 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e088d3fsm2503310eec.25.2026.07.21.16.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 16:46:41 -0700 (PDT)
Message-ID: <f73b76bb-dc27-42d0-8e47-b617eec766a6@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 16:46:40 -0700
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
Subject: pull-request: ath-next-20260721
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: QqGGxgm2EzD0SeTsk9vbzyx_wqWb4920
X-Authority-Analysis: v=2.4 cv=CbE4Irrl c=1 sm=1 tr=0 ts=6a6004e3 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=h0gdpq4wJxyY6LqPCyoA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: QqGGxgm2EzD0SeTsk9vbzyx_wqWb4920
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDI0NSBTYWx0ZWRfX0oSVAeVzHM9j
 zyHVx+biNMMS5y6kN6layLKvs2vdNNLvQhzi09MCoIpsIaEa9qmcaH5Se9V127yJrqh9pCNQx/j
 eroz6D2sfPMzPZiWqhOtCbm1neGkSI9Y9QsLKlQuLIYnb3l7hTJ4wQsQe3MZX3aYXnuS6C0DMW/
 p7/6dKns+PmbtPQU+8JHYeLwAFsETHblyaEJAcF332tILzJ3bepWQN4qmLxe1V+FpNKycicN6O/
 SY7Kh6yELruVXRQDRxwhsVdAYyUD2psMZ8JRs3sy+YaHtV8k7onthUiLOhgnvzsjXalw/nIiTpB
 xIIb+cbNpus8hzMhLdLHpQYLm1YZVuzEtbl4XYNxo+BCokGEx8EAs3d2Iq/ALUc34DZvcxzwlVR
 RIQR/NacmvaVpT8GWG1JmCpswUbAZe5AHhQ38gEA4rzw9r8po49zH/glHRP5F4SF7rldESBAnz2
 JnIacAss9T2FgXaiLWg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDI0NSBTYWx0ZWRfXwMh6VxjVE37a
 upJvScB2s2BVjKmqB+UrOq6Y34qy59bXwEQV0lAFoZhzcttrJI8uUlNb1oZu2tOJKGeKcqc92Hn
 nHFSxCSJy+neopWYEUKQp1VXMryri08=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_04,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015 spamscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210245

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-next-20260721

for you to fetch changes up to ca27e3c2284a7a43ba390ed5ce0d68b3c869c0ce:

  wifi: ath11k: add purwa-iot-evk and qcs6490-rb3gen2 to usecase firmware table (2026-07-21 13:00:02 -0700)

----------------------------------------------------------------
ath.git patches for v7.3 (PR #1)

There has been quite a bit of activity across the ath drivers.

Significant changes in ath12k include:
Align with new Qualcomm generic Peripheral Authentication Service (PAS).
Ongoing infrastructure changes to support the QCC2072 platform.
Ongoing infrastructure changes to support the IPQ5332 platform.
Enhance datapath statistics.
Tuning of datapath parameters.

In addition, an assortment of cleanups and minor bug fixes across ath6kl,
ath10k, ath11k, ath12k, and carl9170.

----------------------------------------------------------------

NOTE TO UPSTREAM MAINTAINERS
This PR includes the merge of an immutable branch from the qcom tree
https://lore.kernel.org/all/178362521364.2422497.1305957434056184382.b4-ty@kernel.org/

----------------------------------------------------------------
Aaradhana Sahu (8):
      wifi: ath12k: remove unused QMI definitions
      wifi: ath12k: expand UserPD ID mask to support up to 8 PDs
      wifi: ath12k: correct monitor destination ring size
      wifi: ath12k: add QMI capability negotiation for dynamic memory mode
      wifi: ath12k: update IPQ5332 BDF address offset
      wifi: ath12k: switch to name-based reserved memory lookup
      wifi: ath12k: refactor QMI memory assignment
      wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region

Aishwarya R (1):
      wifi: ath12k: reset REOQ LUT addresses before firmware stop

Alexander Wilhelm (1):
      wifi: ath12k: fix scan command endianness on big endian

Baochen Qiang (3):
      wifi: ath12k: fix dp_link_peer dangling references on AP vdev rollback
      wifi: ath12k: fix MLO peer delete race
      wifi: ath11k: cap out-of-range rx MCS instead of leaving bogus rate

Christophe JAILLET (2):
      wifi: ath12k: Constify struct ath12k_dp_arch_ops
      wifi: ath6kl: Constify struct cfg80211_ops

Daizhuang Bai (1):
      wifi: ath12k: Set DTIM policy to stick mode for station interface

Hangtian Zhu (2):
      genirq: export irq_can_set_affinity() for module drivers
      wifi: ath12k: enable threaded NAPI when DP IRQ affinity is unavailable

Jeff Johnson (7):
      Merge qcom PAS TZ service series (20260702115835.167602-2-sumit.garg@kernel.org)
      wifi: ath12k: Fix ath12k_wifi7_mac_op_tx() style issues
      wifi: ath6kl: avoid buffer overreads in WMI event handlers
      wifi: ath12k: Correctly copy the hint BSSID in WMI scan request
      wifi: ath11k: Correctly copy the hint BSSID in WMI scan request
      wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()
      wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()

Krzysztof Kozlowski (1):
      wifi: ath10k: Drop redundant NULL check on devm_clk_get()

Manikanta Pubbisetty (1):
      wifi: ath10k: trigger hardware recovery upon rx failures

Manish Dharanenthiran (1):
      wifi: ath12k: advertise ieee_link_id in vdev start MLO params

Masi Osmani (3):
      wifi: carl9170: mac80211: document spatial multiplexing power save handler
      wifi: carl9170: rx: track PHY errors via debugfs
      wifi: carl9170: cmd: downgrade transient register I/O errors to wiphy_dbg

Matthew Leach (1):
      wifi: ath12k: fix survey indexing across bands

Miaoqing Pan (7):
      wifi: ath12k: fix TLV32 length mask
      wifi: ath12k: refactor HAL TLV32/64 decode helpers
      wifi: ath12k: add HAL ops for monitor TLV header decode and alignment
      wifi: ath12k: add dp_mon support 32-bit TLV headers
      wifi: ath12k: tighten RX monitor TLV bounds check
      wifi: ath12k: fix ML-STA authentication timeout on QCC2072
      wifi: ath11k: add purwa-iot-evk and qcs6490-rb3gen2 to usecase firmware table

Nicolas Escande (1):
      wifi: ath12k: avoid setting 320MHz support on non 6GHz band

Pengpeng Hou (1):
      wifi: ath11k: validate regulatory capability phy_id

Raj Kumar Bhagat (2):
      wifi: ath12k: Fix inconsistencies in struct qmi_elem_info initializers
      wifi: ath12k: use %u for unsigned variables in QMI debug logs

Sreeramya Soratkal (3):
      wifi: ath12k: Use runtime device count in dp stats display
      wifi: ath12k: Add timestamp to dp stats display
      wifi: ath12k: Show per-radio center freq in dp stats

Sumit Garg (5):
      firmware: qcom: Add a generic PAS service
      firmware: qcom_scm: Migrate to generic PAS service
      firmware: qcom: Add a PAS TEE service
      MAINTAINERS: Add maintainer entry for Qualcomm PAS TZ service
      wifi: ath12k: Switch to generic PAS TZ APIs

Sushant Butta (2):
      wifi: ath12k: Skip setting RX_FLAG_8023 for Ethernet-II (DIX) frames in monitor mode
      wifi: ath12k: Skip peer link info update in rx_status for monitor MSDUs

Tamizh Chelvam Raja (2):
      wifi: ath12k: Advertise multicast Ethernet encapsulation offload support
      wifi: ath12k: Set IEEE80211_OFFLOAD_ENCAP_4ADDR after tx_encap_type vdev param

Thiraviyam Mariyappan (2):
      wifi: ath12k: Reduce RX SRNG interrupt timer threshold to 200us
      wifi: ath12k: Set congestion control max MSDU count

Wei Zhang (1):
      wifi: ath12k: fix rx_mpdu_start layout for QCC2072

Yingying Tang (1):
      wifi: ath12k: change MAC buffer ring size to 4096

 MAINTAINERS                                        |   9 +
 drivers/firmware/qcom/Kconfig                      |  22 +-
 drivers/firmware/qcom/Makefile                     |   2 +
 drivers/firmware/qcom/qcom_pas.c                   | 298 +++++++++++++
 drivers/firmware/qcom/qcom_pas.h                   |  50 +++
 drivers/firmware/qcom/qcom_pas_tee.c               | 479 +++++++++++++++++++++
 drivers/firmware/qcom/qcom_scm.c                   | 335 +++++++-------
 drivers/net/wireless/ath/ath10k/ahb.c              |  12 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   6 +-
 drivers/net/wireless/ath/ath11k/core.c             |   4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  30 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  16 +-
 drivers/net/wireless/ath/ath12k/Kconfig            |   2 +-
 drivers/net/wireless/ath/ath12k/ahb.c              |  29 +-
 drivers/net/wireless/ath/ath12k/ahb.h              |   2 +-
 drivers/net/wireless/ath/ath12k/core.c             |  34 +-
 drivers/net/wireless/ath/ath12k/core.h             |  13 +-
 drivers/net/wireless/ath/ath12k/debugfs.c          |  14 +-
 drivers/net/wireless/ath/ath12k/dp.c               |  14 +-
 drivers/net/wireless/ath/ath12k/dp.h               |   5 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  70 +--
 drivers/net/wireless/ath/ath12k/dp_mon.h           |   4 +-
 drivers/net/wireless/ath/ath12k/hal.c              |  42 +-
 drivers/net/wireless/ath/ath12k/hal.h              |  15 +-
 drivers/net/wireless/ath/ath12k/hw.h               |   1 +
 drivers/net/wireless/ath/ath12k/mac.c              |  96 +++--
 drivers/net/wireless/ath/ath12k/pci.c              |  12 +-
 drivers/net/wireless/ath/ath12k/peer.c             | 130 ++++--
 drivers/net/wireless/ath/ath12k/peer.h             |  14 +-
 drivers/net/wireless/ath/ath12k/qmi.c              | 429 +++++++++---------
 drivers/net/wireless/ath/ath12k/qmi.h              |  34 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp.c         |   2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |  66 ++-
 .../net/wireless/ath/ath12k/wifi7/hal_qcc2072.c    |   4 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    |  13 +-
 .../net/wireless/ath/ath12k/wifi7/hal_rx_desc.h    |  34 +-
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.c    |  13 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |  73 +++-
 drivers/net/wireless/ath/ath12k/wmi.c              | 165 ++++---
 drivers/net/wireless/ath/ath12k/wmi.h              |  26 ++
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  17 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |   1 +
 drivers/net/wireless/ath/carl9170/cmd.c            |   4 +-
 drivers/net/wireless/ath/carl9170/debug.c          |   2 +
 drivers/net/wireless/ath/carl9170/main.c           |   8 +-
 drivers/net/wireless/ath/carl9170/rx.c             |   4 +-
 include/linux/firmware/qcom/qcom_pas.h             |  43 ++
 kernel/irq/manage.c                                |   1 +
 49 files changed, 1926 insertions(+), 775 deletions(-)
 create mode 100644 drivers/firmware/qcom/qcom_pas.c
 create mode 100644 drivers/firmware/qcom/qcom_pas.h
 create mode 100644 drivers/firmware/qcom/qcom_pas_tee.c
 create mode 100644 include/linux/firmware/qcom/qcom_pas.h
