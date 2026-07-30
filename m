Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF448989F
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404419; cv=none; b=RtLOBgjt2bq4bzbqH4wpQjL+plLXK0m34m90EkgMWaG3XZmGYoVhZlyKqDlZCKFCKUgmdf7FTERJRRDK6bo2qdECnjVCHRVACgHqozlthwHu7qZ/ehsj8AOQwXxhi3ccq1Twp6lJoRR3uYJ9qY7SH+FAd8X/y8e6wjcb/v3UH+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404419; c=relaxed/simple;
	bh=Ck//C12qcsTvf62Tmetpp/Nn8MrhL2ZrnyrPfA9mmLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cmx1LmAv0f8o1lA9MAwpo3HzhUsimYLmkxB/h1NmPyh68XW7jO6F2SfJf/T2DT7wa+W9UMolicAr8qFY+JRZLSnsO/txyYgHzYh9gaQb1EedSnSNJ9ViWFHLUqlElt4/TlGWXHkT6/A5btdR2Hf0TSA+/jfEaZ/9uAST76qWYEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bXUIdCHC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X88UAO9D; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bXUIdCHC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X88UAO9D"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U9FlBa4082086
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SLtB7ZyF+St8HvEQIEPSXQokiGSbSWKZ1j1xEWjE5uw=; b=bXUIdCHCloInmJzK
	D0RLBMyh5Un81bUrPpV9xp7qOQIT7jsaZ92rqktWj5yUxQkungApBwCZTkyizrHr
	v7MqZvwKOryuilb+H1NwtD8C438Km2BtzyMApw++2TzQzr9qGPHkOlSFxFNZ8zRO
	e2ZabGc9XX/wA3JHtly9RHIiYn7FkWmrc7EWFCO//zf4IFkZfBWHKg8Ohw1uq8zT
	ZgTcBmw7XSElvqh940rZJyuwS/ig/O7TJ/IjnOlozJdiKs7+g8bsqy8zSvLT32FF
	jxLbiScrVQnKtF8i+8beb7/Moe0n8jJd8E3MGQYiBHiX8v0XooV37HcRO/XtWePN
	9OFBWA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr3tyg3ht-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:40:17 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb835525b13so2554200a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785404417; x=1786009217; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SLtB7ZyF+St8HvEQIEPSXQokiGSbSWKZ1j1xEWjE5uw=;
        b=X88UAO9D3T8xu6HZ7WebRxyqqynRzgCW7tx6Le1ofK/ViChQPOjoMu4YNxTmop6r54
         SBT6TitA/aSImAqPyDbK3Zx+WeXgV9FD2EKrOcr/kqwool7sX6WHnkJqQ/d8wYnrnwPZ
         iwyCPxp21Nr/X1E49kmv4HSNeDnxNvNDo0RXbBQ8T66WFyhPd+kfwHzIHdXop4CbIQHo
         zL7Astz0Ya/rKwjrlLh2PZkp48A/K6bt+wp9xN0LTFPB6BkXx/bqB0QZVcNpa1sM7JNf
         hV8T9nfXY/AcMiMMLj0blH0tRLFvXHoAgegJ2TpOt1IAN5TTnsYSbbAlIyQIyCHEK0Px
         bWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785404417; x=1786009217;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SLtB7ZyF+St8HvEQIEPSXQokiGSbSWKZ1j1xEWjE5uw=;
        b=BBBROlYbdsFAJAtEPzPsFu0r9BYhYyYGdf413RJxuilALzvSSMiXxdIOMZsUMZA+mz
         o0U/1Rrzrc6RobLyiWl6WeDwdaWHgZdDNJ6fzCZlLbAHNH/gfWNGPP72yPha6oOeHRKL
         ETgiWJTMevI/yvOu7ROdKnWB+XQUz0zpreL9cdxhzsji5Iy8BrlP74qWXcTiEZkwY5Ka
         jn4mRrqQre/1YIem1zZXGdzcbKZY4btSLJ+17fqMwfqnD1C8ziiTGCl+CHmmbRoH43at
         4jQYqbxcREChPp5/9Am6RuTZKbdh1Wy7U2TayGxJ04xEDnAKz7rXy9m08Tr73XMVeb2e
         WOuQ==
X-Gm-Message-State: AOJu0YwuaGe5k2TvZADxI8AfL1vLq/02e5mx3H7MOo1srDoC+N67cbC5
	aZYGBZFN/VCxC/oOMNcNoUN+KYFkYLwGW4xoOjxhwcjjUpC1wVhlqvI509ur/4yF8A/1ujZWjcb
	73oEToAgWTVWxvuhZSX3zI78Y/y2A42+PJG0OcVxXL+TywJKy+QC6LoX0ofWDyh7Hpebnq6rRbI
	ZtmA==
X-Gm-Gg: AR+sD11mB6Xbb9G86plJRIMWQSUGg6Q2DP0McmJSn2euv3ANmo/91BXU3dgWaOlsy0+
	yXnPwr/YTNNJFjuQLTrjx87WfYmDcjFGuBuakHBcvU8GDyVeUwJt3B/Rit/hfEY+xVt3zkJrJZ7
	Fpt36WRykJQN1Y6aLMiUDQGRMSPThwSDPZ+f8KObYZJeutU0u11+YC8MQzpctwgzylKQEIR6kRA
	yMUCy5v02sRCSEw7KIbeLSoSzeognfmL3JEyKvoBqCmnT/4k3RXtIwDA70yDQcTnsnnl0ylXq+S
	mRRTq51Ijm/88Acdbqksg/ISks4MwPbx2yu+JaxGlG9y5jESpApY6oUddBszEhSpY0ODrTxzU05
	6Ol+zIbUFSlaKnx3C83YVUB15gDxAMu+cIXDwOJ6D
X-Received: by 2002:a05:6a20:9151:b0:3b4:605c:2163 with SMTP id adf61e73a8af0-3c9006eec4cmr1947286637.4.1785404416702;
        Thu, 30 Jul 2026 02:40:16 -0700 (PDT)
X-Received: by 2002:a05:6a20:9151:b0:3b4:605c:2163 with SMTP id adf61e73a8af0-3c9006eec4cmr1947260637.4.1785404416274;
        Thu, 30 Jul 2026 02:40:16 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504927a7bsm20870779eec.0.2026.07.30.02.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 02:40:15 -0700 (PDT)
Message-ID: <e4577641-45e2-4a2f-ac37-edf35a749f64@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 15:10:10 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        ZhaoJinming <zhaojinming@uniontech.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260729020005.219253-1-zhaojinming@uniontech.com>
 <5ba0a5c3-7009-4e9f-b5b0-11ec79469451@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <5ba0a5c3-7009-4e9f-b5b0-11ec79469451@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: JSHU3a533twioXyYnYT6e6j_7jq_XiRg
X-Authority-Analysis: v=2.4 cv=JZOMa0KV c=1 sm=1 tr=0 ts=6a6b1c01 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=GtBE_Bw5yehhu0ekGRIA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA3MSBTYWx0ZWRfX9D2UlYY8GAmC
 WIzphyUMPnSTuEtAGH4epdbXq+HsQgN5AqrNlxEj0ygWFYsp/LU+pbM2kMWg1ZG+noev2bv0/3j
 /YyFp9AX91UOPs+73IQ1mU0XKwfKQR21IiS4XmVHtfz/ojzBogCIkAem6QfdW40aq4Rr/kzrx3u
 PMA2PJVgjyEIJ5ULIIot+ygS9J6dxvf4yLHHo1lNHhDxjdXTWJVIJu1xQ14siL4TkQte/VXESbO
 /+us68xbIrzPOiA6mIWZFF1rc1W1ht+jRxaxqoag/UhFaHUyh/9BqBeqRJBIH0LtXLO3ziP5GAW
 DL62hHYWt735+gbNNCC/7+NL4mB+PBxKNW31sEtuRF+4Ct/qaCXafWjdy9yMte36wXXDUgDXXiB
 +wMwsT8xAgh6Jg5dTE4r6fRWr2J3TihzpR5fz4x9x6u7tYq/h57eagyOmzy/+w+DYAWdwip0uk4
 WdSK1MNzgEQJ3XERocA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA3MSBTYWx0ZWRfX6e9hFtyyL66g
 pAjIwd+i50mDx9cwni+FWeqg0lluIULAarGDfWNP37vQkPvlVZDAXs7CAKixuqXawxineVgw5Ks
 YyvY5Zv48wlXlPbtf84/I1FTxLtCjsg=
X-Proofpoint-ORIG-GUID: JSHU3a533twioXyYnYT6e6j_7jq_XiRg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 clxscore=1015 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300071

On 7/30/2026 6:54 AM, Jeff Johnson wrote:
> On 7/28/2026 7:00 PM, ZhaoJinming wrote:
>> In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
>> returns the error immediately without freeing the CE IRQs that were
>> successfully registered in previous loop iterations. The probe error
>> path does not call ath11k_ahb_free_irq() either, so the previously
>> registered CE IRQ handlers remain attached to the interrupt lines and
>> are never released.
>>
>> In ath11k_ahb_config_ext_irq(), when an external request_irq() fails,
>> the error is only logged and the loop continues. The function then
>> returns 0 indicating success, leaving the device in a partially
>> configured state where some external IRQs are not registered. This
>> causes enable_irq()/disable_irq()/free_irq() to be called on
>> unregistered IRQs during runtime and remove/shutdown, triggering
>> WARN_ON(!desc->action), and missing interrupt handlers lead to data
>> loss.
>>
>> Additionally, if alloc_netdev_dummy() fails for a later IRQ group, the
>> function returns -ENOMEM without freeing the ext IRQs and napi_ndev
>> that were successfully set up for earlier groups.
>>
>> Fix all three issues: propagate the error up to the caller and unwind
>> all successfully registered IRQs and allocated resources on failure.
>> Also move ab->irq_num[irq_idx] assignment after request_irq() succeeds
>> in the ext IRQ path to match the CE IRQ path and avoid storing a stale
>> IRQ number on failure.
>>
> 
> Is there a reason you didn't carry forward Baochen's Reviewed-by: tag?
> 
> He first gave the the tag for v4
> 
> In v5 the code was unchanged, and Baochen commented:
> I have given my Reviewed-by: tag in the v4 review. Since v5 is identical to v4
> you should pick it.
> 
> once again:
> Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> 
> v6 was a trivial change in code. If you had applied his Reviewed-by then I
> would have maintained it for v6. if it had been a bigger diff then it might be
> ok to drop the Reviewed-by, but you'd then want to mention that in the commit
> history
> 
> v7 was unchanged from v6 so it should have had Baochen's RB.
> code in v8 was unchanged from v7 so it should have had Baochen's RB.
> 
> This is another good reason to use b4 for patch maintenance.
> "b4 trailers -u" will accumulate any tags and update your patch.
> 
> That is all advice for next time.
> 
> You don't need to post another version to pick up the RB tag.
> Running b4 in maintainer mode will pick up the one I just added above.
> 
> Baochen, no need to re-review.
> Ramesh, would like you to review.


Looks like my RB was already present on v6. Nevertheless, I've added it 
to v8 as well.


--
Ramesh
