Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8628635D
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 06:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785132478; cv=none; b=lmfwaykVIgc+nSk0KkK0hdqPMoD1VYMMOBSZz7hWgjOfjaTVpV+sL1KfP/7j/qjmZrx5zyVtrXXo7ZIjcrnZ47mTeWaxWqq6iKCPxmlnNn9dD2d+6d8Rie3u4PWt1pcq6A4YYvc+uE/Xmx2RlJpDNdewfr993rthqNe78QQrzJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785132478; c=relaxed/simple;
	bh=w47HC4/dG/zHAnmb81mtYR4tlvKSjQDXjXekzHM5YjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mm0R3BFIyYWF3qq60CJkuW2nJ409AjkbusXFqq2nxz5zWCLSoT5tnGAoXMWoSAe9SbsFjQ1qGkBbshDqVwCaQN85AxZlo+m+cHys9sexYe1Ke0lnEQFd5XT5RU/1jxiiL2YoxdyZX13qqqJGeeowyptvuudBVHxx9rRFpxRKjeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pQJ9NZt/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NFk2njio; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pQJ9NZt/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NFk2njio"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1gkx02139449
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 06:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gCLCsloY+3vPAHcmMgoxsQBtxcBgu97GDuDz3PvF0Xk=; b=pQJ9NZt/EvqZzYI0
	pwxDbJWFaLUkpONjb8ppcdymqmGomZ4IczTY31/2RZmdZa8F9B7OZF5GT0kn+/Po
	Eh5vCVGr/KioorildjSz0uDCH8D/WrGRKauIRYpP3Yldgi7JvXoBRXWMh5L9szc5
	61dx4WpsikoDplVrmRDYzL3hI95JZ6CnoFMtNrhWJ7XX7AYZn3drAju2JKA30/FO
	Oyy42XhyfuV2gnSPDZStfAl2WMekMtZY1kzXkPeQpy7AsIDiy7QUb2BGJmZtGSXS
	CBcJW2kR37+iwLvSd431K6CZTV0VxkGlLxGd1nuTPL3hePzspRmnwOPTaP7JPIUR
	PfYv4w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnh7vqb1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 06:07:55 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb733fc5024so3285604a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 23:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785132474; x=1785737274; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gCLCsloY+3vPAHcmMgoxsQBtxcBgu97GDuDz3PvF0Xk=;
        b=NFk2njioVN2DMcRhYhPTj0mAt4iN2k2/9J38h15ApvGvDbQ0IPGNnubTsHj0BwgFLo
         3XvLWA+uOWRrbmDn9ZEGFlBWHu/bGlH0bl9boRL+LB0HxBfAur7pi2Tj1sXNT+M3SjNs
         PTKd7MnWawWmvVH7nyjKhQRliD0IsNGCi6c1LyovUKMq4SP6prppjq+pQOKvqvuJBHnt
         RuBaVRnY7pRHO89r/LZsvlOOOcIL9OKO/cm5W+rnJH6fHlGgyLKJggfJ0S2DcE6Z9UUd
         h5x4U572dFaTQf825rnt4SahBy5aDIm63Sr86dvlOso5eDu8ZMN0v0/VN7KpxfuoTz8K
         S4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785132474; x=1785737274;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gCLCsloY+3vPAHcmMgoxsQBtxcBgu97GDuDz3PvF0Xk=;
        b=pToxZTbmd99iwohXvE9rX6+BGslhlSxnz4Hqd30sue0l9o0P2vWA5IrQ4oVhPbz4mU
         eNmzNvghIfgEdr1IRQv2oD+wUXZX1oxIPz7nUJ3/uJ8lVUfnOuDbIGGNu2HOU5AA7esQ
         aAe2/lUCF/NEhzcYf5Zoo/W4L54kTD4+NEXz3P0FBeDfUqvlaHGRSOIMAcDoAY08T0Sm
         8InSvy/fTEVQsHmCiUkcMHj1/1ve2ueC+OJeksc38+PiyEVPF4vFBAccZC8FwMAykfu5
         71ZY7lQNdRP8JOzLpy9OvnQh7EQ0gzQs59WAiW509jaEVbPN8Xq0W63QXEKt3AAcsqJM
         UCwg==
X-Gm-Message-State: AOJu0YxytzdVeiZsS1K2llyOovCABpI7QGUTs54Qn0YwXsHPiblysYFg
	bbSamXLHQOUKyyw+lX57auBsTGCgoTTccIkxm6ZJxtX3Rbg+OcMvqSZTT8uOStbILyeK2bh0l32
	HM1C7CUM8SugTIiaDwtA6nclpdCCwEUYDoI+87FQyuf/XbEdZs/feV7nc/aaF55BrFreNvQ==
X-Gm-Gg: AR+sD10MKk/ERFqihGa2FfxV5Mrf3VM3v1BuTXXqw/R+L4OMb9ya0YGJO0yjkzOTPaQ
	xwZHCXvYU5QrVX2V38xgZ6UNI61H0BgeO+uLrEowfeQu4j1lRo8NI0XVFoIqcAXKbDlBhOIZgW2
	Xk1+U6rneCBbGgnYe51XSlWKVdBQltAgMCP6gQn8xzNOHEcnXfOCAw0qotzJnqn4KRUooZkUgcR
	7IqQJECzFwAARjd6ixKMXzxWxNHh7qyZzAD3h5WvX2DfL/ctyZ8NMyz2HwrfG1erO2LY1lrBEK8
	Vsb0SjNQRJZJzF8g+LRczX92XkSqHKfe2j90+VPTLfilQUQhRCaAfMtZfp1CDz1xmcRilQvlfgN
	SYumNM7HYaGBTusm2TLwkrkIT8X/UsqTlGSxsvHNCCGFnr/cSs3HptpGiuo6JExdrVPhePMqmcS
	t8OBkF3ujvd5SHpcEDWbc=
X-Received: by 2002:a05:6a20:430d:b0:3c3:89cf:f55 with SMTP id adf61e73a8af0-3c67e11ab3dmr7019681637.61.1785132474515;
        Sun, 26 Jul 2026 23:07:54 -0700 (PDT)
X-Received: by 2002:a05:6a20:430d:b0:3c3:89cf:f55 with SMTP id adf61e73a8af0-3c67e11ab3dmr7019652637.61.1785132474032;
        Sun, 26 Jul 2026 23:07:54 -0700 (PDT)
Received: from [10.79.124.106] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc548e63sm28217281eec.19.2026.07.26.23.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 23:07:53 -0700 (PDT)
Message-ID: <2067da3b-cbee-4c2d-8104-4b5d74846675@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 11:37:10 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Guard dp_peer dereference in
 ath12k_mac_peer_cleanup_all()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260722095828.2930377-1-hbijlani@qti.qualcomm.com>
 <3d793ba2-09f1-44e4-95c4-1ad877db7b4d@oss.qualcomm.com>
Content-Language: en-US
From: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
In-Reply-To: <3d793ba2-09f1-44e4-95c4-1ad877db7b4d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: XkxUGeRuqne3tTQVQ2NogqCbZYl7uQMw
X-Proofpoint-GUID: XkxUGeRuqne3tTQVQ2NogqCbZYl7uQMw
X-Authority-Analysis: v=2.4 cv=f/54wuyM c=1 sm=1 tr=0 ts=6a66f5bb cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=QSdo0hW_NjUXybdPYREA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA1OCBTYWx0ZWRfX2xzZxT8Mj5ra
 hZGzX2ASEVw6MPCtZfKYhM5O373A/rnGM9S/x5Fom+P4w7dKXsPBl/6iDddqhxZW3+dbRUZSVQC
 AxgBHdEcHM8GHgHnsjxYWXZi2PwaqB4L0YHMabW/QRe8WCKg5AcJOe5pthAt9Jn0cib4/1vIEVY
 WX/TQY7CbnWI40khgrmEucB8VNGjmRLTE/fLmgDnwI3pjF5PRLCrS8Fkz5EwNxKcwMVBM8RpbjC
 wtq/Guf1o3lAf/HDC0k1AqEGOTUhYIkuNncJDJy+j4ndcNjzf7ajy7JH6SbNlqXF+lPTC6S1+Lm
 DB6pTS2XuEzE5t7NuufNkqpgFJ6uDXeIT9+0skR1y9C5M/I0HY/dD9SJm56mIoYxlR8okEeMRMu
 fH30FwoiE0tDE3DOuf2VPL5rDwF94Ia6GMFnvLNPSltOo+GU61X+Wfcc53KyvU4CzserkaKAaVg
 ESsGd+iOCu9cnluPwZQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA1OCBTYWx0ZWRfXwc1zqlvzcYKk
 7YoViis85tqkd3r/+DjVI8R1x+BsVhzrWMhm5z3iOUr+cXD+2Hvkj3XB97pFbeBjqJEoULCgWtL
 VEYkLtUSCnwGDwbMHEVendK7qu118gc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270058


On 26-Jul-26 1:08 AM, Jeff Johnson wrote:
> On 7/22/2026 2:58 AM, Harsh Kumar Bijlani wrote:
>> From: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
>>
>> In ath12k_mac_peer_cleanup_all(), the code iterates over all
>> ath12k_dp_link_peer entries in the dp->peers list and performs
>> datapath peer cleanup. For each peer, it accesses peer->dp_peer
>> to clear the link_peers[] and dp_peers[] RCU pointers.
>>
>> However, peer->dp_peer can legitimately be NULL. The
>> ath12k_dp_link_peer structure is allocated and added to dp->peers
>> during peer creation (ath12k_peer_create()), but the dp_peer
>> assignment happens later via ath12k_dp_link_peer_assign(), which
>> is called only when a valid dp_peer is found or created. If the
>> peer creation sequence is interrupted, for example, due to a
>> firmware crash, a race during interface teardown, or a failure
>> in the HTT peer-map event processing, then a link peer entry can
>> exist in dp->peers with dp_peer still NULL.
>>
>> Accessing peer->dp_peer without a NULL check in this path leads
>> to a NULL pointer dereference kernel crash during the mac cleanup
>> path, which is invoked on radio stop or firmware recovery.
>>
>> This is consistent with how the rest of the driver handles this
>> field: ath12k_dp_link_peer_unassign(), ath12k_dp_peer_cleanup(),
>> and several other paths all guard access to peer->dp_peer with
>> an explicit NULL check before dereferencing it.
>>
>> Fix this by wrapping the dp_peer dereference block inside a
>> NULL check, mirroring the pattern already used in the same
>> function for the Rx TID cleanup:
>>
>>      if (peer->sta && peer->dp_peer)
>>          ath12k_dp_rx_peer_tid_cleanup(ar, peer);
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
>>
>> Signed-off-by: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath12k/mac.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
>> index 956414b953ec..18c1c809ae4d 100644
>> --- a/drivers/net/wireless/ath/ath12k/mac.c
>> +++ b/drivers/net/wireless/ath/ath12k/mac.c
>> @@ -1237,10 +1237,12 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
>>   
>>   		/* cleanup dp peer */
>>   		spin_lock_bh(&dp_hw->peer_lock);
>> -		dp_peer = peer->dp_peer;
>> -		peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
>> -		rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
>> -		rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
>> +		if (peer->dp_peer) {
>> +			dp_peer = peer->dp_peer;
>> +			peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
>> +			rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
>> +			rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
>> +		}
>>   		spin_unlock_bh(&dp_hw->peer_lock);
>>   
>>   		ath12k_dp_link_peer_rhash_delete(dp, peer);
>>
>> base-commit: ca27e3c2284a7a43ba390ed5ce0d68b3c869c0ce
> This patch does not apply:
> * Applying
> 20260722_harsh_bijlani_wifi_ath12k_guard_dp_peer_dereference_in_ath12k_mac_peer_cleanup_all.mbx
>
> Applying: wifi: ath12k: Guard dp_peer dereference in ath12k_mac_peer_cleanup_all()
> Using index info to reconstruct a base tree...
> M       drivers/net/wireless/ath/ath12k/mac.c
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/ath/ath12k/mac.c
> CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath12k/mac.c
>
> It conflicts with
> a2fe9dc70f3b ("wifi: ath12k: Fix low MLO RX throughput on WCN7850")
>
> And since that adds the NULL check I think your patch is actually not needed?

Yes, since change a2fe9dc70f3b ("wifi: ath12k: Fix low MLO RX throughput 
on WCN7850") is already adding exactly the same check,

hence this patch is no longer required and can be dropped.

>
> /jeff
>
