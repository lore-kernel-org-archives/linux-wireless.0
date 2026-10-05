Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6AA4AC159
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211086; cv=none; b=tKoLnTd886bGmOrjoK7p4wiQ6/XiUSDsQzY4O4Gt7h6bXlFTKFDIXQi6TKiW/ggqP5+2yH/0+niXziRx0CLiE8/xwhu8psIfuiMG9BWmpA3Ilb1huF4RS7dj/M7k90uISYfenu/3Lp+6bz77joVPB69Gc2b/rafKpBOpWEja1Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211086; c=relaxed/simple;
	bh=2SzhxrWuyWL8OXijp7aZ7p5Wq1jUPOcr0yrxzKmNLyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZD7zpChcQwfgALqcxGKHBnCQnI1bNGMDHLQB5R79vHMfUhR5iNScQp5XHkGm6Kvh4fS/NOCMfWDQDFDmxR9rpsbsHoOjJRYhdG+v9sIxijOz9BXIGra6h1yzVZE8ZagGoKzoYDezyS7VK7e/CnPWDs5gxqT9s3HkFXCpq7VzBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JOW+uXb3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Zvx6oON0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JOW+uXb3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Zvx6oON0"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP51h2214862
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 14:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2eIAsOhaVPTC3xP3VsP6J8u+4Zt4CiPhaYh6vvOX53I=; b=JOW+uXb3RPBy2i2f
	k0Rq0bqa9hOX+IVfUvD9Hc15GGu/Shfe8BhdR12q0zA6YCSS3XOOc6qgbspcAAxX
	etRk7wp3EbCbLZm7VgWZNsoOQMND1Qz6cTqndtdcG8k6t4z6aMomDkQmcKbMiOgW
	aUjlNuZU6utIH9HRoTVqNxQPLhVE76omG/uGadDW6FW6XS+eCGsIiBALvxMnDChE
	36WlmRAX7Ru0QtqhJ7eDOBp2uCZtlOiE2SCO4BPgrWAPWoNNl6gpN2nGep1SwiOp
	LvcRlmt3FdYmy8DhzMsDw+muG5wiaZNbEhqLy/JX7RLBoMSQXLrAR998KYFW8ZPR
	i70CXg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h3xgytmvr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 14:37:50 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39b6416441eso2796229a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 07:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791211069; x=1791815869; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2eIAsOhaVPTC3xP3VsP6J8u+4Zt4CiPhaYh6vvOX53I=;
        b=Zvx6oON0bfWFlX+u9Yl8Ma6aHmTWwBKrRRF3QW6/MCtpykVGhjdCWyrZ8AtTT0qjRQ
         O+X7h1tKaqsGGY5DT1aZYdQ0nR6wLE+0NXyX5IzHxPjNG5JBd3MbndVHqh7QpiCS7O9S
         /TokC+18TUw1al4Mig1Hk1SPcMDWyfkwah2d41qD/KJwcMTUFkJH6X1SaRxsj6JqVqRm
         u3wkHs1u1Xp76bAOU79fdekxa18fMV7HZDnYA+/T/kobfJeDu0bwqnG6LxQz1r4EpSPO
         SZ9VvidD65hR+kmOfJYFtV/e9ckQz+6dwp2Leem8XD42eS9Zk3qSF9rw4E/JgwHPH6ts
         6QCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791211069; x=1791815869;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2eIAsOhaVPTC3xP3VsP6J8u+4Zt4CiPhaYh6vvOX53I=;
        b=ZhEk/jHXEkIZYseZ4rHzrhD/6KJcbdKGk+purF6K4xoeNhZkIu7NuiZHx1jUc4cnsG
         3zmYB3tOPYQxkCmnoajsfVLznHx9rDN8RCyb3iJxyHYV4b2xrogJlu0LNjgiHccYL+CH
         my0UMwLHC7iTZDMdqZ+TgNsViJOp/1jhR8+kAzsNQmMqncknHZCD7OUQ6ifz+9kBLxA3
         MdhABj9LqE2OQVh//kKXMV5NNqGdAvXP1LhMpT3M4tBehak17RuZS14Fyh14VcYKyET1
         kELRS0rjZzvwuJf/ZSuuT4JMpIZG1lnR7QTfdyqltGJdo3BIeIjGxcPiVXAGFkbxkwqo
         r/SA==
X-Forwarded-Encrypted: i=1; AKwUvByh/PxB2NiHi8whrISA4OQKgqA+fvz0MGaAQRWr0xyK0FTF4IOC14fomgJEfCo0ZYm/fOcZjGtcz0n8yZUr9Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYIGWf3z4KCHm/VHjGI98GVGETEMtO2xiXrnklzYx58zEU8TyEeP
	xs7pIv5pEIyD4qYIkukKZizir8+EZWt0/b7CFGbEzE/EQJbGxco6VRYUORRjLBhS+yHDs95bk2G
	IBgjDN0M6lfKzYdqSoT/fy6VspuBSdZNqzZKC+ucpqnPJQ3bsEejyXPKulgiKt9rQ4t7jnA==
X-Gm-Gg: AYBFou0WSF8ANVWcOrlNNaxOBMxO/9s/rJwGe0TTaRoFlOpnYHMFZQEMEAeUlW+eS3T
	WL/JhFUZ2x36X6d0qgbaB7C90P4CTZ0R/9lbIog+dkUXaeP+36HJDnQjKn+m+NNvb0EB9WgS58G
	fbRFyqKyT91lfi28XYMGE875x8VJIKT1RVkKix6cy+vNRioWHQKJDZ8+fit/3667uI2cnjIN+Xm
	vYvi0a64SE6llruPEQAbz5SE3ImEhP+mRs2CC8p6nULtAKGxkGd5d2rv0hBk2ov5kJ8bxsLzl+Z
	qYx1Tws4tazyefW/6fVJFYCL0kAwvEpKCtYFeGDMNg9XDOz9iwimA4LZ3xAPBM2gbO3oulcOPU2
	tzXpL/BOdvnTSN3zllUQFFsGkEcswGtVIJiIZFhhLqiLIwnuvegZE8H3rTw==
X-Received: by 2002:a17:90a:e7ce:b0:3a7:8c68:6446 with SMTP id 98e67ed59e1d1-3a78c687f95mr6625966a91.63.1791211069321;
        Mon, 05 Oct 2026 07:37:49 -0700 (PDT)
X-Received: by 2002:a17:90a:e7ce:b0:3a7:8c68:6446 with SMTP id 98e67ed59e1d1-3a78c687f95mr6625943a91.63.1791211068860;
        Mon, 05 Oct 2026 07:37:48 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a6dcbdd97fsm7594125a91.0.2026.10.05.07.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 07:37:48 -0700 (PDT)
Message-ID: <d791e70f-9c3f-4916-94de-8d76517339bf@oss.qualcomm.com>
Date: Mon, 5 Oct 2026 07:37:46 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: skip hardware rfkill setup on Microsoft
 Surface Pro 11
To: =?UTF-8?Q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        =?UTF-8?Q?J=C3=A9r=C3=B4me_de_Bretagne?= <jerome.debretagne@gmail.com>,
        Dale Whinham <daleyo@gmail.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261004165132.4313-1-franzelfranzel@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261004165132.4313-1-franzelfranzel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: a8Au1zQpMTfEW4uDvSpQWqnKuEiQiJ7P
X-Proofpoint-ORIG-GUID: a8Au1zQpMTfEW4uDvSpQWqnKuEiQiJ7P
X-Authority-Analysis: v=2.4 cv=A6b5rKWG c=1 sm=1 tr=0 ts=6ac3b63e cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=7PQHMOqyCB17KHk-lU0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1NyBTYWx0ZWRfX9B/kIVQBkZCq
 ULaispJTDneqMu/fsWWkvvQO0QiGZDxXToA9cQY5O7zNuoc+GDfKDSaZu4Ty6AOE9DmHqTuGQnW
 rptS63YLHq+1/w946Gu9LJDcBzKuFk1oED7mxGgxsuFCQEtxEwKK1xiN0f2huNUtVNt/PYw79y/
 jVx81i7LjYYGO6T+/2Zfin9GpZMBkHA+FXg8u8Mp3AASMOZYE1/NVMiatwn4XJ8OSy1YrnAFJL6
 dg4AXe+oYwBTHdFstgswogiukd0dktkaGGoSy+TY/Q8Q/ezGODHHVCVXCsVYZM8vY8TVfgkayNg
 XdrmcImojA5IRy2aCqSaXnmSytts5hACtFM4s0Dynj52Na12MxYA5lLflC4m055PnVEgv9gFC7V
 hv1FMAXe19N3WTC0RDUipKjvPVYPkBU9e4Z8CPK7vr2VS9WB1zzy4H/2H1cawBNv8tTDG/9C29F
 5UDiPqZt6xPLor53/rw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1NyBTYWx0ZWRfX4V5uN9zVulrL
 Fcb733MgBSeyLQvjVlhJWRrhApxGHD+JJXhZ87Mf+5+F9fBn8Y0EdVHfW/fD2j22WSK+r5ZE/e3
 iulSC95XOcHnCdBlOIwFGgDZi6LWb/I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050057

On 10/4/2026 9:51 AM, François Roux wrote:
> On the Microsoft Surface Pro 11 (X1E80100, "microsoft,denali"), the
> WCN7850 hardware rfkill input reads as "radio off" and the OS has no
> way to control it. ath12k enables hardware rfkill handling, so Wi-Fi
> stays hard-blocked:
> 
>   iwd: Error bringing interface 4 up: Operation not possible due to RF-kill
> 
> ACPI platforms can opt out through ath12k_acpi_get_disable_rfkill(),
> but DT platforms cannot. A DT property was proposed for this and
> rejected, because it describes what the OS should do rather than the
> hardware. The suggested alternative was to handle this machine in the
> driver, keyed on the board compatible and the device ID, until a
> connector binding can describe a broken rfkill line. Do that.
> 
> Tested on a Surface Pro 11 with next-20260929, booted with the
> unmodified mainline DTB: the interface is no longer blocked and
> connects.
> 
> Link: https://lore.kernel.org/all/2ixwny6hzumlqmok5cjwutvtk7nzmx4t3dhxc44ao4l2u755pj@n6m7jyxf2o62/
> Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
> Assisted-by: LLM
> Signed-off-by: François Roux <franzelfranzel@gmail.com>
> ---
> This replaces my RFC series "Allow DT boards to disable WCN7850 hardware
> rfkill", which duplicated the disable-rfkill DT property already proposed
> and rejected in the Surface Pro 11 series:
> 
> https://lore.kernel.org/all/20261003091509.4822-1-franzelfranzel@gmail.com/
> https://lore.kernel.org/all/20251220-surface-sp11-for-next-v5-2-16065bef8ef3@gmail.com/
> 
> The code is Manivannan's suggestion from that thread. Jérôme reported
> there that the Surface Laptop 7 (microsoft,romulus13/15) has the same
> problem. I left it out because I cannot test it.
> 
>  drivers/net/wireless/ath/ath12k/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> index 0c72948f3..dc41a2a7d 100644
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -83,6 +83,16 @@ static int ath12k_core_rfkill_config(struct ath12k_base *ab)
>  	if (ath12k_acpi_get_disable_rfkill(ab))
>  		return 0;
>  
> +	/*
> +	 * TODO: On the Microsoft Surface Pro 11, the OS cannot control the
> +	 * WCN7850 hardware rfkill input, which reads as "radio off". Keep
> +	 * hardware rfkill disabled there. Ideally this would come from the
> +	 * connector node of the board DT, but that binding does not exist
> +	 * yet, so handle it in the driver for now.
> +	 */
> +	if (of_machine_is_compatible("microsoft,denali") && ab->id.device == 0x1107)
> +		return 0;
> +

my preference would to to break this out into a separate table-driven function
so that if other devices have this issue they would just need to add to the table.

reference ath11k_core_get_usecase_firmware() as a table-driven solution for a
different device-specific problem (selects different firmware for specific
compatibles).


>  	for (i = 0; i < ab->num_radios; i++) {
>  		ar = ab->pdevs[i].ar;
>  
> 
> base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
> prerequisite-patch-id: aafe3fac38f4020441979665509928f8cc832095

