Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19845376BEF
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787134419; cv=none; b=gms3eOul1ENAnHeEfppESz4vVDKd6dtZqBK0mvuhP6PwoTHnp6MQiUYJTe8G/m1r5PpNR2ZeXd9CCeTJBugCSlIh2H2QJg24teBqMIlij9gSyEDnmDZvgn/JR15cUfnaS+PdL25VzWYynW1jeRs7azDZsZc+WR+jdKV+yCHKEhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787134419; c=relaxed/simple;
	bh=/Yd/SsufleYkrrXvflnFAgo2swp56LJ3DXKT8RhxeMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TeU8peeNNddhVAxNgYI+1tjf3aOkbNwwCD2G6Bd+onX6EfxzSQ+Kd06iaueI8uUvzXdfAKIUooWkbKAywuKZvmVP3Lfy9sxfs8trB22ttI5jeYH2DFJtXe8mhKNwtrwcgEN+Riu23yuKj3VYXNFEhvNhKRRprDnu2hYhw68SQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FEHR92zT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X8+AFTtt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FEHR92zT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X8+AFTtt"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JA8EbL3754755
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D9cmhcvWFCUaFi/ELcC0gyefUrDSv1cLf3/+rNb/LbE=; b=FEHR92zTpCUC21HA
	7aG6fhjxF7OPyO8cponxzFjeXTmS27lvIYo4mw1+XLAM3FfjRuKjWRB3PdjeTztJ
	AwN/jwLRAmkKSBFIsLItqkooZLFR1KzIzrLshxG2NPdDKOOsp3tfdmYVx5I4XeGB
	tMPTTC05Bv3DENRONuSCp/NgVAbhBiqlhPZECNP2f3s8KnG7oUpMfrSgQkFQ49TA
	hq7y5/xwQaxq5lkhM3LZkcchapD0x+YN6kWQo/8iPZHKcdn4jBM6PQVubWn6BMXw
	Qv7MBBQZIEE1086tN64S2LVRYAE5fdXUFxui2ZveFBuoGmpkmGftwTo13uti7wfc
	VHuI6A==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yffjhbr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:13:36 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb20f82a0eso585275a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 03:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787134416; x=1787739216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D9cmhcvWFCUaFi/ELcC0gyefUrDSv1cLf3/+rNb/LbE=;
        b=X8+AFTttKHMNlFXuf48pcpEtaiN+vN3NP1EPlwL66RXSNzqyzy/EA/upYVB/Nid2Lp
         BM04yZVaURgG94MeMV2MzmT3jDxMB/y7zlM4tojexQBqGrCJJ+HbRjcLNsuo2btiecKQ
         5gqYHPuTKI8ZAfP9D4gnu9oYagHE0Vub6xSnh5+Is0Yj8GkF7PTF0WVDT6fpkj9LiFrH
         El/IOkBBLfUuOiDOwggTvHZkRlVlyitxSWMpTXFNOk+gQR2fO58zUxF6BpRGfomaTaA8
         bejlnMDcZdCObmUv66DflQl2IdnWygtVxTq31AU3YpamjjY4iQqPuMAtTLVXpBGPyWor
         mStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787134416; x=1787739216;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D9cmhcvWFCUaFi/ELcC0gyefUrDSv1cLf3/+rNb/LbE=;
        b=JOqXjRDPp15ocaUW6LX1JYETg4KZ3f9B+qRbFHoJLVwVGRFV99MS6517U/B326oU3s
         eIHMJ2wyEdeavIvtdNmgPSSPtnw1op/d1uwjV0B8KKNtAgvZ+ZBJ0lCbYNaE/PKXH+qX
         6IiWJnG4HOQK8+/rlnLLnZMgaTIeRa/qslw24h/5GOAQIEsgUab9r1vITZ8myGSf2OE0
         AgutqIkT8Y16lmYjIe4ZjsoZd7tU82SjdLyY7qMRuhBOMBwzNHbV59tAyXYivrAfij0p
         Nnw3NS+NB3uoPGx/90SN/U68Cjl2qLKl3o6saEz9HtMg8vXBA7qjqMDELEjYfgAkmErm
         XtzA==
X-Gm-Message-State: AFuF++nrTEQa32+7SVp4xENQly6Qw2xXLtRt9Sdq3TPpoJcQ9TrQ/2wk
	a3Nfh4LHos6+jyx2QdjdGIr6iU07qB7nWVEVO1nfcC5FwU55e5vqNFHUHhtgw7soKzXuz53HPVB
	Lcb4SUDX/RYFDljTs6JydH/I0ljLP05bvrfsmFge3Xdbh7i5btAO8cbv8upX5GUKJo+4LBwZ2qA
	Vj1Q==
X-Gm-Gg: AR+sD137tSIMjWPwSItJW69JJLRzSW8LxrIYHq3xXH13ZQHv4aJbhTLf5F6g6GWdJLf
	yTOV7O06ODSUi+k9Zj0U4j695Y/O18VopWI3gDRFRoHMuvZEMYPqH28nQ/mdthkRRfna9ZnBHXl
	KSf8YXKXCkv0InvxYseyqFkOcU4X/akmFbNnIBp/wUlx54yINcnpAXAxMmSUzTxhgNBlYjyvVoa
	X5PNJH52eoVCwvAmJkrPnaIcpCrGpSXKQCc2YJl0LzcSX6ueCy4z+RodsQaoDnZt+TLhd4WpVW7
	c03wiG3vsdApUzg1lLY73rXAXZ0BOsiz1EVipJJEHMmYrtIATKD3AcXKv4jBOXw1dq4B7RZ3JC/
	zF3tNlD+oCsFari2zEXpgyguHIQgIMRPzi4YanYU3T6rqCzcktkDI8uYOheJB0No9JkEhO0bhJQ
	==
X-Received: by 2002:a17:90b:1f8f:b0:38d:f5bb:e0f4 with SMTP id 98e67ed59e1d1-39580840520mr7151766a91.1.1787134415845;
        Wed, 19 Aug 2026 03:13:35 -0700 (PDT)
X-Received: by 2002:a17:90b:1f8f:b0:38d:f5bb:e0f4 with SMTP id 98e67ed59e1d1-39580840520mr7151672a91.1.1787134415349;
        Wed, 19 Aug 2026 03:13:35 -0700 (PDT)
Received: from [10.133.33.152] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f96cd4asm2304886a91.3.2026.08.19.03.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 03:13:34 -0700 (PDT)
Message-ID: <3be7c1ed-6298-4d85-bb47-3bd0337eca6a@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 18:13:31 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/2] wifi: ath12k: Free allocated CE IRQs on
 request_irq() failure
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260819065425.2044186-1-aaradhana.sahu@oss.qualcomm.com>
 <20260819065425.2044186-2-aaradhana.sahu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819065425.2044186-2-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA3OCBTYWx0ZWRfX1+QH+T6MC5Ei
 +qAkYWw4Y/UNr4mk3bJQOv7EMadU6PLxxd54Qh1iAIwdjP0muV7I8R7J17hOT07XSbSW3aLrAh6
 1eZ6lupK5Mq19eDXcHx+mkbbRLeTbFk=
X-Authority-Analysis: v=2.4 cv=H5PrBeYi c=1 sm=1 tr=0 ts=6a8581d0 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=BPQVpOrXsMq7AloIG-AA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: mXLYpQ5vrg9GzOQqORl1_EVdX55fBopN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA3OCBTYWx0ZWRfX+GZNpL1Ramhx
 74EwdjreRNUdUXxR/7X9Q+hdq9BpWkqS9JhkmGfnmD+ZNxj/ZG6WB6rqRhmJFqALQwdsWV5f0Mh
 2du8E0LrhpFRYZNJj+Vtlnqi2YbQwGQteILykxmB9WtJg0jxTiCXiFZ3N60OVaH2oMNqR/NdiNN
 wr2Ybn7mIzBfuczy7iZgv+zCXgojExJBFgEt1lzzjQ4NcywfbqVjm5MYZoOwupD5VOSNB5qrOX+
 zwk0BS2rM39dg4U6gDKEqL+MVEs+9YhFMuYx9i9gnqM0pjms6tTlonYV56eANmzWwHh/1fGQwY4
 8it7D97rzyYJ3yqLewrRC7SxszE+RzKHy8ZROscegPOyfKiZW3KsWI1foRDikme6o/zrBP9GdBB
 z1W0tIe42SE673YA3sHaUuBS7iyFxfJSpoDkMXIBTusc7ZhtqZ5q7PzAPTTD1UbA3yxY/rTD3Pe
 l2MMsPOutQfZValtCvQ==
X-Proofpoint-GUID: mXLYpQ5vrg9GzOQqORl1_EVdX55fBopN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190078



On 8/19/2026 2:54 PM, Aaradhana Sahu wrote:
> When CE IRQ configuration fails, the driver does not release all IRQs
> that were successfully requested before the failure. This can leak IRQ
> resources during probe failure.
> 
> Free the previously requested CE IRQs before returning from the error
> path to ensure that partially initialized IRQ resources are properly
> cleaned up during probe failure.
> 
> Factor out the CE IRQ cleanup into a helper to reuse the cleanup logic
> during both error handling and driver teardown.
> 
> Also free CE IRQs when external IRQ configuration fails, before
> returning from the error path.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/pci.c | 29 ++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
> index 6441927b5382..9a78d2f69f94 100644
> --- a/drivers/net/wireless/ath/ath12k/pci.c
> +++ b/drivers/net/wireless/ath/ath12k/pci.c
> @@ -313,6 +313,19 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
>  	ath12k_mhi_set_mhictrl_reset(ab);
>  }
>  
> +static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
> +{
> +	int i, irq_idx;
> +
> +	for (i = 0; i < num_ce; i++) {
> +		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
> +			continue;
> +
> +		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
> +		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
> +	}
> +}
> +
>  static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
>  {
>  	int i, j;
> @@ -330,15 +343,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
>  
>  static void ath12k_pci_free_irq(struct ath12k_base *ab)
>  {
> -	int i, irq_idx;
> -
> -	for (i = 0; i < ab->hw_params->ce_count; i++) {
> -		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
> -			continue;
> -		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
> -		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
> -	}
> -
> +	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
>  	ath12k_pci_free_ext_irq(ab);
>  }
>  
> @@ -671,6 +676,8 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
>  		if (ret) {
>  			ath12k_err(ab, "failed to request irq %d: %d\n",
>  				   irq_idx, ret);
> +
> +			ath12k_pci_free_ce_irq(ab, i);
>  			return ret;
>  		}
>  
> @@ -681,8 +688,10 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
>  	}
>  
>  	ret = ath12k_pci_ext_irq_config(ab);
> -	if (ret)
> +	if (ret) {
> +		ath12k_pci_ce_irq_disable(ab, ab->hw_params->ce_count);

ath12k_pci_free_ce_irq() instead ?

>  		return ret;
> +	}
>  
>  	return 0;
>  }

