Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127AB3A544D
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 20:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785789160; cv=none; b=jNIFWhdm6dEm7rSZA10yYUkxnyhP+GkFKpyJUXL3UKwPtLrY1pbuj6HY5f747GnpZszxgwJWGzk5aJugbnirX1TyE7IHzP7F9tGHrwJAOJYOH7PZDxcvQtz5zRSO55fzQ1jtKTn5SONOGMT/CqXbvwgOocn50l3jQ1hgPi7uWfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785789160; c=relaxed/simple;
	bh=g6wdICZBIiXB48TAuzYtk3gBDlbafzKvrKAkB0s9Y9A=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=P3A/fN+LTd1/PhnCsClijth2IFa3P9+pTPR96VkQEjgy34m2367EEhAY4E2DTgODaPEWoFCpS8l+gcGQge2XiWIA8h4rkfJ7WEml881ab/efgF6P/pUrdciClxthAy4AxDQmhjtJrhhTliCR24veUHD9I9wfoO/lSqqtaGIqWqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M7UU3bv8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D1XOjxKl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M7UU3bv8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D1XOjxKl"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673JknmT2773457
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 20:32:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=awTHV+0FHJTetu7VAFUruO
	wJMsi/uWQRW6kJiJoR04s=; b=M7UU3bv8jvmuGlt360SYvXSL97ZgGhu6ieMi1t
	aclz1S9hmMS5caX8giNmy/akI3PsNwfP0lCQWC9EiUb59Q7vWwWiUnej+CukvsFU
	Ajz4Fi0NbGmR1YEZ7VIFxfBmyGip6jD8KKcrtXN7ucV6L5Dpd2dI/C5P58yhsEdE
	m3h73oWRlD+LayTt7RkROzos00sbiLErn078JI284DMr9mo2huaupdtZmlOF4Hat
	iaL/k63bBeso3m31wbyLs63p3jI9Puf+KHy1zPfLHpUGGAT11SclHBvuh45E5wAP
	x3mlXkYJvoO0kq+BMiT8i8C1MtIkV1COyMWk/pzgjRy1EUVQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftwhdscff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 20:32:38 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-381250979d5so3672832a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 13:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785789157; x=1786393957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=awTHV+0FHJTetu7VAFUruOwJMsi/uWQRW6kJiJoR04s=;
        b=D1XOjxKlxi+f9s2yUCLJAoQNduNB5bj4XY2nl5mZ6M0r5EGbfKbRS6b1XgJieviyxp
         L5CpHj8Hpvo18PBwwXv7E0mkSYgwzM91rwNka0kgtkGlExS3NrKlgLzMZeoqapB/Gi4u
         mLMT1uZWhOsr/MDgVYENrey3fL+3x1awGRpQDymNMsYWn9FahiWQBXCyN0XGN5UFLY6A
         qsxf7GeYG8hJUFxWZKnS7WYX+CU77YxG/JMxmK/QFShzZuMdrW+5RQ0uYVj+U/hG3DKn
         MHi9m9L++ISTDpMRr5xJthXfr6F4ie4rTcVwejrdTeAF1x1ePsYn74GJVxvHthL6/5/A
         ckUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785789157; x=1786393957;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=awTHV+0FHJTetu7VAFUruOwJMsi/uWQRW6kJiJoR04s=;
        b=ViBxUuc++biO3O9HuoYPq271ojJSwBovqcKBsWeY9CZ0zh+shdetPvYV4kQnyn+QHk
         sOahRdCgKKy4A3ieqyWNIDGiedEnGgiC/n93xFCltXHZ3sBctlaTmy0tWUId/8NQaE5F
         r4eJV2cSJ5/AXI6R8nBF+SvXhma9Ofx2xCKZDK7btZabZR7BzeXxHgBqhRNOKG3EQjxe
         8jl32BuzJk9Fffjjlo1nfah7VolOvEHiIXpeud5vSKTmQ3tAs4f2v739lffmJ/HH8zfv
         FXRApIbiYyjBhV+wU5xBOs8CwY1yn/p0BGb007lCbqn3a6cjPHP/4vDlQ0y6lGfZsGAY
         FAAw==
X-Gm-Message-State: AOJu0YxwHQj2zJe90w+/x3AhRWbIPihq6Nh33PHsYjkW8f7KgQ3qP8PB
	q9sDJ7hSeHxDfNQYRV4hGvtZbcCpv+5KhKDcjhR4/YdUCKL8g1a4S2xVFiSxCZ/293754CAPbPI
	s6ql0RqEDI1tB+YaOJffNhskAj4kfE7qlOsEB7fMqFPXrujHTb2J9YQlPPApigTYqYwRtw6VXd2
	mNhw==
X-Gm-Gg: AR+sD12w3iL25wcXzUZ+wLt03crO+Ja8rYa9t2O7lBH/GV/VUleGiaD0p+iV69aLjh4
	5NfBZC8Ge4XuXDru+Sfet3YFvldQXxaTeCRAHvMSiVtFHMJXQcXRShMCNnwmXK/VY7Y6rmnghu4
	xpp9zIjRa/WRDdXj/3XfNJGqVCiwpPluGR3h3RFNKaKf+7d1Y1ua5AHmuSqBy6f/Z+yPC83zUm3
	duw4zCS/rNNaLgdwWOOqzdDXGKaMNizW3Gi35CPlhvU737KEsSbVY7jwZohOfJWd/Be9NJovM9A
	aLC6jcyAqXDsiLYhpQk6JPUkzQQIj/90/+VxyQhZONKBBB3ONxYOFeJIz3wcaH1fKlhoQ6UOzlJ
	QfUFFAvCQcZWw3uWd07p81U5g/bCnxKNqe/Pb
X-Received: by 2002:a17:90b:4f48:b0:38d:c834:2106 with SMTP id 98e67ed59e1d1-38fbc4fcf95mr10430253a91.28.1785789157427;
        Mon, 03 Aug 2026 13:32:37 -0700 (PDT)
X-Received: by 2002:a17:90b:4f48:b0:38d:c834:2106 with SMTP id 98e67ed59e1d1-38fbc4fcf95mr10430228a91.28.1785789156974;
        Mon, 03 Aug 2026 13:32:36 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab1334cfsm37948142c88.1.2026.08.03.13.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 13:32:36 -0700 (PDT)
Message-ID: <e3d855a3-94ee-496c-98f0-efa10e0138c9@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 13:32:35 -0700
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
Subject: pull-request: ath-next-20260803
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Zf4t8MVA c=1 sm=1 tr=0 ts=6a70fae6 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=M1n47RuBD0lxbceSDO4A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: 40xodkKIwpvGemyalBFd54hTEqSkPjoe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE4MSBTYWx0ZWRfX1eZOVQHywtWo
 KwhhRCv8jbb0dpCrXOCyoNQLP5B+OXJpcPjZ/Uv608BQwArJjqyU7mkNGOIb5gYe3TJ31UqDoVx
 qcijHiZ6pB896hhygc/x5VnvCLqER63k9x11TRkxHQQHj/GKHjdprDHoMnr/I7UtuWnySEo4WwP
 rZi3pIGaNBYHIsbPVjgEYnDl49lsZb/7sZ6DpzmIjh7xHafEey/F1C/1OsINqTVKBJNT9JhLH+T
 EEeaRJkCXsg+JgXvhT50Dc0SZQgIgzOGun+IXRUXtuFvgxNnUIglLLG3RQBPoSK/2tY6KGb09hj
 XATe1R81UwX7v86urv+oSPF7UQePZYYf3Ikp8i5Q08APWjoDsOGkx6F4RiPL3CYk2j5E04bRgEz
 tGprVlZqsV0923SZ2z92oSZ0FOLY2MaBp0S+RRYPpIOL8oVyHM2f6Ao1HSs8rGj51Z63EKqZ2Q4
 YQFtKkOlJ5RdE6RQ8+w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE4MSBTYWx0ZWRfX/Ra7M7ElCa8P
 Z+inwpJZsKXPUhYIvSOIzQVkXaO0LkUJptxsO4Nx99ChD5QhwKS4EHFadZc7ez/CsL5x2oLhxg4
 laLfYVi3PvFECbqXIVMxKCGuhXldEs8=
X-Proofpoint-GUID: 40xodkKIwpvGemyalBFd54hTEqSkPjoe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_05,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030181

The following changes since commit edc84a9396acf1a0e78c46230dd0bcee1b84ac53:

  Merge tag 'wireless-2026-07-26' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2026-07-27 16:03:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-next-20260803

for you to fetch changes up to 4f25071afe9218aaae1c63fbf75e229aa6405319:

  wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump (2026-08-01 08:50:27 -0700)

----------------------------------------------------------------
ath.git patches for v7.3 (PR #2)

For ath12k, add MultiPD support for AHB platforms. Other than that, just an
assortment of cleanups and minor bug fixes across ath6kl, ath10k, ath11k,
and ath12k.

----------------------------------------------------------------
Aaradhana Sahu (2):
      wifi: ath12k: add AHB platform descriptor support
      wifi: ath12k: Share RootPD state across UserPDs to avoid duplicate operations

Doruk Tan Ozturk (1):
      wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets

Jeff Johnson (8):
      wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
      wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
      wifi: ath12k: validate TLV length in process_tpc_stats()
      wifi: ath12k: move firmware_mode enum to qmi.h
      wifi: ath12k: rename firmware_mode enum members to use QMI namespace
      wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
      wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
      wifi: ath11k: fix leak in ath11k_service_ready_ext_event()

Linghui Wu (2):
      wifi: ath10k: filter non-UTF testmode events
      wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump

Pavankumar Nandeshwar (2):
      wifi: ath12k: Use different RX release ring sizes as per memory profiles
      wifi: ath12k: skip MLO multicast links during crash recovery in Tx path

Reshma Immaculate Rajkumar (1):
      wifi: ath12k: fix encrypted EAPOL TX in encap offload mode

Sang-Heon Jeon (1):
      wifi: ath6kl: return 0 explicitly in ath6kl_init_upload()

ZhaoJinming (1):
      wifi: ath11k: fix resource leak on error in ext IRQ setup

 drivers/net/wireless/ath/ath10k/snoc.c        |   9 +-
 drivers/net/wireless/ath/ath10k/testmode.c    |  14 ++
 drivers/net/wireless/ath/ath11k/ahb.c         |  79 +++++++---
 drivers/net/wireless/ath/ath11k/wmi.c         |  30 +++-
 drivers/net/wireless/ath/ath12k/ahb.c         | 209 +++++++++++++++++++++-----
 drivers/net/wireless/ath/ath12k/ahb.h         |  34 ++++-
 drivers/net/wireless/ath/ath12k/core.c        |   7 +-
 drivers/net/wireless/ath/ath12k/core.h        |  11 +-
 drivers/net/wireless/ath/ath12k/dp.c          |   2 +-
 drivers/net/wireless/ath/ath12k/dp.h          |   3 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c       |  46 ++++++
 drivers/net/wireless/ath/ath12k/dp_tx.h       |   2 +
 drivers/net/wireless/ath/ath12k/hw.h          |   1 -
 drivers/net/wireless/ath/ath12k/mac.c         |   2 +-
 drivers/net/wireless/ath/ath12k/pci.c         |   3 +-
 drivers/net/wireless/ath/ath12k/qmi.c         |   8 +-
 drivers/net/wireless/ath/ath12k/qmi.h         |  14 +-
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c   |  90 ++++++++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c |  64 +++++++-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c    |   3 +
 drivers/net/wireless/ath/ath12k/wmi.c         |  32 +++-
 drivers/net/wireless/ath/ath6kl/cfg80211.c    |   5 +
 drivers/net/wireless/ath/ath6kl/init.c        |   2 +-
 23 files changed, 550 insertions(+), 120 deletions(-)
