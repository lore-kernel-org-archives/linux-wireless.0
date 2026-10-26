Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994204;
	b=jN1WHGsMj7CtuGxFWeGb4PPIlZjOaCrNrtH91qqQCxXLTiyfQvReczuJZ6PLpEsIPGWa
	 ZmDLTC2NhCpndOI5jeLNwWv1MY1rjAy3HS5vxHsDgJ10mFd/404zd/vWYlVdC8uTwJ5v2
	 KlDo49RulrXfFzf1rxgpu8iraXF2q8sp0gzMH6VE/bDsd369oIDixK+XXiuauQppH7k3L
	 E2usTsIykKFJkkQwcd/EuiowRqoMpKvUnycmrx1jAUFGFjS2nj3Q1qxHab/MWajE8znD1
	 8z0VNEEwlNO+DaDjBfQ/Lbp0570Abk9PH4H9BVQR4hQIHnYvVuz/RIycIg30xjilYHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994204;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=EAFf+h75G8bfaH+hZb4Eei0IjzBUojLNmqRmkAbraJA=;
	b=JnwfGCRHXh+KwWagrLuHZgppjk5eU1/4vdM7C2mkIsZPB7aWwmUB+Eq8BSwZHZO9qvZu
	 9QPzBQMoQxnJ4PccQs4D/J2P56xC+vXJrKO6OTBa2VM4dvx4NLm8o6QdVFCAyLoDcC5k3
	 vLqR61ITybQRYZADLTwxWnXB5PS1YGWjxJ7g3xjVZ3/xk3CAFya/v0SevBauYMrcOYF9l
	 tA/NUuy1PyTEMprJy+9pFJUsypwn6HLQLkwlCUh5N1tMUBaSj/RfvQkAapmXrtqTvxGgd
	 42wmOOvzzGHSYtCb5TNve+ksPz87qR/Lu7DKMVSjVHGTcIDj3d5TQJTGYFsl82e8v0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nCUl1lF6;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UsxZV6hR;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60D3606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:56:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D60D3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nCUl1lF6;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UsxZV6hR
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q4aUKl1708687
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EAFf+h75G8bfaH+hZb4Eei0IjzBUojLNmqRmkAbraJA=; b=nCUl1lF6kESlqD3q
	enBY4KRR+tEn4OWDkNM7oJykV4EuB2ZytRgiCg5h59S/ubLEJODZzlPPCHIoUguh
	XJ1Gfr+qfP7Q4mUl+mhnm0NYjeWpNfOuhq4XTBBuOTo65sZQEc/RRYQG8btQLxhs
	Unmsg/UoQLKfqhUegFL4DwB3w7Z+09bjUXs+CEUz2BP4Imgw/wytAXkrtQdqCKLq
	6Pi+hvbmFJIQcxARfUk6vcVZgxahSlj+zIeuhi5ftJSBh4QBEyjOlI1r/mWhGh3y
	XIz1eBJUaKWAlIHO53JO6SqUl3djW2Ihtycd/get2pZRrdOQnFJlpQM3s8/gdFms
	0pp1ng==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hhsjd918j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:56:42 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae1d132d52so517696a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792994202; x=1793599002; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EAFf+h75G8bfaH+hZb4Eei0IjzBUojLNmqRmkAbraJA=;
        b=UsxZV6hRKIHFPQXL51ii0zeFu6BYgVhdK9DgvcfwX9003pbqdK1Yr1qhLfdQ5Ag99J
         yKvepp4BUkCSSmuZa+nKZeZUxNauoWxE9wTgNBKDSmU1VRb5T4pyPoB+iFWxPtBd8YqX
         IUh1okgc2gaX9FednGFwGD9PcrqsClNRqyiFrFuODPQYP+AZMY519W++XZhRzmBjkj1Y
         WsoqR3VKo8Se6JsOQP+FoqhB3Uqswl3dl5DusgE4N3q2fBXN6o8VlxKDl4hPf9t7Aa61
         h97Htsc62FqsJlJXvZ9UWxOgEDnPrfV1ddcHp3urMJ5ehBJH11TWARNN6n2gYW25eQmA
         WqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792994202; x=1793599002;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EAFf+h75G8bfaH+hZb4Eei0IjzBUojLNmqRmkAbraJA=;
        b=Ekh95mymDRg7K16wd2hPqf0OXffTa4ZcqYR9P59T0ETyqIX9VBhWDrebbNHNDsKZLm
         8aQ8xXDsGX0Zq/S/diP9KCTBqcwtmYHp3mEd43bWXnctzqcO35sY0/mikWseyz6/6HPs
         At2dr9YIkQQjBS09eDWTA10SWpHR4sjHKoMMGtf6xCUqee0LQ9YXGpr5c07J4JSGaZQE
         taKYzeUR6JgaJ7hY0mkby8yCv71ZiHiLgIOKtwE+x1o90VfpYaXjrBF7ecTZZWUT72u9
         +MgSX0E+eEh/9BIkFJIlVRecyeuYfBCFgQTjSB9P4J7EmgK6VHhTpEoSUE5iKv2vX3ZA
         u91A==
X-Gm-Message-State: AFq9FYLLqW84Lbxn5CMMd62NYrNrJEbKlPqkxwAqF8zWIlqhyQpST5RR
	1gdkmylZvS9EonGzvsaihXLi7dzvieFT8HohhLkXGeNLj8B68GLnh4Z0qHKBCYQekms1l3nsPFa
	Y70fZIdZuYQiDOB0XBwyEpddZGN7XY49y0OnYYS9BOGN5T5iyxeApS6zjlUZvVt/CTuOR9nd2eU
	48MftL
X-Gm-Gg: AYBFou1JLLQeSVNr+shNsWS3NH5Uk4mUz7pKylpiUZ37vyv6ys45YeAmuJO0Sk+gEVM
	cF3Q43+eVtHa/h3kSIfRRj1S8L/ttRrWGAAKGnZ5RDuiUAWGdnoM0GUrf6KXsV040wbUUP7C9kE
	TMSXd1Osd/+eUvj+BsvIr21yM+f68yNF8B2lCkTWX7h+bhxRIu4+Id/yPvlmLIJbw5dRGOmWkfj
	E7FuXyq8yezUKTZLvhlK8v2vh8RpxgedGBJc7phi9Pf8zeCQU1rvBtnCWc/ZDWKv1YCrNcAZ5Zg
	MZ2WH/3F0LrNuiOH8DYaAuyx/U3J8Yt15ibCpPbfFlM4qU4++tUl7H2ablYwan/dDoM+TcDaPuR
	3w1NfwXBHaiCg5Z84HyZ4dz15jaNxj3q9jub2XjJZvgw0GPJtPsjmkm+lnTWeN29M05Mkzm05Eg
	==
X-Received: by 2002:a17:90b:1805:b0:3ac:b2e6:3181 with SMTP id 98e67ed59e1d1-3adead2ea94mr4979802a91.37.1792994201904;
        Sun, 25 Oct 2026 22:56:41 -0700 (PDT)
X-Received: by 2002:a17:90b:1805:b0:3ac:b2e6:3181 with SMTP id 98e67ed59e1d1-3adead2ea94mr4979788a91.37.1792994201441;
        Sun, 25 Oct 2026 22:56:41 -0700 (PDT)
Received: from [10.133.33.143] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebadfeb1sm6740111a91.9.2026.10.25.22.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 22:56:41 -0700 (PDT)
Message-ID: <ec616beb-0423-4b0c-b0bd-71a00aad6977@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 13:56:38 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: use hal_rx_mon_status for PPDU
 parse result
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20261015-hal_rx_mon_status-v1-1-b32d5a7383fd@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261015-hal_rx_mon_status-v1-1-b32d5a7383fd@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: VG5ga24clQQl7YggJjZtV_EyktOrQZ1V
X-Proofpoint-GUID: VG5ga24clQQl7YggJjZtV_EyktOrQZ1V
X-Authority-Analysis: v=2.4 cv=a4elZkSF c=1 sm=1 tr=0 ts=6adeeb9a cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=f15Pc6MQFNcZvwnbqmQA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAyMyBTYWx0ZWRfX7IEofEzfbY3Z
 u1VtpfIt24rZdoNixkAxfFQgcXdOaVyE4stwAxPFYID5hGOm9FOR/5nSTziuhYB0wXQCpGt/IkB
 fwrzc9OT/ZmkKt1Md9wAU8jvayP2TUU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAyMyBTYWx0ZWRfX/e81c/L+f7KB
 DSY1+GvIihsbe5k505S4aICDADXaSDfRzf+G9zOT0hmC9nOWYIvKkT/AViOZYannSHUD483fuwE
 fIwfV/CNn2tyGc+XT/Tni7ovhwrkykNjG3y+fxNlTOW5OImvoxkHsPTf5V0d8A+KJ3pB5WbDFKH
 3lwP7e80f12RULOotNqHmKTHMK79pPueO9z6kwdhMoYh0U0GumUhMftoPQPoAXBcx0S1Y7CaxHR
 rEVtqVlLLwAjcgk2P6+CN7W5iOLZhybayVpf0gtAlo1uDAQ0jKSumJqmdlLAfYrSE/PNUxvaxt1
 gOyLLf1iFVuP7CD404UUQuHV/0+WCQavP8eCHJ2tLf0ufPMDRImpiCobb2meNeiHLb4MM/TOFIn
 QuWUurcT3RHMrmIm4/gn23QU3f3F6tw3huZHkaaU10iAPgOijDqMKiCQ5zIPoufHEZoo1Bpu6Dd
 ILSVHDk1UxjKXUzbm/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260023



On 10/16/2026 1:49 PM, Kang Yang wrote:
> ath12k_wifi7_dp_mon_parse_rx_dest() returns enum
> hal_rx_mon_status, but one caller still checks the result against
> HAL_TLV_STATUS_PPDU_DONE.
> 
> Use HAL_RX_MON_STATUS_PPDU_DONE instead. This is a cleanup only
> since both values are identical.
> 
> Remove the now unused HAL_TLV_STATUS_* defines.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 2 +-
>  drivers/net/wireless/ath/ath12k/wifi7/hal_rx.h | 5 -----
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
> index 1e29c13ad66d..7d29b49e8a54 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
> @@ -3214,7 +3214,7 @@ __ath12k_wifi7_dp_mon_process_ring(struct ath12k *ar, int mac_id,
>  
>  		hal_status = ath12k_wifi7_dp_mon_parse_rx_dest(&ar->dp, pmon, skb);
>  
> -		if (hal_status == HAL_TLV_STATUS_PPDU_DONE) {
> +		if (hal_status == HAL_RX_MON_STATUS_PPDU_DONE) {
Not part of this diff, but the same topic:
ath12k_wifi7_dp_mon_srng_process() still declares "u32 hal_status" and
stores the enum hal_rx_mon_status returned by
ath12k_wifi7_dp_mon_rx_parse_mon_status() in it. If you respin for any
reason, better to have it fixed as well.


Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
