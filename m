Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E022D7D3A
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 19:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786217387; cv=none; b=gbxKIMM7jN8oQYsvqUE1XixPL3RxlCZBbc56SA7G/R6XslsmOMMoFn8s6dCj80izL03PuNWoQuvrsiWpv9CCMloUl0iysdcD3ZEF0a19afhiGcNT3pvwTlReFvSB75mfeLiWiRPWoKhxePLOjsMxhswl1NqoC2ea6kubA2rhEgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786217387; c=relaxed/simple;
	bh=yHhEujm9w2fdoxCBn3EI+A9bh1w+vHug1uM8tn17jE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUOokm7y0KM5ZYuR1hujSCtZ+w3IRi/tWAa91Wo45PIdtYaxqYeMO3ELx/Of/QQM4R/9MCquwASxgZjsM5EqvYG6AyUpPxkjSuBUrNGxlxWcd6kwfXGl8gXO7vcRKfvCmU3Nr3vvBw80UUGbuBvjtCi1web2KUjYMyu7mRdXAT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pBELRQgy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SzofiAeN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pBELRQgy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SzofiAeN"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 678GlXO3043857
	for <linux-wireless@vger.kernel.org>; Sat, 8 Aug 2026 19:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MuvSutLPjPyL9CCFdoTwZ+Nso62iCYQCLauMvboUt2k=; b=pBELRQgydIm6D/Gb
	5TVa3LH+KEImXFbEoDoXTBwwhz3YBO6ATRaJAtTkw89FvQh+VQTuTBfHuD6t6/OS
	+rQ4BYMVeyIMEWOpnO9Bpt/Jg184W79p8Zomgj2DgBOpHKOPbeR+HVr6WnqwhvgJ
	utfYL9WkM8FEarK5SjoJyP5UpGjWPoX5S0/UTaLQx4zfJTZ365NMIlS/6NEB0dfy
	NHeR+QYEIlGB/8FXOfXCMhl9NiHiX5O1/vgrELslPeL6U33sKkCxAJk/bHijf2/I
	kEHWO8TVv7T/6/W2A+bxLQOCfx0KaZY7sa8Mm1GiKKuyUIXvJpxG9/RV0zWlUZYM
	FzpNsQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fww7csgga-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 19:29:43 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb6433e9d4so982306a12.3
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 12:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786217383; x=1786822183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MuvSutLPjPyL9CCFdoTwZ+Nso62iCYQCLauMvboUt2k=;
        b=SzofiAeNBodMWu1z1NJUwM7MBXfufpBaTQLkml5ZIZ5USUhLg0UXB/zqmkJT7E8UrA
         fjntrC64/0m5ZIL4WCIJ5ylPokbZ3kZjXHXe7nj5k+0VkGvJeeyvlQgWBgzjgioWh7ZY
         s4F79NF5VCL/DubFBej9tUKX5PdbUYK0BnrfomIpGilsRAUAZp4CUKN9mxXMkripfd/h
         BHuE3s03twetHN5dlvruURKzCVFPs58fmtkabCbEdWKT/xTgY3cAG01+bKzmLt+Fobwr
         PRGAPQsxXBiwggj9gEJklfiNcImVdkcOJq67bCU3nyw2G/tqBW+j5GKvysZZaGkU40ZJ
         T8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786217383; x=1786822183;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MuvSutLPjPyL9CCFdoTwZ+Nso62iCYQCLauMvboUt2k=;
        b=MsoiWC9uvw87vVtrMRaVPqvVwulzqYXOTRvC5+Phk8nbqOj6uVdK+s6K1avCvc1Hy2
         Czpw7EavOIyV1DC7P7iDhV+oQNBmQY63sa93I8JnmKqFfL53kOhM1K8LtAg62ka5ge2U
         KSbd+B8Me28f8NsWWoQHrznEMx73lfHlCcDlcSsFdHlyJ6K6otEJjaDZ9eIBJxUeq9K5
         dsPf7q6opwVt4L8hcAsstgr0O1VTtegzRHRatUCMfumBBnfUwAhqjJ7cayg3Yy7St38U
         aDwizc5cHxCyfJlUPei1hV9c1TuRPWjv9hp+lD8nshxV6ii+F8B8bP6IM2xZrqxZblCn
         dW5A==
X-Forwarded-Encrypted: i=1; AHgh+Roh4LCBYRCyLr/COiz83Cg2y2te+10B7Awdc6G+C9Gc4e5jx3ske/arWNENGsrmt+GWpL8xHpy8Cbel+pNdiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YymIP7efQkux5I6PVUxO6K/65I+Jwd5A3aPU4k7SusTQqQuwIH/
	z5cJVjG1uF7y73GiDV7q7Mf51hQT9gH3IKOf0F4IRF+YmK3dzTDzUBEnYid0xgxxJ27SU1EQw3E
	9g1wPDzIjd1h9Z7NlkocBft2WGOcCPHWAYtGjod1074oh6NYhEN9a03mdYaQE1dY59GhVKw==
X-Gm-Gg: AR+sD11Lw5grPvgja+OIo8LB5GevpCUyfw75wpYKVGEtTh5dOM/tHEIiuLoIU92Yuug
	p3y8DQDZEg8dJLPh4Y46cl3ySq/TcBQ+sIvNxOtQ89mcAwTgrNqlIxzddYk9UzoBiIUNJGdjq1p
	2lNshOsHvjzbayRn28NrIgi0wSrvfq+IWLkT1nBNtWD7pVvYJa32Nx3PbrN0v6AxkQxNumzc5vW
	HqwbH5i0s9rfas2VbUoHQUiELkvzExCReMdTWAhNbphJD0SEFyMPdi0R9RKUpiLV+dR39+6BO0Z
	L8DIiobqnlAj3c2GXnMftKHIv/W2itJv03RI2objuOZlDUHonXXSZ5jvJ+fvXiC8HtsaZ7HUd0t
	js/RcDlRe1iia9dK3hynP8PkPeSTeegwYk9ydGbakWneNev+7DeJ/TbgXuxxl
X-Received: by 2002:a05:6a20:144d:b0:3bf:77d7:667d with SMTP id adf61e73a8af0-3cb85efabdemr39590890637.28.1786217382800;
        Sat, 08 Aug 2026 12:29:42 -0700 (PDT)
X-Received: by 2002:a05:6a20:144d:b0:3bf:77d7:667d with SMTP id adf61e73a8af0-3cb85efabdemr39590853637.28.1786217382245;
        Sat, 08 Aug 2026 12:29:42 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec128a0sm25876629eec.25.2026.08.08.12.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 12:29:41 -0700 (PDT)
Message-ID: <0b72231d-59f8-49bf-82a0-76d2c7862729@oss.qualcomm.com>
Date: Sat, 8 Aug 2026 12:29:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] wifi: ath12k: implement custom wake_tx_queue with
 flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260807105843.20203-1-jtornosm@redhat.com>
 <20260807105843.20203-5-jtornosm@redhat.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260807105843.20203-5-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: NqD3RhFQCHKV9RkQzvSKzryvuo8GXNdH
X-Proofpoint-ORIG-GUID: NqD3RhFQCHKV9RkQzvSKzryvuo8GXNdH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA4MDE2OCBTYWx0ZWRfX5mEDTrMgjoze
 GHbajjGe25Vzbbl0++6SjJbga28ED0P6ssFyC3KSlyQiO8E7V8WLOzovA03o/c9EtIckkeE7sAa
 vvvlFNu8q0tY7vw0Bb+7XmrDcz5TSEksNUJF3FmoP7/G5xN9nwj9q29VuKbUQTD5b33dlv0xDCC
 2dPBUTZA6hcdIKJU1s09lYnFrHyyt7fE1veSYustkDFMneHD9LGbaJn1hqs7CRdZc4up6bIfgCo
 8WdriJbiVorrsydTf1lQzDHSFUfc5DRHZUyCIQ7Jz0MFcG8s94Ydk0Z9Tk1SaW2MqegeShmS9Yj
 1ICtcG3Ti+n2T5+4p/pJDTkpukjLD2Pu9zPZvbDU55N3ek29qy9AKdCPH15sflszmrE5WRWQaHT
 sYD1Ua8+Wv0VcJZYHlD7Badtf+CLtUyuwzGfgZQD29Mlb/WtkxY2jpZK6M3OrDaDy8HkKUvhCw8
 M37+NKidMmfXg4fu2iA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA4MDE2OCBTYWx0ZWRfX+KySv3NSB84X
 t/8bGUtuJzuMHtnMxIoEegRMIVbOE90BVMUa9sYiTuvbGAdaZ75jDLqM5peRg3tG323gf9gwo6u
 F0L5hanHpJR7mQvsn+Yhf0mpUPXQGQo=
X-Authority-Analysis: v=2.4 cv=IPsyzAvG c=1 sm=1 tr=0 ts=6a7783a7 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=Vholvesw0q1f2_GdfVUA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-08_06,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608080168

On 8/7/2026 3:58 AM, Jose Ignacio Tornos Martinez wrote:
> Under heavy traffic, ath12k can hang and experiences -ENOMEM errors
> ("failed to transmit frame -12") when the hardware TCL ring fills up.
> This issue is more commonly observed in VMs with PCIe passthrough but
> also occurs on bare metal systems.
> 
> Implement a custom wake_tx_queue operation that:
> 
> 1. Checks hardware ring space before dequeuing packets from mac80211
> 2. Uses per-ring locking (wake_tx_lock with spin_lock_bh) to serialize
>    concurrent wake_tx_queue calls targeting the same ring and to ensure
>    bottom halves are disabled as required by ieee80211_tx_dequeue()
> 3. Syncs with hardware state to get accurate free slot count
> 4. Resolves the target TCL ring once using get_ring_selector(txq->ac),
>    which selects the ring based on the access category
> 5. Returns early during firmware crash in the same way as other
>    tx paths
> 
> This approach follows the pattern used in the iwlwifi driver, adapted
> for ath12k's hardware ring architecture.
> 
> This prevents hangs, eliminates -ENOMEM errors, and improves throughput
> by optimizing resource usage and preventing unnecessary packet drops.

Tested-on missing

> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
> v5: Remove an unused variable
> v4: https://lore.kernel.org/all/20260724053121.15759-5-jtornosm@redhat.com/
> 
>  drivers/net/wireless/ath/ath12k/dp.c       |  1 +
>  drivers/net/wireless/ath/ath12k/dp.h       |  2 +
>  drivers/net/wireless/ath/ath12k/hal.c      |  1 +
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c | 76 +++++++++++++++++++++-
>  4 files changed, 79 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
> index af5f11fc1d84..3d46cfbf0a1c 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.c
> +++ b/drivers/net/wireless/ath/ath12k/dp.c
> @@ -1539,6 +1539,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
>  	}
>  
>  	for (i = 0; i < ab->hw_params->max_tx_ring; i++) {
> +		spin_lock_init(&dp->tx_ring[i].wake_tx_lock);
>  		dp->tx_ring[i].tcl_data_ring_id = i;
>  
>  		dp->tx_ring[i].tx_status_head = 0;
> diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
> index f8cfc7bb29dd..68d2020be9b8 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.h
> +++ b/drivers/net/wireless/ath/ath12k/dp.h
> @@ -58,6 +58,8 @@ struct dp_tx_ring {
>  	u8 tcl_data_ring_id;
>  	struct dp_srng tcl_data_ring;
>  	struct dp_srng tcl_comp_ring;
> +	/* Serializes wake_tx_queue operations for this ring */
> +	spinlock_t wake_tx_lock;
>  	struct hal_wbm_completion_ring_tx *tx_status;
>  	int tx_status_head;
>  	int tx_status_tail;
> diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
> index a164563fff28..071cb5d30931 100644
> --- a/drivers/net/wireless/ath/ath12k/hal.c
> +++ b/drivers/net/wireless/ath/ath12k/hal.c
> @@ -390,6 +390,7 @@ int ath12k_hal_srng_src_num_free(struct ath12k_base *ab, struct hal_srng *srng,
>  	else
>  		return ((srng->ring_size - hp + tp) / srng->entry_size) - 1;
>  }
> +EXPORT_SYMBOL_GPL(ath12k_hal_srng_src_num_free);

NAK, must be EXPORT_SYMBOL()
The ath12k code was contributed under the license:
// SPDX-License-Identifier: BSD-3-Clause-Clear

>  
>  void *ath12k_hal_srng_src_next_peek(struct ath12k_base *ab,
>  				    struct hal_srng *srng)
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> index 7436cf70925a..af0a3ba805dd 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> @@ -1100,9 +1100,82 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
>  	}
>  }
>  
> +static void ath12k_wifi7_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
> +					      struct ieee80211_txq *txq)
> +{
> +	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(txq->vif);
> +	struct ieee80211_tx_control control = {
> +		.sta = txq->sta,
> +	};
> +	struct ieee80211_vif *vif = txq->vif;
> +	struct ath12k_link_vif *arvif;
> +	struct dp_tx_ring *tx_ring;
> +	struct hal_srng *tcl_ring;
> +	struct ath12k_sta *ahsta;
> +	struct ath12k_dp *dp;
> +	struct sk_buff *skb;
> +	struct ath12k *ar;
> +	u8 ring_selector;
> +	int num_free;
> +	u8 ring_id;
> +	u8 link_id;
> +
> +	if (ieee80211_vif_is_mld(vif) && txq->sta) {
> +		ahsta = ath12k_sta_to_ahsta(txq->sta);
> +		link_id = ahsta->assoc_link_id;
> +	} else {
> +		link_id = ahvif->deflink.link_id;
> +	}
> +
> +	rcu_read_lock();

does this lock really need to be held for the entire function including the tx
loop?

> +
> +	arvif = rcu_dereference(ahvif->link[link_id]);
> +	if (!arvif || !arvif->ar) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	ar = arvif->ar;
> +	dp = ar->ab->dp;

or is it sufficient to cache these values and then rcu_read_unlock() here?
my LLM reviewer seems to think that would be sufficient

note the spinlock in the while loop will cause the RCU read lock to be held
when invoking mac_op_tx(), satisfying the RCU lock requirement there.

> +
> +	ring_selector = dp->hw_params->hw_ops->get_ring_selector(txq->ac);
> +	ring_id = ring_selector % dp->hw_params->max_tx_ring;
> +	tx_ring = &dp->tx_ring[ring_id];
> +	tcl_ring = &dp->hal->srng_list[tx_ring->tcl_data_ring.ring_id];
> +
> +	while (1) {
> +		if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH,
> +				      &ar->ab->dev_flags)))
> +			break;
> +
> +		spin_lock_bh(&tx_ring->wake_tx_lock);

using guard(spinlock_bh)(&tx_ring->wake_tx_lock) would eliminate the need for
all the spin_unlock_bh(&tx_ring->wake_tx_lock) calls

> +
> +		spin_lock(&tcl_ring->lock);

seems this should be spin_lock_bh() to align with all other callers in the driver.

> +		num_free = ath12k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
> +		spin_unlock(&tcl_ring->lock);
> +
> +		if (num_free == 0) {
> +			spin_unlock_bh(&tx_ring->wake_tx_lock);
> +			break;
> +		}
> +
> +		skb = ieee80211_tx_dequeue(hw, txq);
> +		if (!skb) {
> +			spin_unlock_bh(&tx_ring->wake_tx_lock);
> +			break;
> +		}
> +
> +		ath12k_wifi7_mac_op_tx(hw, &control, skb);
> +
> +		spin_unlock_bh(&tx_ring->wake_tx_lock);
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
>  static const struct ieee80211_ops ath12k_ops_wifi7 = {
>  	.tx				= ath12k_wifi7_mac_op_tx,
> -	.wake_tx_queue			= ieee80211_handle_wake_tx_queue,
> +	.wake_tx_queue			= ath12k_wifi7_mac_op_wake_tx_queue,
>  	.start                          = ath12k_mac_op_start,
>  	.stop                           = ath12k_mac_op_stop,
>  	.reconfig_complete              = ath12k_mac_op_reconfig_complete,

