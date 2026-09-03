Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919923C1D5C
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462173; cv=none; b=KFtLeWsmmtrbVM3mVAS4qhsEM8iLwQBqGLg0W5DGAjmrM0CCxmDPOs4IpH2e8cFLBCm/5+hFW86hPZdXU1h7wkF6Pob5wm+Flc9QRYmcCKFh9d4NOqHCzB/SVfEOzZ7Qd9xReUNprxZQnOclaFjmdbFc990eun+ZXgbbEHIqgWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462173; c=relaxed/simple;
	bh=Q0gHMfWELAOX1ZOHLajVRb2Gaa87Kfki/ZYiaa3bG2U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Of9Rva+msyoimVhrkROZaKpmgfnIQ/LjnpjjPHeB7XZKosWaPueG2mNaVjNHhwhQU36XZAqMVOo+5f6mv9p6yV2RnpRvc4ulEEK2oeRLc2bHgErU8DLD4SYNNkrXOHCpqD4RSZB6xvw7B+AbJBraQIVWPaaJgGr9hpBTqL/Y5Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pjCmj/a9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TZzB0hLS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pjCmj/a9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TZzB0hLS"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G3FuN417507
	for <linux-wireless@vger.kernel.org>; Thu, 3 Sep 2026 19:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yUCeoJ0lyz1zczGEAe/+z+la9Wo25ev9VPqfyBGxzrQ=; b=pjCmj/a9L+ZwKiLr
	vjQbNHySTvXbMAnSIpg2TUWCLWf2DDMaIdyWZwKcHxYcWOQNx/KXf4lRA7ehPSfA
	tbkWIGxbKfpVaDLCtkT3MIpYPHagJ26sPem+YzzRBPqfLALixk8Px1MTI3ckwmTz
	PmYJRwa8rd39+1QO4dvPKRtkhTKGAs67GuNGbhvmPZUE5rdnXJDgAkUIgjHDulYf
	cObJJZOkqu1FmyqCceGRNVvbzqX2RLeyBvUHhT67Xrlwz21iN8J8SJyhWCXl8nO7
	MQlxalq1EX1JIvIszw8SLFlgWnGmPHi/xeyQibqR/aQeUwjXnhoUIce7qQUhRMXn
	lZ0bLQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gf51m2y34-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:02:38 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so209256a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 12:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788462158; x=1789066958; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yUCeoJ0lyz1zczGEAe/+z+la9Wo25ev9VPqfyBGxzrQ=;
        b=TZzB0hLSj6pY5X/2ravE9mexw5MHXWOr3Qj4peWKdgdUzZwnBlEP25hoZxPxmElmUW
         vTvr8kETiP2hoHXQXwDxoHb7hjAHm65tMQHlP0gwYac97DbkjH2kM/zBd+cO9UNTkiMA
         QCsiXZQaqvwtH7AkOKUM9Xd9axVzx43ZpKCxCGpGv/X73ZuNJqyaNElvvzqxYBB0/hLN
         PZOfAUgbCVjHtRiZ9/Ba5VHTlZDv/O87TVqhGBEgd9R9Z8pP0Swq0nqsDqbvm2m5U+vA
         BiOqsL37N5r0xUlI+dNNSn91gVCilx3ruldE4CgzFh3isKwgXx0fLZ4GomkwN/9iLEdU
         uYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462158; x=1789066958;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yUCeoJ0lyz1zczGEAe/+z+la9Wo25ev9VPqfyBGxzrQ=;
        b=HnwpnaCcsp3a2Qj+/LQ6DW+a5LKiqjAYJZtCGuOOs7ENlMRTrc7J4rt2AA1w/KN+Kw
         MU+BoRhNRAwKyKrnnRU2BZYockyw3EZHcpToau3kExhZhz0wLrzftSX1eqV/yGwrJA4z
         ipxRL7bFVtwd/imaljXTrAM5Q4rafdCen0Z2etKEfvziSu/QmboRpmVQRhiepZn3Y6Gk
         n9bM3g9hkBrwG1RMAEXNpOsxAtsSdGtbqh+4SgCJanjP7l/01UaQuHwldURt99fibstb
         HqjKwtMoxMYMBB99hCbaHMNA+r1FSBK1fwBCBK6Yuy1kmOn3MrxhJSQeNydVk0OeWtCh
         zxhg==
X-Gm-Message-State: AFuF++nhj2sDTl7/CkB2mUVabgDUG84TrGh6PNrAYmHvC2sayalpDDK8
	TMhlKhXFXHLaj2rAiYFTwcUkdvhq2JmIPn0xwID9sKv763qvhxd4i948gK3jvUC4435Aviwjywv
	DP4cdH3BqDU3dp34W7bAPjFcVsobEgmk0HDARonFkvM1ib4OZG25NHWhzWEB4ckMWI/HK4VsSYo
	c8Fg==
X-Gm-Gg: AYBFou3eIB6FyftdQVplM3Yc8g042DZAVMoHDd1AksVH0rhD6U610Ila12wUqQ5O0Ql
	FICQFyNGqDRJU3kcDmTMsoVq4t6uo1YufsgQQNWhPmG2+ElbSphQ0WUCbg7QR0TH8nOXBXpaBBd
	OTkI4vNu8H7CrIRvk3bvnAtFRmTHI0q+LCMPrNt9B3uvsOr/+emV40/MiECW9OLHoa8d1FXAY0q
	gGoUjZlQ1OhfWRmHoNFOaoiXBVhme26iI9UrusXEwzPiozZ8mu/IXMiP859vvUN/vn37L0HT+AL
	JmBmJ+yEZ2VEOmoXw00ozFCZx9BNsnrXe4DhFaNfV2Sp526VZqRw5JbQRmLtN7Gvzz3dnjZQXrq
	ox8DbN1E6Nme0ecMNESRt8ZQGozRx6/WLwaq7PjI35SZg0x8sL8X3WRg=
X-Received: by 2002:a17:90b:5845:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-39b2620547amr889141a91.16.1788462157526;
        Thu, 03 Sep 2026 12:02:37 -0700 (PDT)
X-Received: by 2002:a17:90b:5845:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-39b2620547amr889029a91.16.1788462156900;
        Thu, 03 Sep 2026 12:02:36 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm1230164c88.11.2026.09.03.12.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 12:02:36 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
References: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/4] wifi: ath12k: fix timeout while waiting
 for regulatory update on bring-up
Message-Id: <178846215597.824911.15370402365282213910.b4-ty@oss.qualcomm.com>
Date: Thu, 03 Sep 2026 12:02:35 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: xKlTJpalzLgTF2BPRTwbp6CTObxOpYKI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX/N5DDUFwDrCn
 x7YpX0wLE+WE2Cfl5OMyM5jRCbwFjbr7JWoNm3AHMdpkB1VDBI18eKXZMUnbaDGcp6qzgY39wA6
 CmHrWOc1EJX8ubadLOMfZcJAJaiuH/LSAeXkVp/2J5M+F2gram/ayDdHTNbIzQJI1rfDzvDMn0w
 Rq3zvQhUPOPnKA9mLHfqy/v+wD3zOcb0jfL1cfYSFmpGnIOQUXfjnGsg8BFvgJVH1hnMqUs/e4v
 tggAufraPrNrDY6csKLRlurXxB8O7yo2uXM8Ssc+c5Ar98brcFgcbeSfZVGWPOlEHSoPJd0y4K3
 ZaWiZsBlYXaoz2E3Qvebh7OJgZ12TBELLhhDGl3IYIj2e/Mtfbil+OhqvYOTioVlPswE5RzqNk/
 HVllo4AHolIzgpdAEeEbpO00BwLw8JjJw6J/iMbr7oWxG+j3yUsevEf+A6M8WhZ1CyFp/6m0xts
 yeVcCzUPWQoGsR1XSpg==
X-Authority-Analysis: v=2.4 cv=X8Ji7mTe c=1 sm=1 tr=0 ts=6a99c44e cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=dBmMSM3fNOV455FkuikA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfXzd0FTYRZLk9X
 9iSBObpFdbVbEDuBT7k49bv8z5cWBTORsjxBE3pQZvXdd331rsTpv05xzlUJLvXObTEScggrDBO
 OBErKDahIZntWWX1xMUopl2Is6YSLE0=
X-Proofpoint-ORIG-GUID: xKlTJpalzLgTF2BPRTwbp6CTObxOpYKI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030166


On Wed, 29 Jul 2026 15:18:10 +0800, Baochen Qiang wrote:
> On devices that support setting the current country code, the following
> warning is seen during driver bring-up:
> 
>   Timeout while waiting for regulatory update
> 
> This happens when the country to be set during registration is the same as
> the one already applied at boot time: the regulatory event from firmware
> gets dropped without signalling the completion, so the waiter times out.
> 
> [...]

Applied, thanks!

[1/4] wifi: ath12k: signal regd update completion when reg event is dropped
      commit: f2576dc0f894ef33045ba7ed057ec417988bba8a
[2/4] wifi: ath12k: use per-radio ab in ath12k_mac_hw_register()
      commit: af8d103b2b23f8cf9a1a72b15b3873bad53470df
[3/4] wifi: ath12k: protect new_alpha2 access with base_lock
      commit: 04497f2a77216f27f60463c9b3d84c3c8f2cf62c
[4/4] wifi: ath12k: skip setting country code during registration when unchanged
      commit: 8ab8a5ee16b2fcb06837039dc42405ed53866fec

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

