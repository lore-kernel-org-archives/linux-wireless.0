Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573795;
	b=OhcuTL5Kz2RXWVk27hoVvIz5dKcCUl4D/Mx2/oXDvcFX65ffOSEEWXbqgai+JbPvpqYW
	 J3P/4kIMBOBb0oZd1tSjzGT7j/X3AH/bLD1rgRQ8nr4Z15/7FkLcVOvdK8BiTCfIYQ+Hj
	 GyJD/1DgKclgAJGEYloYbvYrUALCzppPJdrNDs9ReaShyp65qANaAjrxNSWCSYXdSMNeK
	 KAo5i6zTgjcKIRBENgrPIxg5Or3yVNTOVQfds3qmgvAXaqdzyik/dOIYamfcqgO8domWz
	 54OxUGDkLulg89vUKFSb35kKZRhl7v/c0C//P0MOY3KlOj7jturSVFyPrLdk71plRpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573795;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=DedU1k6ASLyHSDk7lk7U07zZCarEr/9oVyaDy/PsXbY=;
	b=IU5Qp57FcZ+jQX7aREdOtBARZuz7vKnJYP51F4v6oSZOp+cfGRRrUS/2BfabN0Xgy1KG
	 rZJFQ9gkKL+esELcmkfbD8IBdH9bUJ7dKUEX3QQbiLyqCDeMumbJkBA82/NUYzhfQgH4F
	 orToPtLk5j4pHjnEmI6DMpkSKP7OjOMGtuOGaebCYYc4mjq0iXoKWacQE71g0LFzpkm1R
	 +ftGQ1AzOh5kEkd97wm14izcBoL0eVAhJvpPvtp0rZv60uKYKcGVqh7LfrHVJOlBgBHqw
	 Ybf588zgJp8bScODxZY+4essbvVOSvG9DXnsiQkFPd7cJ2Iw+YtSu7AUOmdgUX3y2Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jr5WDmIT;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CYKlv5TB;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066FA606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 066FA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jr5WDmIT;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CYKlv5TB
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5j1XM3926272
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DedU1k6ASLyHSDk7lk7U07
	zZCarEr/9oVyaDy/PsXbY=; b=jr5WDmITz7eX75BcZm7ftA9DLDNW2i2yB1kxmA
	v8lSPdCXFKd0lxxwmdwj7oSMD0wd5fTwl4YDum3UgGKBEEtYoSFu0a7RAt6ko9Dq
	rqpdfYppK05jVSoAKqinCc7w45n7S4LvVNM80p7Ui80nqWlBAsiKeosNSNJCdpJT
	GpiZKzat2OlLkWthBNin9Rt3bmlysX1hVG6uCsB7YzDTj++y4qNJASxO22Cisoxv
	mrHe5OjqqMadDuRK7jyFJDWAtfWAeayHt8lWoedF2eWQpbzwC634VcrhTyCcyGD9
	WGNdxBqSn6oY1qMc424P+LM7qNR2oyfhkGthwQvH8U2Zh0xQ==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4he7h2crjp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:53 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-54d6281f6dbso519894b6e.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573792; x=1793178592; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DedU1k6ASLyHSDk7lk7U07zZCarEr/9oVyaDy/PsXbY=;
        b=CYKlv5TBMQ0Xg9to7VNnCO1a1E1CxkCYcA1o9is7OO1B62Co1O70C8wQyFkYTFFPao
         j2qLeC/7UraEM4f2uiwEaNxmQ+esK0VvPLkMjsQjnwr8r1kS0I93qnOn1LJAz0U9CRgX
         W3rEaC9XoC17Q0pBBqagJvrdQ7RJ26v/SVTXUfiGHP2nij5YB6lIqy9zHFUFDOuKVONk
         gVQyaGNu4BDCvoYO8Omf0wloTccNJ+7YbG5+FTJbivluozLImVNXiBmqf/YgAdFHT39r
         RTyLGy9cjohvt8p/I/WKKBlTFlhygwyOEm1xONuBr/qAd7hnlZAC4U5QWnulM4CqjO+C
         ffXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573792; x=1793178592;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DedU1k6ASLyHSDk7lk7U07zZCarEr/9oVyaDy/PsXbY=;
        b=ZOeeLCmENCpKDzopfofoJm9rrNVrG40lv3BLX7gNSkaCm+fGpOYnxhSb+xnm/s7No8
         O1bNF3Z56thHeP3DyCNNd2afLTxnRzm+juncAJbM3Xzjd2d8ZILDfZmMZ1ow5KflpBFW
         PiOWvwoqRUpTv4AdrrvN7yHApJjSadZaWy+VGvhfwzx8hroy+3e8NjPXu4ck/MEn5ohf
         T5n/VcveesWb/rMJgaSXazLVqbnmFKpDSQB8URqcaf21zG4Iiqn8n8GPVf/GPaZ3WCkJ
         5nqSwT69lDK2+6TX2vRSEgEu/Tfb6mResMxkwcB8s3czXrgtgdzpebleL0NuSd9iUXPq
         zysw==
X-Forwarded-Encrypted: i=1; AKwUvBzxMOzZLCcyKdVzW7jaQEddPft0R11+m5577YLqi/3g8NOGZ2p87B8ay6v0noxzGymZOwTYj4XOTMygnKbIcg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL/sWTX4vnTgcF35PVjAdsRKNoiXnfJlruCLXQ4nkT9s1ops+MV
	03GRbGCzUPoYDBA873sjqRxQq4FmhmN2mC9mFhzSzC4hz7cpTYQwp+CkKzAJcyCQw3In3DtQ6Qu
	3AOcpl1xeroyIth8p9LzPaTgzj3uFZDedIYr9nAG7ztaAQSftH/jj4tPv2PDkfRxdPmUY3oHn8J
	FxhRMk
X-Gm-Gg: AYBFou3zstE1fD9z8aUATTSV5Qr3z6bmEKUI5/2AjXaYIIDs9TjpfQsrmzYlksanU3o
	Puj7GT+8jrhqf/wCu2x6TZJ2Cy9piL+ZHJ1UwkbxiFfPa41/ZPUJ6wVSD8pyNp4lbozCShhsb93
	PYYjm8NY1KpIgdh5oq0IA/fo52WUjidNWaB7sWY7m7RPWMGvHeWRAEXZ9+3Xp3d8jRRh1SMeja6
	NDKKqGTHpZSAOEOX2s/19SufNfGglO7UGbfix90Ct7fnEmuNFyus+LXgYQzLLGyezcFRosCjlBb
	yGEg05HYyBtboH+v6f3OY0Ws/FDVEtAXllBC+CaFCw5pTpsPfahWxT3KG4WbsGXoCY5p7xmtm5G
	caIFf8+F83ry0FZha1TCRCFff5iUAWEden58EouBLni18MoOAww==
X-Received: by 2002:a05:6808:4f51:b0:4d6:9222:99f7 with SMTP id 5614622812f47-553600880d2mr992237b6e.55.1792573792315;
        Wed, 21 Oct 2026 02:09:52 -0700 (PDT)
X-Received: by 2002:a05:6808:4f51:b0:4d6:9222:99f7 with SMTP id 5614622812f47-553600880d2mr992228b6e.55.1792573791906;
        Wed, 21 Oct 2026 02:09:51 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:09:51 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/8] wifi: ath10k: fix recovery and WEDGED
 failure handling
Date: Wed, 21 Oct 2026 02:09:28 -0700
Message-Id: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAEiB2GoC/yWM0QqDMAwAf0XyvEDNpuJ+Zewh1mjjoI6mG4L47
 +u2x+O428EkqRhcqx2SvNV0jQXoVIEPHGdBHQsDOWprRw5r90AbdUWf2ALyuePh0vcdNROU6Jl
 k0u03vAHngFG2DPe/sdewiM/fHxzHB6syeWd8AAAA
X-Change-ID: 20261020-10k-sdio-crash-a37ab499725f
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=2814;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=y3stYXDvP4O7TcU01G6DJq426Gkq4u9WW481UMbgOaw=;
 b=BaCSn0O1b365N5SOMHIn6Bh6B658hO4GH0DBkzlgj8SoAdnaxWhNmkUt3TzqMmXjnJYdbR0XQ
 NOXKIzJPC3rBD7LxN1AIQN6cqQ0sa300M1BhZrll2iguJJB/iXPLJbq
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-GUID: 1l5ftHLjPsCP1zLWfS0twRVr96uaXG6I
X-Proofpoint-ORIG-GUID: 1l5ftHLjPsCP1zLWfS0twRVr96uaXG6I
X-Authority-Analysis: v=2.4 cv=EuJHPicA c=1 sm=1 tr=0 ts=6ad88161 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=I84dKf3nx1YZGivhVUEA:9
 a=QEXdDO2ut3YA:10 a=TPnrazJqx2CeVZ-ItzZ-:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfXxORmhoy/p1yg
 1ajrp3QLPZKrYUOkeNux0VxhEdk2xE27m6N7qI5/rTxuAc2R9cDm2wRxwEPXP4gP5unMKPsNQLT
 5bPXz7q62+ND/dhHRlrwhvUAJh+DyLk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX6Qb0oHhMaN2K
 6OWEoOZQAaIyPUOzx+JmovlD5kFs1+UKlsZ1RbmUsEI7qel9b6qbeMJhwGLdw3rzKrfxkW/c071
 R5F8ER+T9Cd2NXCJgzWFKq26NDBvDEV6ZpE0rpTAFj38UOlIdDW+mFvrohelB+SnKIMocNmuE2o
 lXl8JbxN9/cCBiA3VZkbrSCo9LE7djnPhPSMia5wiOeLCe42of8oRCStVeVTuNfJpGfJzcKnkor
 wT90PfB83MyByYjNGbvsHz4puPQT2wZZPS0v/mFOBPpPZBA2llIPGgz4w6s8LYdEcNTRK4xdena
 r5GVYV6t4wt5kl56tpRKe7CfDuEqde59OBIbGlcNJdMV6cdOG3hNwnZAAExc85UxHcEVRDu6Tm+
 Quke6IDDKT6p02CYRKyxiAXrpM3yfxKi6ATSVNvIScTJEG49Ornqix0mWjoSFa4H2VYhpAUrKcH
 gy6mhxiemsiI07WrxTg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210036

Recovery failures can consume significant time before the
driver eventually gives up and enters ATH10K_STATE_WEDGED.

This series fixes several issues in the recovery and WEDGED
failure-handling paths, including recovery detection,
recovery time bounding, waiter release, and PCIe error
handling.

Several patches fix specific bugs and therefore carry Fixes
tags. The remaining patches address closely related issues in
the same recovery path because the fixes alone do not fully
resolve the reported failures.

Taken together, the series ensures that recovery either
succeeds or transitions to ATH10K_STATE_WEDGED within a
bounded amount of time, avoids unnecessary waits after
recovery has failed, and reduces the likelihood of watchdog
timeouts on affected platforms.

Google has reported this class of failures for an extended
period, with more than 4000 observed crashes over the last
month.

To: Kang Yang <kang.yang@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
v2:
- patch 3: also wake wow.wakeup_completed, peer_stats_info_complete and
  wmi.radar_confirm on WEDGED; reinit peer_delete_done before each
  peer delete command.
- patch 5: remove the early-return time_after() branch from the monitor;
  in ath10k_reconfig_complete(), cancel the monitor with
  cancel_delayed_work_sync() before clearing fail_cont_count and
  pending_recovery.
- add SDIO Test-on tag.

---
Kang Yang (8):
      wifi: ath10k: fix SDIO aux workqueue starvation in recovery detection
      wifi: ath10k: wake blocked waiters when entering WEDGED state
      wifi: ath10k: also wake remaining blocked waiters
      wifi: ath10k: bound recovery time before entering WEDGED
      wifi: ath10k: check the recovery deadline on its own timeline
      wifi: ath10k: hard-block the radio when entering WEDGED state
      wifi: ath10k: remove now-unused driver_recovery completion
      wifi: ath10k: trigger recovery on PCIe MMIO wake-up failures

 drivers/net/wireless/ath/ath10k/core.c | 129 +++++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/core.h |  13 +++-
 drivers/net/wireless/ath/ath10k/mac.c  |   9 ++-
 drivers/net/wireless/ath/ath10k/pci.c  |  27 +++++++
 drivers/net/wireless/ath/ath10k/snoc.c |   8 +-
 5 files changed, 130 insertions(+), 56 deletions(-)
---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261020-10k-sdio-crash-a37ab499725f

Best regards,
--  
Kang Yang <kang.yang@oss.qualcomm.com>

