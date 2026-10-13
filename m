Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A4B26F288
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855322; cv=none; b=Se4K/5b0+nK8QCHDnGPNd64qf8vd8sMEmjx1TRTrWmzQJIy83w7hl3lLixtKsUYW35kibexz7yXnpcCuzOGc62lflh3hsd/oflGaiXSzmvC5OjSXZOthfZ2Fja48zfEln0+g+5uTnVP6cqoNf41gCBUsfb8XL7Pu13gaoihSTSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855322; c=relaxed/simple;
	bh=cWc52xl7063yTUUB1tj3+sZXj9eWuiNYFDQeNU48PTA=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=ZO3M2U73k6Mj5SOmmjltxdOp60bLM3sxdy9S1MpXTFiJ9zmmFN9i2GGDoP/lNw+R6jE1pxIb82Vlh+6uvQQx/Hjk6hMMrZ8D7fEgbjpVPjTN15jF26S3EbTze0vprzSEakz5ZK0KB7pb5DnRfW0RjzjIMvMarjmI5gXuAlRhKl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h1uyUaiP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a0Iv1Ymd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h1uyUaiP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a0Iv1Ymd"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CJN3cp3760133
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:35:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=LFghOFxfEaRKd6WYvXC1xq
	jFlvjsz2IM7ZvFQDLcxP8=; b=h1uyUaiPEiwYeO/mymHt4NdQbBeQAd8ZyMkkAP
	+r/qj2NYCF0DZDLwVX5D106jh5tvOwkmKCvnqiaKaJagcb/nA/f/9C71LtxjhLlo
	bLHnu9ibBAvStNeyF1Sx5kHHWwe9hVqL3opFsmDcc0ohLJgaMI56MS6o79HsKOQg
	6vdAI67fnoyjXqNfwCvnff2jAkr5XEYUkitL1bnq6w9KlTNhVxQ9yI6g9y4iJpRj
	fhLEdFHkOaviP2z4GbkGq8AUdf+JgIIgPI1HrGtfCoktl6H6IvCgtlPX1nxto06d
	XXwEkmfd0TxzSEM1yiDtkU2b/ScAgMT99Jk5cEs2iyw7954g==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8wffkhg1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:35:19 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3425098ae4bso2029294eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 18:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791855318; x=1792460118; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LFghOFxfEaRKd6WYvXC1xqjFlvjsz2IM7ZvFQDLcxP8=;
        b=a0Iv1YmdP90q6LHXWtDHbevpsB6j5Yos9VFjKmgechHLxSkmUhFZ+HCbIEzDSaqjaQ
         7vU2gm39cuiIPOtAa477EG1mn04kDwvk2OLE2S6ZWQpnszRna4dyMfRE037f2FuNbM9W
         QiFYQwdkJxgZrmnDFGWwnisAl7PcKFt5qjYo2z38k9FCufDefZOrzwq3qoJzAUCMVivs
         HjDq3aIcHv+fTHrhP/yhYxP9w8eYiW+1vwCeNGLfzXWLSrzDaoXuHjCrD48TcN98Wgow
         DM1M9xx90Uf14yS0tcbtTWEGAru7Bzf1S360jyEWuU+5yAWEN+t3x6TQPhc3wg5mPZA/
         jegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791855318; x=1792460118;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LFghOFxfEaRKd6WYvXC1xqjFlvjsz2IM7ZvFQDLcxP8=;
        b=HUZQ+XZblMqf7SxBLkUX4/xkJ7ThkuWPiocoR9RRPPQQijSdeF2Y//ZrewW2sYYm60
         q8eTn+swOwhx0oQyH5gA6jKqEAyGZ92hER5WIvgHTFiCgxSVFa4tNST0mGSHKas+5vRe
         R0rjWT/QLsUiLqsxYCtuGzBr+iNLS2Fqp6wsPyMAybb5WkgBg0ADF1qg6MN7NFV6FycY
         G2LNkOB/6+4VMSiv1+UQDEAOo/EtkrxhIyHM9p3m5O0ZEAD/QAnfB6f8u5SAx5ONAjH1
         h9BB+UqSJ8WYzgDpVfm3PM1SJTpEdZc3KrZAeZyvK+ibZzUHIvL2BBFbCXve97gkabEM
         KqAA==
X-Gm-Message-State: AFq9FYKaC+9to/MEYLhFBGPT1QW2eCqFGR1huT+1NbUofs3WHXQYOliS
	32OWNW9T4ww/yqnhQmQxRdORNvh8rKTXd7Ey60kIEtGIDByaJnUhugA7o9jcYCAchp4RGbG6yEe
	LzO7zGFxo8hhOTiGucrVXqb8g/7gypdtoCHC/zT8GRkjZse4qKPXyI4QHo+Xkf9bS8/RHy8ZmkV
	mH0w==
X-Gm-Gg: AYBFou3fxUkufidFYk/Ct/de1PHQ6V9Zt0E+wYd/mSgI9MzYXDqXv9zkmPxVujsInfx
	P+f9Wm4KH2F49EvC/OlfadS0ovrli4JrHSx2k4LsXPCUCGAIlHySkvPCcgC/6S2UpwSZYjrmOij
	qOJHCeDczyV9YzdTjqtUMooHGtU0gInXyBmfZBD6tt/MBQk7wTaT/Xy4dELAUdboD5e3Biarvxd
	igNWf/YJ2isX8TdLi5/nXY1ba7Yhjxxoe1eu3x00ocEH8dBqTCtK1NRO1PSGaQSP+TIfGZxt3O2
	HgXpPZ248SnHpzE0PSxXIibR2Mg/o/G73A9do55w0/DJiQt1e1AO5YfrzcrTWJbWqZG4Dwj9eQm
	xa+v2y0IoznxCmqqK0xcCjaiBNXxNxrXFsSY=
X-Received: by 2002:a05:701b:280e:b0:13c:d071:f97c with SMTP id a92af1059eb24-16a5b97ae60mr16069688c88.11.1791855317875;
        Mon, 12 Oct 2026 18:35:17 -0700 (PDT)
X-Received: by 2002:a05:701b:280e:b0:13c:d071:f97c with SMTP id a92af1059eb24-16a5b97ae60mr16069652c88.11.1791855317120;
        Mon, 12 Oct 2026 18:35:17 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a31f6f5csm32829335c88.11.2026.10.12.18.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 18:35:16 -0700 (PDT)
Message-ID: <97179203-e4fe-4309-a4ed-025408703cf3@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 18:35:15 -0700
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
Subject: pull-request: ath-next-20261012
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAwNiBTYWx0ZWRfX+EqLtGAUaiuG
 rAPCM7+HgdYhTQ8ZPalEGV1cl8k8fN9RkQnIq+yKSPpRm7jLegCuUw745pxugOJMBnZZP7Ea/yY
 gHWg3vHcHVxMgkWvwHvZqsJATbAQynsvMuhOTW5x4IZ/pSyIAkho+qdjAmcIRBoaqAj/JDn11uT
 eQTnONnRSKPixJuC6T1XVjGIYPVKUNpy9Q3soip18tCh2gsYcKTWahHk5NO+N2U5CxJZkj0S0Ap
 ddJC9wwk57lX4udNxJAdDNZkFnhGqTmikSm/D0AqUT1oBLilkVX3E2mmOgmupV9+Qkfybs5rBHH
 nLVaeRBpcrBrh52g71OuLQagMqfG28yHKdpE/HPD812KLI/BejFS+AzF6K+9O/7gdkwyie78JzF
 rLbeiHdf48nPlAZitcJA7Jy+M3BIF5gdv07Iyv1jlTJVU6jxrqo5PDKnTjnMEkuOEnq3V6Mf5Gd
 nUFArOmYq8Hwblqj5mw==
X-Proofpoint-GUID: uI-4iTCIQvX1d8xZOyiq_9zn6uJpx5G7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAwNiBTYWx0ZWRfX0tIs9NKs0SSP
 elj19Fp4glCEpApXmjk5j2MYqvMQNuHRrV4b4IyxVpmYdu4fuTmG2gt5RK01N4sMWAM4/j7i9+S
 YlG2uniprNcUxpJEiWidsNICH2pOq6c=
X-Authority-Analysis: v=2.4 cv=ZcWIpcVA c=1 sm=1 tr=0 ts=6acd8ad7 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=6KfbWdwkAnXCE2h2UTEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: uI-4iTCIQvX1d8xZOyiq_9zn6uJpx5G7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130006

The following changes since commit f49defea7668d8c68ec19fa085ef3da6075561c7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 11:02:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-next-20261012

for you to fetch changes up to 4aa45334eb23d40bf31c43405daea9b73469f2a6:

  wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup (2026-10-12 18:00:36 -0700)

----------------------------------------------------------------
ath.git patches for v7.4 (PR #3)

Nothing special here, just a bunch of assorted cleanups and bug fixes
spread across the ath family of Wi-Fi drivers.

----------------------------------------------------------------
Aaradhana Sahu (2):
      wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile
      wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths

Albert Esteve (1):
      wifi: ath10k: clear QMI if failed during init

Baochen Qiang (1):
      wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume

François Roux (1):
      wifi: ath12k: skip hardware rfkill setup on Microsoft Surface devices

Jeff Johnson (1):
      wifi: ath12k: Remove unused HAL_RX_REO_QUEUE_INFO macros

Jiale Yao (7):
      wifi: ath12k: Reserve space for a string terminator
      wifi: ath12k: validate MAC/PHY capability count before saving
      wifi: ath10k: avoid IDR mutation during TX cleanup
      wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
      wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
      wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
      wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup

Johannes Berg (1):
      wifi: ath6kl: don't take RTNL in del_virtual_intf

Nerijus Bendžiūnas (1):
      wifi: ath9k: refuse spectral scan control while the hardware is disabled

Pavankumar Nandeshwar (1):
      wifi: ath12k: Increase RXDMA buffer ring size for default memory profile

Rosen Penev (1):
      wifi: ath9k: delete channel-context timers on deinit

Vitor Soares (1):
      wifi: ath12k: advertise interface MAC address pool

 drivers/net/wireless/ath/ath10k/htt_tx.c           | 12 +--
 drivers/net/wireless/ath/ath10k/qmi.c              |  1 +
 drivers/net/wireless/ath/ath11k/core.c             | 21 +-----
 drivers/net/wireless/ath/ath11k/mac.c              | 33 ++++----
 drivers/net/wireless/ath/ath11k/mac.h              |  2 +-
 drivers/net/wireless/ath/ath12k/ahb.c              | 41 +++++++++-
 drivers/net/wireless/ath/ath12k/core.c             | 37 ++++++++-
 .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |  2 +-
 drivers/net/wireless/ath/ath12k/dp.h               |  8 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  2 +-
 drivers/net/wireless/ath/ath12k/hw.h               |  1 +
 drivers/net/wireless/ath/ath12k/mac.c              | 87 ++++++++++++++++++----
 drivers/net/wireless/ath/ath12k/mac.h              |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hal_desc.h   | 26 -------
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |  6 ++
 drivers/net/wireless/ath/ath12k/wmi.c              | 17 +++++
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  2 -
 drivers/net/wireless/ath/ath9k/channel.c           |  2 +
 drivers/net/wireless/ath/ath9k/common-spectral.c   |  9 +++
 19 files changed, 217 insertions(+), 94 deletions(-)
