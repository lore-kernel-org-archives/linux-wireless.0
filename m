Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0F4490C0C
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817261; cv=none; b=oTYtR5lMKl3hUVmAiewBmMVg6ToMoHzF0lKsHJykV+BWGG8pBq8Kl9pm2tU5SQS6/U2Dxhddoe9dU0CCInP5w7zhBW9v8t2e8g2NPcmCY3NrfnMkOuZFUuHYSFzssbqucgbC16jB66ydOzOYiraFvWfapav/ykNHlga/xDAzX3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817261; c=relaxed/simple;
	bh=pg/Xd39p8vGC/EJieF1lqt50DJpPMsGS9HIo1a4YnuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SL0Q2n2C9upR4fpPJe9Z/iBvVHZ5a2qJHyaLqOE1DgbEYvEbkbAY+a5YT2ijfUmbKS/q8JOcATV1lCyyDm16NJ0GKBX0owzct7AASTZlv7QF2OSdVIErlgMz0vbE7Tkrx/T0FOc6mUlabh6bwKgAzYq778d6RupxD7Hx72IHpm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nfDuDA8K; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UBR1k2Pt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nfDuDA8K";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UBR1k2Pt"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CC081m3292287
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bj4x0yoc0hxWkj+NH/M3l1jP8L4sufydJgUS05eilps=; b=nfDuDA8K3pjv+kGa
	HIe/ifoj92KOAgGvHTYZd6fTWoNv7Cix+i/O5rT9FnkP/2wCQDPMPg+EPaqFWt7P
	VAHJnoW8F6SHhkzhAQOuFKW3pI9vOrD676IxDBiHJPJc+Wg/IF48NoLuakpXSQ7c
	2CyxBOMwXpWDmxKZyEmGb+UvMt9WaZ2opDNV9OcYweMJTI261FK0Hp20vE85AkiN
	A3BUKva+eCWkWrzMRrHF7tbTG+g1I5nzkIqupNbO0u2sep+mGrg76wOidcwlV1ye
	vJQTJ2eoMC2DZ15nWSWp6FQy1MxY4L4ocHSmIkVpCnFL6L1MpKxchbNqzHkPp/pb
	BnSGwA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8uh3hx8p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:00:59 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35b68bc1985so653081eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 08:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791817259; x=1792422059; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bj4x0yoc0hxWkj+NH/M3l1jP8L4sufydJgUS05eilps=;
        b=UBR1k2PthPZor48yLrmUQMDEWbrqNePB/1b29KibJIj3s5PohTG7Ry0GzCxNKUsITQ
         nFkP9k0Q80c1tFD0R/xvrk6V2zCqZbgVlZVdEOZi89aT7dVByqG9mq010heaGAokn7Di
         aVOA1lx/wy5GOzZVtpYdMHsdcuQSmOoo2awNUXqgUV61p4W3a1tqwGPjfBp8EiYPXyov
         FVZ7vG/wfSvKgzcfeAl69dUCFO5GKj8MmO7/6i0rM/yjjD0BhPoLVyZM8n3QLq5MrQfY
         Chp9IyewNkBqpADT72QtwumXbib3fw1nzU6PxotT+XeTYs9q+SYWFl1zxAOw1hvxpzIR
         cQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791817259; x=1792422059;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bj4x0yoc0hxWkj+NH/M3l1jP8L4sufydJgUS05eilps=;
        b=YfYEoZie0HXxX+QEM99uU7koOS7+7lFvauXzSYd0tLcXKQEJ6YrxkEXv+CG/FaGijc
         AT0WHlQLBNPjCLMVbnkqk0H3+Wwbk6eI0RsMSyfnBe1vBqq8fSsr1NlM+hq+njh67s/4
         kumyQMR8prxjVIpN6AdC1tS1MCaUvj4H8TjtX29HQIYLaY4CNyqfPZPjeHjwRPAurFl2
         boBoqezoGR9A4VCGOSJGL1Z5tX/7OKuEzcbrccQHn9r197ubb5tHbLCl2WY4w2Z8uKaO
         m3Jui9S1UEPvgClsI3pAJHo5i+XXPngNUppXYGWbWsOoWVd76o+fvO3Hy4nN9D0SFqs+
         EC/g==
X-Gm-Message-State: AFq9FYJsVfUln9593L5jrmXOzNM2XbUPQkrLrC3gOJTEVW2DbVEaSjCq
	RzlHuSpE3aaQfzgQOxSgVezBiugYTQ5MjADaEyW1kAM8w6E3PPuZn4LAPxtIJ/I/EOQ55fYlsIe
	/QdQ8yqOC/bROVFaKjJLkME53ug3xWu6B6R4H4LqkQ4WK7GideMkckAqw/6s2Iju7RUQC5Q==
X-Gm-Gg: AYBFou0K4mB55auCafXiwbXB3AKkRrXeT3qPsZ9kmrFd79pVH4xlEEeiMTjG1K4XS7J
	6EAlP9G60eHzMbqkWkHSJv89lRhGEBrdkISWKNPjlAtha1sSImq1sZjfzBYwIFV4sREb5a0tMU2
	g/Kjcu/T2+4xuQ0R1sHycASNmMEc81ykEHEt+Hcf0stOxUa/41XesaKKy4Yv1jyoxGWzAsPLFiP
	V7l9R2dw84paYluN3pGBAMDKbw8SFtW3Ol21I13PorzGF2pcTu8cBvo2Irys3Z3OSaY8Zl0oQqF
	DoBj7Z/yzGvYqD5JOLZsXaWds2LBWdEIMfu78dxb9qy31Mkmy7auenMx7RB98ijTJU48LbdyIj9
	0wbHhfSVlapaPNm84qEcqmREClSernJfy51UAZscU9FUFenptBFcDD3IwOEls
X-Received: by 2002:a05:701b:4585:10b0:14f:5870:2e9c with SMTP id a92af1059eb24-16a15460f46mr12176615c88.23.1791817258650;
        Mon, 12 Oct 2026 08:00:58 -0700 (PDT)
X-Received: by 2002:a05:701b:4585:10b0:14f:5870:2e9c with SMTP id a92af1059eb24-16a15460f46mr12176562c88.23.1791817257835;
        Mon, 12 Oct 2026 08:00:57 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2f17feasm40086574c88.9.2026.10.12.08.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 08:00:56 -0700 (PDT)
Message-ID: <fc1124b6-e0eb-4760-8c94-54a5cf15b10a@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 08:00:55 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2] wifi: ath12k: Fix NAPI resource leaks in AHB
 external IRQ paths
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
 <40903cb4-e39e-43de-be81-27a5f29aeeac@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <40903cb4-e39e-43de-be81-27a5f29aeeac@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA1OSBTYWx0ZWRfXw3JcBBJf2owb
 kdpEeM1ZkQsNtH2eJsTxTEJly7fY/H46f82iFRbLWRuNMJB1vCjd2msXrRZPxeTO0QWoG+PHind
 /mTuQKvEdqoCxgwjE8d1/nuKgo2wqq26AaqgEKzYOtPEvyJQmslJjwpRgEtNat4h5M2eaoBCjeL
 Fn99JPLaWBlD8OCY7vsB9u1mO8bb2vpz6aL3AyvNDr2JuwxcRQOH1kL8KYWfPfYtLpsLsJUppSY
 BqiHx2vdnqzFDi3bLVJDWjMROX9Tqoql/7VupI7zHpm0468Gkgi3MEt2MkLvjIRUhG5A4bsxQhh
 UkaUQ2AX0e+t3huFlEFiCDnvZisTfBC3J4QDu3LJYwEu91BfP7Vew1M+X1bwtMTvZ1+VSk9qKtm
 y4fNzv255UG0kMOEELOEKLSZmxy/eTvs0uCkrBnK5c4DhIKzBMWl9qMwvzaunaXym3txyMtNfov
 4/bmFCfAdOnQH+AOxhQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA1OSBTYWx0ZWRfXwi6cTcUB/heT
 idGgbbdiA2g4pqHBm+nec/7jYGYIx5KtiEQt43eGsPMu0fgr7O4brZi8XcMsWJyY/mAvyuYyM41
 2VZr1zntqc95EuKyb3N/tixcyvDd59M=
X-Authority-Analysis: v=2.4 cv=QO391QLL c=1 sm=1 tr=0 ts=6accf62b cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=OA1JIVzn2EqTZagBuBkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: -arcdhOvSxzIpRmmR4Wf8kbYGMH3nBeo
X-Proofpoint-GUID: -arcdhOvSxzIpRmmR4Wf8kbYGMH3nBeo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_04,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120059

On 10/9/2026 1:17 PM, Jeff Johnson wrote:
> On 9/30/2026 9:54 PM, Aaradhana Sahu wrote:
>>  static int ath12k_ahb_config_irq(struct ath12k_base *ab)
>> @@ -1353,7 +1382,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>>  	ret = ab_ahb->device_family_ops->arch_init(ab);
>>  	if (ret) {
>>  		ath12k_err(ab, "AHB arch_init failed %d\n", ret);
>> -		goto err_rproc_deconfigure;
>> +		goto err_free_irq;
>>  	}
>>  
>>  	ret = ath12k_core_init(ab);
>> @@ -1367,6 +1396,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>>  err_deinit_arch:
>>  	ab_ahb->device_family_ops->arch_deinit(ab);
>>  
>> +err_free_irq:
> 
> my review agent notes:
> **Misleading label name `err_free_irq`**
> 
> The label name implies IRQ teardown, but the IRQs registered via
> `devm_request_irq()` are automatically freed on device detach — no explicit
> free is needed here. This label only frees NAPI/netdev resources. Suggest
> renaming to `err_free_ext_napi` or `err_free_napi` to match the actual
> operation and avoid confusing future readers.
> 
> No need to post a new version just for this -- I'll make this change in my
> 'pending' branch if the reviewers are otherwise ok with your patch
> 
>> +	ath12k_ahb_free_ext_napi(ab);
>> +
>>  err_rproc_deconfigure:
>>  	mutex_lock(&ath12k_rproc_info_lock);
>>  	ath12k_ahb_deconfigure_rproc(ab);

Pending version with the label modified:

https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=ca18680289858564a3bddf3df67aa758b5f16d8a

