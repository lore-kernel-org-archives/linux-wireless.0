Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA29388E46
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786214564; cv=none; b=oW2pv+a8+74hk2ZerJLO+6YofwvSyPIcTrU9SThR9BeRH8zRMMynJRQM2jzYAbiuxWtCvx2GljaOWrFAJwKHgC4zj+yPn+q5oVFy22ZWW9JgjxStijkKUFDtKDrDsXGA0mNxCWiH1W4vTkE8uCpkgbBtcyElFUjowV1DmSHmTvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786214564; c=relaxed/simple;
	bh=CXTNVWk0nM1c6uXQvrDt7Os7kFZuJq+eq97SupFvbmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aiZ3aodV5SuGBEe112vq9XYQmtlXeMH1nzMezbkGZtWx8fpbACuz6F3nQUwr7WtUd8stsY0lhJA4WqbkxXZmJnaCdiyYx1ugjY/ajiXIw6iGQq88l33XXSxUm0aQT/IIFuqFoF6Yf9RQFRzBOuP2GLgenCFcB8MnIaVfGJ1e33k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KRHwmGjb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QiMp0+gu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KRHwmGjb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QiMp0+gu"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 678Glseb360702
	for <linux-wireless@vger.kernel.org>; Sat, 8 Aug 2026 18:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/DDHErlHnBZz4VB/m+ePIzuov6kkItLoeXRusC4Jtj0=; b=KRHwmGjby/MZWAt6
	Y+w/dytUnBVUtxQyajM/anT1Dlooq2bHgMtgRZRyCfx7lnr4AdcHzxY1BZo/mXKB
	AkVuHREXgXsdEE5JX3KQsYXDMKag9qgm4r48MMpvjRqUU15uPmbVxjCJ0u5fGzM1
	imCqfpjO7GiO97lYhGmCd7LD5AS5x1Mfl+vANiAb3eOf/ktg88zRhnmYX72RQEu6
	ev7sgFotwJHJILp3L2721fTbmTu/NoZgIq9YIEKNrJl3aimb3xGJpzn4lpJmKvTc
	BxR50rG0Y+BgjzBFANhVZli5leWiA++U9GJI/IzVWNNZOcyUwA90op+wjaD3sLuo
	Opia2g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwstp1u45-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 18:42:41 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3811279d51aso1298037a91.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 11:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786214561; x=1786819361; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/DDHErlHnBZz4VB/m+ePIzuov6kkItLoeXRusC4Jtj0=;
        b=QiMp0+guH8pvNbDgt1g5bx/JYF6ROf3ne29kpYciDtpwOKgqOYQOPGpnh3a4tdTUBZ
         w4RIXlwJCE8QhytJmUCfO3DO3U0XTCumuMh0ctd0RhYqt5Tn+Tif+l9upmAowolvAf+v
         LUd5meSgdu3NeuB2wkaMKB5/x+NXynlcbQsYigV3AsE7oftvBcn3JfAWYVSp6JIMuAY7
         M3ir+xr/tmal/nemKf6LGoxnP8Deo5wgzjbK6q+Zro5N8FcRkljN19piSYeHgYa8lVnG
         nFMhfOxjx8udDYXyJs2/EK3i7jv+S4T4A+ey8PslzxyEi81Ncq6Vz37ZnTBfkfjiK9nt
         lp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786214561; x=1786819361;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/DDHErlHnBZz4VB/m+ePIzuov6kkItLoeXRusC4Jtj0=;
        b=WutVlPTZl51fJhBHa8lRoLvWsnJdnHYcp9ivaVYyCaNdGZ38tUcl+XXrR32f1knh1S
         gyddZjQ+p+eGPZLdCN1cZL4zsydp8NC7zfaH2uiwJyH2fvQnnwJEhgC8CZoNvD8SChuA
         0A3D3JpItJpyfRBGwSLY1ii1Tam0Nhd3GaiJa0YoHT9uQzJ45xLA3O++l4PPlI8Yjngo
         J5CHlitc/yoelajt9Yuc82HFi+4mN9NESJPBUN1KRue0rCwEjKplo2TtrMow32gZOurz
         CJTaaP8RxD67OKdP+2CYpRBqZfQlgqxJCXS1z1oLf5D3v7WXd0WTkIu6R0HENVrCah4K
         UFYQ==
X-Forwarded-Encrypted: i=1; AHgh+RoZg0K0V5tvmcBbOR0zcc4NMs564Q2yBV/zhgoepVWqb8c2Bp3gwkpAE48dksl6bsvgt/lMoFe5wKL0FS0KZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxnBLQMfYRwTZK/UK6JU7OCpVQP9FYEvdBeLQp913x1n28ulcI
	7arnOBPnvTf+WhXUuPkYiNDIhoDMa3VrRlikwSrDJl3vM+bJ6cmpWp7BeEDoE301RTT8FN1hD8i
	By1Ad9nLYy1ZA9Fw0yuhinWhDgARREobz0OGzufRjOyaLYr+qJyQDCsroAWf+doSL4TYCi3cMIE
	FFbA==
X-Gm-Gg: AR+sD10AT4SEgleTKJoFst/F/KV0eT8ieuaf0LzArKsM1BUABbeNoTaIKWcQsJMnGB3
	riwAYwpFmvJ2cBMZFNarQw/kgGxREQuyXB0S4x2fHBwe38KSSVG4Y5Efh12/jlXENSiiKyISPwK
	or0aoFtD7kPDus3g7HeOMtRBnUT7LPaOFRhAG2SrMTVi2LRb2+Bu1bXNXRFAh7nY43QqKTMoMjn
	QuDWGEzKFvRLZ+AVfyyGC+3l3PgS/Zck2F07MWDiq2cWyf47djsbd9GQI7FXyNm2oK2CEyn5fMe
	0ZZUhcJ7AEUchkwrxBzkMGcCX9T2h7mtxyD5Pjtq3REUIYaB0jSY833LCpAvjZ/fDuJzo4uNNgj
	rgDmkHde/KGzNYmi5uKbvO1eV0a7q7VVkdW9OV+iU4CJYPf53rDZziD59CewP
X-Received: by 2002:a05:6a20:7290:b0:3c3:becb:b705 with SMTP id adf61e73a8af0-3cbc0431ddcmr13212933637.27.1786214560814;
        Sat, 08 Aug 2026 11:42:40 -0700 (PDT)
X-Received: by 2002:a05:6a20:7290:b0:3c3:becb:b705 with SMTP id adf61e73a8af0-3cbc0431ddcmr13212896637.27.1786214560339;
        Sat, 08 Aug 2026 11:42:40 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb88413sm36459413eec.18.2026.08.08.11.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 11:42:39 -0700 (PDT)
Message-ID: <2774127a-01ce-4d26-b8fc-e68f49da2bbc@oss.qualcomm.com>
Date: Sat, 8 Aug 2026 11:42:38 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] wifi: ath11k: implement custom wake_tx_queue with
 flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260807105843.20203-1-jtornosm@redhat.com>
 <20260807105843.20203-4-jtornosm@redhat.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260807105843.20203-4-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: CLZ-2DEzHxC7WNa5y8rPPldoCwTmCwuI
X-Proofpoint-ORIG-GUID: CLZ-2DEzHxC7WNa5y8rPPldoCwTmCwuI
X-Authority-Analysis: v=2.4 cv=CMEamxrD c=1 sm=1 tr=0 ts=6a7778a1 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=UlviFDkLi7K7RJw89-AA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA4MDE2MSBTYWx0ZWRfX7213V86G4i/g
 OvZdwuUI1qyZAc4DGrpkBsfNQ9NI9fdZMIks5M91lwIQuKeoTNvpCwOHWc457L3944oGBZx4Pf1
 AVVJzb1i+Zk5IMSREbMqXcZLhZ9NtPQArP3j5pPLuUJ1Zt/SINsO9xwG35xId4IxIoaOP4X/NrW
 poJfby8wq6p//vaXwoGuf0X/mWZearFzJttoZrjAMaRi3BloBeF/dL1efl5EjFLq0ODkK26ps8J
 Ih9dG14+YzaLbdJriZAgbou1iJyt4fiUF6CNWVCff9hsB/ytOydsOORV/CdGcRyQg4g6XUfgR5f
 e0lbnPKGvBsu9+XjcPgae8EexcGzT+2yEZz9+WurSPx3vGKH1gqIwaSg+byWCA4EPL3SjVgm3HJ
 B9+PaGqpwuXSdSppiJHFg3fpZ4rWKZPFYdl7b6GPs5TFEulGZjuoqsDH8kX6hsEBUGFfdu7Wwa4
 Bja6QEZ6lEClbSBCa/w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA4MDE2MSBTYWx0ZWRfX0bnD3+5RYG8y
 tMclFPe4xTsuToDLsf4THxEYlcBT5rjJZcp6dw+koO2R23PNnbWO20JFN6GpBPNIE9aDp5u4u+J
 vyIq/fVwwFzvZ5UmcLODQ74ya62R89A=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-08_06,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608080161

On 8/7/2026 3:58 AM, Jose Ignacio Tornos Martinez wrote:
> Under heavy traffic, ath11k experiences frequent -ENOMEM errors
> ("failed to transmit frame -12") when the hardware TCL ring fills up.
> This issue is more commonly observed in VMs with PCIe passthrough but
> also occurs on bare metal systems. It is particularly problematic on
> devices with a single shared TCL ring where all traffic classes
> compete for the same 512 descriptor slots.
> 
> Implement a custom wake_tx_queue operation that:
> 
> 1. Checks hardware ring space before dequeuing packets from mac80211
> 2. Uses per-ring locking (wake_tx_lock with spin_lock_bh) to serialize
>    concurrent wake_tx_queue calls targeting the same ring and to ensure
>    bottom halves are disabled as required by ieee80211_tx_dequeue()
> 3. Syncs with hardware state to get accurate free slot count
> 4. Resolves the target TCL ring using get_ring_selector(txq->ac),
>    which selects the ring based on the access category
> 5. Returns early during firmware crash in the same way as other
>    tx paths
> 
> This approach follows the pattern used in the iwlwifi driver, adapted
> for ath11k's hardware ring architecture.
> 
> This eliminates -ENOMEM errors and improves throughput by optimizing
> resource usage and preventing unnecessary packet drops.

Missing Tested-on tag

> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
> v5: no modification
> v4: https://lore.kernel.org/all/20260724053121.15759-4-jtornosm@redhat.com/
> 
>  drivers/net/wireless/ath/ath11k/dp.c  |  1 +
>  drivers/net/wireless/ath/ath11k/dp.h  |  2 ++
>  drivers/net/wireless/ath/ath11k/mac.c | 52 ++++++++++++++++++++++++++-
>  3 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
> index f389b97acbdd..2e5978ec2b05 100644
> --- a/drivers/net/wireless/ath/ath11k/dp.c
> +++ b/drivers/net/wireless/ath/ath11k/dp.c
> @@ -1087,6 +1087,7 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
>  	for (i = 0; i < ab->hw_params.hal_params->num_tx_rings; i++) {
>  		idr_init(&dp->tx_ring[i].txbuf_idr);
>  		spin_lock_init(&dp->tx_ring[i].tx_idr_lock);
> +		spin_lock_init(&dp->tx_ring[i].wake_tx_lock);
>  		dp->tx_ring[i].tcl_data_ring_id = i;
>  
>  		dp->tx_ring[i].tx_status_head = 0;
> diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
> index 84f66839f0c6..6d99501aa269 100644
> --- a/drivers/net/wireless/ath/ath11k/dp.h
> +++ b/drivers/net/wireless/ath/ath11k/dp.h
> @@ -87,6 +87,8 @@ struct dp_tx_ring {
>  	struct idr txbuf_idr;
>  	/* Protects txbuf_idr and num_pending */
>  	spinlock_t tx_idr_lock;
> +	/* Serializes wake_tx_queue operations for this ring */
> +	spinlock_t wake_tx_lock;
>  	struct hal_wbm_release_ring *tx_status;
>  	int tx_status_head;
>  	int tx_status_tail;
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index 2d55cdc4d165..9813f7923c34 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -10065,9 +10065,59 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
>  	return ret;
>  }
>  
> +static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
> +					struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_tx_control control = {
> +		.sta = txq->sta,
> +	};
> +	struct ath11k *ar = hw->priv;
> +	struct dp_tx_ring *tx_ring;
> +	struct hal_srng *tcl_ring;
> +	struct sk_buff *skb;
> +	u32 ring_selector;
> +	int num_free;
> +	u8 ring_id;
> +
> +	if (!ar)
> +		return;

ar = hw->priv and the hw->priv space is allocated when hw is allocated.
so if hw is valid, hw->priv is valid, and this check is innecessary

> +
> +	ring_selector = ar->ab->hw_params.hw_ops->get_ring_selector(txq->ac);
> +	ring_id = ring_selector % ar->ab->hw_params.hal_params->num_tx_rings;
> +	tx_ring = &ar->ab->dp.tx_ring[ring_id];
> +	tcl_ring = &ar->ab->hal.srng_list[tx_ring->tcl_data_ring.ring_id];
> +
> +	while (1) {
> +		if (unlikely(test_bit(ATH11K_FLAG_CRASH_FLUSH,
> +				      &ar->ab->dev_flags)))
> +			break;
> +
> +		spin_lock_bh(&tx_ring->wake_tx_lock);
> +
> +		spin_lock(&tcl_ring->lock);
> +		num_free = ath11k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
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
> +		ath11k_mac_op_tx(hw, &control, skb);
> +
> +		spin_unlock_bh(&tx_ring->wake_tx_lock);
> +	}
> +}
> +
>  static const struct ieee80211_ops ath11k_ops = {
>  	.tx				= ath11k_mac_op_tx,
> -	.wake_tx_queue			= ieee80211_handle_wake_tx_queue,
> +	.wake_tx_queue			= ath11k_mac_op_wake_tx_queue,
>  	.start                          = ath11k_mac_op_start,
>  	.stop                           = ath11k_mac_op_stop,
>  	.reconfig_complete              = ath11k_mac_op_reconfig_complete,

