Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865E438E8DA
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737133; cv=none; b=VyMl0HzBm4jFma+AdcxkwoyN3Sxl7K26Hya8b/qYVdeKROTzh+yk0rkzkndjN8P/SRP1SPg0C6vsF+qBh35R4UXH4j6N70djlJxtIWR2uS5cahsq3fxntZav3SFnAvt60ebzp/sxSTZBjo+sqEENYlY9GSAoeumAMvqAh81H4z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737133; c=relaxed/simple;
	bh=CegzZKbMyqcwqRoha6SNkTurhd/5mXE+Rl/vUv39o7w=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=JYZBrOUNhe7gM+Mg/813Yt6f31HuCwwz0i0hBklekGhqj1uKscXfMOz0+b9LYCgCHFDEeAAqmEgZ/AyfNQGBE9GGbDmLUob4s3dc/2W2XSA7voULmWoAOLob+yjuK5No1WQtd8sJLTX8O02MnLTgEQQ14o8GYc7ulWSdqPxEy7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SPkRfWSI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YIfbZcBJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SPkRfWSI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YIfbZcBJ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MFY0ff727339
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 16:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=bvNGit+48fLsB2erzIJYS0
	LkNke1lzGyrG/tXRkoa5k=; b=SPkRfWSIvnngS8xVCpYjXB4HssV4yX900Ilf1Y
	jH8p3GcYO9uKSjWzurn+2V64jjTmXDU953f0mXe3rIQSioIA3LqVJ1aHAuVkg72+
	cyJp+nVtHbVQp50R4oOy+l62V4qJWlOmkXyofukdQ0ZBdlEcV7ON3lu5Puqq7/xr
	03x81XADAnQLCI9wiAsD1AIT7fN3jr3GGUlGrLdL1puaHA5D0r4s5YRxdi/WU8gs
	/apLSE+/IqoBDJgqNUFe9vho9Pn25lJCStqSQNLtlkyrvZkfT56ErWx+Gt5zh9w7
	V8oHbBhU/FAZ8Pu9CkRzsHTtBZVfGppYEu5qeTkRGg2A+SUA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjxmggt4f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 16:18:50 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-848d21bbb55so9559464b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 09:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784737130; x=1785341930; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bvNGit+48fLsB2erzIJYS0LkNke1lzGyrG/tXRkoa5k=;
        b=YIfbZcBJKP3G4v39HhZoOm8pTvV3XHun7B6nL/Fonh3DNwKRXYNdkmivvXjYU5sgeE
         IybZwlvOWrZpRupT4WqeGd/CUFzexu7OlLK1VktJC7JKD6qZIoa2y4X8V+8taw8sxH37
         n0+qLx0heWcKryaHWZIc+VdA//tVDFfqONv2mGQ6KULRLwKjrLuFOtpd+YG9cIIWFbcm
         D3KOE4UzdLpjlQF8eR36xA2ADf7xcek3mobzP35RNzXqcOYxR4tkB7MpP1VBAbyaP07b
         DnyOGzZRgBJjIZetbVCpmAkTTAvpfDG8PS7pS93Svwn8x14papnZQ7iSJrlvrItxgunk
         QqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784737130; x=1785341930;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bvNGit+48fLsB2erzIJYS0LkNke1lzGyrG/tXRkoa5k=;
        b=HB4fR7c68UZxg785pFdSSKKDpKP5Z+Zb7PBHwZybc98OA+6632BPQgsRxsfPtLTEmW
         sAKXzc3r6U/WZu5FSlK8AGch62VpMauiNJVipnd//69YkyoChHwAlzvOkZrAUeL6UJi+
         tX7K1unPDWVa4nVIZYJLuQwgj+7jfTD5kp3U7kQQRCgglL13IoTG0D9XYVtcUtfoeBWc
         HV7qu99JZ3+P7/E035cFhHvzhMWZmtcKFTyDA7vBDf9vo+5bc9z17HgEghoq/J/CKBA8
         prJJSlTNeGU6ufsufzHCRe9W2torrhePi0FoIKkznLvEZY09b7qmp12ZweKG8YSorllt
         Mn+A==
X-Gm-Message-State: AOJu0YyAYNv9OoL3/Ly0bOVtpdnDgCxkBJzs5cm+MUXWbT9LLQ3d4VMm
	KcpFWEOMNwOyYUUBB0MKyUkrz/ZQbwR32wdHbgJW/gIlH4A+0/pqsXXFa+OHjrFVLbpD5BBwDAA
	Seu68HGtsCl+3fcHYRkSNNhZeEFXLn5LRChfIjSmvWI2jOl7fJ0TltG9BmYqpo1T4lqN1EoVEKU
	11Yw==
X-Gm-Gg: AR+sD13Qu7di2GZNKg/8cmj+TWUPoRPHBrvICrthec8N+ltKV0Ud6mX/SUIitcD7ola
	BwF+DuB8RNBGE8ro5uQPVZiydvyesfDoggisWmmH3AgY2BcO9LCf4oSjDTMcE9eOem/tA/BOYy/
	GIj0m7od17YEnRHysdgxTUGObHErl3lSM2VO9KiO783yZhDNNW1tsx057BmKZVDDthtRq7K3umA
	+7ncrRyfB0XQVZh2o4kJKXIUzUlT8JsBIdHxS42X3dsJCnK2rXBXTotCB7n2KhpjiZ6oJGI/dgv
	ZHcDw/zD6uYIc7gLrHB/300SLk7WMyWfjOwz5VKP4ZWMvcyjD28HflGdW2Lz9ky0F4bcJuNXgOT
	jN0NiR91NaYK9wCti7bfdFerb5iFFKiTmSVYn
X-Received: by 2002:a05:6a21:4a97:b0:3b4:8f18:33a with SMTP id adf61e73a8af0-3c3ad5d7a8dmr25561476637.1.1784737129716;
        Wed, 22 Jul 2026 09:18:49 -0700 (PDT)
X-Received: by 2002:a05:6a21:4a97:b0:3b4:8f18:33a with SMTP id adf61e73a8af0-3c3ad5d7a8dmr25561427637.1.1784737129030;
        Wed, 22 Jul 2026 09:18:49 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e081985sm11060289eec.23.2026.07.22.09.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 09:18:48 -0700 (PDT)
Message-ID: <42b715e8-2cf9-4dd7-ad27-a69a0cd34a67@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 09:18:47 -0700
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
Subject: pull-request: ath-next-20260722
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=D+V37PRj c=1 sm=1 tr=0 ts=6a60ed6a cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=PRdWSULKuqRJmV2TB-IA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: _IHQFbtEGtVBjdDaP904CVx-hqFHHnGx
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDE2MCBTYWx0ZWRfXxn/q9DSbydf4
 nqJDoa6ntffjdI36G/2ZqOTDE7Xj6114A9fxyEMEsy7KojPNQ+aL6k2NETnGnu389r/cG7aqNtR
 2cKPA7b+Ido8Gug3pVnkmJHauwo0hP8=
X-Proofpoint-ORIG-GUID: _IHQFbtEGtVBjdDaP904CVx-hqFHHnGx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDE2MCBTYWx0ZWRfX+WeI2Ry7ukNo
 KVEeYnC3ql0W2GFMtaRFH86tXkYzY+osecCPo8yTjHmY0zKC2wraPAS4bkNdoch9n5oKQ2vx85/
 L6EVNra2JnqKMbE0aG5weLdBeDMDPNdIT7lF/tUE6T92S4vQlX/h3imu1jgGdzi8f/mGaRKeG/J
 3nRHNT3wGFbZl/BinpfwnC4svAb6zJKxfZ3/N1QITFcguAVAnA/ZDHUR/4eiWVrlbd0SnJ6/zuU
 8irFEglmMQgSoZc+fCipfUdpxUmJH1OeU2VdrdGVvaoG6GdmC/OmGzyuYdfPpU+494K51jWE2p1
 De16YJpTPGLKJr6hEw/AaPEfGa2zuWtgI1GMu1gAp4XJq8T9rOt2GukJcTWxOZlq+JwqRlCLBnq
 N+yOcHZJAfj7HrF+f+Rs+cHvh7wiDFqP5VxX2pftOzbDITVxX2X3deS/X/aYgvHUWiJap8V8Uh4
 NdiEXIPwwQ1KbKHH7Ng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220160

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-next-20260722

for you to fetch changes up to 3826a4d293abb82826dc79ad682d7f885f125dc5:

  wifi: ath11k: add purwa-iot-evk and qcs6490-rb3gen2 to usecase firmware table (2026-07-22 09:02:20 -0700)

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
This supersedes pull-request: ath-next-20260721
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
