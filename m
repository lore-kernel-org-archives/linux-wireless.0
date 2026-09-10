Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7D823A9BD
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054006; cv=none; b=MNgExzKEASfRuVMH8hR5l86+NW8EcsyfqN/f7TvAK6gNduMBBjpxgJpGwwl0IGvf5oUTtluZeHtbhed061x8HU9PdfvhD7rhPa7KX1cNX0Hph3QR7CTAnf80Q1pGxYkt3QlQHbPcbnXbZKZ2XZoZqW4XriX52ih5R1lPqs01U/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054006; c=relaxed/simple;
	bh=NXmm0fngHAuAjy99A2bEQQrOULAlIneHawubzpw7EDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZSh0E/ITAdcz0Id5hgWkWM6usNXGnSlxgQt19XiU8Nbdi8ScHWPxbk3sYbyx9ypu5IsjoQ88ys88W9BCPW40zcY0s5eCLNqAFzhX9ZW1cw+VUpG1ducrQREAbrjgGkYN/wuKWWc4Mz85PhHuHk/Ejov5nbviHy0rlXSW9UTmuzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PNfXh8Es; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XaR8qOdl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PNfXh8Es";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XaR8qOdl"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF4Kkb1326232
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	alYzCiYs0Ctw279xxqhDpjSr+4DgUsPddUvgJImzbpc=; b=PNfXh8EsaIOGTV/+
	x03hnk29yHwt1ZmR/KyI3uQPw6pHf5bqHpmI6wH6pIqz0Zsc5jOFYxoBCtbUqtm0
	Oil1Z9AvlEoeNzUYB7Cj6s/60lI6swO+b1JCxw1Eds/LTXjiLBoQ5S/RcQjq2v2T
	dXrc9HocIsDRZvznWxUaO6WMXn1XI8mSkIpwoZNv+tVAcTKQBJeahJpDq6r15SBX
	mXbZv4zmFewls08StU7n2Z94OB2IV/Zu7jcSt074AsSeNH+eOGIjixjEoRw4hzIi
	piSwIOEw2TRs2sO28AWz/tf4uP96as5ZqLLRhCNPoKIMPwCVo30QLN6QmukpYakO
	TsF2cg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkwts0hv2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:26:44 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-395543dc382so3635162a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789054003; x=1789658803; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=alYzCiYs0Ctw279xxqhDpjSr+4DgUsPddUvgJImzbpc=;
        b=XaR8qOdltdc2WM8OH9Ph6dkeriGeiviqmJ7QDe7uQ5iFYbpcKDxZ7IzpwBzBFHlzew
         7IU+6iAqURwzYj9G4K4+4Q2cxGpsaVpnv9HWc0uCrVkxa48bF46moiZMolbEP9WA5/45
         Y9OaCLyn/e1AHdGTxQ2LyU4PEljYppBK7Pu7n68CXAYxz096iLy16PRVPNgUPmrds0Sh
         jdFe7mN2E4aQMUxuRZ3uFoTWJOjWDNwPQZHuS4JicjaMNYK2ow0nlgbQHHmk23+aruc2
         h+sjo+UUQb0wPn+eFkBE+0oOhLtkdlH45qxbbRVo+Kv8CsBGLBmjiWs0gZlrLtyPfpVN
         K0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789054003; x=1789658803;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=alYzCiYs0Ctw279xxqhDpjSr+4DgUsPddUvgJImzbpc=;
        b=NW+nCe7nE3uTTjI6DQyuL8cuj5hYg0Bi7bbWUJOPTWaSUUteIx3JFDsdG9tHinkyY/
         cBxZINeF67TnTkq07xBwxVAz0btVlPE2ePoHt2Eoh6lxzW0sESTEqN1rbcl0V7CMs4wZ
         QoVZH/S6QYeSnyEIIOzEgE6/GYLmLCxgIUG+HzZsGTdYbUhpfLcvRIGO0ityyBNEiNdK
         JtgMczwqmKL7VtyyHZgNo6yi+YHU0hzEZKkkiqWsqudChzO5alFvYUcTYSQVDvp0Rvsz
         3M2qyjIJAsjbQBy4zlauInTh2uumy5BBBjjbzU8z9fwCZ51IpRjCO96X7OKGE3JbLMdE
         ha/g==
X-Forwarded-Encrypted: i=1; AKwUvBySch4A762ig2bpo0gu65OijamoAVKhxpabx7xOycn/fmRL6CDQRgU6Id+nTtNwT277xn6HzO4/TEZyvMheWQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lrcpgyldcEwjP4Og24NVp9j7F5IO/3G9xdi2e0EImqivLI3em1
	Z9Q5cJWjRGv5K0W1GIRIRQPDKT2tqItxa75+E7/Rf1HGqH6tobuDHCpjZ4YLnv/3gVaFciEzfZ5
	BrzZ/R/fLVLhS2iWLuoGnUKU68aijtMkMcOicWJ6gGUXSqRnuxrGxudEgt8LGrsDiQTxQPg==
X-Gm-Gg: AYBFou1mK141u5k+c1mZDeCI0Ek9lHhMXWtQDrjWifnQvhbry6fpQjZUMhIhA/JVGee
	BmlkPQbcAK0d48TYAUd6Mugf5qxQ//G8avtkSOibrCia6xhivjSJhHF2JKBL0qfvh3gVkSUqQH6
	f2deUuDNYB/GRLo7AlST1sx2+s3rsfgvojezsH5vt4oQGbGFr3i1jbkqBpi7gxUHavEBvIW2RrK
	5ls/dm4lNxoPRjjFcwKjq1KSStBFmD/Bz184KWm7/0npLyDstGnvEtxu7wFYx6si+g+5r9p6Sq3
	SwR50LQFgqdqcd7PM/RqwzCNW5BcavdHz+pLuTEvcRW0k7HnNWqP0+n19FnhKR3jdDKtvxyFpbh
	epE2POvvJ4qzZsBKJwk0rPeXAKBsh4AIjRcoh0ZLxS/0WgR8gZe0a4c0=
X-Received: by 2002:a17:90a:d44b:b0:398:d93a:b343 with SMTP id 98e67ed59e1d1-39d709e7326mr13890775a91.3.1789054003442;
        Thu, 10 Sep 2026 08:26:43 -0700 (PDT)
X-Received: by 2002:a17:90a:d44b:b0:398:d93a:b343 with SMTP id 98e67ed59e1d1-39d709e7326mr13890712a91.3.1789054002868;
        Thu, 10 Sep 2026 08:26:42 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-336c2571039sm31613177eec.25.2026.09.10.08.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 08:26:42 -0700 (PDT)
Message-ID: <05750947-c6fd-464e-930e-d45ff6f0294a@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 08:26:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] wifi: ath10k: Add missing validation in
 ath10k_htt_rx_proc_rx_frag_ind_hl
To: Rivaldi Hormat <rivaldihormat@gmail.com>, linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org, ath10k@lists.infradead.org
References: <20260910080659.20831-1-rivaldihormat@gmail.com>
 <20260910080659.20831-2-rivaldihormat@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260910080659.20831-2-rivaldihormat@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=PIaaavqC c=1 sm=1 tr=0 ts=6aa2cc34 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=pGLkceISAAAA:8 a=3e556brghCOcpfj0uccA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: L7b167KHVE69icZfqGbybMqXdsP4LkbD
X-Proofpoint-ORIG-GUID: L7b167KHVE69icZfqGbybMqXdsP4LkbD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE4NyBTYWx0ZWRfX2j+zcaGQq2Va
 bUcagikgKTggDR3M7zI6uGZlEWFvnWHVmjsaZFBVhG8cC/hJr3EIQzkYSugQX1F1BumYp51HsXt
 +6MARmLDnP66TbVShMXWoJw4MJvLK/k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE4NyBTYWx0ZWRfXwpnrzQWUiDJE
 RDU75spFhAmShrIoW4re36CDNvt6IM7Dcf0DU5fPU7RW8llgtvxTynaJvImc99ZDIXfnTWhYMDv
 uk1GAAa4W37671ZKwsYMp2uXtbousBttLp+UaFP8naTwjS00Q0yNI+nKsPAGFnJP2vFVSZxY5NN
 KYgzL9eb1IJStXmsMuEsRaRfGcZyqC13JwjEKfdXfx3+y8m7YlABdtywCF+DXY0c77OLBJbgMpr
 yQZMQQ7oQDYN1nRW3tkAAYonl8+5UCnY5U6tKBtJO842FzzkRJCJTE3GeEIOXEQg3Z7EccGqD4s
 s3PUUfdwXni9AWaI1wdsPy/5+x6w48gVeQgV1kyp1x2LIHIdkNE8AvbemWGPGgUigRIlMxXvXS8
 ckhHC18nKdPiTFQnmNjhkbn3B50gcR69p+GOiAstuFfl+EviuEwXJ5puR5jAFor0KzfDKJm2dWt
 7/UiHMU2GiiZ7AJ+Ahg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100187

On 9/10/2026 1:06 AM, Rivaldi Hormat wrote:
> The ath10k_htt_rx_proc_rx_frag_ind_hl function processes fragment
> indications sent by the WiFi firmware. It performs pointer arithmetic
> without validating the skb length:
> 
> 1. skb_pull(skb, HTT_RX_FRAG_IND_INFO0_HEADER_LEN) without checking
>    that skb->len >= HTT_RX_FRAG_IND_INFO0_HEADER_LEN.
> 
> 2. hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len)
>    without checking that fw_desc.len does not exceed the remaining
>    skb length.
> 
> If the firmware sends a malformed fragment indication with a small
> payload, this can lead to an integer underflow in skb->len and an
> out-of-bounds read in hdr->addr1.
> 
> Fix this by adding the missing validation:
> - Validate skb->len before skb_pull.
> - Validate num_mpdu_ranges to be <= 1.
> - Validate tot_hdr_len against skb->len.
> - Validate fw_desc.len against remaining skb length.
> 
> This prevents out-of-bounds read if the firmware sends malformed data.

ok, at least this one has commit text. Did you write this since it looks a lot
like LLM-generated stuff we see. If you've used LLM you need to add an
Assisted-by tag

but also look at other commit text. you are putting in way too much detail.
describe the problem as if you are telling someone else how to fix the
problem. normally you would not quote specific lines of code that has a
problem, you'd just say ath10k_htt_rx_proc_rx_frag_ind_hl() doesn't handle
undersized packets, so fix that. The code diff itself tells us what the actual
changes are.

> 
> Signed-off-by: Rivaldi Hormat <rivaldihormat@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 30 ++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index ab2d373b4..4fabb9264 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2775,6 +2775,13 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
>  	struct htt_resp *resp;
>  	size_t tot_hdr_len;
>  
> +
> +	/* FIX: Validate skb length before skb_pull */
> +	if (skb->len < HTT_RX_FRAG_IND_INFO0_HEADER_LEN) {
> +		ath10k_warn(ar, "Invalid skb len %d for RX_FRAG_IND\n", skb->len);
> +		return false;
> +	}
> +
>  	resp = (struct htt_resp *)(skb->data + HTT_RX_FRAG_IND_INFO0_HEADER_LEN);
>  	skb_pull(skb, HTT_RX_FRAG_IND_INFO0_HEADER_LEN);
>  	skb_trim(skb, skb->len - FCS_LEN);
> @@ -2792,6 +2799,13 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
>  	num_mpdu_ranges = MS(__le32_to_cpu(rx_hl->hdr.info1),
>  			     HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES);
>  
> +	/* FIX: Validate num_mpdu_ranges */
> +	if (num_mpdu_ranges > 1) {
> +		ath10k_warn(ar, "Invalid num_mpdu_ranges %d\n", num_mpdu_ranges);
> +		goto err;
> +	}
> +
> +
>  	tot_hdr_len = sizeof(struct htt_resp_hdr) +
>  		      sizeof(rx_hl->hdr) +
>  		      sizeof(rx_hl->ppdu) +
> @@ -2799,10 +2813,26 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
>  		      sizeof(rx_hl->fw_desc) +
>  		      sizeof(struct htt_rx_indication_mpdu_range) * num_mpdu_ranges;
>  
> +	/* FIX: Validate tot_hdr_len against skb length */
> +	if (tot_hdr_len > skb->len) {
> +		ath10k_warn(ar, "Invalid tot_hdr_len %zu > skb->len %u\n",
> +			    tot_hdr_len, skb->len);
> +		goto err;
> +	}
> +
> +
>  	tid =  MS(rx_hl->hdr.info0, HTT_RX_INDICATION_INFO0_EXT_TID);
>  	rx_desc = (struct htt_hl_rx_desc *)(skb->data + tot_hdr_len);
>  	rx_desc_info = __le32_to_cpu(rx_desc->info);
>  
> +
> +	/* FIX: Validate fw_desc.len against remaining skb length */
> +	if (rx_hl->fw_desc.len > skb->len - tot_hdr_len) {
> +		ath10k_warn(ar, "Invalid fw_desc.len %u > remaining skb len\n",
> +			    rx_hl->fw_desc.len);
> +		goto err;
> +	}
> +
>  	hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len);
>  
>  	if (is_multicast_ether_addr(hdr->addr1)) {

