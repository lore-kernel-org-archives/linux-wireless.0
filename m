Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C28379C47
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785123619; cv=none; b=MPFA+UA11dNIxwzpHN4WpImOyEwZDBmjo5AYe1rhLAEq268MtHXEALFpb9Dcuskwlq0dSCVWphm8rWT7fNKE2KQxeRRaKE19XIrsrkvjFfxOLt4S9O/qLDV2UK8ROAcXKvQKUIphoqbCuirkEq8U2iEeaxc1rYBKShB46wWug4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785123619; c=relaxed/simple;
	bh=JBUsxdn/axNXJeGNT3U1Bl5zDsjiSEYGdIrSywo1prA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5zwqw4tihxsdVO+f0vtZ9sGH9q+Qoo2zHL/BvNiO1s5ajwcFSW7UDjgM8Ae5xZyCumfjc/z4xpl6YqHhceOMnVK6rpto+LnIzaLFg+8/yE7hb7eR0iWeNL3PDvqL67cBVJ0LM1Vf2t/2LiIEUEkJtUro0lZuo1HV2MfGvQ7kc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=StBKxDeR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jIYMZGNo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="StBKxDeR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jIYMZGNo"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1fjBr2240045
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ih8aiOXSxyRAVJpiWr1ShDgA8xOscoGGaV4GxkAfiio=; b=StBKxDeR5hArvpRN
	D5WL/pn/QO/7u8CWlyMw7qJYZpgvsvhkIHB6eTXiUySagNWzibyDwyUy9ebu49n5
	nJEg8aTS0Q0dsscnO2exEiiBm7/UVt63yb/uLY+zkcX2F6Eq7VNPgjD93tQU9XXc
	L5emFxap/oaC3GOULYhQBU/1y7/bvwWiwnRaykvhs5HciDqS/MijrWfqxieYAp5Z
	n74KDuV/E38NYdzFSAcbFgzbaxJKDNduKAtFoOELu0IzPlDihjEndDpg2G6bD1XF
	kJQxs4Ige5pgrKeTk/4jCwvcg6yVliXSF1YVpu44tSEQS6JYA4RkuSEBnyF0gFWX
	y6GAOg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fnsxs0n98-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:40:17 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84e4ef486c7so1743119b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785123616; x=1785728416; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ih8aiOXSxyRAVJpiWr1ShDgA8xOscoGGaV4GxkAfiio=;
        b=jIYMZGNo3QukyJm2RR2Aqk9wRmi+N/JXGmXXBF6RN3ZKwATuutToHEGk3TXqaPceMW
         /GnO/oxRWXe3f8xtLaoS41l6tdHocsN1Me2S3SbGG0ALUGOp6bR/7W+A99H+5ebt2wzD
         5swNBlhLs+yTc1BxBB5+gbTzmQoK8fkbrSOlfy2JFqWYaMib8L7efjes8fDf81ZcpfTW
         uveKwiWgw3Bn39ooq3faLq2dVuTjqvK4w7sSxUN4bFv58yLiiqIi75AiTYRPUJ3Or8em
         LVhZUZ95L6eIyjJPC/Ww39m5xCm20TJSao95+T9KmEf+xCEypCLoLAByXAwmKkPSgDwy
         m3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785123616; x=1785728416;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ih8aiOXSxyRAVJpiWr1ShDgA8xOscoGGaV4GxkAfiio=;
        b=LTHYv6qPlXTPK6QQZ9twpZm9gw4105n6vu4YvID7oTsUnc75KKj1G6QiQT0OUtkVVJ
         FwANYteokQPXGp/hrznsKXEazxQtktRJPJIfChfFQObsdKoAo+gSB1S81sFvlRoEnTKy
         UaoVjSs09zl0mfmfbsUD//6b8hup2mmQDBcn+ovrBs8t/1/P3bdmf5ZYguiTGBF1+9eV
         +xkT1hbbUaNr0G/v0tBbkNnN78bMdIcVxNhzlyqvmbgemznqwBLUbdUqYxffe7ckhBJ2
         0suhP14z/7fwFjF7tNc2AIFqgS3rmsMWEnNZq0e+ZJEO7H57Sl7ToRIn4JViq68x+jWJ
         SB2g==
X-Gm-Message-State: AOJu0YztWyyt48zOgPI9mafkRkGOEz0xVakaI83D0nzaKPXgFAB7JucU
	p+11q5up8zwNQyMDtRJwJX32VobR2pUqK2iNLoMlscj7/LkWko/QhCNP/1rd89QDshHFCpKGVWg
	6D9RP0Oe8JZ1rCWtYNDsCU76KsFQBp4soa+q9pFcWYcxPtV9ho3qQA6+zqMYduBKxU74zRw==
X-Gm-Gg: AR+sD13OEssW7ytXdY6xyn+5k/3K52as8vA9harVWmqEgKxfF7SgzhDVBaBNv9ocQis
	JIVj+bFEy4e2UPVDigvECpuLLNVzKqSIzhJJ4rLzj/QihVhF/+E1Pru+jtjsOzklrqhQZfmnu5G
	ROsKM8UcC4HLvnweNvUlXQeVTlw0NKM/tYvpiFf6sF8UrD/oXxDQcLAv7nceWA8JiBnQs4LoVvu
	gPDUMWGR8hr67aubCTSfUHz5ZKG+aY+sgMOo4TaD1TjRB/V29siX0NlAnCIfar0PBD1Dt7mS6KW
	nRO4oMJCOKmvtAMr4s8Z7BsggakEQ/61YNhmmvtzP+fWyf+5GCBOroa13OO8XJ6beR7OzerO9gq
	AVoKj5tPzvsSBtnjBYkDNJx/1y/aSAQY=
X-Received: by 2002:a05:6a00:6c82:b0:848:5417:c41 with SMTP id d2e1a72fcca58-84e59575a21mr4611983b3a.30.1785123616045;
        Sun, 26 Jul 2026 20:40:16 -0700 (PDT)
X-Received: by 2002:a05:6a00:6c82:b0:848:5417:c41 with SMTP id d2e1a72fcca58-84e59575a21mr4611961b3a.30.1785123615610;
        Sun, 26 Jul 2026 20:40:15 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e533d1637sm2332122b3a.33.2026.07.26.20.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 20:40:15 -0700 (PDT)
Message-ID: <84c2ed4d-bf0e-4359-8c1a-b7a55fabc564@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 11:40:12 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Use different RX release ring
 sizes as per memory profiles
To: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260721110459.2203038-1-pavankumar.nandeshwar@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260721110459.2203038-1-pavankumar.nandeshwar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDAzMiBTYWx0ZWRfX5l8lPx9aVqYM
 gNbD4QWVkX276bPdTNp7cPYf87b0qLa34aUmNZ+5J8qh3xIJQdecaAvYay/YmDZMSs0JJuZJo4i
 PE1oi8kalfTkAD/ThbhqHOhiYZ2E10cCqCHHPVOUxsPq0J/fCJSQO5LWNn4CejKqEgf8S7uiRhj
 Fzte70XV3Gqxu84eOHmoQcnZAmMScntA3UHz5/q16SWpUi+RErvxZJEaegUYhoATlTnLRF/RuN7
 maeTJBHsU3em7N6qVWHUWs7nIzQGsr913WHOMn+XUOl6b/F70xbX4uR50un2kR2WsbgqifwUiIf
 bgl0MbzQ0ueqvLkY3s86k9/h8JErOZvEFRekzpEiqgYPaQnFW4qBlhxbYhUP+QfciglykXFyPE9
 CSkTdG+yF6yLQaqvPN6gnXvzKa3VLZfBCRdWfmZtFH99MHqxgYy6UsGH8dPOgWIxHHCcfUx5r/B
 ICrdPAqNtX7cjvI25tw==
X-Authority-Analysis: v=2.4 cv=EYr4hvmC c=1 sm=1 tr=0 ts=6a66d321 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=32pKNZ-c1SNXjFBoJ0UA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: xSGCTBB_fk9QRhMQ9td3NoUQzWP5X24k
X-Proofpoint-GUID: xSGCTBB_fk9QRhMQ9td3NoUQzWP5X24k
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDAzMiBTYWx0ZWRfX6VsO72v4Vq8t
 8/E+ES3ZRC/lPY2WYidYPb6SXI3S2oFdCW/TQJP87BK4ei3L4cW7Q4qpv8f8kgTYCWjei7JN25w
 8h5PE5oX3Emt3+vd74jiuyvQjLZt8ak=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270032



On 7/21/2026 7:04 PM, Pavankumar Nandeshwar wrote:
> Currently, the RX release ring size is hardcoded to 1024 entries via
> DP_RX_RELEASE_RING_SIZE. This value was sufficient for older generations,
> but is not adequate for Wi-Fi 7 scenarios with higher aggregation,
> parallel processing, and increased likelihood of error bursts.
> 
> In Wi-Fi 7, a PPDU can carry up to 1024 MPDUs and each MPDU may contain
> multiple MSDUs. In error scenarios such as REO out-of-order (OOR) events,
> a large number of MSDUs can be pushed to the RX release ring in a short
> duration. With multiple PPDUs being processed in parallel (e.g. multi-core
> or MLO scenarios), this can lead to significant bursts of descriptors.
> 
> Field observations have shown frequent OOR conditions and back-pressure
> issues with smaller ring sizes. Increasing the RX release ring size helps
> absorb these bursts and avoids back-pressure in the RXDMA/REO pipeline.
> Without sufficient ring capacity (e.g. 16K), back-pressure was observed
> under stress conditions.
> 
> To address this, make the RX release ring size configurable per memory
> profile by adding rx_release_ring_size to ath12k_dp_profile_params:
> 
> - Default memory profile: 16384 entries
> - Low memory profile (512M): 8192 entries
> 
> The larger size in the default profile improves robustness under high
> traffic and error conditions by reducing the probability of ring overflow
> and pipeline stalls. The reduced size in the low memory profile balances
> memory usage while still providing sufficient headroom compared to the
> previous fixed value.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> 
> Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

