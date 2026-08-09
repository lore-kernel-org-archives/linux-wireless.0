Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719243A0B36
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 23:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786318191; cv=none; b=mMQjmBdVG9X7mWKER6hxMW2vik+o47j959+pPDVDkph78ZVOpTELHGSJ0unIwZVUR9RhBFesOFSRZGtAqKZayGKrNd81FSe1OsnVo8f1anBPe3tze8iu+lGPgVE0eulend857qMisC5pMDHIKMG3c9eIOQXYDchuFkHqe73JhaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786318191; c=relaxed/simple;
	bh=aUj1lByzsONwBfHgwAtCXtMsLCyAJlVeRezvGRX3/+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVtvPZz//hj+0RIIn8uJH0VXxDj+HRcMfBdwgcv1vx1+6izw3emntILYdd1YeLLXrhAcZOnMV9WXT7HQF7ZEQtCoZW9qjodN9v5eUKtK/Z5n2NuvHvdASLUR65pDR85l7VzhVahU7dnmoqb9K75utAhxxyNoEdv385xIQTVhoR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pg3axF+H; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dKqyFP0r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pg3axF+H";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dKqyFP0r"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679LEC2m761149
	for <linux-wireless@vger.kernel.org>; Sun, 9 Aug 2026 23:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=MgifLTeWoPs7xR+NoGmw3cPD
	yJjBTZUCzAC0a9BDorI=; b=pg3axF+Hfg/EcnBJkRW7KwIiDyxAwk8LUfQjgKPP
	egMjGONOwsURlCbnafIb1A3SLZMngJxWpEly9lvrnFWRQwtAL02CDxQLDYETMmu0
	2LCKQrg8s+wq/+P6pDGQv7D8fGhk6/+IpgJm/omRqFID4jq9UKrHh2Scz+cvXfkn
	hlYjVdJ1yofirNpuz5DcNfekL5ICEe8AZ1uNsNgpTQbjNpw3jGvkxh+7ns2FAAGj
	aFBdQd8ph+Xa3niJiw8IlWlBrbXJOh+c1iKvkuXyMZIMwHeeXwxCOBg8WhkfTbYM
	ikXaJpf06Nx3MuZLuKzeWbPaROmi/XBUpLDjQzthBonGVw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy19kg5c2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 23:29:48 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51a8db414c7so19767081cf.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 16:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786318187; x=1786922987; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MgifLTeWoPs7xR+NoGmw3cPDyJjBTZUCzAC0a9BDorI=;
        b=dKqyFP0rcIXDhxdhanXo9c/iaQ/c6mucyg+cX/+Xj7YzL+p3KABKexvzI7+eY55OTf
         L8r8pxMBKQdwSBgcAtm2tygoFlN3VODxX09IqXydL9gqpq/Fi3Y+MbIEpfNDVdWSSdvy
         gcEDS5ysct6JRnTi5+Ngvw13dkO1OrUHFdApobo8A20QYl089o7eKlxwfUZDbrrjJacr
         aeEQpb8MkQGyDw5YlQR3pQepAb3pkggn6QvbRsdUVQ3tGSjpiy9O/fex9mjy7gs8ws8V
         5MGIpEYaTZbgR95FIVVxItbiVXTE9E1CQysTSCqUKbADkCBitvFSGM6IL2/iZAN0ynAu
         d1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786318187; x=1786922987;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MgifLTeWoPs7xR+NoGmw3cPDyJjBTZUCzAC0a9BDorI=;
        b=CU461Z3LaDFob+ELvGsaYvni5rdOkbZxT31z8iMVcjm7lIS/D+BPoNx4/F3E31fJsB
         eN5PlH8GdfcOBw3Ug2cZRbT9OSr8N2BO7yDDqUS0BZo/HBgTWg0TX5IQD31Lx9Kq6e70
         i2TD6AnOcmGNWypPoJwYcNElCK5NUwd5G/LK7I7qEzpQV9YOUZCxflDLv3EpPBVCzbS4
         MqU+dK9cDGT1lYbpoXStLyk3AYsAKISULaN2KBbQsD37X73Ullx6K414x4XMykQORiFd
         IXBBQxkTLu03Wzr26G/6e7n3DqPY0IFFwMF57wgv+yBGpa4QkV7QkWKCyXQkr5UMfLUi
         EGwQ==
X-Forwarded-Encrypted: i=1; AHgh+RoCAcdYYDb3fFPVhL/pYrU2tIllfTqWwaCOwfgLWcPiRQqny4lTaF+6S5tw/QmqM7QIXrilp1zvYBz4Gk446w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUv59nL83fzAvCwUaNNe5jPeU+AFXAfMHOicFO8xYeLJCk/cRy
	gUzQwtCM4zaj7FDXqeufnzVPfJI5U0AeXIoVymmxsozoOqAsZV5r3WFX0mhYcJ+IpTbqIIaS8P6
	fnysp/TxfLz8onZvkGuRX5Az09QOmWts8EuMrP5EMMDXim8aiMamE7QxXys6bZvAyoZO8vQ==
X-Gm-Gg: AR+sD12Njv8/T6DfdYPpI6xm1TvBwMHoxNBOMTd3yTYr7aRIgF8XidMiEvtFkyVXFX7
	zB3j7G++rGDEE3Djgom+f8Sxao6e0zRmG+lVVQFbEJTlbEj6nvtQdL8Y+hoG6gl1si0BM6ZhLO0
	D/5yD290EB5FqNFAizFVjd66USDX3a22S0wPk+IqLJTDG4qLz3alA1x+nVEgcmu1upi7HIo8XEc
	HLhwJNsoc8fTnV5QxQb1AtfjFQsVy+c07AvYQ07wp5Vh0rYnAwEZZWrPKc5JyaSpN3olemKt+R8
	hZjAE7KjsSeBX6RnzQ+cPKzDR7+ZdLf2QY6gE72MymO2iCaTX4AvWdanoLshptEDCWdiX1I136h
	Pnk8xyBj1Zb2BFRv7XYoG6Qx3C+r2g5JvIXKpbJ5/ZQ47Ow4DUxBRE14ayB+GLf99B9x+hll1yP
	LGr8IYLXCzYMY26w==
X-Received: by 2002:a05:622a:451:b0:51c:1006:a024 with SMTP id d75a77b69052e-52d20a9abe2mr180714031cf.43.1786318187224;
        Sun, 09 Aug 2026 16:29:47 -0700 (PDT)
X-Received: by 2002:a05:622a:451:b0:51c:1006:a024 with SMTP id d75a77b69052e-52d20a9abe2mr180713581cf.43.1786318186682;
        Sun, 09 Aug 2026 16:29:46 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b3050d011asm1631111e87.32.2026.08.09.16.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 16:29:44 -0700 (PDT)
Date: Mon, 10 Aug 2026 02:29:42 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20260809
Message-ID: <fj7srjlprwhlbgjkk42uafcjysulte5lbw342tnultbhyijx4x@yxsgw6awrsnw>
References: <8476e576-04aa-4fd6-bde6-e34c918ff28c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8476e576-04aa-4fd6-bde6-e34c918ff28c@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: pj0NvWhohSJP1bgvpDCI8yCwZrKJ-rP4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA5MDIxMiBTYWx0ZWRfX7X1fK+PgGCq+
 KxzIgTdSLtJNVX69XytwkdsARSDFw/xIYdFRxISOHzMPnXozyksLkIENOlp7KoPGzq5oqt+FjDp
 nwTpzKAf6JOnIuGgPkwG/cSCjVFr8EOJU0fUNX94eBky06wVUsLLMohsYgSwg74Wx1I0sVs9iS8
 LvXpZ1pcZCSzlr1ZS3mqK7B4u14wdu1zhaLpgMML4Zq547uIqnivuieKwcFleA6RqSUUrz7KXNR
 wfIqlSNYIdiJghN/V8pVqRnJRGR1zx0EVLqyXjBlDVHXFv4RqyCR/Zy7MYZp+S0zTxFJswfAUov
 yQJ0qh+7SWVcegvXW+Hfs71qKIadAQEzM7vY3u2gmlnZpxUQ7EkucooN6+Wr40u/6zexAJTzyIz
 poVvJIeG38ANhCHfnsWzGDGzF84tQyGtbTymexHnIrLRnNGhImYMzde9cFWirPdaH5D842CPz7s
 ZAPMq/+1+gzE31TxsGQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA5MDIxMiBTYWx0ZWRfX2r6y+UtLxDTA
 VKORQtcSlH9fYzoeeO2tbMgH5y2LfGUDUuQ8G6jGBYFzwh4rAXR+Y3dxQnfBmRDtZGTbU9KZrjs
 S7N4ARFQ1VH4BIfG4hBFqgibyDabeQw=
X-Proofpoint-GUID: pj0NvWhohSJP1bgvpDCI8yCwZrKJ-rP4
X-Authority-Analysis: v=2.4 cv=abxRWxot c=1 sm=1 tr=0 ts=6a790d6c cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=p0WdMEafAAAA:8
 a=Cll3ooqCA_IsHNaTrZ8A:9 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608090212

On Sun, Aug 09, 2026 at 09:56:35AM -0700, Jeff Johnson wrote:
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
> 
> There are no changes for ath11k or ath12k.
> For ath10k, add board file for WCN3990 variant Shikra_EVK

Thanks! Merged and pushed out (for some reason it was ignored by robot):

https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1171

For the future pull requests please consider including a change log in
the commit message (so they get recorded in the git history).

-- 
With best wishes
Dmitry
