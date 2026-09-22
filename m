Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DF65616A3
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092389; cv=none; b=ks+MB6nACbVm+b4DFJM/CHX0TX4hmjDTXJikpAAKOJrXnRh+1OQL0Ql0ACwrpS/1cfBpf3C3PbuoVWCfLNzAhXm5+nbSCiTMVmudrF4U6ec7AAr+AHwskmuF9m12Tq646K/NLcih+8QgmUWGmWBBA+7iVa0fWXckMo+x5GSFF5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092389; c=relaxed/simple;
	bh=+0cvY03uJx1y1P2D/+4vHDG5Zh8Iu7Oql+aQLHLkJjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FmN+8piJEchqAKgly/4Qfa3eZSOcpwdgAmUKSU8EVDcdEz57IK2hT42d7HI7cyWU4GmztxBIgNfZelU3QUcJERSG6vZ6LonUUQwGiXpOrkEXLY9Vy877EVsAz0A0UJfCkvD3jw7DPZgjV1eZEW4Akd0gTMGHRn+ERjBQ3okhdAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eghf+xvy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TSvlnhpZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eghf+xvy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TSvlnhpZ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MEjVFS1058306
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 15:53:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XE/iO7cZtAlOijfmvMM+VDRqjHxwnf6dpW+xiR5DDVg=; b=eghf+xvy//ZOFslf
	UpveaGSVcYErvpNTp5T2vvsCG2NizpveWEYt4+MVh1sZFUIW2iXMDf2koLfzGvxw
	Fpm69AfvdrlllS+wklhM0clBw+kQXpvQfbFtAvmsRVD1aNFxJWJ9qVWsxQyRtgSF
	BXGKQlyBgfpBKL+27SAXmqIVl8sfhVa61k0bcIwLQUIdY1BfPxh68UiWB3ECDcvo
	F0ilmftXrHMrJtzTwfS8kH2Gl7yavjz7AEzq2JZ7+zalAxWcEIekePOf6j9vx4Wq
	ikbaCulpsDs8oJ4QUgeWcwrNt7hFwyzK9Q8/Byr8KrL1EiYErSIv2+l2I0RY9ySQ
	WWcGMQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guha5u7vu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 15:53:06 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2db3734d06dso73423395ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 08:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790092385; x=1790697185; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XE/iO7cZtAlOijfmvMM+VDRqjHxwnf6dpW+xiR5DDVg=;
        b=TSvlnhpZNvpLiAmxSknwQ/S3c7/tpkLASCvGwb+0T+oglp5UtuTwJlG+giP3r/IBRE
         HoWgzCIfKRbjmfq4x9TxFV+VMmCssVJTKtVyLl9E3raVk5Tcb5BKxw00+ffkVv7NwHQL
         psK4B9c/7VwwuKwiL8G4Hl7lonCnNpa9ezpZ3hxVWYXCA0yWNy6l8GEULXfiNdTpwON3
         +biuKym72kirTIOM09E7HdJQeEAxgmQVJBqurRE1f4ER+oUEki6ZPF9sqVP9s/VAR8eM
         yk6vC5Si7vT2ODBcm+8cGxfN8BKTAzbHgVLx7+JbvZJVE/fr075t8YEavSPYmr2T3+R3
         OnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790092385; x=1790697185;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XE/iO7cZtAlOijfmvMM+VDRqjHxwnf6dpW+xiR5DDVg=;
        b=n1TQF7mmZalyRPvXxwJ0sw11LvPaG36tiDs+L8Cn85vYX/ephrdcrQWrQUIJ0vwGXc
         KcatXkupXBsFgjaeXCATnebd2UHWcl5NmQ3AuhjC9ghhl3O4nyvdYQUvcd5ixn6S1e4p
         F+/7Hk9gdyBp6w4hkIHdDi+WMTOCjDH3f9BiZFCFj1k2l9ir4um2AB2tJ1y6yUebw6/L
         Ty6gbGSXkyLcSLtKMgk2fK51D6hbWjZXUYH/jwuLUqr8B1w4pfnNofzjkMrCfz3is3Nb
         Qf5Fbqn29EAaoN4GUozkR0YzqfS3Pxf/EflUoI/t/P1qEEzj9EaEGbDVoptcVE3mAibd
         ObxA==
X-Forwarded-Encrypted: i=1; AKwUvBz34jh3OGmaOgQoz7gKi/SVFH8RnnTZyXJjd/vBwDZVDYrzH2dQwK5tFJKzOyiyWohBVCQJYRdH2s4mru/3KA==@vger.kernel.org
X-Gm-Message-State: AFuF++mm3qm4PYhAZKdo3Ca4R7WLeLVyzWPBhdtjbx4EFDgTMs36LQhu
	AZ4J17iY+8oBFwKH15mxV6RzF20KaLcwoM5wsEujfVlbuR8ZEEyKir+8N3Ci4QWeubMgGvnw1Rr
	Jx+KnlTCNV6smKVnbHIk8RppKbugSvkIbjOWpoR/ClY1aS6JsGIZEXJOW++bgYWw9CR/DuA==
X-Gm-Gg: AYBFou2Ru1aSgQ+VSiun70zgkt3k1GIZSa90ezGCwEd5T0DEXx5G3LoZ0V7nJpMAQBb
	EL2E8jSYeBIbKnHrKUSARzfNf2qxkD+qxv3Fu+QgRTb+2DeQmfkJ9a4m+iCMIiQ8YFV0LVs2RzV
	jnCxu8ORFPtCD5pn/9M2Cb0YbWavzTLOajS4zlUoZKLmaO+dj+6X7IsDcA2LqcfrxsUaJ7uymIO
	qGvBEpwt20Zfuu5JPfBIQ7/ts9+9r96vRT5HScDOYtwPqhWe9wPt3TMvMfgwgVuBj3bkjnR4ib0
	fbv6LSVstNfSJSy861ZH616ca76pU+hUHHITy2X2HcNqNqZ65KSK3pdTviWTRBITGZMAB59+MAr
	dzKE4lMXOCCsKZE9znqJJHE0dBLlI
X-Received: by 2002:a17:902:ce8a:b0:2df:3b08:a30d with SMTP id d9443c01a7336-2df60b60b5bmr20251525ad.43.1790092384960;
        Tue, 22 Sep 2026 08:53:04 -0700 (PDT)
X-Received: by 2002:a17:902:ce8a:b0:2df:3b08:a30d with SMTP id d9443c01a7336-2df60b60b5bmr20250935ad.43.1790092384329;
        Tue, 22 Sep 2026 08:53:04 -0700 (PDT)
Received: from [192.168.29.33] ([49.37.212.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d02f7e1sm13009205ad.39.2026.09.22.08.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 08:53:03 -0700 (PDT)
Message-ID: <f8f231b6-a4fb-4f19-9ec2-949668bfd5b7@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 21:22:55 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] wifi: ath12k: Connect to the QMI server belonging
 to the device owned by this driver
To: manivannan.sadhasivam@oss.qualcomm.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        Bjorn Andersson <andersson@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-4-c00831e88957@oss.qualcomm.com>
Content-Language: en-US
From: Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>
In-Reply-To: <20260922-qrtr-multi-ep-v3-4-c00831e88957@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: xShYLQ-sWHg6WXc3XrFKKq49fNkWv1rl
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDIzMSBTYWx0ZWRfXzRwEKFSBZAA2
 xdc9Ziqn5+wVOUx2S17IrjgUs+VsCwy87Kh8pvgfu9WVveP2l994lF4z59m2BDdidyoPJVj6cpe
 UPi+w/730tqResLJ2ec8yV7A7mWZdGc=
X-Authority-Analysis: v=2.4 cv=U+4Hnuru c=1 sm=1 tr=0 ts=6ab2a462 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fVbWt6ZMyMsyUNhTwytWAg==:17
 a=bQg6oyjaoxrshYPP:21 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=R4z_reooDQMcG2LTbH8A:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: xShYLQ-sWHg6WXc3XrFKKq49fNkWv1rl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDIzMSBTYWx0ZWRfX+K+j4fqBbbk0
 BEiOYqCqWJrShme/kPosDmOZek3HYzPZh/EXnaatEUcPMBQ0cR5Dr8zeV3e7+PPNb/Z67kAPxKV
 T3IyPut7apoJApnyC86qyJGujq4X2ZSGasfGKjs4If2bR5VgmjjDvO/+aLAjNkvUprkGWPQgkR7
 dluAOQ62bNWeHjf1L0Yv8rEoADp2s5sGSLIFzSYlzCiqfG3AXolyejwi5orVuIfBiVgwOD9P3TL
 YaYq8Cahwcu9AbUkYQOKpADecg6Yhl4ODoGlCRxGutwl6pmkEvuiZ5gEAXe+1gJwFr7EQd1rY74
 rwMDlM/XqFBAtHZ4jRzOcC8uKNQQrSHWxr4vzxkdJAdi2CBDukoJ3aedbcIMK7znF0egKYllaxN
 BUihSbzYuUUbdmNQj1ckyQ00gBM6ZIaf4JPNK7wmQ0gsj/n4APmEgUI8azlYWrlSNSq0NYWGzjG
 grSpVekocGa3gjJcJ2g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220231

On 22-09-2026 19:11, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam<manivannan.sadhasivam@oss.qualcomm.com>
> 
> When two identical ath12k PCIe devices are connected to the same host, both
> advertise the WLFW service with the same service and instance id. The QMI
> lookup reports both servers to each device, so a device may connect to the
> firmware running on the other device.
> 
> But now, QRTR provides each MHI endpoint a unique node id which is
> different from the node id announced by the device. So use the same id to
> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> the node id derived from the MHI controller index and zero for transports
> that do not assign one. In the new_server callback, skip any service whose
> node id does not match. A node id of zero disables the check, so transports
> that do not assign one keep their current behavior.
> 
> Tested-on: 2x WCN7850 hw2.0 WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
> Tested-on: 1x WCN6855 ath11k + 1x WCN7850 ath12k
> 
> Tested-by: Juha-Matti Tilli<juha-matti.tilli@iki.fi>
> Reviewed-by: Vasanthakumar Thiagarajan<vasanthakumar.thiagarajan@oss.qualcomm.com>
> Signed-off-by: Manivannan Sadhasivam<manivannan.sadhasivam@oss.qualcomm.com>

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-by: Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>

Validated in ipq9574-rdp433 with three QCN9274 PCIe devices.
