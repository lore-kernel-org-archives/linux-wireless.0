Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A3486406
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 22:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789164799; cv=none; b=XEDPDEiXm8/mZH4NmRo87ZusdHcgyL1PpSc0KIdi+413kTzu9Jq00Sua8k3F1Id3Etb7EJQfvaZYoGMl2gZiDH5Wf846x3PfskbGD6xI3bN15bw3+QmZmD4iaSx2PGhDHdSnoFWuRi1SOTevOGq9jHb+CPrSiHGNxB3dXsXDmLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789164799; c=relaxed/simple;
	bh=GJ264Cr5qJNMmTrOoDUkVTWKU6YipymNgYlSijSgHVo=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=k0ch/qjR8M7EmC7vTO0lxq/lNxrt2CmX37eXGMN81BFvn1s0ikKdfy7hFQHm19CyjVTqZ5do2q4nzJEaRRc3BC/6d5dtQoXHdAAJ4Y6hbocriOfA3AsxngpN4CqFSX50NHRQ8kvdaXaxvOO5odrEHVV1YMif0+AGQhPtN12hIz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GRUeFQm6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a7TbV46O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GRUeFQm6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a7TbV46O"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BM3SX1715368
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 22:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=JYwTxVAwAAEy9xr61JO4H6
	DlThANBCiqbXJNrMjjvpc=; b=GRUeFQm6/+FKi+X3HvnS+qPpR1BJ3t5z+FbdVZ
	AKOn/eTE65GbCG2TRYO8myNf6T+DUPZSKP/F3g23x4Kg3JuDyFVEssqfOqgLuJIf
	mjIn/J+ZLc3nTVeJ7fDzD86NswFg2uIQiao1LuletsNewFYheXRGZSXrn7ZKZpLY
	65mlirpqrnoWxIZpBsBarJB3IM3g+ok3daIDfaa1apwCPo/d2brt5c43zDes64uW
	vFcGhKxHYCOyUlBzgFM1bVHSoXO8rG1VrRCCcCDD671ozhz1UgaVAaPPjCh616pV
	JWATxbaCPTqf1GmUy+LMyxpOY7lYSxKmvG6BzXPUAyFeHfzw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmt3u80xc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 22:13:17 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-399311947f6so2489981a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789164796; x=1789769596; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JYwTxVAwAAEy9xr61JO4H6DlThANBCiqbXJNrMjjvpc=;
        b=a7TbV46OrWTjRHRvs9koc/MH2QkHdM+xKRgvpwlUyc62OXg/aB71zkDbEHkQRPxDx6
         CILgISvMCuvla0YfKwsiOStkA17v7Wvvj9XnXU3zsr0nKI2q1GCFSyO18c/aRTseASJ7
         mvp1gkC9hp4X1UMPvCj7ge8fJU0IKNJDCp/Tjms/KW503oVi0DL/OiofGEV+JQeusov9
         dXScmR3iPrEVplXn9jewsRQAHvH2CScZiLrFYYqfJmIvCxrFj/ILoSfVRJoG6bi2iV9p
         NWoxMcbvfDbou0Yqf6dBhdy36MotUvhS+dS5zX7+Bm22N6tsyimzFp/l7NcYhyR+dA35
         dhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789164796; x=1789769596;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JYwTxVAwAAEy9xr61JO4H6DlThANBCiqbXJNrMjjvpc=;
        b=pPNYU6q6f/zk0TSwUfbvhgUHZb1pZqZsJHPnFNfvrmoiy8M/3eQ4ojvTr94uSfURWh
         v68/sEu+Xmacs5WUADfhnJ2Fr2XAU+dELX3M5fMNGmHF2DxAHfcZCHq2o9dw4vc16cKe
         Im7LyUm4IKxxCUxNu8y9/BZvWheeWBD37jPaOiKxFw0REF/Kdu8remN1vpq7Le7x4ryK
         WUKPHjRIBF8V+odUg4jKKDE4q8S+46M53xnFPyGRCQbuwvgl98QM7EKnLXBUzAmLVNWi
         FhB9QEphlfzoZcbbZtnG1L5A4VtoiToZt2mCcUZWtR5lBXTw5/oGcwQTxDAd5zHBWhfp
         TsFQ==
X-Gm-Message-State: AFuF++nEuOPT+cu9K9o4oxQrRIGT3KrR7zSWR0EBUnsEIJZB1QLawk4Q
	EoJhvOyohCtHzgi7CFtOEGGzGSVbhrUckI74FAZXA8wa0OfBmO7j8pmpOtv+tR8mUwLiQ1ND8m+
	s8Vt6P+n8701Vi4XqPjorH7qXsr74RhLqJLCznmQQDg5VZw+cEod1TZxNi24LJRqVp6aaiA==
X-Gm-Gg: AYBFou1soUfiCrNCZ43pBDqTo5z5+lkFMktkrpJ+jThl0m2ZDN7A2plwJZfuFRko3DU
	Rhjh5ys7g+IIhpnwvF6Hwh2jaqqaXgqGWbFS8HhTkVT8dfOb7qhdZwGfET38btxewx/XsUYQf47
	E9EMOTkXAc0nbgDdRA9ZCyNctqJUlyRyj6W8ULsQE9jVTBcu4G2EzWgvph8lkhkU5w7C0FUmEtx
	Iw8x9Q8NSh453dvlKH0p2CMRNf1FlFDCs3FEJxL8+gGWvgKikD3dIfjNEfqzRyhaCnDeratOBSw
	oyctrnh9uK4A83CrOv0noV3xMbf78q4K0oafZMpV8hLR73wAJBmsFrQgjn5nG/FMG1DspXe5+jn
	QXeW/lqlhYbr5hIPP3XgR04ENpI2OLpI4Tw3s
X-Received: by 2002:a17:90b:1f91:b0:398:9bd5:4910 with SMTP id 98e67ed59e1d1-39dbc7205aemr352746a91.23.1789164796298;
        Fri, 11 Sep 2026 15:13:16 -0700 (PDT)
X-Received: by 2002:a17:90b:1f91:b0:398:9bd5:4910 with SMTP id 98e67ed59e1d1-39dbc7205aemr352694a91.23.1789164795793;
        Fri, 11 Sep 2026 15:13:15 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4ed79absm10137893eec.17.2026.09.11.15.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 15:13:15 -0700 (PDT)
Message-ID: <766a6ea9-f670-43c7-bafb-5c91f49cb451@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 15:13:14 -0700
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
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20260909
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: wnwqoebmNJuPH2xc3jJtDnDuSfCAwDeJ
X-Proofpoint-GUID: wnwqoebmNJuPH2xc3jJtDnDuSfCAwDeJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDMxNSBTYWx0ZWRfX4faC4ha703id
 s+J8ppiQ8k3H9E3k8M41mm1CDqxncaZBavQVxluvyDr7/E+986V4AHAJfMRbAEC/Ga0iQ/NI7GC
 w2w6ZwiYRoWgNi0RvAfQofekeaJYG9Zx6rzhRiohOH8yhZCN3hnQWLqsmQMOQnPcFcqkyxQF2HZ
 ri67gpEh780pdNUTYJrv2ozdaZG+6WYNy+yQdi8gooTfDDylU4NXSWKICNBjPxzKDsEkYyhVWQU
 Jsi21TPsMB/5RaU8NWF0BlJq11m34Oo+jF4i3b3mLA2C663SE1JIOKDVu994B3ZecSAC0LFbt0B
 PjVVe3QRwbUuoFmTMysSp6OaElo8VidjxMe6UxyeOLoQm3qk6+IEn9ETWP6/xkvsgiM6Vwc6Iix
 HnsUh/GteEF4EhqP4Cqbc5jHL2pfWNCAIaibbwxtaUYNF0PzBBrV9fRfn89m7orlU3UC9e+KVI4
 gDNeN5L2ETqki3hrpAg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDMxNSBTYWx0ZWRfX0lRXjCEffkQ/
 k1AvboO7ZR0IBj5WjoJi9YUu7EKyXgAQfa0UcO4dNXuftDpZZnByBQyAD16MmsTg/8De5URPhcF
 R5PvbIaH5foK7hCZtg6cpg0inKwhDEA=
X-Authority-Analysis: v=2.4 cv=QIX91QLL c=1 sm=1 tr=0 ts=6aa47cfd cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=rlMSw0Raz3rYzQdK8EQA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_06,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110315

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

There are no changes for ath11k or ath12k.
For ath10k add firmware files for the shikra platform using WCN3990.

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit e981caea6ed33c48d25b7dbf473327dbd01df163:

  Merge branch 'inf43455' into 'main' (2026-08-31 12:35:31 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20260909

for you to fetch changes up to 46c028dc5c8e8a75c70987b9b4388ab6133d1012:

  ath10k: WCN3990: hw1.0: add shikra firmware files (2026-09-09 09:52:41 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath10k: WCN3990: hw1.0: add shikra firmware files

 WHENCE                                          |   4 +
 ath10k/WCN3990/hw1.0/shikra/firmware-5.bin      | Bin 0 -> 60 bytes
 ath10k/WCN3990/hw1.0/shikra/notice.txt_wlanmdsp | 571 ++++++++++++++++++++++++
 ath10k/WCN3990/hw1.0/shikra/wlanmdsp.mbn        | Bin 0 -> 3811820 bytes
 4 files changed, 575 insertions(+)
 create mode 100644 ath10k/WCN3990/hw1.0/shikra/firmware-5.bin
 create mode 100644 ath10k/WCN3990/hw1.0/shikra/notice.txt_wlanmdsp
 create mode 100644 ath10k/WCN3990/hw1.0/shikra/wlanmdsp.mbn
