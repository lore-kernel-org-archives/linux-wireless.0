Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853123C13FB
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785080537; cv=none; b=dBy0SDxn0oBKQKLo1ExCt4eG+uZpte/a8JdwHqCOsKSqHqqq7bdowv6Lsx9TrwscFzNMFP01En63edtMeGlMP8RPP9k05ewJh3Ln8NCMLcVWzTfxziuHAjeaR+AItYBAt8hGWiOy9MlQON7rp2uKucB+zDkcIk1iY3iHgaqn8fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785080537; c=relaxed/simple;
	bh=V5+e4jJn5FCQHnFDu9ae7szfEHJdj9ZX5hakmedlMzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQUZ9oCRMMMyY3sdqk4tkqr4mhYsiIJKc5yafIYVBY59z/IHOOIgC+Uz79r4GtUl06fCJupTvQ4rhsb/RYJh46ixx71epMGrbu16CR+yeAxky1F/6NWhPlndSSwA6cMjLc++8qpZYJxb2EitQ1dd9+gRgywqq16RQwQDoR0o2nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aUgqhjjR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gckTxiYP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aUgqhjjR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gckTxiYP"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QE39QU813282
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	v200F8RN3Gyi9qoIEhul2UgJeVzD/qG5lgvFwS9sbVg=; b=aUgqhjjRKeWT/B+j
	WLlikbG9zzhXgJJyK/dK9rRc30cGthlbi5vASdtwk5F4MojVeYiemysJ12v2wVRp
	mI8YTf3dkQKmDl5ZVsyREPTS8y2U2fuGQ87jP04LoXaBNK+74EMR6lkG4cQ448KE
	Ha1MHFPbdyeoRZi1UNH9dUrMUVTrZdgg2Ac3xd2jbfb5Q9Nmv+hwf80jKolMdw0H
	8VGA3iOAq8yBUBEFiTo57+BDqx+vZwVvnKgrZEFt946eFg5Z7O27OLv+CsbAWe15
	IPW/WZSN8Tx6+VMzZjQ1xjWRJ3n+2hgy1q4eIze2Fz4ragJTDALZMJBZcTlAv7d/
	4b0xgw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmjgn3mgp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:42:09 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e63de75aaso3225541a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 08:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785080528; x=1785685328; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v200F8RN3Gyi9qoIEhul2UgJeVzD/qG5lgvFwS9sbVg=;
        b=gckTxiYPyLiCYbwNd0+p+7jeJqPfxWJafB1HrU94mpXs7hFTnLC549KAgzo9Sxgwc3
         N50GVGyJnAZVA0OzjQUOPzr/yEAceoU3gL8hOHTxx0DjwDI9WwKwLiJ/h2Kw+ixY1Iha
         p9BGpGxhIg14y3LDuowCXVJ9z2qqolZ2ChGEE8ok/Ky1YiFVCYvMKCzrn1VpOdKNT6Hz
         Cg06KxO5MUHdH2BzTtwkuww9uTULUy4740rotHrAQsQgQL1VoTy07U5QRUoWrWt2iV2D
         AykBhq48lAXTVaUC4YrtS60Faqik7mjkFkk3/yTNvVsBIaJ5LgQkdWzHLUEjM5aqI/cM
         j7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785080528; x=1785685328;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v200F8RN3Gyi9qoIEhul2UgJeVzD/qG5lgvFwS9sbVg=;
        b=MjGnoK48mHe+yxEJAFo7imgHyk6guiR/+ZVIQfzIPFrzUFt7ECIu/Ji6ol4odeD484
         Nu60fqPd3jcJOTgIcKdGQvww13MtuntNr/g+ukua3QcplH8UAKNDRyy1qU7MHF+IFDhB
         8ECY7lR5NcMlN5ZyaovVTjDgumbi2W6OLZR6rpfpbWzOaa2+OiIJ0rB+sQOn+UIWxmbN
         qVRW21mqg3znVPEeKGwWKJT/kzdttnTTuupkUx6QCnMjAft11eLxDflhCjSH0FWGJhcX
         bb3KBXqeRklMrKqSOVMQ4gNsa2qhUr2EY0vxHSpgQJyyRNO6u9YCIL3t5u1eJvZYL7Nl
         rsOg==
X-Gm-Message-State: AOJu0YzjHboeme+U8Ge85GlSe3DpV2g/QjerNCkIRQn1r0gQ33Urwg1b
	JLjeDqcE9y8pvQBERklg0ZmcYi50YaWD9mOPmeey95b+mQ562xedK7TS9wS0fgR4E3W8Pi+sMIT
	NRVZb2U2/allIaqYGYVTds3omdVcQHwFuWdSGvwZHAZvcp+tdEB5vOXXUkUnGfYKyTXgA+A==
X-Gm-Gg: AR+sD12M3JMCRFVU18B6OwjPCszGAwJhiAnW8BMt04gACEC4NZIQDeMjIjb2NhKuYtL
	BD+QoI8AnPHox4kem0jV561P270ufZIl+qmciSdVud4AvS3iqdfk1a+yCbOwhseXoAGBsJnL2qx
	FCFZno+NNQFEYOO4wO1SFimDDmgcGGE831J0o9OgqKwvmjeyHepECjICPrKxmJIuuXWD01RarlQ
	CmcI9q/5FhAEJCocOmt4A40AITULQWzzvcXYRJBs4xCgy+Gekz7+oqA2oXsuEwGBXzyVYuYLE+7
	DWIfcki3lm0uJSqhtcsz1lkR5yhpvLBv5PqcWU8u1XE052iZFNJ9M1uo37bF82BaSpn8synolbv
	cikks1WQLfed7PQCjRINY8O2PGoWckePAYWaWZNxMafvA6o3s+HeJoAGqOw==
X-Received: by 2002:a17:90a:c104:b0:38f:474f:e78 with SMTP id 98e67ed59e1d1-38f474f1029mr1178329a91.38.1785080528493;
        Sun, 26 Jul 2026 08:42:08 -0700 (PDT)
X-Received: by 2002:a17:90a:c104:b0:38f:474f:e78 with SMTP id 98e67ed59e1d1-38f474f1029mr1178319a91.38.1785080527937;
        Sun, 26 Jul 2026 08:42:07 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130f55c6sm72975488c88.15.2026.07.26.08.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 08:42:07 -0700 (PDT)
Message-ID: <88f7d41f-43e2-4dd3-9479-8d45f2da668f@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 08:42:05 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 3/8] wifi: ath12k: add TCL ring TX buffer
 allocation failure counter
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
 <20260723125448.922361-4-pardeep.kaur@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723125448.922361-4-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 5sQoJIqTVvR4Wc32A-IHKFV-I3KXCtiH
X-Authority-Analysis: v=2.4 cv=HMHz0Itv c=1 sm=1 tr=0 ts=6a662ad1 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Jcmr85nzS8LN7tR81WgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE1OSBTYWx0ZWRfX1yFumZmafybO
 CEDyVv9b3QOpGy84GFVcEiuGWufXl++Qziy2/uJ28jWNC5dUAPnwNBmb1jc0GOIxGcfDoqmT5Qz
 6Q83HijLCQfy4AhU2U5zhQjE2lzUNNUIZ0z08j+99sX7pk88sX8W8iohCFK4oj40ohp/j4u+2//
 kB0XDWbzsGHCbd2l6we/ILqCFyydLm+leRmeiIWsa/6RWIo7mzr19gclBTGr+jiOpSFEO2bcID2
 5pAWIe860+E+QxErwTPSBxql1lyA3X0fhLu/p3/np+F69QUqca6aGFCGJWezpyCiI8KhzAD19aI
 4bFOC58c8eGHMg3V6GhztXGSosb8RH1SXPpkgVeu2Ooh7nU3SVmPT87+M8Mcc4LEWTtHDs9tlfR
 ZxaFLJwx/zGodtneyX49jL+yrbuZe+ngiGh2YQFIsLTqb/Jb3337VoBAKKxfVISTtn/y9NAi4W7
 G1vB/b9bu5QF28ABCoQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE1OSBTYWx0ZWRfX7LnlrtvhZiX6
 v99ZBtn+qyaPocv/dLwyGEyCO0eQnBOr++Exyh2g5wXR2L2RWtnW9yywouJG8sBMLgFv7dK1yQj
 yx5CHzonVj10qX0Qu0+KsRnLfeHT8X8=
X-Proofpoint-ORIG-GUID: 5sQoJIqTVvR4Wc32A-IHKFV-I3KXCtiH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260159

On 7/23/2026 5:54 AM, Pardeep Kaur wrote:
> From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
> 
> When ath12k_dp_tx_assign_buffer() fails, the TX path returns -ENOMEM
> silently with no per-ring visibility into how often this occurs.
> Without a counter, buffer pool exhaustion on a specific TCL ring is
> invisible during debugging.
> 
> Add txbuf_na[] to ath12k_device_dp_tx_err_stats to track per-ring TX
> buffer allocation failures and increment it on assign failure in the
> TX path. Expose the per-ring counts in debugfs under a new 'TCL Ring
> Buffer Alloc Failures' section.

Is this counting the right thing?

One of my review agents has the observation:
The txbuf_na counter is indexed by ring_id but the exhaustion it measures is
from tx_desc[pool_id]

So I drilled down with another agent and got:
The commit message intent is to answer "why was this frame dropped", which is
valid. The practical question is whether ring_id or pool_id is more useful for
diagnosis:
  - pool_id = skb_get_queue_mapping(skb) & 3 — a property of the traffic
class/queue
  - ring_id = smp_processor_id() % max_tx_ring — a property of which CPU
processed it

If a pool is exhausted, pool_id tells you which traffic class is
backpressured. ring_id tells you which CPU happened to observe it — less
actionable. So the other finding is a genuine semantic improvement, not just
pedantry. The fix (txbuf_na[pool_id]++) would make the stat correctly answer
"which traffic class ran out of TX descriptors."

So does tracking by ring_id or pool_id make the most sense?

> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
> Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/debugfs.c     | 5 +++++
>  drivers/net/wireless/ath/ath12k/dp.h          | 2 ++
>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 4 +++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
> index d54995b7adb2..0f8b458200a8 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
> @@ -1117,6 +1117,11 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
>  		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
>  				 i, device_stats->tx_err.desc_na[i]);
>  
> +	len += scnprintf(buf + len, size - len, "\nTCL Ring Buffer Alloc Failures:\n");
> +	for (i = 0; i < DP_TCL_NUM_RING_MAX; i++)
> +		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
> +				 i, device_stats->tx_err.txbuf_na[i]);
> +
>  	len += scnprintf(buf + len, size - len,
>  			 "\nMisc Transmit Failures: %d\n",
>  			 atomic_read(&device_stats->tx_err.misc_fail));
> diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
> index a94bbc337df4..ac125adde258 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.h
> +++ b/drivers/net/wireless/ath/ath12k/dp.h
> @@ -428,6 +428,8 @@ struct ath12k_dp_arch_ops {
>  struct ath12k_device_dp_tx_err_stats {
>  	/* TCL Ring Descriptor unavailable */
>  	u32 desc_na[DP_TCL_NUM_RING_MAX];
> +	/* TCL Ring Buffers unavailable */
> +	u32 txbuf_na[DP_TCL_NUM_RING_MAX];
>  	/* Other failures during dp_tx due to mem allocation failure
>  	 * idr unavailable etc.
>  	 */
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> index a0e409452a19..ca0e1369af21 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> @@ -123,8 +123,10 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
>  	tx_ring = &dp->tx_ring[ti.ring_id];
>  
>  	tx_desc = ath12k_dp_tx_assign_buffer(dp, pool_id);
> -	if (!tx_desc)
> +	if (!tx_desc) {
> +		dp->device_stats.tx_err.txbuf_na[ti.ring_id]++;
>  		return -ENOMEM;
> +	}
>  
>  	dp_link_vif = ath12k_dp_vif_to_dp_link_vif(&ahvif->dp_vif, arvif->link_id);
>  

