Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8085E47A0B6
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786556651; cv=none; b=WrdRFQRAuMbxAiv55R16YbYoKrMdUiGZBQ7xOp194ViLH6dB6n8M9i4CmcdnoKvgu9qPd0hrn/Mv4CFjc1/b71tP116faYhywTGu8ikdKleK2kMWq5CkyuE4bMgkUdhEuU7xyDrBeMRK/CgD0mnUmKoS7QQul7Wp2ck2OPtFIf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786556651; c=relaxed/simple;
	bh=Qkefgy0OuFAOwldlQ/n1WRh8UyINUd+Afak2C/o6OgI=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=kmKCvQXPYLeKLQ3rEWpuZrxW24XuErOFMa5qj0LOGFVcQvG6Qik/f277TblE0eJ2vYzwbYLbkZXnk1YZGMGzV2znkiHRgBlGVS3CsRYpFK5U/J/MgIDwuDGEIio9J5CvxBwTS1suBNE/2uDvH9Hj42MZJWULtzMp+0Tjf1xIhiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bmyaQwom; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ARFjIrMJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bmyaQwom";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ARFjIrMJ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67CGppLO4083399
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 17:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=WPrUe1AHxk8839bSM8P8eF
	DTJ+/fnhI9uw2/dmjlgD4=; b=bmyaQwomX0028YIjqP24MgJYMgs88YwzsbdR2u
	+T7RI7MyNpTaNDbpHDSTcNimEmT5jUBZIKm6A8RznJU6gn5Xt1qgUVkm7etEK1ol
	eG6vKMv9gQ/WKdb9BDI6HQwq0OxMSC5anSpaI1olVLYhu/fgcYaLWM7xlfe/mFHH
	qf33+xWrsYM2meKe8wnuyQSnmCS0SzzAHTZEWW4ZBjiqTorwh4Xpm4c2wMAviDaf
	Pc7VBegBx4ffmE+JxRe4IxjIv9SbALVkyLsGhccYuntk0Fx+aTmwIgC3YzrADn9J
	jgTp4aUvglL6kwEK9qC6cGmlXmEVwypjFRpq4eKd1ZK5JQig==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g0pmyt22s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 17:44:07 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb6433e9d4so1515610a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 10:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786556647; x=1787161447; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WPrUe1AHxk8839bSM8P8eFDTJ+/fnhI9uw2/dmjlgD4=;
        b=ARFjIrMJdx9jthNHAou65ftyUNx2ez2QMUcF/EPp056D6RtsEDepZZ2wy8O/f3aO78
         wX1M61pbQuF2mjTnv6Ban9ojDAzErwT/4YMnPEM47D7JybzBpHXghQSeMnZi/Wbj8q/K
         0IPk/l//mr/ThNem2RV6eddxQesl0/1fHXZz6o0Tw88ZLCHE+bWx9hyPGbzTP8GjWFcN
         RyeuEWS6b7w0S0wuEX5tqH4l0goLC1Ysp5FvYg+ou3riEOQ/G7bObyQGjjYTcA/7lsRS
         4q8v8GgOpQQ11rAlSFBXIvnF1HBLxhb5ossRUlkgNvXHoL10O+7BN29eJlQQx8NubEDB
         jS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786556647; x=1787161447;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WPrUe1AHxk8839bSM8P8eFDTJ+/fnhI9uw2/dmjlgD4=;
        b=NTbo5tzxDHdfKKHawnWHak/577J3ARBNp9d+pA298orIqTTZzvLuOQaMTeuZysPc0D
         FiyaV5vxFKVklLk8xWRJ/o6gME95RIIvDkQ4MySzxXE0MeNsXzR4G7IpDbjzODCBHJhq
         inEpqRNMip+Wak7nbV9RMekWLO/94PXKohQy37Ducm4Oh8vY+H0EliB8LwVdy1G8I28/
         HQJ5gf6BddiBwkTIdQjhyOfvmnpn5b8oP17erwWv6QXKWfuR6Nxu5CEIZX1zDBeKRLOY
         kDT2gtVJBE16XXsr+0ny1xT4B1Us5p7MLq3TRAE5YQ5GjCL//N/L5MVEh+zswhk1d4wr
         6L2w==
X-Gm-Message-State: AOJu0YzmVzKfOvCtecTtTlAgjZOzkrV6/nquhzxoeB227RBYRIlSUcba
	2CLpjvt8GSOcykty1pywI755AUlu3e6YR+FbQ8GNjqIOFD6XoL/mLGlx8RozOiAG/X6zxKyZnli
	su6pJIU9bhFf/Xn9ijumnu7M7HviTroVEeQOfFLSnBHkxPyEc1eqZqRVsr3zGKLBAawFTeBOo/c
	Kn6A==
X-Gm-Gg: AR+sD103ADZh7p65z2ETGTLhoW2ePy0cLr+IK9eXKvElgO3y8y8pYawEJopjyfJmSMb
	szw4Okv8Yt7ZfY5GLiwHC5mhae16R/bJjWxqmaBY+Wffxya7jXvcGKR7iRC7KdEehNGVnDR2+j/
	Xm6Zmk6FoB1WoiaPnMc1lM4LUm6Z9HrYRlUp2vWSl8fBISReas3Oss50Z2sAGW+FMnWvxQ2nPVQ
	4InMUYHTYCfafA2jCw/z7l9yET3RbMbbUPlzqO5YkI1zSw9yvIriMLLVlenQgua7iIVUEeKBqXK
	UwULrzlIDiDIl4uYMfLhRe98aOXGK0LUYahH9iy2YFn3wxIHSwzTsvnIdTDDVJGQPz5k2fQXRYY
	LNnNasZMHd6rQt32w4vpekhwGrxfZlQRsP2ad
X-Received: by 2002:a05:6a21:a4c2:b0:3bf:d487:4b42 with SMTP id adf61e73a8af0-3cc553e6c70mr93759637.35.1786556646797;
        Wed, 12 Aug 2026 10:44:06 -0700 (PDT)
X-Received: by 2002:a05:6a21:a4c2:b0:3bf:d487:4b42 with SMTP id adf61e73a8af0-3cc553e6c70mr93709637.35.1786556646396;
        Wed, 12 Aug 2026 10:44:06 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31e65ffc056sm966106eec.27.2026.08.12.10.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 10:44:05 -0700 (PDT)
Message-ID: <7736f627-e80d-48f5-a11c-97bf81597d6c@oss.qualcomm.com>
Date: Wed, 12 Aug 2026 10:44:05 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20260812
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDE0MiBTYWx0ZWRfX7yvd/p3Pfmcl
 WZ4+y86ABo4TfY32xVRCIlaqz/mfo2SkybOS9oy/nXr4SPluKlYSP2G0JonmnjGrIepbRaNvCrO
 l/ySvfjqOloXEaQkLmfkJXj+N1VY1Qk=
X-Proofpoint-ORIG-GUID: EOWt2jCA97Jt1r8PLKsY-SkvXu4vnsVN
X-Authority-Analysis: v=2.4 cv=C/fZDwP+ c=1 sm=1 tr=0 ts=6a7cb0e7 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=-bKND4alXjPcxD5Ql1gA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: EOWt2jCA97Jt1r8PLKsY-SkvXu4vnsVN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDE0MiBTYWx0ZWRfXye77mSpQDofM
 3YIrsZmYFfnym0IGkw67kYyVSapwOPZXUM4Zk4tzyEcTYlxZiBjbmJrFyAZNoJzZlkjW3+l0U0P
 yp5SxVQcNJ773c25lQo1gI0Edn5XF79kz+gJVS2bn5gnPCQB3044l7LBlcWq7lqoq6ggkRQhHGc
 3d+0SKVYBzBZSi1YWzK55PwicPgDnwPDawI/p2zMBrdgzqvcF1qErqA+VFfDnRLs24evayS5un7
 Fo7wmxhjwNuMMpMTeYY6ssCju+Jdd0WaMp9mP9N4N9S1shX/SBxFNhFj/zeLjiR+R0y3hzYvw8U
 SPMx4rIM4QtBssIBI/nO71sktpj/u8bTZPk8FcsmUgSTDn+7ETkbOsoU5n6JiQoz3xLynxKb28g
 WYfVy+20mKW9v3G0rhnToRPeymAsHdyycE2zHfCXkfm6peje1FciAOLI6Ab4foCcsX6Mw2Kuqmx
 BMuHeTM7XfgG9d0rH+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120142

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

There are no changes for ath10k or ath11k.

For ath12k, update the QCC2072 hw1.0 firmware to WLAN.COL.1.0.c2-00228.

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit e3c0c4b70f50ae77bea557b4a44be04413d3f3ed:

  Merge branch 'robot/pr-0-1786456716' into 'main' (2026-08-11 14:02:21 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20260812

for you to fetch changes up to 25c06030aa434817928ace452c06f095f14729d3:

  ath12k: QCC2072 hw1.0: update to WLAN.COL.1.0.c2-00228-QCACOLSWPL_V1_TO_SILICON-1 (2026-08-12 10:31:06 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath12k: QCC2072 hw1.0: update to WLAN.COL.1.0.c2-00228-QCACOLSWPL_V1_TO_SILICON-1

 WHENCE                              |   2 +-
 ath12k/QCC2072/hw1.0/firmware-2.bin | Bin 7111860 -> 7148724 bytes
 2 files changed, 1 insertion(+), 1 deletion(-)
