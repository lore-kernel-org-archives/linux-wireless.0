Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB363C062A
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900942; cv=none; b=cE3slGLEIQX9mM48z8uL1VCzU8HvLNh3L3T+hM8/mWzCj+kX2iLBR6xZ/A8zuiVFgrIvXQH56KJigtvHxFmnEgdidyID99EpLJ+N0A3+ybOs+St4c/GQNqTo/DVVpXFwSGGPGVQtqMoTeGDaPqliyUVHhV1zd4LmWF8anxNmoWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900942; c=relaxed/simple;
	bh=CjH5AZrmcd4Tj6HcXNlPhoi41OA5bTxfnyEeIbRqxSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aBSsgMVubUJhtnroNsbh74AMTdjA7j2K3RqRVZpBw/qOu3t5Cud1UXt6RpcGC6QYMx4jmuGqzuM1khm4kKfnHnR+H0uREbAoh67Nukm7lWSWjQmg/QHcUxa/pg5SklfZxR0FFx2eWvA0j6cG5GuyxnJ9cNdhKOsPdFh8hjqT6wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JJ3YRMKo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IgJ/Mtjq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JJ3YRMKo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IgJ/Mtjq"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdsxW3430730
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 20:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hUD5wJmbUeVWlnxofgswz+6khrcWFjlSF1BO0IiRZYw=; b=JJ3YRMKo28ZtFcmU
	muwG8AHjvy4vTtS7IE/GkTdRSR+2Lwj3nX8fWMMWTT4Mdi5jtM/bMKthmt6V5dFs
	YSlP6BRt6bDhdm/guBcRlLSF3KxdSOaMOJBeUqBRAMrYmfMJ1DOWwvVL1bVF8Xif
	Xtjj8zcvi11ygQozsk02ZYGMvj+2Iq0jUsvGR7uTHmRnSnQN8BO6WvloeAmZAUUi
	CM227rggm/TshIqGppBqMeZoPNlSiCZNF18JwDe4TKrumAcqGgNPqOEkXP1g9xTo
	RV20pakGz6CTrc6U6KsaWWrH0KfQvKqXF0/RgGHeBds9HrnvEbNnSmWbsp/rm6Xv
	upol7A==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjhkj2pnc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 20:55:39 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb48f41343aso5359700a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 13:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788900939; x=1789505739; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hUD5wJmbUeVWlnxofgswz+6khrcWFjlSF1BO0IiRZYw=;
        b=IgJ/Mtjqo7tRAnQe296QfNFUcEGWMHO9moPLrHH8wMpnVRlWJ9h41dQwnWfUp8HHZv
         l+cuqyqtbT2k+tVQk1zsgmQrBRmJSTyoCdsJLcGsdUpmGu7cBhoaV7JkYVHMlEm6L+4o
         QtMMxWA0K0L1+EUBylyMxd3ZNDKKmob9j/NVwPHGpIBGtu53/Xcn7BTZ4qWMw7AjFEAC
         gMj70HrLQrD1BfqloPsu1tWPnfuNmznWxS9SidV2vv5sr+yUutL3/mzRrTmC3pBbw8vA
         B9PgwLBAGmhGaVzOk1kyNIutLsmUywViOUUBAqHu/ZKpaBennb7/ldsgnb4c6P0UitKA
         SabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788900939; x=1789505739;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hUD5wJmbUeVWlnxofgswz+6khrcWFjlSF1BO0IiRZYw=;
        b=pwPE0TVXehy4pJoYw2fPmODrgqCs6Z7YV70o7Ib585bt6dfOoQQKnI/QXTksSnnnFQ
         YFg4wjAuEoCgsZ3vH1idHUaKg27N/2y+U8AHoRaLoaqt09OUSKKXaHV1iF583sjAUS4y
         +fkoeBlpP2ptc0I5gVQ8Oy8FPuSU5PSohaEfiEhiLmrN4QyGMuYAwT7e/3H9bld4GCq4
         6XFTG94/6CrOdhEhxP/l1YfwmF/P46M9W8TAXqB5ESn4ipRExUKl7pxLMwi+P98EBTgm
         CTezS65C2qNB7uLmnYo1fYvzGfbzwC4RdOheTS3vC9/knfopFy3nhl/uvtxcjZdZzX8F
         L45Q==
X-Gm-Message-State: AFuF++mZcSb+9P0ZBLgKaBvA7EEbHciF/Cwtorhcn8F2ghuiFWueguBP
	bigA+D400tFSgcBmY0NGxdtv2rYzDoRPQy4cJ2tipRW/SO/Jgua9a2i9l4kbLAo4vKWG5K3gNpZ
	4jGa1AHhn1JhVJlO94vNFQnAXzHVEFNqVxjf84CMCOIY2aLeS6dGEt7vD93VlYRAGOJNCuQ==
X-Gm-Gg: AYBFou0qelItSpPWKCIFYoEACtDIFiCOFMwnzF+Qh/LHpDpJT3A1Q9OfrWx7GN9hnfM
	NFiOsMiHmT3hO/mgHGtNetoc3wlUGAPZw0f9UvkhhjtOJkb098VAtyZwT6fCIK4LK5OBL7G6Y/h
	cYiHiU61mLN3QrkzIFsavnlUMUAwoAXybhV57EEVKXXOJOhfc7a+iaS9IeRRLk30+TBXANzYiBI
	N6gJJCXbimU4VcmNic4IgotmkHShtXaKu0QITj2eVdhMTafajjUHsAZUyd8qPfpNm8uUxcsJ40K
	ausqOCaRIdZFZGZsAGan2ltkX9LEanIeNkLAzqGW8l7QDFETwZX/AGRA+7hNO58E5qC5RxJqCNU
	dcW6poHqEbc/8ny7KQtKx5Mvl70TsXQDOpUtQXrQTDsreRoufoFBs75Y=
X-Received: by 2002:a17:90b:4988:b0:398:ceed:b903 with SMTP id 98e67ed59e1d1-39b080364famr39979547a91.11.1788900938623;
        Tue, 08 Sep 2026 13:55:38 -0700 (PDT)
X-Received: by 2002:a17:90b:4988:b0:398:ceed:b903 with SMTP id 98e67ed59e1d1-39b080364famr39979514a91.11.1788900938138;
        Tue, 08 Sep 2026 13:55:38 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33688cfc714sm20199915eec.20.2026.09.08.13.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 13:55:37 -0700 (PDT)
Message-ID: <4ed6651c-b1d2-458d-a210-5cc72954b48e@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 13:55:36 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix stale skb pointers after
 aligned TX payload shift
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDIyOCBTYWx0ZWRfX8h0phv0z8Las
 lB6YSgaDZwGmD/5z7OYxA+Wd/1Y/m3qW7orjOC+Gvck/uSWB1PNLw/sD4ZEQ9zDEAP9/IZSJNwp
 Sn533T7RhuWrfy8tk4SXOg3cytykrk0=
X-Proofpoint-GUID: Jbv3OHsnxpjbmdqZ0EP7i68aAsw-NToX
X-Authority-Analysis: v=2.4 cv=VYjH+lp9 c=1 sm=1 tr=0 ts=6aa0764b cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=BDGgVOeuysSBKt4bhqgA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: Jbv3OHsnxpjbmdqZ0EP7i68aAsw-NToX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDIyOCBTYWx0ZWRfXxJakU8PexouC
 +7CVTNI4ig6pgR3Qt0R/z66Hx/jICiQWs5Pk7VxOpd1rl8/SpJYEtAjo3Rjo1w5/asXc2qSwuoT
 fT7hKSN93HQFHZ3tp6dsBo9GgH47gc6+s12cDUEDS6BnY24HXvkrjqysR32wJwbXU6ynlr5LBFe
 58kE2RGMHLrmjE79SLXOT97r5seuFjNfEyDeTsktx9iwzx+/jTpdg7a0uxcYXDeYKxEWQ8rP4Bb
 N95RT92Mzmb1zky10Z4G9hT8pcsUFobG3mdS7RrNYcBFDBBaP27/HQPL0htus5V9u4Gchx6ytOo
 oOlHsVXcSTP8oSSDz+QDEJ79+O26vHlxhecuDl/lp7uYcYkHDIP6t2rk56HfIuditxnF3r1WCQM
 9vUtdCtQtiloF3kn/uXg+kvQwMv86gT8Kb5TR22WwvVObqYJ3Ifc8kwd4O6KfdOYqGojgHOBPAH
 jn/vP9rQEXoK1WsLOWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080228

On 8/17/2026 6:44 PM, Baochen Qiang wrote:
> ath12k_wifi7_dp_tx() caches hdr, eth, and skb_cb from the skb before
> calling ath12k_dp_tx_align_payload(). That function may shift skb->data
> in place (when headroom or tailroom is sufficient) or reallocate the
> buffer entirely via skb_realloc_headroom(), freeing the original skb.
> In either case hdr, eth, and skb_cb are left pointing into stale memory.
> 
> After alignment, only hdr is refreshed, leaving eth and skb_cb stale.
> skb_cb is written immediately after (storing DMA addresses), and eth is
> re-read on every TCL ring retry via the tcl_ring_sel goto, so both
> accesses are use-after-free or stale-pointer bugs depending on which
> alignment path was taken.
> 
> Refresh eth (conditionally, to preserve the encap-mode distinction) and
> skb_cb alongside hdr after ath12k_dp_tx_align_payload() returns, so all
> three point into the live skb for all subsequent accesses.
> 
> Issue found during code review, compile tested only.
> 
> Fixes: 38055789d151 ("wifi: ath12k: use 128 bytes aligned iova in transmit path for WCN7850")
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> index d2749de44553..6b8430260238 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> @@ -251,10 +251,15 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
>  			goto map;
>  		}
>  
> -		/* hdr is pointing to a wrong place after alignment,
> -		 * so refresh it for later use.
> +		/*
> +		 * The payload may have been shifted or even the entire buffer may have
> +		 * been reallocated for alignment. In that case, hdr, eth and skb_cb
> +		 * are stale pointers. Refresh them now for later dereference.
>  		 */
>  		hdr = (void *)skb->data;
> +		if (eth)
> +			eth = (struct ethhdr *)skb->data;
> +		skb_cb = ATH12K_SKB_CB(skb);

My review agent notes there is an additional issue possible if alignment
causes a new skb to be allocated. If there are any error returns beyond this
point then the caller will double free the original skb instead of freeing the
new skb. this is because the caller doesn't know the original skb was replaced.

So I'm taking this patch as-is since it fixes issues when the buffer is
shifted, but we need an additional fix to correctly handle when the original
skb is freed and there is a subsequent error return.

>  	}
>  map:
>  	ti.paddr = dma_map_single(dp->dev, skb->data, skb->len, DMA_TO_DEVICE);
> 
> ---
> base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
> change-id: 20260811-ath12k-uaf-for-aligned-tx-a068d34b1548
> 
> Best regards,

