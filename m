Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE52351C04
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 21:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534042; cv=none; b=cPuNTvNJlTorhkq+z4tZ8fPjfAljepqI+Dh2NM+W/h3rnXykLMyJUw57RL/T6mdVNgoJprB1pJhCw83Vv0N1QvZpIWv82nLSRnh2Dkd2kK7EsaBGUk8KmBF/s2mgEWtXVStKqp5v8BGtyTgl6JZpuOej9IZZGAcQwk4aY5quLBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534042; c=relaxed/simple;
	bh=5AnADSN3lppxGtS870PlE0Wne3G+gQ1QIaz+dLYLPkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q8ofpwyLg7k/B5t7GnZDuIw/G+uIzLM9sgdYDl85f6RqtRVAIwYtzNeJ9Uffq6OmeHoCyaMVsuk9psczcNQEC2gG2IWnXHJnsnlqErd0pkb+DKV1Z2KI8Lf41/5EzPicLrxaZffSdyVTZRkeM8MJ8tWYjAwufIcyV/ZqleV2aco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O2Hgka2/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SjYDUTuz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O2Hgka2/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SjYDUTuz"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VKMFXk779117
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 21:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TfF+pTYN4bzorxHULetkdmAKLRCNK78Wfl5RM7zPhDE=; b=O2Hgka2/DcvXYP0n
	TSi7DyP8IpzrQUFXfM19bqtEuhyZml6nY85pJ962DyOL3SfwFSouVR1bNjxgq4dX
	FNi6K+hbjcN8mauUKjJxA+EImpnLYFKuQNQH4WYkc+GQK1vcGH7Pa2gHFxAy3dWK
	QIkv565zqAwxxJ4MAxsgwcrnsgg88I0s/1tymdDvKNseir/0kkPW7DmMXIIoeakn
	jrs/lf+26Nz2ng8gxk7o91enaEqBI46I9pajN52FgbxqN08wzQ3jmFskrzKFxObQ
	1VPBUuEQxVytg7jQOauCpy7e6qUBRf1IH9FnnW+nq0OScd6iTUO2if25umoz4ijC
	zSDyeA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fru2u2j1j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 21:40:40 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb92868263so1811739a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785534040; x=1786138840; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TfF+pTYN4bzorxHULetkdmAKLRCNK78Wfl5RM7zPhDE=;
        b=SjYDUTuzUqJsb4B2+fsyfJvDgY4K8wjNp2qgKyPXOJXAxfOuRsdqqovse2AMkC+Lg9
         51a+0/+TGSVmKD/Hpj+yAM/4G/RnZ9ZOBRnc+J81OOmUv/2ZmGJ+VE39dns42FTjEjOk
         x3FOaJ7QknNig3PZFE8HrbzOb9EqGu9O/zygKgjhvaCRUpGDMlnDLxCcK3l8x5/CdSLf
         Za5fpCd+kg4Xq77rH2a66mHjrIVFrGYA2mg4ZaymvJ09bhsc73cihWOFcQNKrfcvHgF+
         wan4pCgvh4DxCuVp2hRwJ2ZGYIorQMzqiPMhhYCzzNzRjuCap5r0vZebxrA/7ftl+1Ga
         IQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534040; x=1786138840;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TfF+pTYN4bzorxHULetkdmAKLRCNK78Wfl5RM7zPhDE=;
        b=illCBCgEFle3ch39Cim8S+U74Pnh71VsuFpKS4s8C+fWUs/uxj3xn5bNwHgrT8zV1U
         UOJt+Op1Spw8R9OaTdfALhojwNKCodLl1HEIjmTSGavUiElXGnIidTqHp1KKWCWeymp6
         sKucMw/U7T+hVGRO2LM5cMILWO6PCa6vMHeIJBX0IHJzpNzgh0qvQoPPUqiF0HZFPXNs
         OdLE+RK/9cM71VHp11bf+RlKfFTD9Gipey+KEqQdzn39JnEPlFFgpINWLZ62wtu0+rcu
         Mj8ESQDlZgaujzAkB/U1wiI+AMoGKhI5VzKTOFgM7Ee6/t6jcCe1IpsuO+o1QZaqaUwU
         XvFQ==
X-Gm-Message-State: AOJu0YzJFuIBmpuUTe8H8CC9DhfTcPWPok3EWMLKjEDkZx1MI2D4hK2m
	RP1s00vTARUWKwSY86ieGN0Zcv2ff5HyJbJJWx9CL5DNKf7NC0AATwcpfLAfjGFAearBy+j5oLT
	GSuPbNcOSJzIMXMlrYv3qsB99ft7hCwar86Bf/4Wh6Z6fFHASUlQfr/Uv0D9QzKxhuQgORw==
X-Gm-Gg: AR+sD12Ea+a4b/whlxuW3Hw+pDi+KqFp9w39JqVuHPIimpp4KofCivInL3UAUy09BuH
	dOIYwZ6bsXL0XSF6bpcrMGHbV+JykDkVGysTZLVwmh1eUwil3Dm8oS6WdJWb+SpKc+u+lG5m9xO
	GF/E2cHct5ZqnL5Nl0EsceeAaH2EsSaMXnK4s0RlEIz1rV/rdeiyyQR65j7UGokcyz6A91qflpN
	UNH/p6XdXCWS/QrADJpqfuykCvz1JSd1DbHRoja6F3WM4MSMq7dP+MkaKbGglOhZJKnIkLQapan
	/C3+1qP8vPyDAXymbf6iVVYip2vdjRuNCWfTUmSVAyOlRAJYVXo/ipZQy7CWrdzLgHizJOYh8Sn
	0I1tCbVz+jFJpXOxMYZ/TnNE7UhNCsZXxaTBrIUkwU2FYBXoMxOVoOR01PMU=
X-Received: by 2002:a05:6a21:7489:b0:3c3:7019:64ad with SMTP id adf61e73a8af0-3c92a8be664mr1143645637.66.1785534039853;
        Fri, 31 Jul 2026 14:40:39 -0700 (PDT)
X-Received: by 2002:a05:6a21:7489:b0:3c3:7019:64ad with SMTP id adf61e73a8af0-3c92a8be664mr1143630637.66.1785534039429;
        Fri, 31 Jul 2026 14:40:39 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e47dsm13643035eec.3.2026.07.31.14.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 14:40:38 -0700 (PDT)
Message-ID: <041f72ea-7dfc-4d50-ac0d-e0556f037a27@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 14:40:37 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: Fix possible memory leak in
 ath11k_dp_srng_setup()
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>, jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260727105532.118164-1-nihaal@cse.iitm.ac.in>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260727105532.118164-1-nihaal@cse.iitm.ac.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: aiZwXyJWAKyvG5tfWP0yBvMkbboxPO08
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE2NCBTYWx0ZWRfX+frOspIOemMQ
 Yiir14iEQFNAkq8wgxepZP0thfriUVgfQKdkvLbJlnMe5PvUM6IqEa3Umynrulf4TxTicnwqDw/
 qIKewnr9Ulek54ITthEXnEh2iiv5FGwuGk+HL/ZXdrR+xPCgjBJZnGnXt8HLeYnckt2yFfveuLi
 Nq0knzfP5vwGO6dtjw+G9WGoxixuwTtOJdFqy13+L0t7hbKpKE9igqOcfrOo2rYgvogSTo6A1ln
 3+WK+aPQOskZnkDZv4/o8XFNPsu5SO6l9XqpHPbhnQ1etHWKcUrpkQkr40iqvaJfF2FB89/iwHP
 m/6ROYJInx2BaqRoAA1gNwPP/2hV+dxm69Z9+2OrOcai+3XZQK5ehR0Egpmbq7TPh4NvxuaHlVP
 KZ7FJUmJ7lAORO9QQRH6+QCIBeLFjYjPfGMxfsVIqJHtUs029Vk5Dx0+hS5YfwzPvRA+H9z0qrn
 fAJHKjGVKi4hFDpSEqA==
X-Proofpoint-GUID: aiZwXyJWAKyvG5tfWP0yBvMkbboxPO08
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE2NCBTYWx0ZWRfX0RybAjRzmKRk
 qCykLbO2LjfdrdVrhzWVzcfaHAsC9ESOWVmy1Q08w/QRIkDxPyJoDYtRZZCcvBD5p64LFo2rHm0
 zDhtK2NSrnii5spckETlCxehUxUWjy8=
X-Authority-Analysis: v=2.4 cv=b+uCJNGx c=1 sm=1 tr=0 ts=6a6d1658 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=FZ0-UiQHMHqYDEnaofEA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310164

On 7/27/2026 3:55 AM, Abdun Nihaal wrote:
> In ath11k_dp_srng_setup(), the memory allocated for
> ring->vaddr_unaligned is not freed when ath11k_hal_srng_setup() fails.
> Fix that by calling ath11k_dp_srng_cleanup() in that error path.

Did you find this on your own? Just want to make sure you are aware of:
https://docs.kernel.org/process/coding-assistants.html

FWIW my coding agent says this patch is correct but incomplete. There is a 2nd
leak, at the switch (type) default: case which returns -EINVAL without cleanup.

Care to incorporate a fix for that in a v2?
For that part you can add Assisted-by: Claude:claude-sonnet-4-6

/jeff
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> ---
> Compile tested only. Issue found using static analysis.
> 
>  drivers/net/wireless/ath/ath11k/dp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
> index f389b97acbdd..c3a16da1cba7 100644
> --- a/drivers/net/wireless/ath/ath11k/dp.c
> +++ b/drivers/net/wireless/ath/ath11k/dp.c
> @@ -324,6 +324,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
>  
>  	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
>  	if (ret < 0) {
> +		ath11k_dp_srng_cleanup(ab, ring);
>  		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
>  			    ret, ring_num);
>  		return ret;

