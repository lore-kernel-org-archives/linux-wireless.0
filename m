Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29893ACA49
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166721; cv=none; b=kOXQM85LFP/kb+DGpJ+aEBDKQ/2tdCMclJrTCmN9k1JUQxxhfawZr9ygE5lYwYLf/zdWcTc4fr6BapRSMw5O9+KhOB1OcAk87RyJ0hpYiUS9kIEdxqZA52OkB7kqn3W9TlBTohUSm+8aBW7ScdLqQEew71ChX7RF6gpKBI/Nifo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166721; c=relaxed/simple;
	bh=/Vuk9lFfAxCP6Vlq+zESasIWK9BzEEUQ2/Rz9Rzl8PA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J4b6wi0fYoAmubRzH5J3K7vwEGrLlP8FONbDRG7gwEihI/DPPE1Hl9zgRpEuON+0ZKMj8eFzhHJtQwX2EqMM4Wr4h6R9VsC8Hoj/ejj+cAxqUIep08TwhaOpxtAuvfl2vvkkK8hDNfpByuuOWgAyDL3JYZcU51wbyJwFkKkVnZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eYgr1T4Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iD1ska/3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eYgr1T4Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iD1ska/3"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RDlhtj4061123
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U+YhlS0G2dnpct3e4Mp57p3mSG1QUBhWZ1LoIMFJVAo=; b=eYgr1T4Y2evbyMnI
	HisWPI88QUNT3WDKHiGjbVadYFq5A54BbDeHB3y0J7+ZL5tJkmVboUXknQ+qhAxm
	rCK6kvWr0bufFWh+UV2u+6xSa3xn8Eo82fzexHXpUacB6VYy4fas2JxnIm6kTN0T
	WhMOLinpeNVHAUyFu0Gf/4SvrVzbBQwt+MgAk2+9eRL3nP5JWj/NMa23T5Ngf6v+
	qN1Url3ldvfbsUfJMIx7Ht2QWhTqybe4qRTXqMBsdbOyBylQk7S56VrznaQFktmx
	DnEsRJMV7wgLsKa3azw4saYRgZzmi3cnLbKya9M/wKhyRzxZWult3y8UOBBa2Bjr
	cqiw+w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp4mq1gff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:38:38 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c860544c077so6154636a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 08:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785166717; x=1785771517; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U+YhlS0G2dnpct3e4Mp57p3mSG1QUBhWZ1LoIMFJVAo=;
        b=iD1ska/3Gkc6o48Feu/iEiPwJukUbpgAPLkuWmw5dFY/DSpnsWjVn03h6sCYdaLxxF
         QwGSte8qbnCFOiDMVB2wAG/+fd7otpo04Enbo1Zi5H4LqGhVCcqCRgqMPtrflF/GhSK4
         SzPczlyh5+QvDMalmWewqJRjlzHEvb6KLsFDIAG3ilYAm3Xtvx5pNl+U3Kkbj9+Cg+yl
         96ODP92Ub4x6RxXN4ukGFdcX25e8CppdreBXEJAXv9YLqIMW281bkuEUoi1c3B48uPkv
         M7IWe6ZlwdwG4cmD0ud3gSMGcfOEA9XETiT5HzlX0qax8EJu+9l0XS9q0VQMjiqR4E3w
         OrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785166717; x=1785771517;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U+YhlS0G2dnpct3e4Mp57p3mSG1QUBhWZ1LoIMFJVAo=;
        b=Vjf61XnBdlm1vIqdGBNhRLiAsyaRcJfIOOecjQqJGXb76BEic4WcYyQWy5RIlE4UJT
         VWPqdQ5ILEhbo9ykYI+x/HIiJtsy7JOPrGKyCWJvzSpRqTykoh+ZbT28H4jy0fd5Qq/k
         lFIMczQv5oFYUT028La4VJXfwbSMLjYGuoFRyxjK23yqbWm2U13pa68tpiQRAfqAIJCi
         1j6ZGy64mETXKlMEdB89Xpyq2BpXOib0IZxTmMEYRJBIbs5UQPaZWzzWaJnjq/q55FCb
         JNe2N3MFz6QH4lKUoOAb2ym8Ano6pmAev57Gb0SHP/GcGCAR4RAHr+0bZw5xghz/AKAk
         jhFQ==
X-Gm-Message-State: AOJu0Yx7kFb1QSrHbXVk7B9Ug0F9UnM0OjvRt37bbBViq4TuxkWz7W+P
	1q73nsKZ9miAHpfCmcsozNnJ4495g5T8tKTeUXpfs1LBawmNpIiC745Ai/f/ommoE6E1kIVz+pz
	5MmuEKv6qseAM9ucBp+ip9PFuqBFHnY0OPVMSIxFJhtwi1qugJogEQmJdbsj4DonZlz3CDQ==
X-Gm-Gg: AR+sD11FO+c8z8dykwV3gKaALGsqwfE/oYOqlH4v6rLTg6T7BeYY65C4neyJsG1RnPc
	ohIhcCjDEkWCM7Gmxo4mhmroroZg1VXRSIbrrDhyUlzagg/N64ipxRayjaYhSqL6auxLZgyO4Tp
	gCswOKcMrcJbqx4HWQiaMqN/DN0yc+nHlPmI5T/jZ73rYJH/DmlMVTfbEAfto/26oBEl4uWPSRp
	AtFqBJtSoIjYoG3zg/E5iFVsZVXj0GhCi3jYhvUwPyCNbHhS3UIInCh/0gJw3IlWYOfIqFfCIP8
	KJ87MaDbmmJwuG20seB5yl1xr9wqllfR7i+LYTDSbOn6L4KuUvfFUdYm2O8WnnNjxXWHIuQPRB5
	hU0X5HXO66Y2HLqWU0ZnGvB30uarmkIovaYO53L/a73mQnskKRCf00xjGqLAy
X-Received: by 2002:a05:6a21:681:b0:3c3:8440:f6da with SMTP id adf61e73a8af0-3c67daa76e9mr8966300637.29.1785166717451;
        Mon, 27 Jul 2026 08:38:37 -0700 (PDT)
X-Received: by 2002:a05:6a21:681:b0:3c3:8440:f6da with SMTP id adf61e73a8af0-3c67daa76e9mr8966273637.29.1785166716925;
        Mon, 27 Jul 2026 08:38:36 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e5c921686sm17726721c88.4.2026.07.27.08.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 08:38:36 -0700 (PDT)
Message-ID: <da1aa515-58cd-454b-9f18-314732d45913@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 08:38:35 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2] wifi: ath6kl: remove conditional return with
 no effect
To: Sang-Heon Jeon <ekffu200098@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org
References: <20260726133851.1382095-1-ekffu200098@gmail.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260726133851.1382095-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NiBTYWx0ZWRfX+EIO52J+I9iI
 tK98MVEkdleNJlakekxhmg52CVEWrLrz8bQG/xhYsUNfv0pdvJZPBVArcM+kUCMPJ4TNbCPWsWS
 pvzBHUIA5X9M7pKZDjhrADDUBTcVnf4=
X-Proofpoint-ORIG-GUID: TpjPpCQv3ZPMJQ4dULrqs1lUn_6NUrqj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NiBTYWx0ZWRfX/lOyT5e4IV13
 Qv+aG8QsxLDx9L837Fw/7sihc751vftUCP0jSgT6nd5voJ1ZNrwGIh42ECQGQiKQTDl+bAy+oo1
 62stE9rF6QyAu2k5FJxudc0Sa3npq1g1lfaO548fQVN9cZYHWa/c4IAIsIcImDum0BtWf/dkJnb
 YSd8DBPs8jFzNxbrh0mVRBCz39SjKQuNxL0r8eVXmsgEwtYhuydXYxuIZZPmr5Q+y5+DgdpF2U2
 VCitjOhNGxT8I3Z9QtdqCAYf61+iU0TAB/+bVjgRPLelSynS7UQOMfcGUd/nnnzscBIEe+AXfWL
 fbMqmsjbxFbhs5mlSTxN9/vqvDQWoHOypB6lHc4u6ppe3R35NZFKtNqgIG7r/xIeNy9Yvl+ZY0Q
 TN+XHWUwK2w+KOnumDq/sK74qnwbev8m2T0YdsZMV3sagB1ga+Ud/ojbZDwnkdpHX1a7pOGa5pW
 ycNbvppvETKiVhFW6tg==
X-Proofpoint-GUID: TpjPpCQv3ZPMJQ4dULrqs1lUn_6NUrqj
X-Authority-Analysis: v=2.4 cv=TemmcxQh c=1 sm=1 tr=0 ts=6a677b7e cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=QYuAbrt3OfAyO00_B5gA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270146

On 7/26/2026 6:34 AM, Sang-Heon Jeon wrote:
> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
> 
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> As suggested by Ping-Ke, the wifi patch of the treewide v1 series [1]
> is split per driver and posted separately. You can find the Coccinelle
> script in v1 [1].
> 
> ---
> Changes from v1 [1]
> - Split the wifi patch per driver
> - Change base to ath/for-next
> - Filter only ath6kl changes
> 
> [1] https://lore.kernel.org/all/20260723184538.3888637-1-ekffu200098@gmail.com/
> ---
> 
>  drivers/net/wireless/ath/ath6kl/init.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> index 782209dcb782..61fa10d88714 100644
> --- a/drivers/net/wireless/ath/ath6kl/init.c
> +++ b/drivers/net/wireless/ath/ath6kl/init.c
> @@ -1566,11 +1566,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
>  
>  	address = MBOX_BASE_ADDRESS + LOCAL_SCRATCH_ADDRESS;
>  	param = options | 0x20;
> -	status = ath6kl_bmi_reg_write(ar, address, param);
> -	if (status)
> -		return status;
> -
> -	return status;

this make the last call inconsistent with the other calls in this function.

my preference would be to change the last line to return 0 instead
> +	return ath6kl_bmi_reg_write(ar, address, param);
>  }
>  
>  int ath6kl_init_hw_params(struct ath6kl *ar)

