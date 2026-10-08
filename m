Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9BE348C63
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 19:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791489533; cv=none; b=CjnHQsdBL94XXNfZgef2VSevACD5OSsKky9NBK1F47bWNVO588C8RTavcjp2qC7o9KQYTb3/FZGvW4w3AXshsrof1JcOy4e+Wk3XAcVIqwGCXYl+tdP9FU8A1jF4ySCWa0KO+UA8drFzrRL28MVQFE48y5IGLc/2PMRoGt0n5g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791489533; c=relaxed/simple;
	bh=RIQ89OG0oMkpxZU3EAfm864t/Rpd3QkJY6uU3ivutjA=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=Q8yuVw3v9DHCRsQkczRToEge5ffNsp9UWgcZ+eG/OLdhONxAC2tTIpsfR0OSaeC0OiFHoIOwfUQUWS4L9dpITFog3sl+EUn3umRxIigOnsHYkLI8TrJhdHVlbBBfln6c15DmlRXUMMzEQNyAy9UtxoZwXjwqKXAynZSLsHdlaPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TSh9G+Os; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aaHMl6Lk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TSh9G+Os";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aaHMl6Lk"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698HVfJq3197387
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 19:58:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Ebm5pPz/0g/tl4YeJ3Jr8z
	4GlCJlRVCE4c+RayxNGYo=; b=TSh9G+OsXhfm89ob9xVjQRWC/oY/KUteaDdiiL
	nPGfiBycxAbaJSuvQ7GyZ4IeiO1mqqgjlukzObzRDj2EXmEaEXHmfl1kaQO0shHs
	qb+yI/j1GsJxLe0zBc0exsG9Dg0hVgYfkwduqOMHT0cWFYqECMYIWBHytMd85R9B
	6/P2b0xlkjPw54p2Kx6hgRSIywmsPIFaocA4wFlBjzvdIHRLoaebYyHLJQIwSrc2
	lP8HDjYHxLKZQJyoMgoAwH+6AD9svbgk8H8ziHwldNsXXR2x64aHuqCgVyjzcOCn
	E/afPiJPcrVFlxHRhjk+JDNx8IjwcCFzohn2ZjxC83PJH1fQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fmqrgxg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 19:58:50 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-313d1015161so16172175eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 12:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791489530; x=1792094330; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ebm5pPz/0g/tl4YeJ3Jr8z4GlCJlRVCE4c+RayxNGYo=;
        b=aaHMl6Lkshga9KRn6orMDDQ/plYidu9gfbvvIN+ugIvvWZqzJlNPVAfm2A8kdWPk+A
         3ESYGvVD6IysngwbzMAoIe4EdKhV9ksTFtA8BAsGM3QFzKsBvTuEAKlk6AQ5qCRtJ5Qo
         5J7k5nBOUAt8pOu0j46Cles1CrJPymZifn6k766Pd/jQkpjYT/n/JRTna8HR/1JZvtbC
         iKXsnp5K2NRpqccQC8qJYfMnDHz6amlNpbbBuh7BUwEzc9WrjwDZ64rzJGhoKytUBOXZ
         Htrp7OkNEIoUmxZi6mnM7ID4oUO8rEpFx0nLUyGexQgWyq4QtKrX212DtEF8y7d30I0F
         B5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791489530; x=1792094330;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ebm5pPz/0g/tl4YeJ3Jr8z4GlCJlRVCE4c+RayxNGYo=;
        b=SBditAt92BfVy7K0Qcw8li80ABR7mRB+t6f9VCLkIQ2BctkfwVknjq/i+GLWnj42HF
         yaJbqLqARUs6y65nQcj4eRyVFmzy3Lqjv/eE1H0stw+czbbca5k85RE1X3iSpKMTxiBp
         /G5TDH7uXAKZYDJDF1Lci9NUu6efbbDmqSsAeaQGXC5+TQfh6xpRygFnbsSX3vDh7sNM
         uWr/XYEC+DMA4nCNndKKBeGH0CYOZhb4t68EfZT5mM7r5KD/8V32EAF8yoYg+FSlfDn2
         4uN9/9x0vMeqxPYxwPe28E/McfSToBA/QAPWpLRLzTYfgHNAAYb2LVhpITcERko5sVsO
         haVg==
X-Gm-Message-State: AFq9FYK/J8Uts9jxwJoJo9I0gbEVQPmMhXyFVari9yS1sV5drGyVL+aH
	BUNcnNrs+CkiaVdpCgX8rx5SZ+O1SjLp1cT+6oz6C+KZ336ca+84m1tfIZiGgk6T6rhhISHtmZ/
	9+6wYl5atbClfhRZf8g8dLqLIdKzENy6PDgDPdezO93ROlacJm/aOSo8zGjbzB2pO8KeTig==
X-Gm-Gg: AYBFou22r7FB3MkaVSP6mHZWaNDxCug3CI07IvmdyrM7DoN+6aW7Jnzr78jjKj3s/JC
	ParPxDyjKHyv/4pgTIl+MShypQkSZXXnwDwnUq4309tFT8xMRGG1mQtl58zjQ3bvKIQttCBuMz3
	fr3PmEZDI/5Bvah4/7Sq31Ix2mdAR1VY53XZLZfg+vfuL+q3KSY7o6aY0fPYO2AP/qgWqpLxYnU
	9+s8vrXvXPT76/DJPU0ZN8Fc7ct1Xi3Gu5qSzmeDEGCaAG/lSJtXRzlN7A8CKuX9tSmUEHxz0XK
	TyM+iLu+sX4quyCOmJ7FE5UrcRRcf6y6q+Y0IyGM6XSDVg85VmOE6tvZWAz7Jgv2id2dSjHXL3N
	c4fSsO/1A6E6enZEtVR49iNnk3tc06BmWvqc=
X-Received: by 2002:a05:7300:560d:b0:351:165a:baec with SMTP id 5a478bee46e88-3515e0030d5mr7053374eec.37.1791489529790;
        Thu, 08 Oct 2026 12:58:49 -0700 (PDT)
X-Received: by 2002:a05:7300:560d:b0:351:165a:baec with SMTP id 5a478bee46e88-3515e0030d5mr7053339eec.37.1791489529022;
        Thu, 08 Oct 2026 12:58:49 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb6a2afsm231759eec.31.2026.10.08.12.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 12:58:47 -0700 (PDT)
Message-ID: <5ca444cd-9d83-4805-88ba-f551576961cc@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 12:58:46 -0700
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
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20261008
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA3OSBTYWx0ZWRfXze9AnFjsJ8Jm
 GoxyHSpDJpsz8grS0r7ArYhfvSD8QppVnTvdVn3TNTftKzPxauc4iv7BXFDnCFLQSXAbosenKwC
 hmOAgactwrlUfL0r7ZgvGq5MGeI1t6M=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA3OSBTYWx0ZWRfXyrnTXf4nvp/u
 enHfQ/ZeKOOe4qebVpF0vV4Gp2j/VbtGUUfYlwvVlQuaXBshQ8CdFvvhSjet50yBtmrhX/ibTd7
 DZ0pYqEzR5GUOeZpbk9pLnc1+zZ3FoYEOka2NzPQiScGY/Lqw5zsPx2F81QjzQSIXthHsPQ3Ghd
 PqWVMYflCU/Jiv5Zfz2lVrRhEPtkoF2iWM0MmwS08gGJY6qmZg4dmD+CopIO5giHfadXJ0ZB/IY
 QyKY+fiG8kIwrzCcxFuTdpsAo6EXRpwS98I9fvtbZiJzRbc84RolPyd2acqpXRDLVvCuQAZKu5U
 BLTWSatKXl1Tx/21rkLbIb621UQUGYVmWkdQK4TTtnSFjJCP04dr5KfO3zHRBulgk3QUNWysfmn
 sJ7ODS/LxMrmad356ff6j1A5S15dtE5nPYCQbEHy6lAeAt25fsDk1xwcDThE/IFCYIaXxY4cpw9
 MuGxI8aRRGX2o48Jn/w==
X-Proofpoint-GUID: FN-HUepqsBeicUsbQkZ2lNni5PAwOiRv
X-Proofpoint-ORIG-GUID: FN-HUepqsBeicUsbQkZ2lNni5PAwOiRv
X-Authority-Analysis: v=2.4 cv=IqCL47/g c=1 sm=1 tr=0 ts=6ac7f5fb cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=WKo8ZlZ-uQDsbn5PVaAA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_06,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610080079

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

For ath10k and ath11k there are no changes.

For ath12k there is one board update:
WCN7850 hw2.0: Add support for the Samsung Galaxy Book4 Edge

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit 24247053afda2bab6b4ace42402dbf9f3b1305d6:

  Merge branch 'arch14-8' into 'main' (2026-10-07 12:01:52 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20261008

for you to fetch changes up to 575bbe3f83565d18caa73e9b9458f754dd286f48:

  ath12k: WCN7850 hw2.0: update board-2.bin (2026-10-08 12:37:22 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath12k: WCN7850 hw2.0: update board-2.bin

 ath12k/WCN7850/hw2.0/board-2.bin | Bin 2431852 -> 2431968 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
