Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0393955DE
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476707; cv=none; b=JCAXPFaF4iRLsopVyKW+wcJTBVVPtS/tY1hMit+ZkaF6TtZRcthsT4/3uUjkaAY45jlBQJGMuoxcb0KG0un94HaU5ijtQjHdeAAfjdkRCuiCcCvc7yy6fqyLDDrksV8F1Vt3/z/SOq+XpUZH8iy7C1hNhmpXx+o6Qm0rbYkl8B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476707; c=relaxed/simple;
	bh=Vs+5rGUucy0PFKqrstrZgmPgXHE8v/mFwnQmllp8gq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a4eHxvplVGsP3mbAqjk0Y0uSxbP6qogrcj/ckioiv+AMhHooHsgP/mmaIMGex4l/pBVrOhPXH1ZzzVLew5zITS0O6QXON2t5v155OdkDU9DTjh0af6ffKNFq7iVxn915Q/vXVnTuUfCX0bw9GMyJTCek6/lg9LtdcFipXZyJNgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hQKewCh+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pp/nnd1+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hQKewCh+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pp/nnd1+"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698GK4j53881348
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 16:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PrPZf5SWpHn7JseCoewc3m7EX0hPPEz3Jrk1GAafdW4=; b=hQKewCh+rxpwHiyJ
	rSwqE2PX3cd9T+3U53kvUEh5cblkjVgzW8qkVUenjMsD1hry9OjtWr9He1oF8uMP
	2XoB0464xFZ4iQ0EnFj8xIhR9A2qiPIMOVUH39jdTLP1fnuc782wZFBaRsQKjBvv
	0Q466bcdVWZKVCo3xJRtFYiDmBq/OXvAJha0rUttpX9g52Q+npw08+R9b8u2l9Il
	zsPomHgk6I5bhmdmH2FfoaraSV5cwl9qcfzpELR3yETBmX3hpKJ9awst9sa4RSYc
	qy8WqtyVIvc4XiT9THJPcMMtRdhM5oW4q/g9Aj5GbDhnSfvbu42D8RIQSnQFerPf
	7iu4yQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6ekv80qg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 16:25:05 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3aaf955db5fso1197286a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 09:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791476704; x=1792081504; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PrPZf5SWpHn7JseCoewc3m7EX0hPPEz3Jrk1GAafdW4=;
        b=Pp/nnd1+X3z19wF1jNOzcAbHDgSw8z7m9tMkUtxPkgCxGwOK1scgtt3p2AzrwXvXoO
         Lfl9gVa0lPjdXMKGX2w8Qxa7knj9uddEJKnM7T72EEk9SlETV/Y8UKIzBiBys39tXxRp
         DfyVfENuEiqryK9CEdnqwSMdDhBhT2Gou5vG3Exqcu3liCGDmYvHorWsmVOBrfl4E1/k
         EEc//LRhUwGipdosa/zzkTUrnP0Yb4BrIL48JAUkGYAyAP7tHvXTZNDsLBQnKF3TE+fq
         cPmTZQG54DZpksBhFUz05gjLxDtDHkCYQLvgLUA/ZytanUHV++H7W0h3NJrluyQcZszH
         LJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791476704; x=1792081504;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PrPZf5SWpHn7JseCoewc3m7EX0hPPEz3Jrk1GAafdW4=;
        b=dcRfXZQUMGS+8jmrcmkSI2mJMkYfVYEiF7oODAXoaVcPskuV+z2DPAneXhfJz8lfwc
         R6hKwyjnLZnfG6Kvd/TrusT6lOp1TY2ByOnoaCyChRKwa/8EJSeMAouvoe2Dx6xkH9UK
         WFMp8lpWq8sNPNZb6GUjMVIzLtXDGqb/ZuX6gnPnXWU8b0Qb2M/1V1cA5AyVeb7RFN7C
         b6ICIwwTWwEoU+hoFvjkrt95m5IqF7sS3GScR/twm09J/sPGYh6KYdciPpOeg5X/DqFA
         kFpODBZE3rJM1oe3NqkFMNiRX7Z+WR8GkNbsZ4KxZge/5aFINRt+Q0k21r640xb3Pd/Q
         T5OA==
X-Gm-Message-State: AFq9FYJe8O4wYSH7wDhR/GJMG3mHklypBhWNMjgFxeZ5C74Mr6T9YCdn
	/DNzpyhO+i8ro+ykrdHqcP4HRmtCT/eL7sf3Z2m2csmnKwi0htrIV9CkIuTR6DAw1Ao3/3Pp7LH
	aUbSj5p3CGwiwxOLda4bEhppcSuBNZuA95tu947mNcviQq/SB1771MQkdkTpcxuIfuUFdhraCtp
	Siow==
X-Gm-Gg: AYBFou2T8URmsmkzJrQRgrnIt8wvySIXKYUw0GanElULYUb6eGiPvImtF2NLwKIJ8L3
	nvZMVjJItth7ZONRtcICePMmTZlM4qyv/T80TFYsgx7G8nq+zR0Ms0kIQuRN2zQJ8bcVl8IhQ+x
	Tz/9GjaHSHWq877K+H2l4IIs8iGMPTocdjz7+He7j/0vbvG4EJWelNE2A8ailj1YUQdl2jkenAQ
	KuqeyHlHjVCRS9lzIT37la2mfKMFXQthrLe5+Ow2+yxmFSjZhQO6G8FaM+oP4sQboOYZJz43Hs5
	IzeK2LSSVXNOrbF/s59WcDp15T8Wp/kCbCeou0mvMue+Cy/FcPtuUjpC2I+qPIo5JrjTMM8ppKd
	T2f7xA1zZzBa5rCa3F15Crp+bL+plGxp04PqKh58XpC0=
X-Received: by 2002:a17:90b:164d:b0:3ab:413:49af with SMTP id 98e67ed59e1d1-3ab04134fcdmr2005760a91.49.1791476699432;
        Thu, 08 Oct 2026 09:24:59 -0700 (PDT)
X-Received: by 2002:a17:90b:164d:b0:3ab:413:49af with SMTP id 98e67ed59e1d1-3ab04134fcdmr2005742a91.49.1791476698950;
        Thu, 08 Oct 2026 09:24:58 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff8669eesm4665613a91.10.2026.10.08.09.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 09:24:58 -0700 (PDT)
Message-ID: <b792c43c-1b59-40c9-9ddc-0ed263104aa3@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 21:54:54 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Configure RXDMA buffer ring
 size per memory profile
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
References: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: N4OES5n8MCCcF38GL3mf2DS-dq-TiCrk
X-Authority-Analysis: v=2.4 cv=csYOAF4i c=1 sm=1 tr=0 ts=6ac7c3e1 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=xhaovxbADAV7QXi6LY8A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA2NSBTYWx0ZWRfX7FgKVbCwNKnk
 +prm27cO4/AzyoD/+HlgN0uVHN/1A20AicH5Nj6GBc2JgPAQpugt0WMXHLe9SMpbs0DVq81xRCQ
 J1QFs8luhDzfBJ206cvueh4zAeHic2RUd47FL4Lck+Xs7stLwKa47/ryLI6i1ncFpRjUwpl5w1Q
 1ePTskGGWr1OupDkrwESKNHPrRMxfkoPWnmyipp+qZptTazTIc2j+X8DKgYuzVnvgBOJsHGXsvS
 ffh5fCdJOMJzagE664Up+TA9zAoPIJerLyaadt5sU+EcK13mJzxTnQ2FI0LC/0Wn8jagr0VYnN3
 uPLQO+sCMyn6k9TFlrmlscpvIxU8/zSx2cK2O4oi1NDuoDXQIkJz4giBQZBndght9bK+n12MF9B
 Kt5rC2p9o1URhc93wvr0brYLC+Er42m8TIU5A3B5M2cFpQp8S8QRp6wIIOXWwQYqAfRS+RysZZu
 yg2kHhSB5ArHVo9bn3w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA2NSBTYWx0ZWRfX3tdudhz4jFqr
 nIGdIfZxXu/mANJ2oFiiQPuXYi/pyXqn4qCG9QUQiduAnKSlHS60L0N5I5jtMDFQurLJT0rrmRg
 /V6ZxNsTm8zIJARtHhChrZgGz4V+Lkw=
X-Proofpoint-GUID: N4OES5n8MCCcF38GL3mf2DS-dq-TiCrk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_05,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080065

On 10/7/2026 2:53 PM, Aaradhana Sahu wrote:
> The RXDMA buffer ring size is currently hardcoded and shared across all
> memory profiles. This makes it difficult to tune the ring size based on
> the requirements of individual profiles.
> 
> This series first makes the RXDMA buffer ring size configurable through
> the memory profile configuration and then increases the ring size for
> the default profile to improve RX traffic handling.
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
> Aaradhana Sahu (1):
>        wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile
> 
> Pavankumar Nandeshwar (1):
>        wifi: ath12k: Increase RXDMA buffer ring size for default memory profile
>   
>   drivers/net/wireless/ath/ath12k/core.c  | 2 ++
>   drivers/net/wireless/ath/ath12k/dp.h    | 8 +++++++-
>   drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
>   3 files changed, 10 insertions(+), 2 deletions(-)
> ---
> base-commit: a90ebf2176db07c5d91e0a62e15ded1fd50710a0
> change-id: 20261007-mpp_ws-a041d5cfac9a
> 

Other than a commit text nit in 1/2

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>


