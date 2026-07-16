Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9615C31328E
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784167067; cv=pass; b=AUtX16/ruAfeL0rqlmzA+7mLBYyL6m5AVtLerbkd/HY6Yrg78l0PL1K7w+bJjIFLW6q+rtBn+nOY80eMqWZuKQUGGrch2D/bRdK/QQAv7s3KtIep63ikrWnctsV8GS8Lf0gXp2cI7/w2ksG9cR24DdJQDpr+yCXavp/JTNMeU3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784167067; c=relaxed/simple;
	bh=Er46m88ZGrH4fiXayReTOMnUahxt+9FZGQ4jHFrylqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tr5CRcqk13JTSfUP8aXR9NT41Wb78pL2bHJAIIsv9TLMm/gXmQwCofAlMrPBOrZUUuxnlFW1XIJBlOg9g7ybQV0Kfsu9H70SPycZjib7A5V6fllrdktKTeZX9loULZzR2uTo3poS+iVOitkbWfOosfMDnvy3d4DtH9+ZbC9nupg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eC/gUW6t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bMOYI1nO; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eC/gUW6t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bMOYI1nO"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G0Xlc21125168
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FcJOtzH5ZQPgdth/24g7ATlf0K+lEyfhd7GpxU8dSaQ=; b=eC/gUW6tCgDbZDyM
	v9NCuygzxPGI9CJ2e1fdQemuN0QQWuF7aWk5MoBNjQdZ7FtRrCyE7dDY2u3sqqca
	sbkLRcKZZbHKfcIS6LPjMoFi8GOVUukK5mfxwE+qcNa+9RnD4LwRaAVg12ysDR+S
	nzk79Sl11jugfrQukPXbGR4Clifl9itiIg9CC5u3M9kAQqpY2JCZgvQOpaesHzL7
	kAcg+p0oJNzOMNsRocSml1dFXUj7AeBu9oDTNZvPXi9m18aS9B993P+ky9x6W/YC
	dWMNsywj8sERF5+NTk53Qhn5CDhf6zjLCMfx8cw4kiSIdS+fi6KP7k5++VqFwBrI
	Cd9DiQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fe7q63egg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:57:44 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3811343bd68so1843093a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784167063; cv=none;
        d=google.com; s=arc-20260327;
        b=gCoBKVf9BCwvVEPZ2eqMThXiI5wcZRy2cykaAXQLlNIIFZMzDJdQ4QUxqUJUitJUMx
         Yz3q2EURUXZcGBmUBeGXk/uVAneqcuhcQ4UA/WWBOVIpkm5/lw3T+DTl5pPJgJFYsGHc
         MpMiOHt+JaASfMrtKhyoLVf7im8Iyc72ymLa/0hPCmDNT/gMhdarrVIrUB7mj+2ogEew
         tGM07XvSkQAXrWlUGlOztakEb8hLWTib4ZYXF00lrZiRd4uapqiCIqysbq5FUHrNH00M
         VkGPKfn90uKVWIKi55nixILIPOtnynXpgOq0l5ILnABX78xPX8A1RKCI8ddrWoT/74oh
         UN5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FcJOtzH5ZQPgdth/24g7ATlf0K+lEyfhd7GpxU8dSaQ=;
        fh=+ZqWxDZEIQrJBinrzGJ7fR+sSAJRlYqCv2LqmOasiCA=;
        b=stNbRjplj5iKs4yoZOOJ870sRuO2lyQ7zK6JzF0lT8QnwVefvZU/peOp+kRCM8Qm0X
         foNcp1s3OnSrxdWCBDWR2dqgdLRj6A+hPuzw54+awvMo4rADuuU1QR1cVvI8mfxzhEjW
         U+fnWMYJYf1v08G8+CZm7H9ghtEedS5DKqshuLq5ZCwVsgmrYkdsBQqTbE7Ad2WhBwP2
         yYqdbrA1y9la2vYyLoWckmp8eTLLMpOS4IRZzQV/ELvwLpU56qYY3Rb7uC7z4X0reG24
         yUX6S/+lVSmehzUrXqdB+oq6jGj0EgdeIezQInSrLDq0rRqwDedSZcqOx7EK6kVn4MpO
         EF0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784167063; x=1784771863; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FcJOtzH5ZQPgdth/24g7ATlf0K+lEyfhd7GpxU8dSaQ=;
        b=bMOYI1nOtYMKo7wlz3v3EcRnyVskRtvXLPPljOsNs8uiKbDg+2nfQqLFRgyOAIwSD5
         Z/DczREJz+Q5KzuHDFZOU/dD5vYdUddvepiSg5/A58ytSW7wZsHiYjzOdt4xgxtIOW8X
         kIKPjVbndAyAOybW/qRxuFViUpP+EmckD0KIF+Q9xgmGE2D1vKk/xdCTGeQDu0j2QN9u
         QVuZyaHvp8GJgm8vC40J7OD2CyzVFIc9FLpaxDKiW1i2mzFDQnhWE0Ee+wv0f+gK39tl
         N0vyMIxA1PIHfOqtq8ABMeBy/oI12UBHcLiyA445Rt/Y2ZYHVdzQ91Pvv4xgcL3knJKU
         VoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784167063; x=1784771863;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FcJOtzH5ZQPgdth/24g7ATlf0K+lEyfhd7GpxU8dSaQ=;
        b=ILBysh33+DmyXMTzBT20ELdUxeVeSS0Tnt2OBCSlO2uqenehkhooeLU0ur3kpY3GBO
         Ykn+2ftmhITPT7PEuoGJuqsql9Qp0OS28x6kYrv5tEw0Xmz2FuLF/NoxHt4lyMZ4nAxK
         srlK8rhmM7IOPkNN347yQGRApx97RBzSUNltcd9EFVdJlxg+eiXSRhTsxM+MYLuZU2+J
         XJSUmWSNqifG6ZR8N2Eah+dW973sd/NrjJZC4gEV1yPlz7h/rqHBJ67mKsBM9T++hdK0
         RNho67r7U9KpfLGFUq/3XrvNA5f4XAIULMZzGygjQXxHJA8lBhhXe8lY0C6z4ieQ1P+e
         IRlg==
X-Forwarded-Encrypted: i=1; AHgh+Rr8i3mT6NuEwJJ+W9fhbAe2Ta6lpb2UJDon1Xo2LTr+mnIoGltz42Bud4X9kC1OCpQHE9WLep+qOUnCHPS/9g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmuxk9BUvS9LsMLSjtfilp8NiT7BAfakXEIULBg1YsXpu5SPzd
	SYVeoNUwLds6WnDnzUE4igJ2sBJ9aJZWLkyVFkhoGTdCWyeS1hVBLTvlHGCJMvZmyoJnbktoqZk
	fa42hDi3RY2M76ijykyK3D7NaWQqvQb6qv2PfOKHRIUdOFccwF/FZmVUd5ofGL31BfGHTo28Vag
	ebkn8HY4a0nUBK+qzLJ4vTU4ffhsIv3vD3jixoUvZTo6xN
X-Gm-Gg: AfdE7cnG2bYUNJOkRYwC+iE/Q6esZO0LKND1ca9g4xqVaGdT8SBB1JQu01o+BwWLkVc
	KCERWvUqBhR3ycnQxDfApQoGddU7frj7M/eQSxruELFdleP7PwTYpz73Yr1rxNgeaKp/4j2ikz5
	8MGFoFWCCYjJ5nLIXjF145jgitbSyXnF0p2agNjanIWwY6sYhKq/dK0/ScBxaZZSTfyG66JKdL5
	KqqHFEb8FylwepM+OM=
X-Received: by 2002:a17:90b:3d87:b0:381:fa5:5217 with SMTP id 98e67ed59e1d1-38dc7848a6amr15709340a91.7.1784167063273;
        Wed, 15 Jul 2026 18:57:43 -0700 (PDT)
X-Received: by 2002:a17:90b:3d87:b0:381:fa5:5217 with SMTP id
 98e67ed59e1d1-38dc7848a6amr15709314a91.7.1784167062784; Wed, 15 Jul 2026
 18:57:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715125017.277242-1-jtornosm@redhat.com> <20260715125017.277242-4-jtornosm@redhat.com>
In-Reply-To: <20260715125017.277242-4-jtornosm@redhat.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 07:27:30 +0530
X-Gm-Features: AUfX_mwzFnOaWEdPGknbaBHXtvjCifI0N1LyjfWnkPVHNRa7lXOSWWzCDn6Dj7g
Message-ID: <CABkEBKa26vR52mX85t4xuZbrXz0FiRc0O_NeDFSNAQpSx=RR7g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] wifi: ath12k: implement custom wake_tx_queue with
 flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: jjohnson@kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDAxNiBTYWx0ZWRfX8HINGh2VOLgH
 BEQrtgXhKxwC1lNYE4ttJeHYWdIytp0qXAMMl4U6Jwr3u78oCjvLAFxfEW3Z5Km3J2OaIMAz/xS
 90s9BqCXVMnnqJ+hLV6xPM2ROI9HWVE=
X-Proofpoint-ORIG-GUID: aMncAn6gffHxoPWAeHelntsZFWKxoE-0
X-Proofpoint-GUID: aMncAn6gffHxoPWAeHelntsZFWKxoE-0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDAxNiBTYWx0ZWRfXwuBEvAiLHUVI
 z+s+7h/BK1AWBfSjr6H/H1hxrxkyHVch63mWCfEAZKZ+NbhHwhAURMUDJfCij3ruCBTeQPdOgx4
 xhJHo69SkgqVJmvIdrFPAJ2VvuSbNzuLpLglcNanKshtse/MCnbCubmapawSerBs6Cma45Q9CnJ
 Hr2bzftypzTjmMwLdTMftN+MaKfkLLSqPMIbocYZcRm5nnSXnr9VPvC1Ulehy1Ab2//o1SGAcjL
 /R3D25Ll9Agpn2eljZJQMFC+po7QGkTzXJptFWlbNb24ZVuhPp/mPeqTbmk0Xq89YZp1jujMf6H
 JzGmkGvnXx8wylpNWe6YqGm1l6qrYrc/ixqY5NmUEkz1dCB+GBAsDf55l7Nib7ZC20CA3V+EFfd
 IWAGr4vKaIW06PUIPLDK68XDfvCPVZLE0kkF4JELiBmQFrvqwf3rx3zGUE78R++ge1HDyeJEzYe
 2kvQRaVA10kw5BSFa9A==
X-Authority-Analysis: v=2.4 cv=BajoFLt2 c=1 sm=1 tr=0 ts=6a583a98 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=20KFwNOVAAAA:8 a=M3vVt1PL3_miW-qGmNYA:9
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_01,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607160016

On Wed, Jul 15, 2026 at 6:21=E2=80=AFPM Jose Ignacio Tornos Martinez
<jtornosm@redhat.com> wrote:
>
> Under heavy traffic, ath12k can hang and experiences -ENOMEM errors
> ("failed to transmit frame -12") when the hardware TCL ring fills up.
> This issue is more commonly observed in VMs with PCIe passthrough but
> also occurs on bare metal systems.
>
> Implement a custom wake_tx_queue operation that:
>
> 1. Checks hardware ring space before dequeuing packets from mac80211
> 2. Uses per-ring locking to serialize ring access and prevent races
> 3. Syncs with hardware state to get accurate free slot count
> 4. Uses ieee80211_tx_peek() to determine the exact target ring via
>    get_ring_selector(), matching dp_tx on all platforms
> 5. Returns early during firmware crash in the same way as other
>    tx paths
>
> This approach follows the pattern used in the iwlwifi driver, adapted
> for ath12k's hardware ring architecture.
>
> This prevents hangs, eliminates -ENOMEM errors, and improves throughput
> by optimizing resource usage and preventing unnecessary packet drops.
>
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
.....
>  drivers/net/wireless/ath/ath12k/dp.c       |  1 +
>  drivers/net/wireless/ath/ath12k/dp.h       |  2 +
>  drivers/net/wireless/ath/ath12k/hal.c      |  1 +
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c | 65 +++++++++++++++++++++-
>  4 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/=
ath/ath12k/dp.c
> index af5f11fc1d84..3d46cfbf0a1c 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.c
> +++ b/drivers/net/wireless/ath/ath12k/dp.c
> @@ -1539,6 +1539,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
>         }
>
>         for (i =3D 0; i < ab->hw_params->max_tx_ring; i++) {
> +               spin_lock_init(&dp->tx_ring[i].wake_tx_lock);
>                 dp->tx_ring[i].tcl_data_ring_id =3D i;
>
>                 dp->tx_ring[i].tx_status_head =3D 0;
> diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/=
ath/ath12k/dp.h
> index f8cfc7bb29dd..68d2020be9b8 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.h
> +++ b/drivers/net/wireless/ath/ath12k/dp.h
> @@ -58,6 +58,8 @@ struct dp_tx_ring {
>         u8 tcl_data_ring_id;
>         struct dp_srng tcl_data_ring;
>         struct dp_srng tcl_comp_ring;
> +       /* Serializes wake_tx_queue operations for this ring */
> +       spinlock_t wake_tx_lock;
>         struct hal_wbm_completion_ring_tx *tx_status;
>         int tx_status_head;
>         int tx_status_tail;
> diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless=
/ath/ath12k/hal.c
> index a164563fff28..c1c656e4550b 100644
> --- a/drivers/net/wireless/ath/ath12k/hal.c
> +++ b/drivers/net/wireless/ath/ath12k/hal.c
> @@ -390,6 +390,7 @@ int ath12k_hal_srng_src_num_free(struct ath12k_base *=
ab, struct hal_srng *srng,
>         else
>                 return ((srng->ring_size - hp + tp) / srng->entry_size) -=
 1;
>  }
> +EXPORT_SYMBOL(ath12k_hal_srng_src_num_free);
>
>  void *ath12k_hal_srng_src_next_peek(struct ath12k_base *ab,
>                                     struct hal_srng *srng)
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wir=
eless/ath/ath12k/wifi7/hw.c
> index d9fdd2fc8298..306d51da3ea1 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> @@ -1100,9 +1100,72 @@ static void ath12k_wifi7_mac_op_tx(struct ieee8021=
1_hw *hw,
>         }
>  }
>
> +static void ath12k_wifi7_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
> +                                             struct ieee80211_txq *txq)
> +{
> +       struct ath12k_vif *ahvif =3D ath12k_vif_to_ahvif(txq->vif);

Is txq->vif always valid? Do we need a NULL check here?

> +       struct ath12k_link_vif *arvif =3D &ahvif->deflink;
> +       struct ieee80211_tx_control control =3D {
> +               .sta =3D txq->sta,
> +       };
> +       const struct sk_buff *peek_skb;
> +       struct dp_tx_ring *tx_ring;
> +       struct hal_srng *tcl_ring;
> +       struct ath12k_dp *dp;
> +       struct sk_buff *skb;
> +       struct ath12k *ar;
> +       u32 ring_selector;
> +       int num_free;
> +       u8 ring_id;
> +
> +       ar =3D arvif->ar;

Shouldn't we check the link_id for fetching proper arvif? this code
always chooses deflink ar and dp for packet transmission.
This needs to use the same link selection logic as op_tx.

> +       if (!ar)
> +               return;
> +
> +       dp =3D ar->ab->dp;
> +
> +       while (1) {
> +               if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH,
> +                                     &ar->ab->dev_flags)))
> +                       break;
> +
> +               peek_skb =3D ieee80211_tx_peek(hw, txq);
> +               if (!peek_skb)
> +                       break;
> +
> +               ring_selector =3D dp->hw_params->hw_ops->get_ring_selecto=
r(
> +                                       (struct sk_buff *)peek_skb);
> +               ring_id =3D ring_selector % dp->hw_params->max_tx_ring;
> +
> +               tx_ring =3D &dp->tx_ring[ring_id];
> +               tcl_ring =3D &dp->hal->srng_list[tx_ring->tcl_data_ring.r=
ing_id];
> +
> +               spin_lock_bh(&tx_ring->wake_tx_lock);
> +
> +               spin_lock(&tcl_ring->lock);
> +               num_free =3D ath12k_hal_srng_src_num_free(ar->ab, tcl_rin=
g, true);
> +               spin_unlock(&tcl_ring->lock);
> +
> +               if (num_free =3D=3D 0) {
> +                       spin_unlock_bh(&tx_ring->wake_tx_lock);
> +                       break;
> +               }
> +
> +               skb =3D ieee80211_tx_dequeue(hw, txq);
> +               if (!skb) {
> +                       spin_unlock_bh(&tx_ring->wake_tx_lock);
> +                       break;
> +               }
> +
> +               ath12k_wifi7_mac_op_tx(hw, &control, skb);
> +
> +               spin_unlock_bh(&tx_ring->wake_tx_lock);
> +       }
> +}
> +
>  static const struct ieee80211_ops ath12k_ops_wifi7 =3D {
>         .tx                             =3D ath12k_wifi7_mac_op_tx,
> -       .wake_tx_queue                  =3D ieee80211_handle_wake_tx_queu=
e,
> +       .wake_tx_queue                  =3D ath12k_wifi7_mac_op_wake_tx_q=
ueue,
>         .start                          =3D ath12k_mac_op_start,
>         .stop                           =3D ath12k_mac_op_stop,
>         .reconfig_complete              =3D ath12k_mac_op_reconfig_comple=
te,
> --
> 2.54.0
>
>


--=20
- Tamizh.
