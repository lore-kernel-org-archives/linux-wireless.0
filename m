Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792723398;
	b=La2qZwOl7iTCUNJ6yDH6V27JwyFRtew3rIT8zD8EZ6XIdcKbSaWrAnULl/JiCLz3Rih1
	 PbQ39vAsYZizrliPY7zcKBvT84s5bnAehxAuhascJhAO6Y5LKIMuoD4mjQGWjtdepYcBA
	 +jnVfoJdlNsmY3BU3Ou5H7bJs4fx/6tShwolmQ0f/7YOS2qdc6fbUulzQgS1mE8sfJStR
	 9+G/Ek9anVXw+EqEqmHCjh2EXap36LevhnOxg9MOCqtg/SGpDThU8P8x3K59HtS/nRFYX
	 bA5FeshgUbCRdXBceIjmzQCX/MrS414sO7Rj55lT+/PEdl3QsCy1ynNOoZ7yzndXKQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792723398;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=t3/8p3pFjwueYne/Fh+jqF50g48cn2FBQc5K0PETrMw=;
	b=3A/IwsK1MeEr0u52Az3PQqfJNEeE+uoF6QfNuJ39OgrYgaYTIy2lb39ecN3WjM5yR28O
	 0PoGg2b4FTJ0mrd1e1JyKEM9suWe9PugwX5LhDQazhXwhwExH/veuKeW5plyAl83a0+Ht
	 KWZZq9iQbMqDrBG1yICAMbT0JujpMOH0AeVN5s2sKj/S8+ilEYcZgX5YGxLnXkBHIU+/h
	 IamCffU42OZqCas/VRtQ9xK+aAiCNF4/xCWicMfdbnSd23wC/iQlyXOLRk8JOqkG7gAJj
	 Lm06XbWTVs06lzyYSzTolx2A9SwbuZWrmfM1n2F43RAzTEfFZOrmQvCV5Ps/V2KcmsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Te9rgS+b;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J3vq+TMe;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B18F606A319
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:43:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B18F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Te9rgS+b;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J3vq+TMe
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1Ev7T2376102
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=t3/8p3pFjwueYne/Fh+jqF50
	g48cn2FBQc5K0PETrMw=; b=Te9rgS+bv2msXXO/5wYw5VMGaXSbyCBYxYwRNEYX
	LwHCITC9h8OsKfLinfrSSqDOPiM3prbubXt+YUPvYcpl3BDt2GP+WuBVeoQVDByq
	28inHfeyJ32OunSJFdrIR2qyTaOGifx6pepv15QtegFY8t1ocKR6BBSlYEecWbEs
	z+BbZXSys+ZNbyZh9p+i5ehE+tr3tzuIxv2XOz7cR+iUByTWBN4b8n8Asb5sW8d5
	NVmEiph/se58xaYRFZiR8zz3VrSX6uwwBIcKtyqKOVYn+NUvaL3Hg/2x6SVEAND/
	wUlfjy5RrQPmsr/j5/IkAwO58ZUXS2kTLF3k7FKZrYhyeA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmr9ghr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:43:17 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35cbea41088so605930eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792723397; x=1793328197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t3/8p3pFjwueYne/Fh+jqF50g48cn2FBQc5K0PETrMw=;
        b=J3vq+TMevafEBwT/jEk6H7RPuCFGhsxwYahCP/X+rucBEP/vaHRqCuh8A0j9AlTIQZ
         XUPz8HU8bvu54z+3uoSDCT4E7CSaxomQ9UGUp/Vz9uQeSouD15bSw0BcAavnOYOWp3XW
         3eLCnzFa9Q7KIYW93eiVwLUNhSR47F8ZSXeGZbsAknMsRad9jqFkcnt1OFp5JYRMsLbB
         +9mJq8hLQUCHPdjJTIiQXpvnRWy9Yx4ek1b7IGv6/Z2Sg+WHtbUdo9YMpjNeILO38fzL
         0joHR5GR4368asDgBnOBVXnUMcFJ4uNEYriUhGB9psLSDXuyxwwvEdPlHSsRuR7SdCrE
         aM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792723397; x=1793328197;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t3/8p3pFjwueYne/Fh+jqF50g48cn2FBQc5K0PETrMw=;
        b=bBKQAuiwb8Sl9iOm+/imZTGpYM9bWuNKqD+vigJzTICzAR7jModLWmjPMuXYYyuNB8
         3CuIDn/ogH4xhJet9VeAPB/TwdPBJxRg7h0e7QhoNxdTQp0z2zPiEI7xlp+vQRRT8dKn
         yS6t8/UvlD8w98IyZo3AlsnVkBphCKD3iBeFJBwcs/xSwkzV6rO3knbbrT4NNpP6qpoH
         MCV45huw0PnckTgz2GBRGXYIEM7UEHRndQqLMxGGSx8aK31PEavRAcWM2BcOvYCI+0cY
         swzFzSRQITDeblvQm5VBaU7x77+N64bTYOXQXoVIH7/CqBSLazhGUgZ1PTY3HiSrcnYt
         4H0w==
X-Forwarded-Encrypted: i=1; AKwUvBzr4kFcb5vpdBwbLtMVIzJcWC//mMC2vEsE4cXYuLFJF+ptHqmm1atITe3NRThFLPoF0vEteDppMbUuIt102Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKGsf3cHS9prc96nvZdStPDbbJ3O/YMiwWiZTOwUVljFpJsf+Pd
	bVos6tVdZPEBLCdAtYhOcoC07dTuKUCtOquVPyV7dSF8RHnVAoHLB5OQFLuGXg7FLtgfVxRg3ZO
	Xv7G9G+gIf0WxPX/9H3IzM8tbWF9uIFVjQijtKVl6qGjCRmUVJXEfvYmu2DQ2q0a3Z39maQ==
X-Gm-Gg: AYBFou1214YOnj1asOy3/mk7Xk/QFGkVyrLKlICqWyKjPeS6USZC27yZyypp5Q7ffrq
	68Bhf+H6WKbpByN7pX/jMmnVRrQX5/q4DhV8fGzGiuoOTBktJpl3WNcSWgklowKj9qq5b0QPdB1
	SDwH9Ien7bfj17OUjhGS3ce5ZUFi1PHOZ8C8oil9U9xdxQQKV3gyZmEhm1vesTlOrSzM4WEA2sz
	PoFDDhgaC1y2SA3RI321+2/1m+LaRtO9BxIcvj0vXEOwNVTUc7AlxuY6U7FT8L3pFjOg8tiWW/M
	Czm4LmkcsnSm0exjUf6vvYrVivbbzvaTzIgCSDt3+PejJ3UX8DTv0hvB7rYTdPXcsFKPAqzwytf
	Pk+KfABr7ZrTkiwFVtDvQDF+xMzaZJCvB4gmDH8B2zg==
X-Received: by 2002:a05:7300:f48b:b0:356:23dd:3c72 with SMTP id 5a478bee46e88-369d964640dmr1148550eec.4.1792723396650;
        Thu, 22 Oct 2026 19:43:16 -0700 (PDT)
X-Received: by 2002:a05:7300:f48b:b0:356:23dd:3c72 with SMTP id 5a478bee46e88-369d964640dmr1148517eec.4.1792723395966;
        Thu, 22 Oct 2026 19:43:15 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9d5e9edsm2090503eec.9.2026.10.22.19.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 19:43:15 -0700 (PDT)
Date: Fri, 23 Oct 2026 10:43:11 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
Message-ID: <atrJv0wgF20tmuDr@QCOM-aGQu4IUr3Y>
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
 <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
 <cbfa35c9-cfa5-4eb5-a203-09c9069e3b0b@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbfa35c9-cfa5-4eb5-a203-09c9069e3b0b@oss.qualcomm.com>
X-Proofpoint-GUID: Z1smH5NT_OvcE8o0yoPVIl65cdXrZt4A
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAxMCBTYWx0ZWRfX33QwfqZfYi+t
 EZqoWbHrDjpISeb1JmDRRu/Rxmq9W8hqNcWVC+wBwQ8RvsjJ4x6yFI3+LeEFFGEjgF0TyJdmyEY
 GPkiZjr+JmdPUEzWnR5xpkkEap3VfTI=
X-Authority-Analysis: v=2.4 cv=VNZIDNPX c=1 sm=1 tr=0 ts=6adac9c5 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=0oYm2DgIxsn4U9MLWVAA:9 a=CjuIK1q_8ugA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAxMCBTYWx0ZWRfXxb5NkEhhp4nw
 PXM2u/uXNF7wxNsGeG2NxiD5t0nTFNu33FHdgkeZCMGHkJl3IpK6keNXgU7A8sFIxa61R8192sZ
 1vL0ysCNr3xgPRG0O45NC3LQ5eIUztFCFtpwMBTSLVDjdK6RufGqhZcYavjcPxBoeG9537xeJsx
 FOWX1qE93Pa0WcxaY9CwD0D9pwvPQaW8+eqPLJrdbddNH1Jyh20W2x+0Ezc3mGRnVDAazIDdEK6
 9lKhmqLLIVNcNCQqXidoyBAhKO1pAK8XrcxMgNVuKsKFTk/S+4jELvUGWelREvjwCjdKROmj6DU
 Psgc7d+nrWm7Jj87CEun8KMyZyke0M5Tr+7DAoMSDwjrnAnFVsT6uYHCvgu53mzaNBKZhHpkQAs
 ihEOKPKSMVKNpGUnUVMfNv3kBOvKb72s27vOQcko/jSv5jMw96jkKDMu3tSVFZTrpHaHhKzan35
 cX8jDm/6FfW/xj9ceZg==
X-Proofpoint-ORIG-GUID: Z1smH5NT_OvcE8o0yoPVIl65cdXrZt4A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230010

On Fri, Oct 23, 2026 at 10:13:18AM +0800, Baochen Qiang wrote:
> On 10/22/2026 9:44 PM, Shawn Guo wrote:

[...]

> > I bisected drivers/net/wireless/ath/ath12k between v7.3 (broken) and
> > the ath tag (working). It lands on:
> > 
> >   15f7603b69a8 ("wifi: ath12k: Increase RXDMA buffer ring size for default memory profile")
> > 
> > The previous commit, 643f0bf93617, still has 4096 entries and is broken.
> > 15f7603b69a8 changes one line, .rxdma_buf_ring_size from 4096 to 8192,
> > and works.
> 
> thanks for sharing this. I can repro it using the 481 firmware once get 15f7603b69a8 reverted.

Thanks for confirming!

> so the rule here seems that rxdma_buf_ring_size must be at least twice as large as
> DP_RX_MAC_BUF_RING_SIZE (I also tries four times large, it works). This rule looks
> reasonable to me, since WCN7850 get twos HW MACs and its firmware setups rx_mac_buf ring
> for each, and each ring fills itself using the buffers all from the single RXDMA buffer ring.
> 
> maybe I should submit a patch mandate this rule.

I'm more concerned about how we would fix the regression for 7.3.x stable
kernel.

Shawn
