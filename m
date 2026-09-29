Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D410253B613
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790693904; cv=none; b=OMwvTN0YN3Rl9gl6CfqsS6AjiTvKqeAOgQrSrNEaaRCVjUr6TSb3Owgsn2VOU56d4hZ8w57Skj66ZLNXzPLLUQnCejNwywXXl7glzLAPKu1Hly9q70gQ753G8kZkbuUObg+CxwINYh/sLkxj4OOlakD/Y6yQkqRcfhe7dIEgEJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790693904; c=relaxed/simple;
	bh=pPOmVbG0Tnty689LmSWCmuD50q/tNXrgdKeY041Xa4I=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=jculRN5MSL7P8H0oI51qE9MtZQxulmWxKX23K5EkjCXVfweQS6bM384iEVk1VPRgxrG60nd5y3UQLUKOKErZqWg1D6E1OSf/WGedPvd+dQFJUvElJYnZaIyinU1M/kWN02tZ7M4p0OQ3ETwIldaaTH4mcCwabftPC3mORouq1g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kC8tdC+O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=emweOMmJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kC8tdC+O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="emweOMmJ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCqdBI204825
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=y3FAXes+v/ckFLFxhg6vzm
	hXV+ldag2L1geEzXuvTko=; b=kC8tdC+O4jGkx7MBe1lGJU9fylEBoj41LNFXyy
	fFaCe7hCOkXfH8lEiLtdR08HY8xOWhAxPrNoHXhe2gTuVahIsgEXj+X1jAoli5in
	Ed/UNz66CtpcwYUNbDpyJz7syVqHlELEB+EYrGkoQABaVB1jbxaw2ZRuLdufCq2j
	jEKf5CpJi1YfyGFqFb3lT8SPp0EzLFm0FHnvECsP7Iisn9gnqTjD2i6Cnq3I0iJl
	00WH75mDgAGF2Ts/mnanwHPqxhaJFYOQVMRumX8iP+ZUM7zsVkJSBYeLHfm7Mja8
	0m/goyvW57TkwPiIyUQNNAJf4bvPGV+iKstdyXqX77GgEkzg==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0144ukq8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:58:13 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-14383177746so9517881c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 07:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790693893; x=1791298693; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=y3FAXes+v/ckFLFxhg6vzmhXV+ldag2L1geEzXuvTko=;
        b=emweOMmJHNb15nN0vcs9XpcMtU1OG8NO8WNMab+nCNZmZIJAO4DFiRC1zPNf3Ti07R
         wMfVj0gdfFwJpUUNF2NeYCCac4wWkuzAMrCIzoR2bT9R8NDOJgvZw7UQY7wgYBqJAP1a
         rkOq4GzNivuSVz68ky8k6O5+Q5/ZtmctFbh+2bfzwZQ+Jd5GBJK6KvbHUvVNhA+sLLoe
         Iwy403EW9sze7WazTyjfi9SMBNNhPlG8RbCCQjpeCYH1x69nuelDk+Fzt8jcTkxP+M0L
         lgrvM2DtyI9bxgbrra8hs8JgXrM3BHEF/0IR1SmbjnXjv+GCAxSN3yrmUmxYG+dAYW9D
         TFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790693893; x=1791298693;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y3FAXes+v/ckFLFxhg6vzmhXV+ldag2L1geEzXuvTko=;
        b=ENG6A3ZJ+Wj9jmgwZI42AIy/LkuNHneBekGKvaWFhOz81vhcJ0+kEV86Pd2Vj6o8hN
         7mTxVZX6qpYZUYyo3vWO8UFQikaPj7aKzk8EpRDW5UMjCCofdhTTIrat1fx2Lz9TsDiS
         4tyMae+AqPMbGFRoK3qzOQBqa/Tz0KIRTuNN0Zm1kyHlWUKPGtsT6i4NgmIVmh82QQCK
         RpnaSDn+b8EEM7FVfenscfVPSd9PyUUvZSA2bSoYYU67lZN9l1it8goGzmGdvz93QU0R
         M8ssXeCNhi2+c7bw8hcuvc5iUGwJSzN229JBrDkxLmwHFuOUwz4v74X2Gtx4qpk1wbrq
         PhPw==
X-Gm-Message-State: AFuF++lDdFuFBUVtxYYsHN01uFVbMsaChKlJ8JGMxzrVER3uZXeI/0gD
	Co2WxQLtaDFl8eZ9St9Cl/UaMcp/x4R3biVHmKELOPrQtQ2c8vyV0qpNrn5o4Wq9X1HTf0irGgg
	KEKAgptSSNUxrMCZ/bvVCtTbpcTiN3IDLYMrqkjLUjCF5m1xHqmveZWNqgiQo2WbzSL5uhHMAFC
	oITQ==
X-Gm-Gg: AYBFou1j3GWndRzpWbb0+UrpVtHOjuzV4UI8Q42V1mZUME+NxBCQGgNvPMtGBdYAlXG
	0yiQgMwKdDH3/t82JDU5/hxW/3OKTOLezlGY6F6y02VTN1n2++gwcYDxDxGiAyge5J+6y/WMNMB
	FNX0AG9wZ1BCQs+Aeur37PPpkIK6kHF2esiUyzk8ElLEUdU8NQMypTDakYPXjRIIHWMyO+wQyw8
	o3dxRHeyuZzxb3QNMIv3nt1q+ScZadBvSYKfQl4aVhmvPmwvl1Zvtxc+UZtyxystZzIedZOyUDu
	uba2AmLGBqAFl1KI2W5CcbYHTNH9W1mLnvF7BUt4VaNFTLq60d7wRWC4fi34gBtNpWDhHYENjAs
	0jKgN04huXg6NpFCsh8GoSF5ZY8IT9ptmYkI=
X-Received: by 2002:a05:7022:7f19:b0:143:342a:3d3d with SMTP id a92af1059eb24-14c18a55c48mr1297371c88.0.1790693892537;
        Tue, 29 Sep 2026 07:58:12 -0700 (PDT)
X-Received: by 2002:a05:7022:7f19:b0:143:342a:3d3d with SMTP id a92af1059eb24-14c18a55c48mr1297330c88.0.1790693891851;
        Tue, 29 Sep 2026 07:58:11 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14c60c55ed9sm163937c88.2.2026.09.29.07.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 07:58:11 -0700 (PDT)
Message-ID: <2b42b119-4271-4b9d-8a7d-1673c6ef62ee@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 07:58:10 -0700
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
Subject: pull-request: ath-current-20260929
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1OSBTYWx0ZWRfX+vSDuALCrbSB
 TP6AexdTSMJv6Q0Ts1zvddyPvo8vfc0GZ1jBCkStrK3ytTUT5MCaRQq4SDrS/zG2c+PcmNKp/iC
 B6VUVBCx/s8zHbU463b/dJ9F1S7TormEDt87tH0gahmCYOtsMMrYdUQbUpn9yjhniqYavXX+K3J
 2ZIHFuLZEBMiwabPH+29MqIfaZ1SOTuZZW8/uny50G4l0pgqT0kzfIAayOZ+z+dadZ8dw1UHae+
 A2BrNv3E6DSiAyx767u/BIiCYOFJpXfB8Swj+xXRL8oWYB3oiGPCJ3Im15wyaxCoAXftLUDd9SU
 EB/czyG2M9xXiyD+ju73ZWi/6+GsJiKG49uSyObZHwa5rmnMCoZWroAE14LoyJ4eonL87VreBcK
 gk6or2Ah1CJcji62YwQj9ufi3RXa/niOSZd830SdhGPNkL8cpMyaGu9B9yidbSrxXYCAfxUrtIT
 2u00UlDpjjDF+BAv7YA==
X-Authority-Analysis: v=2.4 cv=FJSOVOos c=1 sm=1 tr=0 ts=6abbd205 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=zv2FTJzYVlaOH1Dba7MA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: AB7t01pordZNQQAf66A_IaWGjtZzMUdr
X-Proofpoint-GUID: AB7t01pordZNQQAf66A_IaWGjtZzMUdr
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1OSBTYWx0ZWRfX9qym9lNRKwpj
 Lt6Z+Gu/ik3bbUVN7qyXYTF+VQx7s1LyHdXDC8RQL6N5TIzHD9OUcc6B0DPi70TpRDhXa/8Rbo9
 yAixwmUctTnjnJ5O26tdS4aBfqFNGlQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290059

The following changes since commit 6f63e919fe1e335b8abcb3a28bfd4804a98d875a:

  wifi: mac80211: fix slab-out-of-bounds read in ieee80211_monitor_select_queue() (2026-09-28 11:11:19 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20260929

for you to fetch changes up to d52302171b61dbba6c9c15e80e9a5f02f1e9f95c:

  wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume (2026-09-29 07:03:58 -0700)

----------------------------------------------------------------
ath.git update for v7.3-rc6

In ath11k, fix an IRQ imbalance during suspend/resume.

----------------------------------------------------------------
Baochen Qiang (1):
      wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume

 drivers/net/wireless/ath/ath11k/core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)
