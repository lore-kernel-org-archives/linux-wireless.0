Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CECD31A045
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 20:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791577041; cv=none; b=Pwygj4UQVaICzmNpCcNTzv+8BbLafdZwxMSam8eJlJpfTk4GEogsMNrxorcny/p0nE3TcgWWMeo0LCZe2gys4pTgQTFLqh6Piv8ZiHPXbr/iIbzcVfXSgbnTURzg7m33nqvAWOFhmQaXHxT1IiVBZYL+Vnoc2qNGitghsLYeYOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791577041; c=relaxed/simple;
	bh=Ol2PnhHjDYW19M6M167aj/OOs8/Yg+yRRDESzWWGpKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvgVHkXhq3kXFb6LoyMMvvW+wKv8+l3rQ26XOThgpBeV2xf1o3JM8qpa/V2ALXNcRHntuFcLdMXMPjrUYbR84WpF3wtk/Dm0zs28kCdKYLkVGT4+sQ7eoj5gOnje4C8f3B5Z1yl4Ms7iFbqnULeFHsLqxPmA7Ar8hgM7IJcLNYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OLK6sFPS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cMT+KMPe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OLK6sFPS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cMT+KMPe"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699K12qT2457641
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 20:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PDL0lTK23qbaiBwfqM1xuIN8jBpy/LvRkHDmRDr3tG4=; b=OLK6sFPS/2ZFLGoc
	tbT9BMUIiSI5bTvQoA15sn9i0PYjcXdbnWo1ictUhdcCEgYZRnxYz9jKzntSG0U4
	QxzfF7esWfDu4Kt1Ktr6hcE/zqO7myRchBOgeihUM6UPrVua1x0PWqReUVpwoyCZ
	kFy7xhYKMK15uZsLul0E3tzqK5BL/fR34IF8+1mQf7KUK6B0BU9J8fzHRmxzEZF6
	h8ayL1a/zusG8UNuN3JckUeKU9pUBFhwPeuTLLZdhdMDwCW02eBcFb1ZoVB3oneH
	sA8Tcp5aDFy8fSCnUOFrv8HnuL8y6zOLkHt7lE30MOYfKqOtTrKN8a9jl3l2pXRy
	9AISzQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h74t7rk2j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 20:17:17 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3510d0baf63so218289eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 13:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791577037; x=1792181837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PDL0lTK23qbaiBwfqM1xuIN8jBpy/LvRkHDmRDr3tG4=;
        b=cMT+KMPeGU+2w+8ZzxWqP1xx0S5jN6vHFaLf1RAqIL2U6WL7tbvZHnAX0GnKcV/7RN
         5HPlNPD2mj5MsEQBm/LYpQgN924WO1/x1rrmMQXwty2umLm22dFc9yXIoY0mau8vzVfg
         BonYORyBwJRC14908UFs/XggT97mn7jQJ+ohY2cMlBB8nh9lUTSOAI2AUMIQuDy0gpbX
         WLcfVV8XDZ666zJAnpIpTiNQmP+I5K5Umqr85YnnsRp641PQ3Ai/sdu+tH3S+rBgrFo0
         dqLsUR7PpkIKG4TedOolrxbKNWaWWNZcvpDan1eTrZBjabQXktY7xV0yrZH3VJQCaWTm
         RgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791577037; x=1792181837;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PDL0lTK23qbaiBwfqM1xuIN8jBpy/LvRkHDmRDr3tG4=;
        b=zOrfkH9/GyPgLcAvQCR+KMare2ZTmpKiF6D3xNcoe2K2jsHRN2xj5w0pbM3Ns4auKV
         A5SYEM+klTjUaXAQIjkHU4sMofvgAXOUANBuBd4Cu52trFSCF7ToWzfdpimKJA1n3MHC
         ZKO+fxATZI7kZEyM5zp3ohjiJXykm83NbrrF0MeN5EqLswGI7nnaONtCZw1zEHD7k//M
         CtU8T4xYB0WQIPalKXWa3zOjjbdh7l38moAA5XF+i96okQv1ZM5uiLaXT/q+ut7UcfNc
         Sa8mpgzN50La4AKZ14lu94MsWb7nXGlmu0jS15ed4dD352Dv38F7s8wrXnZ9rRUmKKTG
         w5Uw==
X-Gm-Message-State: AFuF++nb444exEIjdm6mQloIcNoX9k5m2u0wb7UeBLNQZSEw23JFGMJQ
	rt7UN2omzMMfNcqoBH9gDZNkP5Dw2J2/bzCqrg1SBJkXGi4sUip7x8oTPbQDV7shpe6po9TmW3V
	+sEQqwz4hTM66Gq2FAFBHTn7ax6YUhD81ANT1j9L5HK4yDAAldxkEPdLSKRNh4OxQAs74YQ==
X-Gm-Gg: AYBFou03YcM73n3By9zZELnTXHGpMGN+qCbLDZhlqupXZybIylRHASXdWrWNYQ6J5oh
	shBcJ7+iIcqmIOV9HaI5CVTIjpMkbY6pmfjVlcBP85hqDBT5NQmmzlORbUoWt/7vNrtD7bhk5W4
	prdQy8hqppilfGTdXfi8G/lBp9hoUegLUSvV8E62zktgIuBGW57hhS9QCLbca7zhCfIwPCW4/MK
	LXDB/CcV8lwWli4TKZyxZPetMMOBj1mDd6h6cGLujMVq87N62lhsD0rfJhKl/OKSupi7Ef/lhWs
	DjpEGp1ANWh1TDXMGBJmzv3TuLmbxEKYRH3nr+dLk1KfPtkWXq/IOZ9ZBHBQTvSZC1trDaUqnkk
	WEHSZ+aFeGeleS72vxKUCLzJpGH8JLhiPZBi954iDhpcigdUFwXhLXv6wog==
X-Received: by 2002:a05:7300:ea11:b0:353:58a7:c0e4 with SMTP id 5a478bee46e88-3537e0333f5mr3800176eec.13.1791577036813;
        Fri, 09 Oct 2026 13:17:16 -0700 (PDT)
X-Received: by 2002:a05:7300:ea11:b0:353:58a7:c0e4 with SMTP id 5a478bee46e88-3537e0333f5mr3800142eec.13.1791577036136;
        Fri, 09 Oct 2026 13:17:16 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca1b556sm10963957eec.9.2026.10.09.13.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 13:17:15 -0700 (PDT)
Message-ID: <40903cb4-e39e-43de-be81-27a5f29aeeac@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 13:17:14 -0700
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
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA4MCBTYWx0ZWRfX3qpBWf+qr7Tu
 BoVIq7dzkbBgFGVUZ1FD5tcXeWpahX+OEqmLVXcTWVcRnTkXZW4MtPUQuFy3DDcJzzqcww67OA0
 hj0o8PByAC7EIUuYI+uEBUzTLeUg2wokICq1Vrk8pqGsVKp6sQ5pVYLQIlHMujXTBcGu3tJdT8I
 exISZqU5apXS8MvqLTr/gOEgZC+nCLmiGnnWZRXnCPoB6ANtMImX88Igl3mzEKHEEPu8SqKv7St
 XmqxEqwWcH1iBmRf0tO2TvBB+mgNB9f4R0oHbZkZmLBQuOR85ivicEZNiC0gPO3yltIOMPZy6Q4
 WtmLf2bA6LARo9JJbGbe2eVpbolEbswFeMIIIpTXUmN0mzUTld6utu4XcqnsTAldUK2WN8+Jhgf
 UtsIkAEI9wX8fBrlZ+vNRYHPYKlk/LhooUWqZTl7x34gy32I3T6t7MzFZwIVpsiMyoNIy5Mtb+c
 ZBVtnq0F9rUrLBQ3Ozg==
X-Proofpoint-ORIG-GUID: kEqJN2VuGx4HH6x7wwcsW0Yhijgln1ys
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA4MCBTYWx0ZWRfXz2gX16BAzepA
 AHW5wy/Jr+3vh7kMFc6zUnP2O5QhaVBu92VV809GB3txOa6Wkf7iQmaE4c9jNOuYLtIh2l7hm3m
 DXGt2ClMiGvButmhZedvVMf9A7isViE=
X-Authority-Analysis: v=2.4 cv=PaFqFShd c=1 sm=1 tr=0 ts=6ac94bcd cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=9K0OBibQ5eRIEVzO70cA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: kEqJN2VuGx4HH6x7wwcsW0Yhijgln1ys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610090080

On 9/30/2026 9:54 PM, Aaradhana Sahu wrote:
>  static int ath12k_ahb_config_irq(struct ath12k_base *ab)
> @@ -1353,7 +1382,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>  	ret = ab_ahb->device_family_ops->arch_init(ab);
>  	if (ret) {
>  		ath12k_err(ab, "AHB arch_init failed %d\n", ret);
> -		goto err_rproc_deconfigure;
> +		goto err_free_irq;
>  	}
>  
>  	ret = ath12k_core_init(ab);
> @@ -1367,6 +1396,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>  err_deinit_arch:
>  	ab_ahb->device_family_ops->arch_deinit(ab);
>  
> +err_free_irq:

my review agent notes:
**Misleading label name `err_free_irq`**

The label name implies IRQ teardown, but the IRQs registered via
`devm_request_irq()` are automatically freed on device detach — no explicit
free is needed here. This label only frees NAPI/netdev resources. Suggest
renaming to `err_free_ext_napi` or `err_free_napi` to match the actual
operation and avoid confusing future readers.

No need to post a new version just for this -- I'll make this change in my
'pending' branch if the reviewers are otherwise ok with your patch

> +	ath12k_ahb_free_ext_napi(ab);
> +
>  err_rproc_deconfigure:
>  	mutex_lock(&ath12k_rproc_info_lock);
>  	ath12k_ahb_deconfigure_rproc(ab);
