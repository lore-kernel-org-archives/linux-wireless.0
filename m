Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A48F28D8D0
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784166579; cv=pass; b=giON+rKZlxCx7eWceKsaopgGXp2lSZVuwJ+8zG9vXp6oRL5gkZJZBu7H0c54vVu5A36O8SNfM7d4dVeTpp4lCc3pa6Yt40UKq5+3dtG9xIoUx5Z2naY0Iias08Lb5e+19XCCfTENfDLzI1+PhKWZ4YFgA/RaqsDGKdz0ob9J4eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784166579; c=relaxed/simple;
	bh=au3egA3e1wQMPXEhWhoVvtzzE3sRSvcVn0yEDUr9h1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UsqM5bO+gGYkucDt3ZAkuLRyp9zAqjqx2LaO7C9TaE95Iirl/NXsga6lvA6zc5RrUsanHzI6lF3yxdWw4iBmKM5wLy79A0uHf8b4B0IxsvcLUVP3+Us7ZBH+uGVIOIxc62pHP+lIsaXmECw3PQfQbhkJFBHpiR0aebJejEpQSlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bwFLpkhD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AjRaPv3d; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bwFLpkhD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AjRaPv3d"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G0Y8TQ1243845
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=qa1jVvwlc7r54xvKrbPUREgW
	GYwQxqIPvdAwkkBI+/w=; b=bwFLpkhDGO0sp66+VGtYuwpMm1DkFrtzvaZd9Mqv
	xCugxOxtySxzLl3g98ke0kbwal8P9/Kcz3HcKHD98TVw0FSO28926z4atwlDAilQ
	dhPy8ZdrB35lf9QMQ5TOg9wkCWZP0eLKpms+OlzFnJH7wvtghwAEvh5W6kkbckv2
	BYwpThJ22ufruy42bTqwpIkWhUD2IlFKSVu3M/oRCDvY1mzfRr9g7Ts1nt8sSuGZ
	OcUdfDomZNKcsjgNPg7vIyug1WALPYZ3GXx5HI6Lu+CQgkAOSMM5CzT9HsmA88kq
	WzMZ2GuYqjSILovfAD44a4MSbRaxLyvetIMw1soDcRXXYQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fe7nmkfw6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:49:35 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3811343bd68so1840758a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:49:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784166570; cv=none;
        d=google.com; s=arc-20260327;
        b=lLOpUactqxEaCIVQWiC03HGvisGeJC+N94FbvZ2KFv7vZux/geJyRGa3AdOC16vqcT
         gVnrr+vnv9LCeZKIym30MErTvMBw4detB7yU5zRj/WyU40c+UT4KXTWW3tu7OZGCEFLf
         23xakPXJVL4qTi0Re6H7tuKBuO5TifMoNxG/LJYXsJ8f2AbGlT7/iuOu64PUgl4eGT3u
         dHfTYc4ksPJGP3E2JyxRxol6hvMUewQS0i3W1I7jzu1UJLwAHdlVqUddB+zaBnXhz/W0
         NAN8+YK7suzZwkJzFEnmUQtsW+NhB8Zfu1Oo99Hla9rbiaxP8HqSUsAzxpNYCACBxhBJ
         9uNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qa1jVvwlc7r54xvKrbPUREgWGYwQxqIPvdAwkkBI+/w=;
        fh=TZYowjRasSsznOxyCEPwLbEWbpIf1QxRWw7K3S25jDo=;
        b=NiZnV2ujz5hYs+El/Mr9WLqPx8Gu6noj4RnZ8RZBXiAoNE+f+X7LwSy9f6be41JlnT
         8ApYh7p+1/XOdRsD2YHcmzfJng7nqaUqyCRyDZU5DniZ+c0+pDcI74z3bsee57F6QT8s
         QHyN5qWWxKqh4tT4twNz5bt3B1oUFvL1aLF91udmIt4VlBDTksLskR7IUEckFFHR/iQz
         IYIwfDTW4BfM/nBusIEUw0ZGb4JaSBcI8pVrXfThAZDU3qSAL2rIX8T4xyw6a3vnAgZ6
         nqvMLXOMd4ZcT0zicEcLtsmZ7QGWlm0XoGla4QRh3ISeeQGkWNgOfpAv1RiMYBDkX6xr
         U9Og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784166570; x=1784771370; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qa1jVvwlc7r54xvKrbPUREgWGYwQxqIPvdAwkkBI+/w=;
        b=AjRaPv3dllwuIP6c4P4t+Es/g6np5uO2Y+7GY9gG9+qy6F/KvxxBQdatZ2lp7A7t+U
         ng6Im03qVqRGD55yrRjGgmAXLgNNSO+1UjMB4tDhbj4AE28tSHYnVfI4IC1SGHJhywbL
         BnqCdF7g/U+l0UGEiaM6z2IyN3r6Hnq4lj9ya3p/ytjD6jGcpZ9R4vVxoNVtyP5VtOAR
         FZAoDIVGPvE7zfezAQAE4oxpAdB24y+A/DMDm81rJqZKi5i0/SMwaqYigVAOmrV5ggIy
         XMYmE1GX9PffN37CgvhZkb3vH0GzvTVI3j58CoUFb8kVqfEe0L5OfjFfmz04nD106rUp
         dzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784166570; x=1784771370;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qa1jVvwlc7r54xvKrbPUREgWGYwQxqIPvdAwkkBI+/w=;
        b=V9jy8GBxYDb4el8QwNiUBG4/eWJSlEp2drajms3NEi3Opq7SfPCBRzK1pChOm9zXrc
         AzGla8bcWfnrNa+zQ7rT+kTrKH6HBCteReT47tuzwVra3y2hq7lOhIEo9glNG/i3NeAa
         ZRJynvrY4vJv713lCbsgLPqM7aCsr7gIqvYOxZhcfdvTnsOvHu1ies8DqZ5vCVsSslaO
         2GFAqDD4NKlnvZTJIHRJHtBJIwnG0zpHVhWTzxCn5DjgNZrQQeLoELX/R68f5UXr3P8B
         pQKYy+VlJtehHixKMlOe87MjRzCE7srNTVsG4FKSQoi96WOhytmMNchJih6GoRHaFm11
         wDOA==
X-Forwarded-Encrypted: i=1; AHgh+RoMFn+XV6bt8LABzWvbjeZTonM334px+lVk0NjY+owMmYgIoASfHZoRqO6Sw4ZKH3IF6Am2fKR6YqvV5SLD2w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrjnfwE0UdCVCvaGBaK8IQ/By1zyZw0HBRBZz9GOJvYPNqKRVo
	CXAYEdRp84ZqHntZCeJF2961VZpMjP0Qa+t9l4JB+6pZbxtkMlguTDSpkfMd4LTG1SyhTaxEhCh
	zQ3vZFGinC2LTWtJ7Zzn4cbo+zP2NO9KjrEqgu4pL/V6q0ynH4G9N1qRZQ2lxBaNTOAuM7crxUU
	gyyagwBcSbQiw36Ad3XjCsb/Rch8FdLZZZvLgObMN9I/OV
X-Gm-Gg: AfdE7cluLDUuGbDiG1dTT21KDiO2M4rNmLQxmpYBSR4v9NmIclwm+xceKlWSo10qNtE
	4GEVngVARzE8vB52NWvudxcT1k7BriwhZlm3YfdKjFii+tbRrZny1OCzKfuSUkctCSJR1X2K5D2
	SBX4zDKvsSwpcKH82IQdy+1aGaK2LGNfOhAsZL/hvHj6Ty5+k2UrcrX649u5gg8pWB0J0J9OBdZ
	qxJKf3aBVFRSC+IYlE=
X-Received: by 2002:a17:90b:3bd0:b0:36b:9323:c726 with SMTP id 98e67ed59e1d1-38dc77ec3f6mr13642867a91.4.1784166569610;
        Wed, 15 Jul 2026 18:49:29 -0700 (PDT)
X-Received: by 2002:a17:90b:3bd0:b0:36b:9323:c726 with SMTP id
 98e67ed59e1d1-38dc77ec3f6mr13642848a91.4.1784166569134; Wed, 15 Jul 2026
 18:49:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715125017.277242-1-jtornosm@redhat.com> <20260715125017.277242-3-jtornosm@redhat.com>
In-Reply-To: <20260715125017.277242-3-jtornosm@redhat.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 07:19:17 +0530
X-Gm-Features: AUfX_mzcv6sf1IfdrSAmX-JluVOmlIR9QE6B2uqgl3rt1pJlfmU8M8nrlTnuAAg
Message-ID: <CABkEBKbcQYvMMRUmVgv+GyG8eNiot0acJ13Xy2236zqqr2cnXw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] wifi: ath11k: implement custom wake_tx_queue with
 flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: jjohnson@kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDAxNSBTYWx0ZWRfX43y8Si5AwEWU
 JFhZXklVC19nQl3hCpXsDHtjtyok4z6CF8jvbzZU/uL8pR+W3buTX3R+ggxq7luCZIvhy1yrJx7
 q9QT19jm+fQ2tZnjbl3dvzAli6Im8Zw=
X-Authority-Analysis: v=2.4 cv=cuGrVV4i c=1 sm=1 tr=0 ts=6a5838af cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=1RTVyt60vU6GMwtd-eQA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: CGCrwt8BulS75OkBzI38LhedOsT6dhFE
X-Proofpoint-GUID: CGCrwt8BulS75OkBzI38LhedOsT6dhFE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDAxNSBTYWx0ZWRfX3ogyRkyehcOt
 P/XKLGdekA4zWcIudHTbKiT9lwfQ3snvqsAU2kErPzoppfw+o5bvzDWcdG8K5J1rX3wTuKvqL3M
 SANwqV8WW95wjvfngI4BqnGJziWZ7I1CHCvF18RCz9jKhKn0qBAtAaQGO1JHEGpSTI2gK4xaZWH
 jNlP94hLa7w6I8WQ5SBXDONPJEvnlLYv89PKz11myA+2+P+ARPvPzEMft01g4wTja3G7Wr7TnKA
 2j9BoMsRAnoO1EOXJ4zHQviTnoy5utJZfggHiVAkveQUU1ZvAtbRQFzufx53zu/2rlkcZ/S8QMX
 zdjQd4kwlKeyH5pf7+JpzaWUCBeUxS4xz3IjsPKqmG+q4dvbwC+u39rUxPuGHfqB8U0smLv7WyD
 OR9JajbI0OxHCsptUyTeWZPWG88j9XDKcN5H0+FzHhyXSCywklEwWl47wAc/QEriQoQ8BQWAQay
 RpiwjemPZTL4U7LaB6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_01,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160015

....
>
>  drivers/net/wireless/ath/ath11k/dp.c  |  1 +
>  drivers/net/wireless/ath/ath11k/dp.h  |  2 +
>  drivers/net/wireless/ath/ath11k/mac.c | 60 ++++++++++++++++++++++++++-
>  3 files changed, 62 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
> index f389b97acbdd..2e5978ec2b05 100644
> --- a/drivers/net/wireless/ath/ath11k/dp.c
> +++ b/drivers/net/wireless/ath/ath11k/dp.c
> @@ -1087,6 +1087,7 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
>         for (i = 0; i < ab->hw_params.hal_params->num_tx_rings; i++) {
>                 idr_init(&dp->tx_ring[i].txbuf_idr);
>                 spin_lock_init(&dp->tx_ring[i].tx_idr_lock);
> +               spin_lock_init(&dp->tx_ring[i].wake_tx_lock);
>                 dp->tx_ring[i].tcl_data_ring_id = i;
>
>                 dp->tx_ring[i].tx_status_head = 0;
> diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
> index 84f66839f0c6..6d99501aa269 100644
> --- a/drivers/net/wireless/ath/ath11k/dp.h
> +++ b/drivers/net/wireless/ath/ath11k/dp.h
> @@ -87,6 +87,8 @@ struct dp_tx_ring {
>         struct idr txbuf_idr;
>         /* Protects txbuf_idr and num_pending */
>         spinlock_t tx_idr_lock;
> +       /* Serializes wake_tx_queue operations for this ring */
> +       spinlock_t wake_tx_lock;
>         struct hal_wbm_release_ring *tx_status;
>         int tx_status_head;
>         int tx_status_tail;
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index 2d55cdc4d165..046cefd53178 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -10065,9 +10065,67 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
>         return ret;
>  }
>
> +static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
> +                                       struct ieee80211_txq *txq)
> +{
> +       struct ieee80211_tx_control control = {
> +               .sta = txq->sta,
> +       };
> +       const struct sk_buff *peek_skb;
> +       struct ath11k *ar = hw->priv;
> +       struct dp_tx_ring *tx_ring;
> +       struct hal_srng *tcl_ring;
> +       struct sk_buff *skb;
> +       u32 ring_selector;
> +       int num_free;
> +       u8 ring_id;
> +
> +       if (!ar)
> +               return;
> +
> +       while (1) {
> +               if (unlikely(test_bit(ATH11K_FLAG_CRASH_FLUSH,
> +                                     &ar->ab->dev_flags)))
> +                       break;
> +
> +               peek_skb = ieee80211_tx_peek(hw, txq);

in ieee80211_tx_peek() acquires fq->lock, peeks at the skb, releases
the lock, then returns the pointer.
Between spin_unlock_bh(&fq->lock) and using the pointer for
ring_selector. The same skb can also be returned for
the another CPU which calls this function. This may cause use after a
free scenario.

> +               if (!peek_skb)
> +                       break;
> +
> +               ring_selector = ar->ab->hw_params.hw_ops->get_ring_selector(
> +                                       (struct sk_buff *)peek_skb);
> +               ring_id = ring_selector %
> +                         ar->ab->hw_params.hal_params->num_tx_rings;
> +
> +               tx_ring = &ar->ab->dp.tx_ring[ring_id];
> +               tcl_ring = &ar->ab->hal.srng_list[tx_ring->tcl_data_ring.ring_id];
> +
> +               spin_lock_bh(&tx_ring->wake_tx_lock);
> +
> +               spin_lock(&tcl_ring->lock);
> +               num_free = ath11k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
> +               spin_unlock(&tcl_ring->lock);
> +
> +               if (num_free == 0) {
> +                       spin_unlock_bh(&tx_ring->wake_tx_lock);
> +                       break;
> +               }
> +
> +               skb = ieee80211_tx_dequeue(hw, txq);
> +               if (!skb) {
> +                       spin_unlock_bh(&tx_ring->wake_tx_lock);
> +                       break;
> +               }
> +
> +               ath11k_mac_op_tx(hw, &control, skb);
> +
> +               spin_unlock_bh(&tx_ring->wake_tx_lock);
> +       }
> +}
> +
>  static const struct ieee80211_ops ath11k_ops = {
>         .tx                             = ath11k_mac_op_tx,
> -       .wake_tx_queue                  = ieee80211_handle_wake_tx_queue,
> +       .wake_tx_queue                  = ath11k_mac_op_wake_tx_queue,
>         .start                          = ath11k_mac_op_start,
>         .stop                           = ath11k_mac_op_stop,
>         .reconfig_complete              = ath11k_mac_op_reconfig_complete,
> --
> 2.54.0
>
>


-- 
- Tamizh.
