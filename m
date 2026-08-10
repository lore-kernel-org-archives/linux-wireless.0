Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16A4386C2A
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786337709; cv=none; b=WdT++2N/qBUDRJ25TeWOnLKdGflMXpCrN03OuA4Z3DyNIPBQWZ15fGbEZkAMoAncu7nJgtTAsKhE5DKjuXzlM1WqjejnMZN6pcPZDWR9Ohec7nxiF3VaQ4ezBuNxfs/vroRcrb1v+N1j6Hwxr23zvWpaLfW6eGXYO1sWmG/zSiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786337709; c=relaxed/simple;
	bh=yR/+IIQoTBzve7Hm6IcxaZqzuiRYQ3R8GtyKug4pV0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0yYzZW48OxFCTwmSrNCEfm5P4ClmM9jm0jnd47Jn7aoC6jix1D5QHJ+ZoZWj6wL72xzQFpH+hBVuT9xrb9NhKTc4B+LD4hyq4T+H7nRtQdMCj9Fn4dOwgKEAXiK/6WNH3aMlV2ZZtwXDOwBGPk5qx2vTun2bImZnILJ7fu2sY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z4nak5RF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GeN27qP/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z4nak5RF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GeN27qP/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679L7Ugp3477005
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ArTpDam5bh0KLdnINtdiE20WeCWsVmySFXjbwgWmPwE=; b=Z4nak5RFWZGgUquk
	m94HXSBn/J9iD0zhM6QbhOqSHrHvSSmXxWaPDP2/ZYc02OtmPaRaAv38OH8A548W
	oKGwZ6hG2hmmWxFq7wVS9/oldFsCT2OtVd4FAUec8Ziy97ri63Jq5/qkm5QoQZvA
	MWRmO5M2gZYpWcOvz9Bppze9OmkaAwCerMfjRnF2TVsLwDSXkAVF0e26BRQflsQa
	L/RMa5HUZ7+oj3xn521JZycyMNCtkxAZ+YdpeOdfTs7Fbv8sh/OJiQrvxGE6LOJF
	W8JlaPr6kaND7q2++nkgkeoHtAhVXM4IO6kIi/OEK923nlPxJXfNRZ+noUp1nHgK
	+gqUfA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fww7cvb6a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:55:06 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-848662cd2a1so1734241b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786337706; x=1786942506; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ArTpDam5bh0KLdnINtdiE20WeCWsVmySFXjbwgWmPwE=;
        b=GeN27qP/SjZl640hibyErmTJ+1JaqB0ZRbuKiMncfFQn+r9HzDb1KQfknghIoqP9Oa
         48Cap8t32C5Ya+ivXUq+X/oU4iG/F7YZR77RN5dSJH8qOqA1o4PJR4eiMW47uobZSFxC
         8PWw4DPUGe/6DOHPIUYjPbLVHvuEVY1vGCKuE8h6e/YTShCyF+9VOxrHjms9SLn6ePWW
         eTfg19gRLgxg03sYWAd0xP3ztIyZejj4OLiqSLF9F6ejG3g4RnljdzftrFWoGYk8V0jT
         +xRtQoTAWiW3vIRTyuhcj3U/3J448RWhwgYxKmNf2viUZiVS9QuxmnUDwI7pOFXzA8pt
         k2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786337706; x=1786942506;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ArTpDam5bh0KLdnINtdiE20WeCWsVmySFXjbwgWmPwE=;
        b=XwhBv72Xusq1yjpRseyrWtJTsqjvwal3Zmfx31p6j2UZBP3wdMwpOieGkYjprO3T0z
         8hUcFScpEDMTCTLmTRQzoWTwvfM+gAkXdscr42U/S100zfszQ5a2MYJMbnyzp7iFAF6n
         YxIBkrWxyImlJtxSF1i2rV1N1xYTlvuuAp42eShDzP18zgaLKj4wZ/GQFZxpnJ3WFpl/
         TRDMuZ/+PykUuOzvXbHsWbeVp1uPl09fthBTuDAAlhuW7GugsWk6RydHJc4GP8fBvRxi
         HXSqUbmyhgUE9fob+TqcrjuV/gH8bSSWTZ/l3pYltUOmM+oZizPQ4sfN/fdg01U6a7cZ
         RejQ==
X-Gm-Message-State: AOJu0Ywh2+rkgrTO1uRQpX1nS5QWE3fMOulBgKGaGA+J9qwIxDjkLKXk
	Rri+II3+K5q4RkOaiDuP+GKumRbWZhcRgPZD7WuC8c+rTE1sM5S1DYDtGiXxYD7T64trIxtrpyp
	oiaoTpKdIdZvMMq8z/9XSLHHTEqfMurdSoKW31uxBup49mgbTMJ4lS5VV+J76SEN90GAAyQ==
X-Gm-Gg: AR+sD11fq9AtL04ni2PaNMDqLRFDjVx/fAZ84qmTwK8z4ZdAxMEGyr2Xq8Tpx6KSnIE
	D32UQkptheeHLDCFrN1QsWE2hCw+As/YRMNJhHpq1eWrb51P6O/H8w8taQMoXnbZptCinPa8PNK
	OWDrHQN6z1BXGUw2PeX6E6g3eSUkMbbA3Q86/8iFiJXXSts5oCtlQ1sHo12sB1lBclKuSVRttYo
	bGA5+w1BtffSBAWS7QWJCqpG4V46YxLDHIbI0nZC4xcmX8k91sZctvifvzj/gD6nJaVqYi9neQx
	nvJP5pQ+j2f8WRGRvbidKSbQgL4hkQOk1yw2ttXbwoN3QTI6MisQB1Ui579tEXHeXtbHXStUXVc
	R19VTIEU0Y0BjGlWic90xNxtOGulO5zmqOqsW31+GFgzCetYfNxpcBW0VPH6N8czxjmDJmQKaGz
	QRqaSq6op6/e2OJwlizA==
X-Received: by 2002:a05:6a00:2393:b0:847:881c:7026 with SMTP id d2e1a72fcca58-84f69418396mr14737204b3a.3.1786337706099;
        Sun, 09 Aug 2026 21:55:06 -0700 (PDT)
X-Received: by 2002:a05:6a00:2393:b0:847:881c:7026 with SMTP id d2e1a72fcca58-84f69418396mr14737174b3a.3.1786337705575;
        Sun, 09 Aug 2026 21:55:05 -0700 (PDT)
Received: from [10.79.124.186] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a3a0f8dsm3248601b3a.12.2026.08.09.21.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 21:55:05 -0700 (PDT)
Message-ID: <89f8b7d4-fea5-4b22-b5e4-07d8de06eeda@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 10:25:02 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 4/8] wifi: ath12k: add device DP stats reset
 support via debugfs
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
 <20260806132427.3704828-5-pardeep.kaur@oss.qualcomm.com>
 <9dd4f651-3437-467f-9994-93b92a83270f@oss.qualcomm.com>
Content-Language: en-US
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
In-Reply-To: <9dd4f651-3437-467f-9994-93b92a83270f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: AR0QkZ4E5xLrvnO6VxTicSCrps2TDUpt
X-Proofpoint-ORIG-GUID: AR0QkZ4E5xLrvnO6VxTicSCrps2TDUpt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDAzOCBTYWx0ZWRfX3GLwjHQ9Kuir
 WGKj4bQGWHsDv/FFMOmQ/dIAQNXl8e8RzUmb2tbJlQy3ANbA+qLPcwuf4y3HQaN+8M6OEeHozSc
 oMvS9aOUM8gCdDhGMbr66YLuUtAZ7/uI26/41jgaxRZZL+II48MaiJL4oL+5jFDHCUiGNyrZABi
 qNdwEQzJPJyJTR9w9aNRuNTLnRVHAc8shw4L02LiB67lBWKxT0SC0yPmBQKIlp9E0pyRt8Dfe0d
 oc5Z+WmGCp09cjWj3tL6mM+OmB4fypVXsokohUm6nfYnJLJD7cDmyhh/i+fP18m3wx5ffghSND/
 S0wVJMM5+oOnAHQ1FofghVZwUOq8W1YcenDHyjtWVB3pZtIwM4Gbpx1QVWwLEa/rLcHNN+ACI6+
 c+IMEFYgMXD3r6UmX+AvcFzSj7K0+MJNl0PlGHA35j9pewTy60Uzq3ParrZFwWkCT5ArusmzE3k
 anlZ8UtUtL0iX6oqUmQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDAzOCBTYWx0ZWRfX2hnjPa6LFbP/
 qLCKfiCl6uhFbSzMDUZEMo6plPM+wIaM4jS5yCOQn5XMtWrrA7uNFxfcSgNF8fhxIw9YLQemtf1
 XK1uh1/hXRm1yNtUU+FbJ2pj85/4Nqo=
X-Authority-Analysis: v=2.4 cv=IPsyzAvG c=1 sm=1 tr=0 ts=6a7959aa cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=AFajGRLNYAwZlwsr5FkA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100038


On 07-08-2026 07:44, Jeff Johnson wrote:
> On 8/6/2026 6:24 AM, Pardeep Kaur wrote:
>> From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
>>
>> There is no way to reset device DP stats counters without reloading
>> the driver, making it difficult to isolate issues to a specific time
>> window during debugging.
>>
>> Add a write handler to the device_dp_stats debugfs file so that
>> writing 'reset' clears all device DP stats counters. Change the file
>> mode from 0400 to 0600 to allow write access. Use strcmp() with
>> newline stripping to match the input, consistent with the existing
>> pattern in debugfs.c. Return -EINVAL on unrecognised input.
>>
>> No lock is taken around the memset since the counters are updated
>> locklessly in the datapath; taking dp_lock would be misleading as it
>> does not protect device_stats updates.
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
>>
>> Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
>> Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
>> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath12k/debugfs.c | 35 ++++++++++++++++++++++-
>>   1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
>> index ec49692107a8..0e446a666f4c 100644
>> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
>> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
>> @@ -1220,8 +1220,41 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
>>   	return ret;
>>   }
>>   
>> +static ssize_t
>> +ath12k_debugfs_write_device_dp_stats(struct file *file,
>> +				     const char __user *user_buf,
>> +				     size_t count, loff_t *ppos)
>> +{
>> +	struct ath12k_base *ab = file->private_data;
>> +	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
>> +	struct ath12k_device_dp_stats *device_stats = &dp->device_stats;
>> +	char buf[20] = {};
>> +	int ret;
>> +
>> +	if (count >= sizeof(buf))
>> +		return -EINVAL;
>> +
>> +	ret = copy_from_user(buf, user_buf, count);
>> +	if (ret)
>> +		return -EFAULT;
>> +
>> +	/* drop the possible '\n' from the end */
>> +	if (count > 0 && buf[count - 1] == '\n')
>> +		buf[count - 1] = '\0';
>> +
> my review agent says:
> The new ath12k_debugfs_write_device_dp_stats uses raw copy_from_user(buf,
> user_buf, count) and never checks or advances *ppos. A write split across two
> write(2) calls (non-zero ppos on the second) will copy the second chunk into
> buf[0] instead of buf[ppos], silently failing to match "reset". The existing
> ath12k_write_simulate_fw_crash in the same file (line 63) uses
> simple_write_to_buffer(), which is the idiomatic kernel pattern here. Replace
> with:
> ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
> if (ret <= 0)
>      return ret;
will follow the existing pattern and update the patch
>
>> +	if (!strcmp(buf, "reset")) {
>> +		memset(device_stats, 0, sizeof(*device_stats));
>> +		return count;
>> +	}
>> +
>> +	ath12k_warn(ab, "unsupported command: %s\n", buf);
>> +
>> +	return -EINVAL;
>> +}
>> +
>>   static const struct file_operations fops_device_dp_stats = {
>>   	.read = ath12k_debugfs_dump_device_dp_stats,
>> +	.write = ath12k_debugfs_write_device_dp_stats,
>>   	.open = simple_open,
>>   	.owner = THIS_MODULE,
>>   	.llseek = default_llseek,
>> @@ -1232,7 +1265,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
>>   	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
>>   			    &fops_simulate_fw_crash);
>>   
>> -	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
>> +	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
>>   			    &fops_device_dp_stats);
>>   }
>>   
