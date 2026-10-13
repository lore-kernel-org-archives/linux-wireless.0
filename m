Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD6F349CFF
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791853562; cv=none; b=DBVbqYwKQMBem5PiPOUBmQaS4UpmND3qL0Y12rrmkhW014xaFkGkR35L09tS3TeFyyeI7+Op80bOF9xySAWTY345GZfliAY0JXiKp5JJjvntuJToFYyS1r1QvVoKIx9YrHe2YYo1MWiFbouxN9FBVQbK4IogIpN/g86Jcmd25/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791853562; c=relaxed/simple;
	bh=h/MBqoW4rymsrUEs28VvN7VfwrPYsRjNMLitK8/jw3c=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EbjzyitwIFFdkqUfGTICBZFN2R9Nn9e6Adzknvtr6IQOf22kZggGXINKWumkdS2h5uHYQCaJbfKqOxEJF1nOY63g80BuhN/Ac3X9uR6Ew+LSbzVckB8sRuTgyeqodn0TAFDtYLWZrgU33B/0QgN4TOfvnSQu+bQNgZ9l1DxSfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gVvlj4Iy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fCqlaP9f; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gVvlj4Iy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fCqlaP9f"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CJgRU13106517
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	l1kY0j8rfR8BCLWSUkl+P7vz1k2BLAGKluDytO7OdqE=; b=gVvlj4Iyu3w+P5Os
	Qzcj/4L0CUPcGh9gLziBe6aVEphPNK/yHDFPlzFEZW69sz8GRgQu0NaDa8/jrGIL
	2Hzqrd9OOSXctD6DH45CCRkXsk1ZfdGHtfzTIOrQhirjA5/hMtbkRwAxbPBIlXhk
	n1Axv4SFNL/0jD6wyBhQyruqVWaDzf6YWfmmfgAwwzOi8APkGlrJQOVwyc5GUrDD
	gVh14VSoarMFlMdHt53+PbzVMeLxHrZGg05uB3kbzFMBfd76uW7NO+m7ZRqm3HLs
	+fj1C8Jo6IgqR4ulYuHS6Hev8xNWu+i4JHNpeLvyavcDLxvDRRDTgswP5ru3UWbT
	GSV8ag==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h95xqrxrf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:06:00 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1665200f4c2so3390867c88.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 18:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791853559; x=1792458359; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l1kY0j8rfR8BCLWSUkl+P7vz1k2BLAGKluDytO7OdqE=;
        b=fCqlaP9fZxxCLg5lF629zo9sSAeirXgKl2s6sNJYYWUdnxVPS4j3YvhWGnn2qfXrBM
         ZFtBd1DqBns1nhxY3unoGvCo4soogpI8TeGichTmy9V75pQRzVNaO3Y2rj8eC2gUdRqa
         CTaOwOpmtJRIco/xZHV0wQqXTNg07BhT3NAb16XYQsFHK2+4Q+L8i7w+o7Ntityabn2T
         UYlrEPl0rH45tka+RdQ27BggNKGF+RHQg/JyYNbeXI/chhhZ1G2QA1NAg2TrKwdYPebh
         DewoiYwaQi72iJar1t7CFeZBnxrP5wYit+ppq+lvwCF5PCaWINb/X2fg4xZhpVdNFS+C
         qNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791853559; x=1792458359;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l1kY0j8rfR8BCLWSUkl+P7vz1k2BLAGKluDytO7OdqE=;
        b=nrMbHn8hMCuOtsRiGG6MH5o/ksDsVZwlQ2sp3mSF0uSzLnj01upRsxy2GRxTeLSYFU
         N3z4tk193wFFwC49ucKfXJSAmdUDmimxlZWUGWjeyfu96LxUYt7l9vxgi6IbQZkK3ZOe
         tO7SbuSLD/qvKmKzBqJK+nOfS2lu7r5Mg7Uu5xLkJ42FsytRNFjQzKFtcOFe8VvrFGU2
         v9elMoK4YgXrTEaFS4wO3YlGudMQALno1h7q7Gcuc5GR4Z2zSaQ9km4G1J/Ow4XImO6T
         dU97h7Vgvqh2SJamANUr1Z/v6ZE+7UL25ZRfe/DBtVTcKT9eIuybaVZ34hW2gszVlOG2
         7idw==
X-Forwarded-Encrypted: i=1; AKwUvBx3Iiwt/h3aKvKthsb/Sz2taOA3mdARqUwAqWrnWbtKNr/rEXIvtSzVnKA/0h6iP85ydsd0mVqy8Zt24X2vBg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL73H1Ga67tvZWhP9fwoT6VRz3c516KM2ESWVDE5/BccZiuTu3s
	3iOAECUBCwE7vtykN5Rc1LOr2JGELYg77mnMjjyim0w7bNt2BJmsuK1/KKn/0jLCdrTXsG6Wsbm
	1m/2hX318vrMbTn7VkqEKsaptsNn2DrlmKXYdpoZ4XR9CNJYq4E5RsQ/KA6HrrBpnHaeghA==
X-Gm-Gg: AYBFou1U22S8iuGakLsxszKELOvrjebMqp1YMF4KZbkngr8lNyjvcxPww9BrpCw83ZK
	YX2n4KebTljI3J+H5cXFJ2/fALCgOIZ7rUPL5lgSpM0FAu+hnyReXyNeVphuL6hulmVAn7e2BC5
	H0LYvRjXwU7l+cwZ+vQDrvF8fDaRsOzjCY/8hl0ElVewa550Fja9wmS2LHCxZVq742BimzcQOSP
	UPeZupqVijCdstyIYd++Lpi6QRjsQMl8LJEFuqANceX1uESBgOdBR+3KS9mH9WHXq9jc/yPiJtc
	Fev9D68MFB5Jnj+WZHCKs8MaUl10bgsY7c39o+lsNELe3sFn4f1NKL/qT6F+hemwK2VH3nIKz56
	Fukq8cLrcakd//pbE/Sxc1tzTavNHLDsuoj/xErDwq2ds62C2ECfV/b0=
X-Received: by 2002:a05:7022:170a:b0:141:51fa:e609 with SMTP id a92af1059eb24-16a4c33923emr14320887c88.0.1791853558827;
        Mon, 12 Oct 2026 18:05:58 -0700 (PDT)
X-Received: by 2002:a05:7022:170a:b0:141:51fa:e609 with SMTP id a92af1059eb24-16a4c33923emr14320852c88.0.1791853558074;
        Mon, 12 Oct 2026 18:05:58 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a567bd18sm32904080c88.21.2026.10.12.18.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 18:05:57 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@qca.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org,
        Sriram R <sriram.ramachandran@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Jiale Yao <yaojiale02@163.com>
In-Reply-To: <20261003092104.520135-1-yaojiale02@163.com>
References: <20261003092104.520135-1-yaojiale02@163.com>
Subject: Re: [PATCH v2 0/5] wifi: ath: avoid IDR mutation while iterating
Message-Id: <179185355715.3481009.13105817063716132761.b4-ty@b4>
Date: Mon, 12 Oct 2026 18:05:57 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAwNCBTYWx0ZWRfX5VrFKvl/7KhU
 /JSJgzZoib0qo7079zeVsoh169o46kHcinPBTAnFGgT9GvV5tx3EjgADWFwn1j1rxu6XvaMIiMS
 +Y6T7EYZIuFe8qWC7i4lD81pERERZ7BsYU/zBw69+MJfhPZptVC00rgTu66prNbddI4IwW+8ymI
 mSIH3d07V1hr4bQHxGxj/mTTypw6Jaa+EoRHFkhk5GWusEA/r1UQXsaVUvIKlz5RFaGhReSc/yq
 mLd6FX9X05+6TaBkoJHKtDcVSWfovjYlw9iqJHQxDZmi/nPISLchT2JXcWSPvyB685sgXa3XHvI
 H+Zo4kuANGLO5NVaFjNU/8NeW0/6BxrrLLqKSMHe7tOAayfaYjZeyLWIjquuc3pZweYw0Oc2AZV
 RM68hiKcDMP4sXITX15kKlNLzf79j4z/gBcoC+jFO5zuIzezdi7+i/PF/yuhHUc+PVYQHf/Z1GG
 IDZzIHO3Up36vTyLb/w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAwNCBTYWx0ZWRfXyNV/HIMal15y
 6HqAvCE7ebHZ8McvMs/hoid0BYalYihzp81PTt6CQup8mv9oLkPwWUbJkBFnFKqYiw5z/Rcv/Tb
 bPEGKRCf5bwlu2M4FMBWtlBcFPwb4xE=
X-Proofpoint-ORIG-GUID: -udSve8WlmRhiTBvYiQLmAx_Y5zfeBkp
X-Authority-Analysis: v=2.4 cv=EP+TQFZC c=1 sm=1 tr=0 ts=6acd83f8 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Op5QjlldpLrGc0l9b0wA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-GUID: -udSve8WlmRhiTBvYiQLmAx_Y5zfeBkp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130004


On Sat, 03 Oct 2026 17:20:57 +0800, Jiale Yao wrote:
> The ath10k, ath11k, and ath12k cleanup paths walk an IDR while removing
> the current entry. idr_for_each() retains radix-tree iterator state across
> the callback, so that removal can invalidate the walk.
> 
> Use idr_for_each_entry() in each cleanup path. It performs a fresh
> idr_get_next() lookup for every iteration, allowing the current entry to
> be removed safely before its skb is released. Keeping the existing locked
> removal helpers also ensures that a concurrent TX completion cannot find
> an IDR entry which points to an already freed skb.
> 
> [...]

Applied, thanks!

[1/5] wifi: ath10k: avoid IDR mutation during TX cleanup
      commit: 1c1a208e65a08191901cfded3bbccc4a54e4a75c
[2/5] wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
      commit: 3e7f5d362b2b3a21b3adb4b860aad14b69a896ad
[3/5] wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
      commit: dc29226dada34a6d19af77b4b51e90f8a3a8de34
[4/5] wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
      commit: 94c7b50351fd30e1dfe1b4051197a1445d8547e1
[5/5] wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
      commit: 4aa45334eb23d40bf31c43405daea9b73469f2a6

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

