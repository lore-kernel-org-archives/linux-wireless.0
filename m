Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2839F2D877A
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 06:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786947043; cv=none; b=WclCdWooW+/jYXlYRjZcoBvDtniySvK80uvX0gdB6AydFU2NsSH6r+E18KYMg3lBX4LXehdqzAjB0hL5LsBzZh63FUsFvAv71ykpXkQcVPLRcJjKnq0fR2mJ8+cIUpRg2QsqnbyeBVQVZ73Dk51bgpcLwXcU3All1fOF4OLnfr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786947043; c=relaxed/simple;
	bh=F8Cd2tMJ4CwHN7oo8kTqXx7z+vE+3V7q/eGo91YzKsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hAwjp3NVhy4gen4BqgfvXlOHZ6mmfKu9HGDeAwT0eJOxh9yoBc/jHhoFw+wdcPKhQ6L6z8lqyFaMfF4A4GXugPZ0v23dQqreH6diwvvrMZNVbP2qMZPk1aWqc5nCFpxzKx/TQ7k1f0Hfy78GXXuhBtrxXN3FZ7GAZDlsg8LOgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mA+HVcVv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ci6PEo4z; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mA+HVcVv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ci6PEo4z"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLCP2U160937
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 06:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9krNhIE3UBw/rESP2PBqxqCBjvhWUs/VVPKBV1N611M=; b=mA+HVcVvnnkABkbS
	Eb7IaTmmTjTwWQu1in9v54A72UN+iEm+fEGJ3xra5n4RZqL5B3EHNvhcJ2zEyPXX
	Qd4N5ZTIZEFEan2jFbeV2Tivcr2kWAYK5aVaWFPSEanwovF4g96txQiByTWGlrO/
	JNYNtLrHXjdorFqaFQ4OhWR5FZ/zfAkro8oWu0wJxydZTAS6hkZskpQhELm50Gal
	C4WNHRK/BbaFEurnEYpXiGvkePZ5yzVOtxhDhEoi+Eu0mrdXTUbEzFAkKNiFmUI1
	REIM1YGQAMGZr33VzuWgk97xrC1N/ivhr/t3amo6q8UUngXhNp3sADLm/0JKGT3M
	7opB5g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g2ghk5e1e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 06:10:40 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso5551845a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 23:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786947039; x=1787551839; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9krNhIE3UBw/rESP2PBqxqCBjvhWUs/VVPKBV1N611M=;
        b=Ci6PEo4zwqAxOMZnUpLn3b6zDTOonxYbd/Swc+rv4YUGKV5Iapfg2sko+6IHe5iabH
         qq887KVnkOQmbMHp5BqcSjG6GWmPDbZkz7RbERj57slFntD2P+r5kDpnTN+MbSpt+0wp
         Pt0DJIfPFRHK32th1uzVhGN+ghoKTYepG1p5V3z0xeWu+ONNuI4uFuo4DuTyGYeypF4g
         nTbKCAe/VKFn1j1q/XinE59tX5mQRsvSRGLHhf1Ex+RBqE/Jfwt74AJcOmLe1UEr59HD
         LxZH7Jc8JzjY0t/rC1gVdwkEhk47WcFp2Mtv1vosyn6b8mpxPx56Jr+GC4YlL7Tvie7Y
         OYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786947039; x=1787551839;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9krNhIE3UBw/rESP2PBqxqCBjvhWUs/VVPKBV1N611M=;
        b=GBPGSPqAKOZWxmxMfNAazN6LfonZzZF3WDTlWFqWBsyJR2Phm3qKAmjJUvyyYCNX1z
         dg93ySBZc4hqm/qo53bjv7YBvvOVDINfRIJZZoQzDNchMnVy0moFGTUk64wc76o3wZ94
         4RCYkiTY789mqIDWJz3qeeg0n21DP3U0TdksU+i4HsaLLv4Uz//1Z/9+H3/HbfPVyTjd
         zVtyowLoczfC+pctH7Xz+A0KB9Ci8A9v/v8WK6kEhtBehxA9V13M3KTuxWZRlHNr8BuD
         pOABQUYvtfW/UXbzcEsa+X0qDdTc8qUmUinvXaQlsT5IIotfVwVjM3xBuTwFzovm2WXH
         OMSg==
X-Gm-Message-State: AOJu0Yy6cieRZXzlu0mTBAE9r3FF1NokyAkOcO3Ais3Nk5E4pLmERTzn
	Jg5kvPMS8drEBtMk86J/V7X0uJYU7ECZUn8nE5p7JLqN5/dahjD1whXclkaNQJKFY5V40xGEvFH
	N3KlONNBrI8bgAXx6aT9fFBeONWHiHVxgEaTv2xNW3hUb6xmkMR66Db77ttUA4JkK7WRoPw==
X-Gm-Gg: AR+sD132mW89LBiuAL1Rhp/4FMNQeqyYUgWdPTU5gtxYnK+dFD0G94bbicfOU0oB8In
	sTAZDqdR4T+6mfdKWzCQjW1mlqp/4uF4WyUqw/2El74gpO9elwqKLlFPNIDGNsk8vVoGqKa+gV1
	w2KR1CAsfoYIYNEdScBR/s9GfCPNkcOPT2LAE0gUUgkJ7Xf5g+8s8VvU9Rev2f0Aj5TCZSUXwfw
	/G/PEJHmIeS1RWfgz2uWfOwN9oP7psooeZsZsHQtR+yGxOdPk9SxX+Tiql6WbdXo7mb2aY1tA9v
	H08KKwnZINSbTzWhSMny3094VnTEdRtMg7HQdrpOhr1UX1UnI5+kM2E0Vbk+SC+BYMu2xRaSuLq
	3s6ov0yYk+o1t22QMsem8sdZ6NZlBwzgSRg==
X-Received: by 2002:a17:90b:224a:b0:38f:837e:fc5d with SMTP id 98e67ed59e1d1-3933b786507mr22120895a91.3.1786947039581;
        Sun, 16 Aug 2026 23:10:39 -0700 (PDT)
X-Received: by 2002:a17:90b:224a:b0:38f:837e:fc5d with SMTP id 98e67ed59e1d1-3933b786507mr22120856a91.3.1786947039093;
        Sun, 16 Aug 2026 23:10:39 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531fbb3c5sm3545712a91.9.2026.08.16.23.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 23:10:38 -0700 (PDT)
Message-ID: <17f92055-2605-471e-be27-ca0cde4c9830@oss.qualcomm.com>
Date: Mon, 17 Aug 2026 11:40:34 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: add support to load shared
 firmware on multiPD
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
 <30a72dbf-2872-489c-94eb-6d68828ec5e6@oss.qualcomm.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <30a72dbf-2872-489c-94eb-6d68828ec5e6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA0NCBTYWx0ZWRfX80Dw9gmwXivx
 DTQW2wf9k5H5Ocgf4MpEhQ/4i3FtNYErBhA8V9NtgEVIi571ZQrkHPhiE3X5VryDVgEUUGewHu2
 8DWmPJS3thk+FmU3iojAI4WcnbdCA5A=
X-Proofpoint-GUID: BpBAyl6Q0GXunbXEnbwU1jJBshCXSJLZ
X-Authority-Analysis: v=2.4 cv=f+14wuyM c=1 sm=1 tr=0 ts=6a82a5e0 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VBYNMMrA9GbHywMzlVQA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA0NCBTYWx0ZWRfX2Q3KE9y6+Fhm
 5moj9BkR9yl5xMBEP0+W1w0Mz2++cT3rTdDUL3Upzis0KcRO3F9Zw10KqPEhvy/ihknv5ntwgQ/
 I/C0ypDRx3EkDG2b+Ya8rcXf0xgEXlhyPKyqU3uJ0zwABRAgYU38iTn7D74CEgOnr610ToiaOXx
 v1v0uJ1JOtnB+EwYe11qaZ4LKYjJzrT9QTk3cO1MTMEHXHtCpZV2Ii4xf9VmcQFiFPwjN0HtWEU
 1W9ffBeOdeTYEbQQeWpM4tvANyAyVq/YMgjueYOeeQcJWH01q/BrPWKT+f/yohKNBs2f6sQPeAl
 pUf+F+B1KhnTAI2P0p4YTIb9FJaE8xZMljJmWGmEieve7RRHVy+gUMcRGcJUh5f4C17G8upXutU
 lmDRnuPZ5NLdh6F7D0JHhymoVOfO9NZfX/tcbPXjWmF1Z408nRJJgxNUUJt1F7uH8HsfpVGtC+x
 SKv91MDqNIie7jkd5AA==
X-Proofpoint-ORIG-GUID: BpBAyl6Q0GXunbXEnbwU1jJBshCXSJLZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170044



On 8/14/2026 11:54 PM, Jeff Johnson wrote:
> On 8/10/2026 10:43 PM, Aaradhana Sahu wrote:
>> +static int ath12k_ahb_load_auth_shared_fw(struct ath12k_base *ab,
>> +					  struct ath12k_ahb_rproc_info *rproc_info,
>> +					  const char *fw_name, u32 pasid)
>> +{
>> +	int ret;
>> +
>> +	const struct firmware *fw __free(firmware) = NULL;
>> +	ret = request_firmware(&fw, fw_name, ab->dev);
>> +	if (ret) {
>> +		ath12k_err(ab, "failed to request shared firmware %s: %d\n",
>> +			   fw_name, ret);
>> +		return ret;
>> +	}
>> +
>> +	if (!fw->size) {
>> +		ath12k_err(ab, "Invalid firmware size\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ath12k_dbg(ab, ATH12K_DBG_AHB, "loading firmware %s, size %zd\n", fw_name,
>> +		   fw->size);
>> +
>> +	ret = qcom_mdt_load(ab->dev, fw, fw_name, pasid, rproc_info->mem_region,
>> +			    rproc_info->mem_phys, rproc_info->mem_size, NULL);
>> +	if (ret) {
>> +		ath12k_err(ab, "failed to load RO firmware %s: %d\n", fw_name, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = qcom_pas_auth_and_reset(pasid);
>> +	if (ret)
>> +		ath12k_err(ab, "failed to authenticate and boot shared firmware: %d\n",
>> +			   ret);
> 
> my review agent says:
> qcom_mdt_load() calls qcom_scm_pas_init_image() and qcom_scm_pas_mem_setup()
> internally, which register the PASID with TrustZone. If that succeeds but the
> subsequent qcom_pas_auth_and_reset() fails, the PASID remains registered in
> SCM with no corresponding shutdown. The caller
> (ath12k_ahb_load_shared_firmware()) calls ath12k_ahb_put_fw_load_region() on
> this error path, but does not call qcom_pas_shutdown(). On the next probe or
> reset cycle, qcom_mdt_load() calls qcom_scm_pas_init_image() again on an
> already-registered PASID; SCM returns an error and firmware loading is
> permanently broken until a full platform reset.
> 
> and it suggest calling qcom_pas_shutdown(pasid)
> 
>         ret = qcom_pas_auth_and_reset(pasid);
>         if (ret) {
>                 ath12k_err(...);
>                 qcom_pas_shutdown(pasid);
>         }
>         return ret;
> 
> 

qcom_pas_mem_setup() is called by qcom_mdt_load() only when the firmware contains a QCOM_MDT_RELOCATABLE segment.
The firmware loaded through this path is non-relocatable, and reloc_base is passed as NULL, so qcom_pas_mem_setup()
is not invoked.

I have also verified the SCM behavior for our AHB firmware and confirmed that qcom_pas_shutdown() is not required
when qcom_pas_auth_and_reset() fails.

>> +	return ret;
>> +}
>> +

