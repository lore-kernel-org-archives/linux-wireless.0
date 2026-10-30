Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367035;
	b=tvqNce+y1Jx0qSR2T6VLbwLliX0P9fp/vm0AdkM2qCd32YIPwOsyOElF7IBOv0Sh54yp
	 aJSGeXpYyCpDz2u/pJmgxfpDZznvD4Zrx6fV9MIw/rzY9igRryt9qLOP14oJ8H4ANjzo+
	 qzKmp5lB62UpSsegV+6s6U7JVEJzIi2q2u+OkEYMNw1zviqQ+vcBCv6lw88jzi0TjgK71
	 ZsZOeWSKDTYBf4DdNPwhu1armgxPIg7hgu2mVHVqBv9DksQ2uWuRA9jPr+I2pY1Emh9dS
	 /XjdHtmxHcB6FlUfa492qo5ZFOu1taVy2iXvYSnSnvqFIh/zeGfYSY9TC20C5/sdBDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367035;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=2S2+ftVMigTG222SzS2D5iPPQE6qVzbPncufpVNONLs=;
	b=3oZRUGAOUhVlDvj+YOoKB8QWM6WPF/v47iXr+Oj1nqKU8dHCuKhUP/U26RNTHKJfbJZq
	 2YphsDjmu0Ou+NCyUw0ClAlEMZ8Nh1FpI9uFEEsXPJ8UQha9BlCOrg5K8H/Dwu/TpBvmV
	 weYDnVzCF4pOvmPrBSRyZOThgtA43Lidn0dPTfkpwyLZ3LmR8kOW7P0lpK0o/p4Fcbh8/
	 sXSCA6l4pU0Dr8lo9f9lK8iiiyFfHClvgAjlZPsQJEW11d/auSEAr21rj/z61M/CW199X
	 ovnSmR8VVnzm0pzDh/cFRExFIwKIFA9cQg17Auz9NS5bS9uS93v02iLPYlkulddmVZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C7upM36k;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OyKqpevL;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B8D606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86B8D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C7upM36k;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OyKqpevL
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG4je3142130
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=2S2+ftVMigTG222SzS2D5iPPQE6qVzbPncu
	fpVNONLs=; b=C7upM36kqbXewR1Fq7tvHTAEa5Fh7N8KcgtDyJ2+SzXcftxUifW
	U3AIOx7fgYIvbtfdAGIbKVKd+76FEnO+zdw9/n0JxBQvmtGroMPqdaJC/y9bCixZ
	udaVYzZftlMeM1NsCRD0WecITITNP7r7HKWTDluPHEDaljbS2a8BCSh9HMUgmgL3
	+og/LmF/k02uXwSq1G9JRC4OZNwNbUE7PWZu6TELBlKhZg2yqvjWf3i4V+mp2K0S
	XTkfZkFKRoOXthGBmxGrK5Osn3KnE63bhTk1kfwDm5O+OYu2ch2hGHXj7pOSg/CX
	MP1PLrW4jyiNIaYSfdG573iBuQhQ5VSCbew==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk6uf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:33 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad53f538d2so692305a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367032; x=1793971832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2S2+ftVMigTG222SzS2D5iPPQE6qVzbPncufpVNONLs=;
        b=OyKqpevLHuzMWrds30calT7axpQdbjaeElqCXcmSnMz+SfYdXi1NeWIy+VUmApibJn
         T1pcE+r8IE1eNXqyewTKm3T+gGPBkjqV4VpdMnNkxzuedcpH2KYl/eqFcfgnYflgZi/x
         MlGCfFbVxyw0XsNn+d+RL4wHT/p6dQmYtthEWmCFIg6UnICjRAdF2zA/E5jQsFsBH359
         /q3yg+a1clu0kZyeIIVJXJbTJOu+f5ORsvfwrMYYASYAeCllE1Sez+k5BPe+bNuI6Jpf
         4k7gtyJdQMkQO7z+tFrjhIrA++PQlFfKrYuTXpeCQzk01uXkUoezX/8opyJQDWP0tTPG
         hJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367032; x=1793971832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2S2+ftVMigTG222SzS2D5iPPQE6qVzbPncufpVNONLs=;
        b=BWKrZRFLg6UKa6KLC2EWEqguY1tCTJYGxp9UJY1vUo4OYEmzogb5Sdvz3MecU4Zk58
         LThXmz97rWAFpd8SqWl+hdQ6CoTU9JfyAhrOGbAJgf5BEA66TjZ3jL+O+tJM//ee3zCY
         eu9wVa3laxW9xyJrrSm+sd1QofvvT57cr43mPspiCP2U4qCwp0Ncv8eHwWEU10/keZD6
         Rgo6HqtVg8dR387a98gr7r3vHJfbEDXz8p+JFDVwZgLv8b7hYq3voKHFwNxNB57/Fvlk
         EDl3dfz/tlHC94SwP+TMXLZUP3rzdjnwHgUP7Y8OHrQ/04hodA1TyJPKGcz9hD1dK6zM
         NDBg==
X-Gm-Message-State: AFq9FYIR3NbBQdPQTOY3IoCUgLFNtbEzEwXjUQWQBxvFXo3Ijn/zOLVW
	/9iMlqSlBiPQAaMiVrm9gf5Gnoq9RdZrK4HfxsNu0iGZ7uOT8VxgM6x09qoHchE0RuKC5vUKBe9
	6gXHyDZ1Gu2T2f40OgiNsNFdkUDIBVr1XMefyezXiDQr030d4jcsPRDWI1mcsM7OXxCEo5Q==
X-Gm-Gg: AYBFou07MdM+eOtNIuKf7ZQKXuLU7Y3PWV+elNzYyMJ9u4VVUHr2L7a4nJcAtyD2A6I
	lC8dHBXcsj0yhko4Nh/QpfqquTM+0jmTvp0OThaBpUyCr1NoEoWghMvnDo+uXhgmvsaHdQQaSFI
	uCx14vX7RaK+D4gSjKqxphnQkFubzQDwP4lscr+xuLhBO7pwJOBFTrDB7NRzSfnQwKxhzw4WKuo
	ztbT08o1BbLTAQWiTzJf4Gjcr7eyM4WklD3BEfQWIBaDynLuAPgNNCLK7RE8FA+6h6+2ahhaxVx
	09U3RQPw/Olhrs7Ge8HFLoD8S5Ok57dFtgTKhKP2T3AcJmU2KrC84XkV2mScAz+6j5xN4kcfEFb
	GlGgagb1iVIabp5+KJdU+o4/SKZX5JkTAxaueGKwRPrEtNF1T/qeaVUNsB6QJ7Sja0xOGk/h8Xx
	EmqizG8bFwTw==
X-Received: by 2002:a17:90b:540b:b0:3ad:eb15:aed9 with SMTP id 98e67ed59e1d1-3ae8957cffdmr1778990a91.9.1793367032201;
        Fri, 30 Oct 2026 06:30:32 -0700 (PDT)
X-Received: by 2002:a17:90b:540b:b0:3ad:eb15:aed9 with SMTP id 98e67ed59e1d1-3ae8957cffdmr1778956a91.9.1793367031569;
        Fri, 30 Oct 2026 06:30:31 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:28 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 00/16] wifi: cfg80211/nl80211: add NAN offload support
Date: Fri, 30 Oct 2026 18:59:56 +0530
Message-Id: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
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
X-Proofpoint-GUID: 3NmtHig-sqlqJQz8IVO5WwigCozXAOCb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX2PzGv0hKEuHA
 B9/A68d4Vg5YayAkmuE3jhTbKrlxQzaojrW1/1j0GfffWaxEXnu96o5XGp9LsPOUfY8Fd1U57sb
 +qkPwxJTVm9OexqEAb9+do9uZ7p2gHQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX64It6N3Lgath
 uzXWBNPqyUcfh0/IsQs+ItqP7QmiBAqFwodOt0boUl1CWOb91pL4lbq5OmAfebeWIzg2HYyyapo
 cSMzFo0SijLsuHfIVBGheZNgn/77jf7merR/9PAqJkGLDAwCtNCAvjYVz7/FFwAFhudvJNmzMYC
 3QuBkGgNLowiMKVzxYo893gM3mAbBH5YAf2C/4EiLJIS32nL3xh8NzYyvikXSKgcnetP4N+htHC
 nu0pb7V0v73L+vARWiGqd7wI61j1Eqgab+6vKs6Z1mREw7Icf0AuLUJm7uo8o10DSaJSLsiWXk1
 odIYRHdQKli+DFJImyK/1aE7bGInnfUjXrqnf+OSN2tXUt9uVfiLFOwiilxYDhaTkjITPAs0c4h
 rNMRYZNz5n5kzXwFA7H1VIpR8SXfZQvjQjs4iTb01LjjSlOQvjCtIS78z3E0ZpD8NmhI5SNieYY
 z7/JRHR0ArKCYMNyt6w==
X-Proofpoint-ORIG-GUID: 3NmtHig-sqlqJQz8IVO5WwigCozXAOCb
X-Authority-Analysis: v=2.4 cv=TpVzFzXh c=1 sm=1 tr=0 ts=6ae49bf9 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=93fSU1KXOlF1mvaATUgA:9
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

Add cfg80211/nl80211 support for offloaded NAN ranging and NAN Data Path
session management as defined in the Wi-Fi Aware Specification v4.0.

The series adds interfaces for request-based and discovery-based NAN ranging,
along with NAN ranging capability advertisement. It extends NAN function and
match attributes for discovery offload. It also adds NDP offload capability
advertisement, commands, and notifications for session setup and teardown.
The series adds an Instant Communication operating-frequency attribute for
NAN Discovery Engine offload.

The new behavior is capability-gated and does not affect existing NAN
operation unless a driver advertises the corresponding offload capability.
Driver and firmware support are required to use these interfaces.

Changes in v1:
- Add a 16th patch to pass the Instant Communication frequency for NAN
  Discovery Engine offload.
- Reflow the NDP PMK and PMKID kernel-doc descriptions.
- Remove the extra blank line in include/uapi/linux/nl80211.h that triggered
  a kernel-doc warning.

Kavita Kavita (5):
  wifi: nl80211/cfg80211: add NAN ranging FTM capability
  wifi: nl80211/cfg80211: advertise NAN ranging support
  wifi: nl80211/cfg80211: add support for request-based NAN ranging
  wifi: nl80211/cfg80211: add support for discovery-based NAN ranging
  wifi: nl80211/cfg80211: add ranging results to NAN match event

Shivani Baranwal (11):
  wifi: nl80211: reject NAN add-function when Discovery Engine is in
    userspace
  wifi: nl80211/cfg80211: extend NAN function for discovery offload
  wifi: nl80211/cfg80211: extend NAN match indication for discovery
    offload
  wifi: nl80211: add NDP offload capability advertisement
  wifi: nl80211/cfg80211: add support for NDP initiation in offload mode
  wifi: nl80211/cfg80211: add support for NDP response in offload mode
  wifi: nl80211/cfg80211: add support for NDP termination in offload
    mode
  wifi: nl80211/cfg80211: add support for NDP request indication
  wifi: nl80211/cfg80211: add support for NDP confirm indication
  wifi: nl80211/cfg80211: add support for NDP terminated indication
  wifi: cfg80211: pass Instant Communication frequency for NAN offload

 include/net/cfg80211.h       | 346 +++++++++++++-
 include/uapi/linux/nl80211.h | 271 +++++++++++
 net/wireless/nl80211.c       | 854 ++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h       |   3 +
 net/wireless/pmsr.c          | 120 ++++-
 net/wireless/rdev-ops.h      |  48 ++
 net/wireless/trace.h         |  88 +++-
 net/wireless/util.c          |   1 +
 8 files changed, 1722 insertions(+), 9 deletions(-)


base-commit: 2c50cd5d10e8723797f28c7978f1f61688e0c0d2
-- 
2.34.1
