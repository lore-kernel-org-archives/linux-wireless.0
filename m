Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F38539A80E
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 07:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785740868; cv=none; b=Ibbw9SdDr5hCV5yr3XjOKp7G5vBI5eeNxRqVa1JNJyp0LBoMSluPBeRohvDqnz8QraIAPEZl6gdLqDz9ImkcyoKUlYslqCLsDVMqXKFGrfH7R5OiLMVqpl4zmtZZgE8HGYFsa5LhcYkBSWKEu8LBv4Bi/OsAXnTed9i0qQ2jA/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785740868; c=relaxed/simple;
	bh=gLP8V6map0eSHPOl64cKbGyO29l5VAbii39xtqvgRWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJ6l1Gq9P1gNqAKFKYu8Qp2nXoc+PYgw0e5KW2LcwQmsvVb7cKhScITXTrybcauhtjjbZcFPwEuBs1xy22hoAeq0g9QSbhHMFwAtz8IZXi1Dgr1iYNI1Xxt0DqDIHjtxwbhiSPmLT8SujnbxbWuazWVxrnXIe0xVIdJ2Mo6X+Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JC2q4HjE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NYNvOxBv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JC2q4HjE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NYNvOxBv"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6736kvZ24123817
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 07:07:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Uylxz9VVZchrtEvgB/E7O4hO2qJgkiTSZerKRLMUiYw=; b=JC2q4HjEabbStTrn
	IbeO1rcatNdDLZK+K/2ZPAmcKzeLjvZ7bVGTobWVJZFTvw67sRaDvIxNGK8QZQRO
	v6BDYP4GkmpqNXjeicHw7sdH52EjhEtrB6pRf3pR3uQG8HRpJVwB2OqMeUD9QF1/
	0Bvkg/t+sR+GtmY0imDQi0kKb5uO5m0e3KDkSf01vBSY7uQbZBgrvfi3pNq3ptQq
	RYLSycilFKCEJahIvk246zk+Czo22f5ERC3me8lVPOp2DhAqVjTW0Ff9lkYMDQdq
	w40mZ/jhEHjeFzYdhr+u8gakNf5ixZsPVRpcWRSmQ5xXQCnVCC/E7ko3e8xRqN0z
	gxCc6g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftp1682w2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 07:07:46 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce8a76df2dso53395375ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 00:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785740866; x=1786345666; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uylxz9VVZchrtEvgB/E7O4hO2qJgkiTSZerKRLMUiYw=;
        b=NYNvOxBviOvYXXfDYKRmoZYkWWmG+CSy8V0hSGWms37OwPzMLyu1GG5Ye2iQ+rmGca
         NCVG+cU7ShBqZq1sFAnAMwboJJZjylY0S9uG0zRTkVcyARbQrqGGoOQ5J9WvCPpVUXVJ
         r93x7DvLJdkLPF/CYZ2eDyWnbUcL2rWUd2JnDlx1WqqSuURNReC7ufeKlrYBy/DVsbSQ
         UO1hLbz1+jlLV2X0XcDkzvUrbOA1xNFzmIeXaWPm1yvwtYNN02LOEZ+plKXG47qA99WK
         8wOpK3sUyahfGC/CFnwjainKXqvy1jsTYcpErCD/SudryfjY6U1fR3RnHI3sm35Yv1mN
         l8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785740866; x=1786345666;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uylxz9VVZchrtEvgB/E7O4hO2qJgkiTSZerKRLMUiYw=;
        b=jKJ0CKNnd4Se0NJplmVimS6cYTCZFr8gX/3YBAoh3hsuiTs+sx1BdVAb43UPgPRKXU
         Q5c2KONgf4sVoFPg8UxC2TqjIzsafpA4GtzC6BJBM5i7wMLspY3KD0bKWT5mgZ2I6rIQ
         SJ3aGkgjP9yl6RBhQN/DUrEzjUip6J7P7D5iAFAWqVerQyRNMbCRARjiNCKpsBcK+x+O
         1DVLlw35ZZHQjc5AHO0DmzHyuMNcPm4afK+7e9rMqicz7D0gA6iBj5bs+XSuXknpwOy5
         EJQL+sWdUix5ij+BDvTwdLjCUiODZwfkHiQ81MQUrUo4nfm/t9Zzikd3Wf7h9RzWCES9
         o4Mw==
X-Forwarded-Encrypted: i=1; AHgh+Rq+53eh2VuHGnnj0LqTWO/8xj+HTABfhS5armfNpe9L6oT69VFR4V1Yn6B68zrcVHYQebih+AeR5WVuxgyCcg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywib81zy5YfR54vanWCIxemlebwu/8Je/3oH6IybbZ9XPvZIY+T
	PbZJzpsyO616+sFtp0x5gh5DabHil+VmEqhyN8QJm7U3CwsXi4ubSTg89bvvnHcaXcdOGZ4YPdp
	hwceLuxXScxYELlfTpMy+bNiACaWZmANeUzW3IOu6TxjxAiXwS1+Sqh2w0bi0/x1wWK9UQR7rPs
	2zJWqS
X-Gm-Gg: AR+sD11sIzatmcpbw+k2UQajBIM3n9E3jIKlaIeC5WE1Vnhz1VDeiD2YzdQRb3BXmFf
	FfFHq6qLvGHjlKRvAGa5nN6ysZk0E7Wa45u9S/HZKzH4YgG1sxPcmEnSDn1X4KK+I3xbepb8JDl
	QryuHczORnTTyWF+8WIJP2wPG5rPfRftOMbJynHcmFHHTYtcHakIrlmFmTUoYm1LwIlDu+/KIap
	n/cemcDndD1PUUYk8raS2lLOPKYO+ycrnccqa3rNb43WiNjIzbtGtkstS2SUuyJhPsg1xoitNPP
	HEgdO25hwL4fI3uoKkV9VmzNVMDlTvo1JkPLu0sJq38cwdbmH9TtYavGtl9ZgqA3A23mqCkXs14
	JMtZ2g8JqOMSz/tPJ+TmaEDum//AM17AMOSgZ/y+QMeajE2KMuTms/Yl2SZ/V5xmP7FdX9o8=
X-Received: by 2002:a17:903:3883:b0:2c9:b396:1a55 with SMTP id d9443c01a7336-2d0522023b7mr86121785ad.12.1785740865954;
        Mon, 03 Aug 2026 00:07:45 -0700 (PDT)
X-Received: by 2002:a17:903:3883:b0:2c9:b396:1a55 with SMTP id d9443c01a7336-2d0522023b7mr86121465ad.12.1785740865561;
        Mon, 03 Aug 2026 00:07:45 -0700 (PDT)
Received: from [10.133.33.22] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae19411sm33697225ad.8.2026.08.03.00.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 00:07:44 -0700 (PDT)
Message-ID: <58cd73d5-d7b2-4259-9936-9c6a55492d53@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 15:07:42 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH ath-current 3/3] wifi: ath11k: unregister PM
 notifier on QMI init failure path
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
 <20260730030948.147892-4-miaoqing.pan@oss.qualcomm.com>
 <f105a3df-6769-4a61-ba37-a6b874a918b6@oss.qualcomm.com>
Content-Language: en-US
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
In-Reply-To: <f105a3df-6769-4a61-ba37-a6b874a918b6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA2MSBTYWx0ZWRfX9rjbUsuFhFaU
 XRNdLTMn19ULXszjcpsV5GomToLkEauqj9Z2/lmxhmCwhF4AUd/IiL0u+vogxJ38eVJpi+fPJsD
 hKCM2q53x3VOFz6RBW+k8gfr2AHiMDhWns17hrkrTT8quORkYTcur+z3HMgqW/YaMNRftCuJmXF
 WvV/JE2ldU1kWGUORzbsyZeNk0iA7hSGnzhAfeFdKIvqIieIkHE4o2o6nhl9PG7jQw+GjQ9RjQb
 /auVu6EQkvHbHcisbgBzLFvI4cyfcM2RJrWWr1ORPRpFOS7DyrJo13emFr4SOal2M9jKkjBnOMJ
 8zzhArBP7ILjEruy9X8Ow61Po5iMJZelj3UVOC0ROquam/XUxPCU7gfWoYZRNTgciCHbWw0Vct3
 XogTzAclgv4vVqTG4HJtJUi4MIU0x5vjCmUxDo90pkCJFa1Hn6eeNCmKNU0590wHa/OhFVpSUno
 pNtIVZMqThv06T2F4IA==
X-Authority-Analysis: v=2.4 cv=Wpob99fv c=1 sm=1 tr=0 ts=6a703e42 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=JNLNxjGKG8KZZL2vac8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA2MSBTYWx0ZWRfX4g9sdqEiwCN6
 6Ptj02RPNIoUeJyYmL9yKTToAG0zhwahr4e/x/QjvqCAjemO+Jg92TlhR6KibDYHvFs3rdlAZCh
 33AhqVgMYVSz4QCFDessS+dDd6ZTaKU=
X-Proofpoint-ORIG-GUID: WC84K-3YRWCz_hqjSVVG72xkxEMZ-QoU
X-Proofpoint-GUID: WC84K-3YRWCz_hqjSVVG72xkxEMZ-QoU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030061



On 8/1/2026 7:06 AM, Jeff Johnson wrote:
> On 7/29/2026 8:09 PM, Miaoqing Pan wrote:
>> ath11k_core_init() registers a PM notifier before the QMI server
>> becomes available. If the QMI server never arrives, the device remove()
>> path can take the early-exit path introduced for QMI initialization
>> failures, skipping ath11k_core_deinit().
> 
> This patch felt wrong to me, so I spent some time with my buddy Claude.
> 
> I asked Claude: in the last patch the commit text says "If the QMI server
> never arrives, the device remove() path can take the early-exit path
> introduced for QMI initialization failures". where is this device remove()
> path code? I'm trying to understand why there needs to be a call to
> ath11k_core_pm_notifier_unregister() in ath11k_ahb_remove() as well as in
> ath11k_core_deinit(). since ath11k_core_pm_notifier_register() is only called
> from one place it is logical that ath11k_core_pm_notifier_unregister() should
> also be called in one place that is symmetrical. the proposed patch breaks the
> init/deinit symmetry.
> 
> Claude said:
> The symmetry argument is well-founded. Here's the actual structure:
> 
> ath11k_core_init() registers the notifier. ath11k_core_deinit() is its
> symmetric counterpart and unregisters it. That is the intended 1:1 pairing.
> 
> The problem is that both ath11k_ahb_remove() and ath11k_pci_remove() have an
> early-exit path for QMI_FAIL that bypasses ath11k_core_deinit() — but still
> need to undo what ath11k_core_init() did. So they replicate the unregister
> call directly. This is an existing pattern: pci.c:1188 already had
> ath11k_core_pm_notifier_unregister() in its QMI_FAIL early-exit before this
> patch series.
> 
> Patch 3 simply extends that same pattern to ahb.c's early-exit path, which was
> missing it.
> 
> The symmetry break isn't introduced by this patch — it was already present for
> PCI. The fix for the symmetry issue would be to restructure so the early-exit
> paths all go through ath11k_core_deinit() (or a new partial-deinit function),
> but that's a larger refactor. This patch's approach matches the existing
> convention in the tree.
> 
> The commit message claim about "the early-exit path introduced for QMI
> initialization failures" refers to the QMI_FAIL branch at ahb.c:1301 — the
> goto qmi_fail block that skips ath11k_core_deinit().
> 
> Thank you, Claude.
> 
> So I guess this patch is OK since it is replicating the PCI pattern, but is
> there any way to have ath11k_core_deinit() called in those early exit paths so
> that we can keep the init/deinit symmetry? It just seems wrong that if
> ath11k_core_init() did not return an error that we would have deinit logic
> that would skip calling ath11k_core_deinit()
> 
The init/deinit symmetry issue is a pre-existing concern and not trivial 
to solve. We can address it separately in a future cleanup/refactoring 
patch.
>>
>> As a result, the PM notifier remains registered after the ath11k base
>> object has been freed. A subsequent suspend or resume event may invoke
>> the stale notifier and trigger a use-after-free.
>>
>> Fix this by explicitly unregistering the PM notifier in the QMI failure
>> cleanup path before releasing ath11k resources.
>>
>> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1
>>
>> Fixes: 32d93b51bc7e ("wifi: ath11k: choose default PM policy for hibernation")
>> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath11k/ahb.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
>> index 7f5f5c8d7c56..bdb8c99f10fa 100644
>> --- a/drivers/net/wireless/ath/ath11k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
>> @@ -1272,6 +1272,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
>>   		ath11k_ahb_power_down(ab, false);
>>   		ath11k_debugfs_soc_destroy(ab);
>>   		ath11k_qmi_deinit_service(ab);
>> +		ath11k_core_pm_notifier_unregister(ab);
>>   		goto qmi_fail;
>>   	}
>>   
> 

