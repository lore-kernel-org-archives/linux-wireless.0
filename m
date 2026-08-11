Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8782B1DED4C
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 02:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415530; cv=none; b=IKAuaF5PRZ2jzs0i+P6pNB53axxK2PbYjptqjJizT5fuwEnjiT9gep3UQzHWSy4XL1oWtUjwiDuU/2wfLXIGC7EjHjuUrl8fgVxfPibIlTrSvXwveBgLizbhylhbVTz6zlQyyZdtTRm9ZpW8Qg2Z3rggf2IVAqS8o0nEt0HAdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415530; c=relaxed/simple;
	bh=MGToxY2eDxoM6n9czlVuDmQRwlhCvJ/pAfN2DdTuhA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o9kMnz8gBbvK/nCAT8cZ9cq9ivdcF8B2GwX1kxR+gyGYsVU5GoOUf2nePiutK4Ic0lJvewDRHijZ0Rj1ojIMPQObp4sbuv6dxY2vYdKXlSBaLtP3j1BHS2hjy9oGJ4ixPTLqphwUxlb1AtwzsDZg61rvANeXi3fI4w6KZGiQ4R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hwqGvKLX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bu2PwZML; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hwqGvKLX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bu2PwZML"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AMppZU3552892
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 02:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	C7bWfU9OcPL3SCb4TRXGcsCsHePl/fLg8SdLe4htIgc=; b=hwqGvKLX5Ord9dO9
	aA+WLQfBJgNa7NxXJILgQpxOv+PevzHAxiMt4y/SBLtlaM0Ad2+B0qT4SzPiEIXx
	mIeaDEE9HK6eS8Iqrd8cNtE5f0SRvz+2X3+Bu8XmBljoqV0a1Dph/Ubl3dT/d/Nc
	PgZXfY7xY4Qu74nxQKc1c+UWkklXbJcpE8ZwQwzlCdsZELU6r+DsH+BSfdqPhG8D
	Wg5f2H7wSFZpTobVoXWjaB4hqlLQ7/ea2dd52EKBxeqEQLV5u98JMBx70eT7ZW10
	pigRsD7A2Ok/9e+Ds+ILt099S/VDU6pX9vEmh58L50SUy6cFn1/WFOim0k2wTUvG
	DTfzpA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyqmk0muh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 02:32:08 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e6d253330so632211a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 19:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786415528; x=1787020328; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C7bWfU9OcPL3SCb4TRXGcsCsHePl/fLg8SdLe4htIgc=;
        b=bu2PwZML8nS3b9fWS2oeZW6X8NtGPHKBg9yBaAqIjkLSQ9YvLbeKWNhnV1hmpyu7ro
         oab4JlkhpPxW7u+41GbJB5Sni3GSFHbDeEIpiysU4fEhAGrI8MbeI3OyZ9HwBcYfnRCC
         gaZFB22039gRytYYX6sJQFWb8LSBXedtuvlRUO6XQr35BfK7BbTxVQTX19FqPS83/UjM
         Ts+I06p5mIxQi4Zbw6pu8SthJOQqcvjTRjcon3UvNT8Ut4WWtp19mG/7YBPBatYIe3RP
         NglS3RImSxR70rjDzSB5WeIQjcSlot/NNFCqPnMuhFTmAs6P67Q4vPfs6Ho2toquOQ5g
         BJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786415528; x=1787020328;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C7bWfU9OcPL3SCb4TRXGcsCsHePl/fLg8SdLe4htIgc=;
        b=JFZYiGq99m5uUgDtN6ORJ0vTGSA1zUoYct09pGBGkZWJsysFIGtZm6rarwBY+BWFX7
         1X0k2JNQc8UWjg+mtmwDg/WTTFc5KjQ1MLbfxbF8vss9sDTVaqpz36+17lm34pctwZ8H
         5KHCEBjST86GYgENAVhhQqKJ7LSiVa1OqExNFV8XgI3gzy6PhphjuhjsPaf6w6H7Rn/w
         XuqE+9zpBA7CBkvRNLYG6M1lWjIArYs0t0M1jy11CvKXaJp6mYMMRmgbCY13zd8Osxtr
         rTDG2FQsZfbH+9y+Bau6Gm0HroePP83NAkjowkqIV9qAH1D1Mss5ayBAY99iyTCeO+TG
         BT3w==
X-Forwarded-Encrypted: i=1; AHgh+RqBssK2r40OjjobVPGjCVrBp8nlwrztJQzfc/oKW0PhUSh/PABoUZ5VsiZFW2zfv8eNPswAHa+sQf3u9e5o3w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzp+zuDnojNakD1q1/6zcHm/O7LkChhrOc/wJPkza1hFWM5Sjg
	666gvK9eBOlX9nln3Boo9Lpr+EpBqSz9r91MvnPWUAtgqSgFh1sk7mPcjvln8JNRUoXpcjS9ioM
	S0/SD2qVMLIg401txgk8jMWCvO3XcpH7W5xgxxL2FrZjTqsF7rI8mWMrVPF2OlsOikwZyTnOg26
	Rb6gf3
X-Gm-Gg: AR+sD122XGGWwlci9728isplbSFUmcLGvKPi+dEAodb04MeHg/E1dAVrvSp6/ZeRSXE
	p3HdtidQyRiw4ZyQqVeOZN1y6nBdpE97Tb+PmQLanspsF1MHfI6/lEgQ6HxORiYD4hfco23zU79
	Dw8nBOBm09G/uuBskJ/cNqf3hoxqS81O3k6ERqlFdbu7lL0YKq02JWQLR+bxDdSWNQL254QphTb
	JkDdFDIZ2kUGf497Pc9d0k9snuriuOnhLOD2CVFFTJ7xPaQ3Nlqu3B6NDzFdio1OccMWp3TnGQ1
	Afk5IUNmqExGrs0xdAZe7wlSA4fIasP6X4SW4drBPABCTmgMFklhc/l+UZTc0HYvfznqqxCOc9x
	A0/su7ZGAjsu+hGIS2QwDDvFe8guH0vUOusQxeCuTpbcxXKoe9LD4Ul2lyXmLdvEmJBmmyyYb
X-Received: by 2002:a17:90b:1d10:b0:38e:c232:9d2c with SMTP id 98e67ed59e1d1-392d611213fmr857761a91.2.1786415528066;
        Mon, 10 Aug 2026 19:32:08 -0700 (PDT)
X-Received: by 2002:a17:90b:1d10:b0:38e:c232:9d2c with SMTP id 98e67ed59e1d1-392d611213fmr857741a91.2.1786415527554;
        Mon, 10 Aug 2026 19:32:07 -0700 (PDT)
Received: from [10.133.33.43] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d51be07dsm1581789a91.6.2026.08.10.19.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 19:32:07 -0700 (PDT)
Message-ID: <73f642ac-6be7-4287-89d6-d6afd9655efa@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 10:32:04 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: clear dangling channel pointers on error
 paths
To: Linkai Gong <gonglinkai@kylinos.cn>, jjohnson@kernel.org
Cc: vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260811020523.387433-1-gonglinkai@kylinos.cn>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260811020523.387433-1-gonglinkai@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDAxOCBTYWx0ZWRfX4Hv5nRtyjUXs
 ubZ4QlAdhSVn5MN7tFPQvEPtf/vLL/8jucZvOk7QlKGjfLS0G5S99W9GdUWAbLtQJxoG7EtsirI
 YuwIZmZYbLmPUoGtbg9/czO/lbEL4HiF/c6MuE5UMlGaJv5SrJEeXyFmbazomDxcBgTV4LAOy5R
 Z2IbP4LD+mjsF3ScwiXZ/vgc80vDbZgQV2IpL+eFcvj1Gecm9OXf2eGSpLjsFDhh0t+TevqAq4v
 PvyHz03Cy18AJFPA9hnxP04OogY6XzNc+sLK553Zi9syrHQKOhympvVsUPvp0HlBsC7pbt0MwB4
 kzJ3y6juJWSS2YV3W3FC+HrncGLH9gt2vKb0+rbFucG/Xt1cjQfh3mtSbctwylGMAbPJzo40GMS
 yN8ndujrSDlg4YIE3UyKWlIfl9cfGBAsxKNo14TtuPNDWk+vbV/kmZSUrhynHdMRKVLNcf1HRjy
 3qjEJJuhiOGmMdtTUlQ==
X-Authority-Analysis: v=2.4 cv=O4YJeh9W c=1 sm=1 tr=0 ts=6a7a89a8 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=CpnD9HFvDKrr3bQfTTUA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDAxOCBTYWx0ZWRfX/Di4QvfQFr2y
 KAVPG5LNadXEO7yhBrdTXmJn6FIZmYbLnASvs7uiznIw6bxx0+txTUydMqQ3lItnlZb0qUsQRGN
 ngh3/iRwNYTLdfDUeMMkge092B1/HUg=
X-Proofpoint-GUID: 7RWZMaa-eW38OXcW7Ar4C82cp-dCfs1x
X-Proofpoint-ORIG-GUID: 7RWZMaa-eW38OXcW7Ar4C82cp-dCfs1x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608110018



On 8/11/2026 10:05 AM, Linkai Gong wrote:
> On failure, ath12k_mac_setup_channels_rates() frees band channel
> arrays but leaves the pointers set, or clears the wrong band after a
> copy-paste typo (6 GHz free paired with a 2 GHz NULL). Clear the
> matching sbands[].channels pointer after each kfree().
> 
> Compile tested only.
> 
> Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
