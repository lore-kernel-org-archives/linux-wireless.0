Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E063A3821
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473380; cv=none; b=Tm+m05YmFSHzbUzY+nnKuX0xthsvBoRQRPPOK/nMIGG0zCxMOuVTv4KdzS9u/oPzOvQbRUuwZ0U2myALNUXRmtdZMHaiqUGB1zfVqHg2KUDqThEO8OPJw50RRbh8zKXOH4GAsyc7BVyzFyk69hysYJUcf+KX6eW6yFAONoNIWrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473380; c=relaxed/simple;
	bh=obEU8FQa/7EEfOAnqKu/7iXbgxmpWUiqeteabXfw7Bo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tXBkHN2qFGBAdL/TJ/uQxXVtc8SfnLUP475rxZc6rxUCKtOFYyCXDBwIEdCXXH6oDJtDoGOGTP6XAKhlI9hVdXMydQQTSJb1yr7m2wYT7vohSe3StFBETM5LGoQRYx4XcD9HQkrJAdYAADFhDThEqJNtGnSPzLfqaJku8tdQjTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZVo9oO46; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QqCXBjYL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZVo9oO46";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QqCXBjYL"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JDvmfC3725846
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 15:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2Q4SC8NtttZk++EtMhiJma5PmFZ92WlKLiK8pVJDm0U=; b=ZVo9oO46dNovUoDT
	eS8NEz8C/6cCQgvt/ZFBukCdY2TTd2Id8IsbDVJ37O66p74XibHrdkr99kIBFkK6
	f7mRK9TbdP3223zJFPL2vRBaKFY7Q5cRK6hlUpWntOcEbbKccN9eZyKLcJVxYJ3p
	O9ONwbxD3m2CKGyWTlu8HnK37XPiIYZAEDD+KeYbmA97h+CeYLj92zFq0cIB2gfn
	C17t22lasASzSmUZVnlGXDSTfDLhcdja9xfKrO0qL2EDhmMytAaJfRt3BdLxB7pH
	Jt8e7+G8U1VThXK2cjiAj9Pisn/hF0W2Jlj+BnMD4fNOSsfCMiRwfY16YdPU/m6X
	pHZUEQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2bnjxb8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 15:02:57 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so4316165a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 08:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784473376; x=1785078176; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Q4SC8NtttZk++EtMhiJma5PmFZ92WlKLiK8pVJDm0U=;
        b=QqCXBjYL7QplyG3S40+7bm61NjHw8vrUNhYHOYFPfDAZJyvGnHM3DyPA8/TFnNgRq2
         XeoAVbWMr+fVAWFnOIfksFSK6EM80qTXxhwOMgozz3si/rOB/DRsahs+RVNZmqc0521e
         Xr3RUYDKfsyQupUMGYlmhcUwcXUGXxAujzePjTzas55LBZJsXOIVb21PphpOTf/fRxaZ
         9KX1krr/XL0uNxAEehn9amHFPeJO6xmlfOw5YRiziBT+nWZgqGSazBSQcD2V9VQ/1296
         wtZvXS4S8YvjuH/HC6UJfmdTCdl/bSno0yUcANA0rErdKaUqymqLttLOjXTi1lvmLfZK
         MRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784473376; x=1785078176;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Q4SC8NtttZk++EtMhiJma5PmFZ92WlKLiK8pVJDm0U=;
        b=AZIJ32xotiajQ6jSqZOtqdrZ9h4GEBu2584J1nYUrrUS5zPVm/WU5891XkvC6hs1fb
         E3csOSNkjp3wJYV1LkhLpK0tDgxzlhV/vUypDS+vCKMuxobHsyNUQeCcdR0wqCEwShkV
         +4QGaaJqSNDSqyivOaOMsnVVcI/qf1XIv417tKu3qb1339k++JwfxwjuXumEVeWcUc0q
         otHZwcgQ5Kro5pYwLBfE4FQcDj3+ymTcPY1v/sypFQozdZMB0U2Up1/p6GIiwuTH3PWz
         YvGiaismJrdYodn+tnQM9zoN/MrkJxR1O5C2VZW00oW9tQmwnNtXqvp71wbH12gxzLg0
         P0NA==
X-Forwarded-Encrypted: i=1; AHgh+RrUbhSYQXvsfogBlNUTP693BPkJ0sP+IkfZwitPhw/qCWWWnB2QGepY5lUwmIpYnqU5WSX3MhsycuRwMjeGww==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2LyEC5j8kJmWzsedg15jqKw1BWf/CjCwDflxCgQeCeztn0nkX
	L9NvcwS10egsGG+ffmWFPGQd+StxWqMNbcQzagq7OyU371aAbOnwXctvOrZLX1kRHShO7+qLief
	4ztjk06Ix+Mi4Fg/hYcxQyOiV4P4xAQDNMrGRCnuq1jvlOKAQjDwyP75um6McGnPM0VwFnoAVrO
	kyuw==
X-Gm-Gg: AfdE7cmw878uImFPYNMSe/7R5Go3QBmVnrd+rwuDxChXNA8N/n2DUPqk8zB8b0Y4Gcz
	HHNKYMYFBNyfu9DbP5tp13mcNZDrDZ7s1Or0ChE/BS+pXvOr9RCkx2it8jr/Ja7YsdOHmFk0iN/
	soZxByVp8FHdJ7cNZgdBGfY4RNbCo6T0W6XrugcCSPmZX+6SQ90fvyYlLg2Gw2x5PojDPlRBE1O
	9X6nBWVFFAzzuB7R5q8KXz1HgObjv48g4BmGbMkzmKaojyt5IPdwv4xHrzFkZUe0959YslJslgX
	Xd3SIG8RJ7iSZO2SoeT+KlMALpL/mKYwTeUlXv2OEOkivRsYsMcmZTNrIsv31aZUsL0pwFlXQoY
	1sdFXsmo3/nV5G5fSYWP2TJTbTFZPGAZzs60lCgDw3XlOW1VC4D88xRA=
X-Received: by 2002:a17:90b:3bcd:b0:387:e0cb:c8e1 with SMTP id 98e67ed59e1d1-38e4b594dadmr10869545a91.42.1784473376092;
        Sun, 19 Jul 2026 08:02:56 -0700 (PDT)
X-Received: by 2002:a17:90b:3bcd:b0:387:e0cb:c8e1 with SMTP id 98e67ed59e1d1-38e4b594dadmr10869484a91.42.1784473375527;
        Sun, 19 Jul 2026 08:02:55 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429fe4677sm24638707eec.11.2026.07.19.08.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 08:02:54 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260717014302.284034-1-daizhuang.bai@oss.qualcomm.com>
References: <20260717014302.284034-1-daizhuang.bai@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: Set DTIM policy to stick mode
 for station interface
Message-Id: <178447337433.3680261.7368997594464473638.b4-ty@oss.qualcomm.com>
Date: Sun, 19 Jul 2026 08:02:54 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: K9Y3PUDd1vdK2LyDfJVWABo1yKpOoPFY
X-Proofpoint-ORIG-GUID: K9Y3PUDd1vdK2LyDfJVWABo1yKpOoPFY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDE2NiBTYWx0ZWRfX42IH5sOlQd5e
 rNtQd815H0j2iCOxaGO+H1qljGV3Obl2kVqAo0flqX+8I83zD+j18WCDfnsiaBhdun2mpSu72yd
 Ifv1kQ8XRBgsPjhsSWcreEdPfTulgvrBt7Hof/ZUwy3EKM7IWTfXEVeO00d33mD8v/dTf+XN+MI
 YVzCPMEvK5dl4ZAzUY6dIB3g4nfJfkJJpZILSCN6LIXhLElG5ZmXxQDKT1BaPcyQFkJfx29Xhlz
 gSWfousC99Tj++dBug1xq8Bq7o2mze2Tc7rSRdCUboM0swITY/tA7e+wm5qmJ40NQqG+cAv5ffA
 7QkUfxZ9ggL+3z2aeXCrjh/lEBqAJxIg2Fl7QC82nkR855ZWcta93lJG5R2y7BKdWuC2SvB/ZcM
 GzDR+MxQALOOq/+rIMazEAWt5Uc/m5Ya3p1O48+8XGbfcBvFIDJ/jda+4R2OQ60RK7LayM5Qtk5
 9/MOR5s/9gtPXw35lfA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDE2NiBTYWx0ZWRfX6/Ua5Jo7uQM6
 a8h69DWlzWDs5JlwG56a0fF2vBlSoyW0GF5X6qWw6+R39A7YbMYIke/d/x/OKhbmcjF2HsJVRHR
 PfMfan5w0I5N0cny2xDQZbC0CuqGm/M=
X-Authority-Analysis: v=2.4 cv=YsQ/gYYX c=1 sm=1 tr=0 ts=6a5ce721 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=S7poeZ7bz1ikm6sqKk4A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_05,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607190166


On Fri, 17 Jul 2026 07:13:02 +0530, Daizhuang Bai wrote:
> Currently, the station always follows the listen interval regardless of
> the DTIM value. The DTIM function does not work as expected. The default
> value of the listen interval is 5 so that the STA wakes up every 500ms
> when power save is on. This can cause a data transmission delay.
> 
> Set the DTIM policy to DTIM stick mode so that the station follows the AP
> DTIM interval rather than the listen interval, which is set in the peer
> assoc command. DTIM stick mode is preferable per the firmware team's request.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Set DTIM policy to stick mode for station interface
      commit: 4834ac1d4894a2c3513e8f28d5693170829b1e68

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

