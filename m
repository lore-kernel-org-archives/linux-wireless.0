Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792727074;
	b=B0Uhe2XBHaIArGl/zaTFGkljrvOFXzwGKn6wjw7WXkYuoiW+JK6YYlAbELsB1erBKc56
	 elULnfLl5HsmUB78IgSZaBMAuRWkr8/qJUTIx+f3d23pgufZgSVFWADhbclOzzVHCqj5n
	 QToeKTJAyv49ZbvuWu+g5mc73ZomrxovL1dufP3V655mSlDyaWN281ZJjQfnbI2TUjG5j
	 9Q7lRfFaDHKLsP2i2xPxH4OdFSH5XlJXaO1uTMpjHavGehGZwGScw2cPTP3ifePfK03O4
	 G8K11OZcqBkxvq4K0A2WXe6cK+CV5kKliURCdEkgzpCEDJ7J/abCDqa0V69fAcko7Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792727074;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=rDVviVjGMtt9TG+XFk050wccC2aDhnzCOMB4PFkLb+o=;
	b=CCy+Iqbuu5SfKDX9BW1XWaX2nA5byQLLKdgPSbI/6tA+OPubsKVU5N5hGuaS4elQBs1j
	 x5/jBVDmiHuV1DmgLRNaEa1oATb5nZJuRKtJ3ZyfUmYL26BHGoWvjvscS9+JdprDdjPin
	 +B6OkGQSLmGAwq22avZPf0nLpLtN99F1XcgKyjMiSqWL2pgeOzhk95vR8gJDXunXz/Jd/
	 fRb6jHGdiB9V7KkyL7i4rpNuN+Zsz5RkIYmMO2SijlUEapUD+xS6fAErXWMbnD0+ijZ+3
	 jxCR1hL8kYcPo3nA9v9pItSejNgyLb+Y0ULBOz5kCtKMDAa8lDyIcsS3ThAD8QZN97g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HGR+K0Y6;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ia9isg9E;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00CD606A319
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 03:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A00CD606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HGR+K0Y6;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ia9isg9E
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1Fm254008255
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 03:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=rDVviVjGMtt9TG+XFk050wcc
	C2aDhnzCOMB4PFkLb+o=; b=HGR+K0Y6hv3tjU6JGy4GJhJ8z6ziq+8BQ4wCfSCn
	HmBc4nsKBrcYy2JHafV2oyTldGFfivc507qHTGq68kw5pIK+/pl1b1IPb4o8aYAo
	NvpCb++xRkwLgbxlXdJT7+sLLMpGAV7gDrhs8GFY0cmX6lbwlp3GqsdX9BDS7UYT
	Ih7dsrR6GiXgzBAKpZfb95YDy/Xnn7ZO7J23gUnA/KhjYpKy6jtN/Zp3wM/1fzMM
	59+yLsOR5Q1VnH100zc7UvVg9lFuSUjCIIRExcpDxqMcGtzhMt3o2Oz8pIJvlvL6
	gXsXRxpPxPKc0R+QTndiT2RIWSDv8L+Fu7KbOapxIXtn1Q==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsmas7g1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 03:44:32 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-359b81ad4e8so634816eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 20:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792727072; x=1793331872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rDVviVjGMtt9TG+XFk050wccC2aDhnzCOMB4PFkLb+o=;
        b=ia9isg9EOEG8SvBP8Xcu9KUkCM04oWNwkWKfmv9x+C84B41XkLrAj80hXt18VnpaLY
         mVYb3jOfoj8FMYteHL/O0nNBFEhPJrPIdd8nHpaFb/u/ujW7t7kyucAuOUbkA0nG9aKB
         QdlDpk985jmsNIOM4iSqyMXl16lmQQmIZqgL9bzWHYzjy9nokKHJjD6YJkZff4HUVydW
         VXZ/ERsFNLkM1gffr8zPLQT0CJrmInz9QKtTvQic+x1ul+HykIW3d3Hkh8DpYGxKE/oa
         +/K6IIbr9+uBex2iEiIcrqyQJYN0/tg11zsz5dAC+XYIPHPE+WwNLN/aN9vrnJ3JjBK+
         bCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792727072; x=1793331872;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rDVviVjGMtt9TG+XFk050wccC2aDhnzCOMB4PFkLb+o=;
        b=va43KnmQFvHttF0gWuRWtuEdqiWSEAd4cqXRXM1m4QIH+/MsMrvE5n/4S89jb/tGSn
         8/Iw7CPCEEx7v4ZotaUp/VfQrr0pnwzjz1H5CLeguFLyF+48aLprOcKKt6Dh6HgRY5yb
         Yuo8QC82HTOSJmIvsQw3uFiy7aFa3/vTgiIlWdNKxUqwi+VX5Ur2aA2J7gri6yhnFSkT
         SEk8Iq38IdSjMFvinCNtbzRvctbHfn8sdOw12zVmITkE9GbT5/vnC8YlggacKLyHYLdl
         60FQLlTL6jbJ5cLUSA5hk25ZTlhEynIqjxCcOJsvIfd3D6HAd2BF/HUFw+QU0WIE8A1H
         dFwA==
X-Forwarded-Encrypted: i=1; AKwUvBx/RdEyXwAyll2Bo637+z9upGGtDfVHTtAyeojMuC2EG1/JlyVhaLnhJQ6La+XuvDwnGklArjlrplDFS4mNig==@vger.kernel.org
X-Gm-Message-State: AFq9FYKsSW52CuuyncUrriK2RxvDNo/sqjWNjicMZkILiuSDCtEBxA7c
	WTo5uIninuqaiRplWtvIYArLhAgOVNbg5YQlnPZfo4wjaiz+BQmag7wV3Ld66Qpf3Ua17Zxg4vf
	xP/GT7LXimxY3Qee6UkpuWrkZhicDImpRNieFZ29eAY2IEzNHEXNxwG/0xWRBObkbhZevjw==
X-Gm-Gg: AYBFou3UeZ55gdurDXCMatzYhCwsqAWvgeD0KszMOTrFpfUjJ39pei390UDPgAwEJ+6
	GPRiAQdiyVwA5aPAw2kIJoXl2hf5LRQ5tJAm1kB43R48TCxTl1rymOyG05+9It8Lwk/QGgtl9xA
	9AR8Q712XBujVHGKlSre+giVuRpplx4y+UHsra2mA3mQgMbZljBIFC3BJPk5+G3Aijsss7UElQm
	ppKY11tRDEIlAiuaK6SrnSBYn1ZfpS2coP3gwWP1JBZHEjy4LAwHHyfO+uxRjXBu+JK+pqM/pgl
	OZGPqCgvoqi4Yn93Pv51IvQW3m+gf2ytjrWKNUTwiGVyIgnOjxIZ1b0tsAnBm15ca0dMgdKMDCr
	c4akzTdYziWBlTeyicwoBaGXKjm1A3HxFOV05DcmNQw==
X-Received: by 2002:a05:693c:8804:20b0:353:7d17:9a86 with SMTP id 5a478bee46e88-369d9872726mr1282481eec.26.1792727071857;
        Thu, 22 Oct 2026 20:44:31 -0700 (PDT)
X-Received: by 2002:a05:693c:8804:20b0:353:7d17:9a86 with SMTP id 5a478bee46e88-369d9872726mr1282459eec.26.1792727071304;
        Thu, 22 Oct 2026 20:44:31 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9e10b5fsm2708799eec.27.2026.10.22.20.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 20:44:30 -0700 (PDT)
Date: Fri, 23 Oct 2026 11:44:26 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
Message-ID: <atrYGgGWB_zQIrc1@QCOM-aGQu4IUr3Y>
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
 <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
 <cbfa35c9-cfa5-4eb5-a203-09c9069e3b0b@oss.qualcomm.com>
 <atrJv0wgF20tmuDr@QCOM-aGQu4IUr3Y>
 <38fc5a6d-c019-43bb-98f6-ba6a667c64e1@oss.qualcomm.com>
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
In-Reply-To: <38fc5a6d-c019-43bb-98f6-ba6a667c64e1@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=V7LoQuni c=1 sm=1 tr=0 ts=6adad820 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=0oYm2DgIxsn4U9MLWVAA:9 a=CjuIK1q_8ugA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAxNCBTYWx0ZWRfX+QrlHz0YFASy
 x3FCsqDw0J/07obABhIMMM+Ff1fHIKd6ZArH4PZi+90tkJ8xFQKZEckfVmIQh7kTKc0TNuBI+vi
 ++ZHSptzw8roVM9bSgNCszg0HJRLIno=
X-Proofpoint-GUID: 43-RV2i5fLze0pNDE1KUJUIoNED_LVss
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAxNCBTYWx0ZWRfXy0ItzjbWmQcb
 lwQstRKJ/NW5ec36KPgSzgWwZh+96Hf0kQmDQDoX7TS/YrHmVKapXEBCOR7CZrb+Zm4aPQAIw75
 3CFvJ+WHr9adbvxLTnqebR9X4tMTBqlVIUZVeBdQjG/67XqPwiBvCS3P8eznZknW64cz525KaBA
 urmdMZpQEyps9nGnATd9b9KosGFNbNegD66S+3dIxcsChFhA9mc7+iXwRRz23+j73tZx3XT3Sw/
 csZqeA+S7gZvA64cnkLzBj/n4ku39gNAw6htObyothflzJ7bcspfL6L1Of6BhyxMLgBxdzbtpNU
 pGMReT5+YX3dcudWQKNeQ1Taipxr32b2LowZXv2GrhQCWnK4O/fmfugImMo7YYQIfJPEdB8dnkO
 +FyxMODzr6+gJbbPdk1LfkoVCyJKtx3ODATIjkrs1CZ4LSV7SyYPJ2HjDyzosyFl8pfu7Y95BMd
 PnAE8M8ylHTU9vt6pHQ==
X-Proofpoint-ORIG-GUID: 43-RV2i5fLze0pNDE1KUJUIoNED_LVss
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230014

+ Jeff

On Fri, Oct 23, 2026 at 11:13:56AM +0800, Baochen Qiang wrote:
> 
> 
> On 10/23/2026 10:43 AM, Shawn Guo wrote:
> > On Fri, Oct 23, 2026 at 10:13:18AM +0800, Baochen Qiang wrote:
> >> On 10/22/2026 9:44 PM, Shawn Guo wrote:
> > 
> > [...]
> > 
> >>> I bisected drivers/net/wireless/ath/ath12k between v7.3 (broken) and
> >>> the ath tag (working). It lands on:
> >>>
> >>>   15f7603b69a8 ("wifi: ath12k: Increase RXDMA buffer ring size for default memory profile")
> >>>
> >>> The previous commit, 643f0bf93617, still has 4096 entries and is broken.
> >>> 15f7603b69a8 changes one line, .rxdma_buf_ring_size from 4096 to 8192,
> >>> and works.
> >>
> >> thanks for sharing this. I can repro it using the 481 firmware once get 15f7603b69a8 reverted.
> > 
> > Thanks for confirming!
> > 
> >> so the rule here seems that rxdma_buf_ring_size must be at least twice as large as
> >> DP_RX_MAC_BUF_RING_SIZE (I also tries four times large, it works). This rule looks
> >> reasonable to me, since WCN7850 get twos HW MACs and its firmware setups rx_mac_buf ring
> >> for each, and each ring fills itself using the buffers all from the single RXDMA buffer ring.
> >>
> >> maybe I should submit a patch mandate this rule.
> > 
> > I'm more concerned about how we would fix the regression for 7.3.x stable
> > kernel.
> 
> we can try to ask stable team to backport 15f7603b69a8 ?

Ok, I can do the backport after the commit lands mainline, assuming it's
part of Jeff's PR for 7.4 merge window.

Shawn
