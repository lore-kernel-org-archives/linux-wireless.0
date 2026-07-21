Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33A239C63E
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619101; cv=none; b=trr3T/PRP3oZ9leNnjRcoz8tDgY3/CZNW3w8B71v/MkMWrF0qAprJ/2TLYlp51JtHuhrkF2vaoQ3AwHYiOWHcQtPhuLeU5VisHdeQgtYz62isMdEL0T3MlL4NT/sXupigjufnNqBAXmbDW9jnIU02IE4/CEwMAHIAXUDGBDyqcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619101; c=relaxed/simple;
	bh=2OqGIlQ7AXaq6UnK3oefUdAe29i+IEinh4N7XbfRfh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ljsV7afkWeMIWqMXslNm0PZK8jeP82O/C7smhISx8aQ2q0Egi6pGhHxe1wamoxeGOmHh+glozT3WDlQOhntbg9v/H3EJgUkazDjeZvSF9A2WqDjtkZ6BMQVYp+1002xWYaOsTty7K0ZY03rt6MbAL7c+WnNHMPQXPAHktOMwpTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TZLZGgV6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RZk8+j0o; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TZLZGgV6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RZk8+j0o"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L6GaQS3978349
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:31:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ntnjqm0Pf0kPnyvZ9KBXYZLnjPI7YDr962+n8joPkXY=; b=TZLZGgV65jkzgNKa
	5B3mWY0R5gwfb/dC8damsMJB+oPCLTESp63P6rVG1vuStaY1c89SuQNKsHweCANb
	z4/wpwbK8PXI769Ov/FK+68z+w2gutZf7LM1WhsKQ7+gmQXOUHUCENwhtWBQh1wW
	AZHaE56hDB7m6p6yKtUUBZpiQJXCnco8WtCAWA/ytbCyKinA/Zb7ZoutyKq19C6e
	nEgNzkQ1UphRfKBtFbAb5B1ilqRPsDYzbNQ0KSi/gWIltwkZQZqDfHSBjqFs2UAX
	Ir6s3hRwg2Z+lo51g11jtx4Z+66eEfTDSEWv3lZ6dWvQdoBjakz9DUOQkW8U8Z8v
	u/FPZA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhqv43177-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:31:38 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cee894b3d8so145125305ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 00:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784619098; x=1785223898; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ntnjqm0Pf0kPnyvZ9KBXYZLnjPI7YDr962+n8joPkXY=;
        b=RZk8+j0o42Ai1o+MiWg0JNYgNZRGRcE8JDlhuq7P6sFLkn6w45vHI7Mt6B9NI1g8oZ
         jxqSIxLfd3iIIIUvwDPrSZDsqlECFnS70XJWRV7YkOV44hDWVf7nVoYGyn9ErGt4OgjY
         sK/6L/wjzC8A5hVv2XF7lOAt1CvNNdwk7093uLgBtexNCKytdfwJCYhcZv+HXm3UT9L8
         fosFubozDO8UmDJviKBBCjhq1VJpV9yq1kx/AqYNkl8pTJHDYUNhNXrtC/QOColjvARo
         XKHlOXKN0P43gA61SyLVW2tdT/oDS+zIDhqsXMl+ciwxbgiv0uNWmgi0VVQ0uT8vrkZY
         vGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784619098; x=1785223898;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ntnjqm0Pf0kPnyvZ9KBXYZLnjPI7YDr962+n8joPkXY=;
        b=gZpQDBzyBG386HkCx4NAfEUBlMSc97Ynz2NjDPBMAZdb15O+4XWnO4V27kUT+AIC2s
         de5jc11AvTeSyzd6NCGWG4PxnG5tIUXPt7m/+rcn2RH/KRbrnRIlFo9XKB4G/0gvIj+5
         n2Oqst9Vge2ZM6bcfZ/qqcI0Lnte1RC0dL00klylvFT7n2tFj9jRNqK6NiKTYMUE17vZ
         z/2TZYAvizZFOGIg9mr96f4RF5P0KiJHCwRYH3rOtywwMllYA8Kvw//rOXRYtASPSfXS
         SEOGz74oNiVigT5Xe43exb58aKFyIfwIhvJQ8XA00PeIZMmeAALJVWLdOrIdyQuR5fPM
         9F0g==
X-Gm-Message-State: AOJu0YwuDnBYgevEzU8qcxwejil1Vs/GI9pRckMXYllo5/Z3iAvvdWA8
	CzjQb9R4A1rnSL7TAj6Pp/EmJnDRqjFxoPL23OU2NqykBYg4zJYAENqNfYR2+LyvvVJzW6tcjpt
	qk52aOoNjMHJy01TYSSN8BJaCdb8Qlj1NMkI9QIUzE8e6L48Ow6Dm9h3uTaGZ2vR7j66czw==
X-Gm-Gg: AR+sD129HnxPz0Hcg51ynGKdDH4mdSZk/BajlXxPFqGM1ZWRrmx7KeaQzgeiQ80mO/K
	eOFTfetPrBGRopttwmVk1QDEP+q9Pl4BYttkJ9R/b32fe4CtDzCnNDilFbVhay/PRxa5KJmctQ/
	L/ftCoQ7MJ6a4EW0/mcD4RIko2IiUizr5V8t+0HWEM3NjFUmxA9ptoedvlKMVVPtbMwpwRws3Fi
	3XoZMM6RDVNk30UhB+9XxqUHT8uE6wFP4fqq2wpicmIYgGW6jnJpTrkRPhABYNINz3zzybeLU23
	iwrVn1UagC6B2Y5oEf1MmBIc/geDKlFnH1ol1LbjsQSvZNwQX1ZEFeMYvF6vaAp+W6SCm9/kUad
	n3oGwgmAdro9dJ1rg7iyeqGotPWS96pw4QNyLrK92vi90R6QFW36ujJoczXH/XhTw+HatYLd7
X-Received: by 2002:a17:902:ea03:b0:2ca:e19c:97b with SMTP id d9443c01a7336-2cf34832689mr191088735ad.5.1784619097606;
        Tue, 21 Jul 2026 00:31:37 -0700 (PDT)
X-Received: by 2002:a17:902:ea03:b0:2ca:e19c:97b with SMTP id d9443c01a7336-2cf34832689mr191088455ad.5.1784619097036;
        Tue, 21 Jul 2026 00:31:37 -0700 (PDT)
Received: from [10.133.33.82] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf342e3a8esm71116085ad.0.2026.07.21.00.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 00:31:36 -0700 (PDT)
Message-ID: <2a297c38-4a55-486a-ac4f-898158d05599@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 15:31:33 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: restore country code during resume
To: Stian Knudsen <stian@pokerfj.es>, Jeff Johnson <jjohnson@kernel.org>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <df37460e-f8ba-4e11-b412-4aa8b17cd32e@oss.qualcomm.com>
 <20260720120913.100604-1-stian@pokerfj.es>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260720120913.100604-1-stian@pokerfj.es>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: yUy8NGyR7cyf9Fd8ilLgjl5tcxUK9NGM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA3NyBTYWx0ZWRfX/mGzJDxVX1yt
 oVipTpTezvcR6/SBe8w+zVHjprpO2eAK+2PgRKMjryE3C7Z1zvmpkBaiPAqPamuEkpTyh1nuyx3
 ql7taDucpImU8Pg5kmGmNPs8idsEqdpF1ryB/sr0K3xDi3AmksXSCcLAitWbbpxfIDQdv9NQnwM
 HfKYT7dirbtG8yNSiHYP0YG0+knS886qOMPIu4Kaa6XhaA1lleAKZqYYnqGW5cPcoP5hIuxhFm6
 CfpTbibWyURZoDTDIhdI3eL7XJVeh9l6Nrj3EJGri+W0hLUJu8feDHrZmaL7RaK/PSsOVJQ9APm
 CwA8zAEMG18oofKRzomjtbr12/jp0XfmBUFZ6cTgV8L5P14dmDA+7MGtUZ8bkSl8W5s7dblcFlt
 o+2+NOOMr8rAf0alj7EShdciOptR4u0HDL7fgJcRfISCTA+/+eVDvHiY6d+4i1XeilcNZyY2kaR
 fWc/9TMljENQFnN6+6w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA3NyBTYWx0ZWRfX2p2xE3xQGs45
 Gd6G86cIPdBA5hJscXPqtM8tqT5WdfDhe7gF6/R+aDU8S7IbcQQliR5svar5VYYqXU0zu7c9D8g
 wZFwHjLthqOyUjZ1w032re8/yQkvOTk=
X-Authority-Analysis: v=2.4 cv=daawG3Xe c=1 sm=1 tr=0 ts=6a5f205a cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-SOlkNUPErW3LcS7OYoA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: yUy8NGyR7cyf9Fd8ilLgjl5tcxUK9NGM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 clxscore=1015 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210077



On 7/20/2026 8:09 PM, Stian Knudsen wrote:
> The country code configured before suspend is lost after resume:
> the device is powered down in suspend_late and powered back up in
> resume_early, so firmware reboots with its default regulatory
> settings and the previously set country code is no longer applied.
> 
> On WCN7850 the firmware comes back in the world regulatory domain
> (country 00) and takes ~7 seconds to rediscover the country code
> from AP beacons, part of a ~16 second total delay before wifi
> reconnects after resume.
> 
> Restore it by resending WMI_SET_CURRENT_COUNTRY_CMDID during resume
> if a country code was set before suspend, i.e. when ar->alpha2 is
> valid. This follows the same approach as ath11k commit 7f0343b7b871
> ("wifi: ath11k: restore country code during resume").
> 
> Note that only single_pdev_only devices support suspend/resume (see
> ath12k_core_continue_suspend_resume()), so handling the first and
> only pdev is sufficient.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 8d5f4da8d70b ("wifi: ath12k: support suspend/resume")
> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/-_iDJ_M5RrqACWB0qmtleg@pokerfj.es
> Signed-off-by: Stian Knudsen <stian@pokerfj.es>
> ---
> v2:
> - Add Fixes tag, per Baochen's review comment.
> - Link to v1: https://lore.kernel.org/r/20260717130254.36732-1-stian@pokerfj.es
> ---
>  drivers/net/wireless/ath/ath12k/core.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -197,6 +197,7 @@ EXPORT_SYMBOL(ath12k_core_resume_early);
> 
>  int ath12k_core_resume(struct ath12k_base *ab)
>  {
> +	struct ath12k *ar;
>  	long time_left;
>  	int ret;
> 
> @@ -211,6 +212,26 @@ int ath12k_core_resume(struct ath12k_base *ab)
>  		return -ETIMEDOUT;
>  	}
> 
> +	/* So far only single_pdev_only devices can reach here,

bad block comment, '/*' should be on the first line by itself

/*
 * comment start here
 *
 */

no need to respin for this, suppose Jeff can fix it.

> +	 * so it is valid to handle the first, and the only, pdev.
> +	 */
> +	ar = ab->pdevs[0].ar;
> +	if (ab->hw_params->current_cc_support &&
> +	    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
> +		struct wmi_set_current_country_arg arg = {};
> +
> +		memcpy(&arg.alpha2, ar->alpha2, 2);
> +
> +		reinit_completion(&ar->regd_update_completed);
> +
> +		ret = ath12k_wmi_send_set_current_country_cmd(ar, &arg);
> +		if (ret) {
> +			ath12k_warn(ab, "failed to set country code during resume: %d\n",
> +				    ret);
> +			return ret;
> +		}
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(ath12k_core_resume);
> --
> 2.50.0

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

