Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79634388862
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786337651; cv=none; b=V7QUbxQbHN7iQXqNMirU6kvgUadfE8rzQzMW4n+qid2apskKKlGRuebw4nizr+ZlnaHlbvNakPLLwKO5U8GQPhOQWUnfYU7Af1Vh81UDG69n+jTc/QAcHt35Axc9Y/hV9fA7ZJtbrN3Cbk+FacDZkS3dpmd7cIMRIdjWw6afXgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786337651; c=relaxed/simple;
	bh=+N03g0P/nN2L8I30+LxefffINurNF0UtOVrxcq7sHvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpGuInrVSsC9GrLasIYXub5DiYCOaRfOM20pYIwRqT36Zx4FwwWNkIf0lGmMZsJyWLMsHoMIFpBZNT9o0VcuFywsE9rdBLkuLc3nTQGYLxSlswViZKn7l0QRd6/RZUmVoSeBKYsLtTzLDlXUwzVDk4hrog5XSL83p1icJ1+oZoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jvkGBKnk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jbk0ojZu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jvkGBKnk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jbk0ojZu"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679LE6nS761115
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	C18zYvwGVWpEleb5PKvoQNV7Ix9APthKPxgivVijLzQ=; b=jvkGBKnkwU+vMGHf
	5X4AdCizFroQW1msTHs21MG6dVag992Y+AnNErco5rFzTVITgdu3YXzZgUxQMiYJ
	YdiH1/xmlJSgcst+JMStBH5VBM9x/v1B1GuhIIkdnRSYA5dU7Hw9yYYy64SHeefd
	Kiss35RAYVjvH/reR4KpIwZkkEgzOQh40uHZlrds2WyPIkHHJ4aQOhl8Euepnn1P
	LEVGcpHty/WiQijVL7seDohz0wOcRJ74rYR23D3MaaApPK/Ki5cRyt+WrWPV5RyC
	IxKyuJP8MHg7YxqxyUf1BHZ+hHd1QUsqUf330HnSp2DOlbLeDWITL+wVe2qLpyp0
	jDvpXA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy19kgua1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:54:09 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cf1c86963bso40301355ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 21:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786337649; x=1786942449; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C18zYvwGVWpEleb5PKvoQNV7Ix9APthKPxgivVijLzQ=;
        b=jbk0ojZu5RA6y9XVtb3f3AiAcTeWDaJkDmXhVP3q1W6472fmmGTSPfgE+EGGUIb0Ni
         +THtUHgq17mQgePztkbts+6QnQFpO+Oefnjr/1iiAnza41DKvaeb8I8JuSaryyO205yA
         b8WBklRuqKqfPDN4xD9qvxeRP+UpddeeH3y/Nm5GdmUNm3DgtwzLCTqgJV65vDGualbH
         kWcDlV4N+W3oNsQUA3kvDDp1Ao4biYGPWUCXv/RePVs0HgvLj3tqTUDKGeeu709FyT1x
         1rWc8zTVG9qkLqQnfxtvxZgf+EYHbrA34kucP6O5BY8UPsmtiPwIfiDyX5Ie+88fEEmE
         PfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786337649; x=1786942449;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C18zYvwGVWpEleb5PKvoQNV7Ix9APthKPxgivVijLzQ=;
        b=tCpaH39MtxBWUhgYG87socV/EhsfSmIHSy3319Gz0vk9sJbOZBcyHkjBjW3sRLGIaW
         xwZD2SSL8FfAIdNU6kpwxlpAGUTmRCtkvKh5Xo7oJoi5WdBx0qBZYzmsbWrtg8ps0/Eu
         Udh6W8sSWkzxVD/T+nj8imjrTEsWcFF5MOgQP8V//JcRuHdt1uCMcNS2w1B8ZPZnWv37
         KvMq6e2WYRtif2kd1/d786Fsb5QfBMK7ySCo8JiP9N2s57s5ixp+mDgwj4eXaJFbCQOq
         /hP5gmRe0+I2tqkukYF3Bj7HzkyVgOpN77DljSwEa9jhJKxe3sUDrcJuSjQ+GOTxM3eQ
         ribw==
X-Gm-Message-State: AOJu0YyH/h9XVJaOz2uQPxPRVa2dVgShJt0qirtHXm2yML9MVKgA3KON
	1UjoQ4Bk5E7tlwPCm3GlwrwhNMfsON1vHU2HN25NBkMFqR3SzRaOLujRuI33kqjbo3PcjXvlaO/
	nJH9q2bwMxDa3/J1pFioocCxUZIk3dZN0LL8bkSO38acw9Evjbyt66ncIFtQhUQYk1rBjBw==
X-Gm-Gg: AR+sD13M8ehb2Sc3nBAEbG5lgWUr0XDhYHH8atSgWoidDV+kX8sg6U2SVGt7vhpB+ua
	T8v7Mna1au4Pift7cBQMLmp/Pu3QTGlqB9d60juYCRbGZDjjDOewHYuSqThGuhxYbMvi99+Wi/6
	zwQ1LYrHL2wJfYa7O+mmflDXxg+oWnGb91wwBuG92qDQCenTzcmh08C2SE6ultj23exPxO5iFLR
	Xrnr2wJq6ASOdPo1E9Qm5mtH2NHkWzp8WuvOoVKEY7PSQWUDWsBa6kGGkmkt66IHBfwgHJ96xut
	ai2pQmm9VXGR0HipFo4EAw8Q/VWnikz+LK54dv6VMkpoUQLezqHp/lOS/vg+QYJfgNNHlzYA5kh
	t0GEvSz/vAG9fpH5R+w16R66iDUuanQw21A5NkJp8I+6VgtRTatgP/nhjdovFjbvX1x/unp19Qx
	nQ6Y4reik179cng9s8Vg==
X-Received: by 2002:a17:903:8cc:b0:2ca:f417:396b with SMTP id d9443c01a7336-2d2b2d8ecb7mr194927615ad.3.1786337648998;
        Sun, 09 Aug 2026 21:54:08 -0700 (PDT)
X-Received: by 2002:a17:903:8cc:b0:2ca:f417:396b with SMTP id d9443c01a7336-2d2b2d8ecb7mr194927295ad.3.1786337648523;
        Sun, 09 Aug 2026 21:54:08 -0700 (PDT)
Received: from [10.79.124.186] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14ccb0b2dsm28814835ad.3.2026.08.09.21.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 21:54:08 -0700 (PDT)
Message-ID: <b9b4aaed-55d5-4230-8b6c-edc41f8ccfea@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 10:24:05 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 1/8] wifi: ath12k: fix out-of-bounds access on
 TX stats arrays
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
 <20260806132427.3704828-2-pardeep.kaur@oss.qualcomm.com>
 <34ab0833-45fc-4e21-bbf3-bc5a167d9bde@oss.qualcomm.com>
Content-Language: en-US
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
In-Reply-To: <34ab0833-45fc-4e21-bbf3-bc5a167d9bde@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ywzR-BtRqa9T88SYgIcO8itvYqag9kMp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDAzOCBTYWx0ZWRfX1riFW4nqZ0ve
 8tJHEsyVJsC5brYzE8Fc2yafB9Qxx1LB9H1s1tq0sDEgN2rZrbtvImiqEnBWpzlJIFyCGQ7jLIu
 ooVss7tXLhntYmVsSZx7kpEv0M152f3Qz3xbPDOj1qQ22Ap52KtWVdunoF1eI49FPVZFH8uW1NH
 vzE9O5NGO3dEtFaB4kzwl0DmntU1QuxIvD0+kzZfcUzjkSFicyFlxL4t1U8E5r/XAKzDNaeiUp1
 VjesBiY7tnz5UamCSX3T6UUmhWkpEkNe52uvC7MdV05RW36DdobLK9iKCSAKVsRfO2Fwpq9QGKu
 53jZiNO1o1K1AyH4xJYhuby1xStF0aoaeRzCXf0BB/2RuOG4W8sR0ZlE4unTi4gSsOemCpt03+A
 QhBUM/vK7fADfRa6NcCHTHpKyRpgakb8OQrpNFA9dFyAGJ9OZDVAGUujs0A+g4rI1OBFkvTs7KD
 NjUcLv25tEKhScCXkeg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDAzOCBTYWx0ZWRfX8JmZtqd3bgsr
 X1buAyBbExcIHw2fsBNbDVTskhb+ibxGtFSiFPb/MTGI0Pw/qmfR13SDcjsjxg5BYGkDuktD16o
 Na7rvIMj8lNjiT2oZK+eg+0IE+GtIG8=
X-Proofpoint-GUID: ywzR-BtRqa9T88SYgIcO8itvYqag9kMp
X-Authority-Analysis: v=2.4 cv=abxRWxot c=1 sm=1 tr=0 ts=6a795971 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=Ozm0H6XBQHCMpJSGI6QA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100038


On 07-08-2026 07:37, Jeff Johnson wrote:
> On 8/6/2026 6:24 AM, Pardeep Kaur wrote:
>> From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
>>
>> The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
>> are indexed directly by values read from hardware without bounds checks.
>> Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
>> MAX_TQM_RELEASE_REASON respectively would write past the end of the
>> arrays causing memory corruption.
>>
>> Add bounds checks using likely() and WARN_ON_ONCE() before incrementing
>> each counter, consistent with the existing pattern used elsewhere in
>> the ath12k codebase.
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
>>
>> Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
>> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
>> index 587d58eeccfa..632230e77802 100644
>> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
>> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
>> @@ -582,7 +582,10 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
>>   
>>   	wbm_status = le32_get_bits(status_desc->info0,
>>   				   HTT_TX_WBM_COMP_INFO0_STATUS);
>> -	dp->device_stats.fw_tx_status[wbm_status]++;
>> +	if (likely(wbm_status < MAX_FW_TX_STATUS))
>> +		dp->device_stats.fw_tx_status[wbm_status]++;
>> +	else
>> +		WARN_ON_ONCE(1);
> My review agent tells me this will now double warn since the default: case of
> the switch (wbm_status) that follows will also ath12k_warn()
>
> So for wbm_status warn in one place or the other, but not both
Thanks for the review will handle this
>
>>   
>>   	switch (wbm_status) {
>>   	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
>> @@ -984,11 +987,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
>>   		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
>>   		buf_rel_source = le32_get_bits(tx_status->info0,
>>   					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
>> -		dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
>> +		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
>> +			dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
>> +		else
>> +			WARN_ON_ONCE(1);
>>   
>>   		rel_status = le32_get_bits(tx_status->info0,
>>   					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
>> -		dp->device_stats.tqm_rel_reason[rel_status]++;
>> +		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
>> +			dp->device_stats.tqm_rel_reason[rel_status]++;
>> +		else
>> +			WARN_ON_ONCE(1);
>>   
>>   		/* Release descriptor as soon as extracting necessary info
>>   		 * to reduce contention
>> base-commit: 691e5e43b2aa
>> --
>> 2.34.1
