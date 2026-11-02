Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632722;
	b=NsrNdlfEmyFAfi5zojbbVApsC9GwpbRSqgS2dks3ZZNe60Ss+VEJYxDRX4Qj05S/pXuG
	 D9daM84XtyLKQRZAG5MjYph/fIK8J5oDDHCqNbhgoAIYKJFkFqYRuMRl6J/u6FQdDUCz7
	 UP2Ih9i7kce1HPQ2q96qnmJ4gQaG9UMoMJN0HvAcPLtT/aEUzWLQWAM8BinVL6g8KRW1W
	 KdT6E+3NrNB+jxuWTqC6FHYnwh69Nj3ouZw5lCT1hjYvPo1tlJ1zTTWNp0JD/CvKkxPx9
	 zQWX42WutV692bXKC/+bfcQDziSEx/MoTMhGPXs57KXC8wf8rzPmd1QuZ2xMf9Wpc2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632722;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=lnNxXJJhJNYm/sF+ahjDCfCc02sPEv63IxnRELLXDoY=;
	b=S3TTzTi079KyolmvnbH57qi0rVMpuFxy4eQcb85gjGa5AbWmBrzQYUSGD5OgYZy4DQCE
	 SgvuhBi7vLpf0icZbhRErQFcJc8S85U1X4Lq7Bu3bTHYDaTCGk2H2QNIMOrVPW6/WV8+B
	 u4MmqIqRCAQNAGW+kjvahZIOeD7u5kivq/snuIUWFGv3ufqMmn6ewScd2eUoPDyLTut/o
	 6WEuFn45Qmwsg9oFKeiUvo+7g2MNDKofY+n+2PqAqB4l6LkfMMNqSEKChzNoGDB6s4sWM
	 VthaLQ7Lg/ADuD/AyZM3rk6mWsAvmeZ4QjlXLPwqRgozKCmyccCrNO05tMO2WguU0UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=S3Y1LCXA;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hP4Yzaot;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314DB606A5BC
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:18:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 314DB606A5BC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=S3Y1LCXA;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hP4Yzaot
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2Dp8sJ4033821
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 15:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lnNxXJJhJNYm/sF+ahjDCfCc02sPEv63IxnRELLXDoY=; b=S3Y1LCXAIggvtLKN
	4uW1qlzJJgU8iXBnd5eFF/lPznGNjz0Tvv80YogqOluYyQAM8ir0f5Vid2Sdyc/k
	onk1+Z0i99z389b+PHm99x+dThrkWbDkt6AcppG9GCfTw9qT6Yo/s8s7skOzJuKn
	yT2/oqy5jt6H+upEYkc68XoNz6g5RvHJIW43giWicFezshvqmktAJfGVcOX7zPIp
	FYmnncfGt09zy7tnr9LYr1kZ1uyXmadO11Q+5bIwRvaPYleNZhV6S6ZJv+FfLGOb
	e8VXm84EELFO4voOUrjJEn3GsbewFi0zV7x+6541dkjez5/fvT5vRUNzZQj5pct0
	GA8VTw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hppfe9shs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 15:18:41 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35c3c370b17so5388025eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 07:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793632720; x=1794237520; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lnNxXJJhJNYm/sF+ahjDCfCc02sPEv63IxnRELLXDoY=;
        b=hP4YzaotCln49TV9NNS4znbC2BzJg3UdvQJQbH4Dm5/YIEWbi/KxcbYsFXbOI60qzb
         fj6RXItcN+/w1Ou5Pir2a411BvhEiMtxoc8vgzbjfyH2lAikGU1exMd5FO8Ho9/eJMgB
         FLPbiRgFJEavRXaCtZH8JoSepqc8zFF5vV5B/tvqJjp+q5oKTZQECpVOpgP1KJDkmKlh
         /JUl/LL4DI2hLVAUfK+FvMVafaHVbVMIe02WjuQp7GKZMyoNlERwARbpjcjLr1suy985
         Zt6nmPYCZ29Zgxv7BdhxVfoQxn+coDNxYr8yfh93TIVD8zJ6d8YKuK/1C7y5dqVzEVMv
         qSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632720; x=1794237520;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lnNxXJJhJNYm/sF+ahjDCfCc02sPEv63IxnRELLXDoY=;
        b=wbhRmK0f4Q8HjP9yRFOq+lzCCOIVrs5mTt6vEip1EfH3odubYcAq9H4tiPzIX8Ybcs
         6trFKKCfwxyXkFwkdRVvPfm8Osg4Kh0Hd405nzgr1EA0gkpHBmbX/Y1Yf1sBdqUM+dNA
         ZsE7nNoesSuA/tmVuyP+2vN0hf3z0YAFS39RQZ/RkY0c00LbtRhgPaaFCACFqOn1rqhU
         m7OisLtiZqkskr0NEuKonttfxkLU2bbzxqm0CduRPJxeW6NqPFnOGyCMYlVGBxWzVxdX
         nDhUzc5FieCmKYsoe9dED+Vd1IKMDXAm98ns7R/1JXAih7ZsAf8EysrffDaBgJqyI5AA
         Ov6Q==
X-Gm-Message-State: APuU4Z8tnnJEM8k0kjc18vEvxStGzSZHLxaw7eXH7VKFvWcFkO0dH19r
	mwTDOcnvsITPb8pQtxN7prXqjmSy+ED4iilLfEq74USfggn/SnGFrJdo39f4rk2snJ8gvfo2P6S
	zXinA3REB4sDhSRgih+yPdy2MZ50gbTagI8EOyWdKZvEYcAW2xVSS76POM0i5uqQmXpvNF7t4KD
	YkRw==
X-Gm-Gg: AYBFou0QTE0Wuv9DvG+rZ5kMHpidPy6/sICRC1m1pCUMwmLiZqyLdaKcnPJdkWD0xv6
	S9CgnRaML+0tuXODuzV8rzk8WFLPpZG2dJK7udJyTLEOMpeuhDO9Xp6LCkG5ucDIkYDi10lwpsn
	XvAfR5Himcb4aK5CZvLea4IzYGIlGQpjSSR3IumvdVJGpA7gH5EIzILa4PpFKyY090uJ5jL0for
	ViBYMzGx2swCMygIRTgbNAiWNvlutbtqKDScJp8agaiLx3UOrqvejHpk6dq3AW9iZQx8u9Ii8Ke
	YOyPLeF4+20XZPvZHOAy/9erclNxqQ/9OmwnF0jnAcblH9NUJdc7KA6/9IAgnDlBin1YspG8fze
	34jC+h/z3p5/IDkYIs7+okwhOR8uF1+MbbXQAdSKJZZHXZY5m5y7F8jfI16l6V0P9sY8r0Rx4Qv
	HiyuNUCmegVoaad5mPhUBl4M5t1PAL
X-Received: by 2002:a05:693c:69d2:b0:368:9553:f2da with SMTP id 5a478bee46e88-36a423f5c39mr17630581eec.31.1793632720296;
        Mon, 02 Nov 2026 07:18:40 -0800 (PST)
X-Received: by 2002:a05:693c:69d2:b0:368:9553:f2da with SMTP id 5a478bee46e88-36a423f5c39mr17630540eec.31.1793632719592;
        Mon, 02 Nov 2026 07:18:39 -0800 (PST)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a6f7f9sm45142952eec.25.2026.11.02.07.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:18:38 -0800 (PST)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Vladimir Petrzhikovskii <vladimir@dfb.sh>
In-Reply-To: <20261029-ath12k-mcs15-v1-1-3bcfab101f00@oss.qualcomm.com>
References: <20261029-ath12k-mcs15-v1-1-3bcfab101f00@oss.qualcomm.com>
Subject: Re: [PATCH ath-current] wifi: ath12k: don't advertise EHT-MCS15 to
 firmware unless we support it
Message-Id: <179363271863.1307032.2099713903992219927.b4-ty@b4>
Date: Mon, 02 Nov 2026 07:18:38 -0800
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
X-Mailer: b4 0.16.0
X-Authority-Analysis: v=2.4 cv=SeZi5fRu c=1 sm=1 tr=0 ts=6ae8a9d1 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=l92UNcoUwmMchHTds88A:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA2MCBTYWx0ZWRfX6NiIITtbAGZK
 03CJR1NpoAg20TMQRsxc2r0kpyH9elkNkfHeCYkWhnyBvhB9AN6s1J/VEHHQQAYGL8Kj8dnjzum
 qDX6LzFSaY5mHdMRPgPPCfq8G7MJ2vdZaybCqhh2FdNkUSxr3ud5PPxupFk8pvny2BXJoF31zHU
 B1RnYwD34XIwOJAOuRtNmxlgOEvp2rbJB2IPHfWqxEyt5RgBFWxvwvqRazJmwD6avlNtMpKe+FO
 J4lBK0iv7yxr/HZd60NLKqpSK81wbo11wBiJ0OlYxB0nehNrhPMECtOFo1l3U7o0ypijPaCY17K
 UzkUimVV+udxX8oYfMnZdGEY5r+NsQfXmMy5olV/tBLtAAVSYJVjzsyGTMoEFS9x+LapoPBvVfh
 nQiCpMLcL+knDipZzPBcv8wCDD5fA4Bt05QhKmOeIMHVpWmADkRp0JPyjo/B42NCtEOsKJ38S/Q
 NDo2sg1djjZ7tt/Z1Mg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA2MCBTYWx0ZWRfXxcT99m8b2EpZ
 eTCZwhRm5uDmpcnf3a+4G7WvV+oNfcGm3B/3bkiogGiqr+xEZxb0HgvyPKjzJYqT+RiftTSA9Yg
 paUjAOg0ulSHDOCV4MeX73nxZIXKeK8=
X-Proofpoint-ORIG-GUID: UHQwFdcvYXdsyeAm8lREI1X51TwGyl8j
X-Proofpoint-GUID: UHQwFdcvYXdsyeAm8lREI1X51TwGyl8j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_04,2026-11-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020060


On Thu, 29 Oct 2026 10:18:42 +0800, Baochen Qiang wrote:
> ath12k_peer_assoc_h_eht() copies the peer's EHT PHY capabilities into
> the WMI peer assoc command as is, including the EHT-MCS15 support bits.
> Firmware rate control enables EHT-MCS15 for TX whenever those bits are
> set, without checking whether the local PHY supports MCS15.
> 
> Currently WCN7850 firmware does not support EHT-MCS15 for TX and does
> not advertise it in its own EHT PHY capabilities. When connected to an
> AP that advertises MCS15 support, rate control may still select
> EHT-MCS15, and every PPDU at that rate is aborted by the PHY before it
> goes on the air. TX then stops for minutes while the association stays
> up, and frames sit in the queue until the firmware releases them as aged.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: don't advertise EHT-MCS15 to firmware unless we support it
      commit: 83d689bbe8f90ce39961bcc3a64f2ca2ec184019

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

