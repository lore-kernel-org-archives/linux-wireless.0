Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9CD4FDA72
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790698294; cv=pass; b=A+ADxvkXNUQKpPbySdIgEc+RlSFBM31fO5KD3JylMRx8YwMJgF4VWo0U8jw7DvvpzxTL9ewuyAUSM8xENxRvv+4wPaIwdiRU6meuAqSbD1+SS+S8jEEBtHBqU3NY8ZTCaH1djsPUCUj8218Da0tgMXnDbEKPR0biOruuE/0FPcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790698294; c=relaxed/simple;
	bh=zphWntJMoTU0hz4UI+cFhP2BQarVUJCuS+q6K7szyuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ncQXzxRgx+TUxRjE7ui74P+at+DydAHyMq2MPh2SAxEcahmYyR/TRUf99hHad7xdYbxh5LdzqQsvXM8G7GB9GGLJUrqNwpDubhvlNchNyayOd7PJjQW3CQx0ipthxgVkE130M1Um/AT8GPM3XVctJKpf7Mi9tWgC42u3fV0yR74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Aj2nl+y8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WDUgTWGn; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Aj2nl+y8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WDUgTWGn"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TFG4Wk942201
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 16:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qJy0ahWd0XaGUEphe2afeC6dCP3o9esmii2MCwrad+M=; b=Aj2nl+y8KxtWdZE8
	+qdWDHad+Yi+SRNY2tyW37v7NRHV40tbQ4W6w29fTc8h2v0ACAVrfb7Nkvf+d0rN
	j1iq7IHb46ANIldXzXrKNalw9oGs6MqP6TGQ9SJpy4HRTZgtVNiF+BFS0lwSob2I
	T78u3XDpUIc3+9BFL4M4WETWd6XvJGf1e5rTP/sARa+ic8ty7ykoJ/b2BrbOryP+
	GmqDDItZtcRwItmz+bNX0xsTHiC83eW6gjT2djkivcdMeFBeTwXr11J4Njtci3oe
	raysUqpFEJfjB2uDyXUFckw2igIoBcK4qQxw+GVaX2wb74JSWsGJmMSMbXGRXOUD
	WLFDEQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0ftug8x0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 16:11:32 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33bf1d17dfeso655478eec.2
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 09:11:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790698291; cv=none;
        d=google.com; s=arc-20260327;
        b=OUP7F59p2oWAIgDS6StH6qLsoIJntogPlIkoo3bD+cIXJycFN4GP8wxsOpkSlENxaY
         HjcRQflOoRK6NEJWgTL+WIU035wb8FhCQOW0pQW2WCCmCMTXU5Day0NexSgC9lemnVs6
         /984Sgu4mtZU1oLieu9SCIxJWqNupancq+ROaLB9uURj3djI7+g7ncK9deOLrZM9EeQo
         84WkVExzACKbmprmxeieRiryR4y/9bcZEcbOT/+pjEfF8WLcVEd3jEw9UfdX0Uckisxe
         MGIhQeyG+9Oiu+/TMDPqxD+YuKNX6a5nhBNk1jHUgm2oAChDxaqj7WnN0i1LRycvnAdK
         FxYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qJy0ahWd0XaGUEphe2afeC6dCP3o9esmii2MCwrad+M=;
        fh=jpaNcr8wvwfi8MNoo7uncEgiOjEoRzcC0GnJk2fEpXE=;
        b=Y0WdZpZlnTdznrYpHR+KHAzp15Qt4ihfneTLDQc7mdKTBJhONrTrmRLKg1X9hagT4N
         djNkmDDrs+g1N3yirM7csEVz1SV8QynO3ZL6wRQpzQCPL9Hzn7kSbyBxf77COTUrpRPc
         O05gQQyiK0KSZeP6dTazgLSG6q8bV9952EzLvgjeQzXFJqCN7SYnk+HgnokomPOj4bm6
         t1geXbnMGDD7R0NOWO4jkW1eOG1WM0wCeb9GnQf1/SSJT1IPyFCN95Sq/Q5CEGHpALRK
         Pe4gKA3IFt/8mgItTdc+Lop7MlbjJ6DfGUgVAf/Klaev9mCdtBH7ozCTx2UfFcO/zGDX
         uClw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790698291; x=1791303091; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qJy0ahWd0XaGUEphe2afeC6dCP3o9esmii2MCwrad+M=;
        b=WDUgTWGncZKGIi0XyESF95x2Es3BVPniBp3XNB0PbX23IX/oYoa0kxbCgjDzEsLDro
         O5jguxe0Sh4H07jtrTifORwtd3K3kCalGzT7Cre+fwybaVDMp3YKBijBjUH6Qodkup2Z
         thZ0Bzr77egItfsiQKyec8tRPi+4JuG6MgAJV2CWV0uHDGlYi1ZJefLgYZQsmH9C0lMC
         D7iUNT29qilajbk/dpGjPXFqviHMVj/oxWfrLTHAeCdlY+AcBjVDRhs4RMS6x4BCSr5h
         UQttLqg/5tCcW8cv3InLaCFAjatAQ/6upH9/Q90pHn9YEYPU1NhBNWeqU5kdY7jfSK7p
         pMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790698291; x=1791303091;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qJy0ahWd0XaGUEphe2afeC6dCP3o9esmii2MCwrad+M=;
        b=WDG5cMMihRDdii4NXj84eBqw1mgTx2lY6mI1UtaHT1AA3t99IFJ3Lkmoh4HjAPRJ3H
         bsVlON/NKDZ25XqOoXViNcAK+wvo0qRxS+zyFTWbl+Xrz00513c6zeRrvB5R3qflrx7K
         u+WEQP8ZBq/PI4Q25f+RgDq2g2y3uEu8YltjlwhKiuTJ972dyp/ry1abL1ZJpT/0qNNt
         lUs++2H1gLEg37kZ9fUdnaKOu9prXpXgzyD9BCcTykW3VFHUyKREWCkR7qreX4DgJ2bd
         +2xfulfO1CTSzVYiV7Ut5xfescOyVlVqfhPvl0A8zGVkeHAkIX6JZTIYHxC6IKD0uNPw
         md6A==
X-Forwarded-Encrypted: i=1; AKwUvBxklGLAqgvhoc63YDw1fLQdty6BX3KDb6sqaqrF+fA9mnvayg/ZlysQX9+ZQD75dT2Z6xjI5tbyidnKeGiQ2A==@vger.kernel.org
X-Gm-Message-State: AFuF++mWaFqMmL+H4rN3d024aCy5SYOL03jsHwQPfTStcTp95vwBKNe0
	nLO5oJrX5dEE50OGahm3DBDxtFojeQ1U+P7STeeEVIcAlU8FXugSMTl1Vut2I1dgNYRQ+AxwXcW
	cKSE9Om31TROcGtjg+Ycku+R6ooFg7XwdNTAV77lAg8zNerrBytU7rCPGkAT+yRnmAjnj9o4Jj3
	hpxDL2uV+tBKy/tRxj3GiXs820TA3wk/a3iVWtuTXjU9Ol1TjlvGhYVL4=
X-Gm-Gg: AYBFou0VkvFdYbtvTV3h0yz5rE1Y+2gRJtVgVAW+R283AcFMuChD5jthAf0noDebO0G
	4LtU+gLnC7tuVzX0naNJsQaHNabPfdOqL+QQn2Okhkm4aC70PcVxWI7CqckYgZtnGcotGPDBu8T
	kfOZFPhlzjPdJTccILBzAkBVhPz12euFJYq1oHLT64Y2Zo+hTulOPnS5dJbQoTy33gT4EzqpwjN
	3TPyn0OKQaeHEsDAy8=
X-Received: by 2002:a05:701b:4542:20b0:139:81c6:67a1 with SMTP id a92af1059eb24-146cf7ee6efmr21646715c88.1.1790698291167;
        Tue, 29 Sep 2026 09:11:31 -0700 (PDT)
X-Received: by 2002:a05:701b:4542:20b0:139:81c6:67a1 with SMTP id
 a92af1059eb24-146cf7ee6efmr21646648c88.1.1790698290460; Tue, 29 Sep 2026
 09:11:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908135319.754140-1-julius@bairaktaris.de> <20260908135319.754140-8-julius@bairaktaris.de>
In-Reply-To: <20260908135319.754140-8-julius@bairaktaris.de>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 21:41:19 +0530
X-Gm-Features: AclHuK8I2Y8Z38X2skQxxlHpAPaU8tbrT2ff2ker0EVsU01MrqsPdyvez8x7uGI
Message-ID: <CABkEBKa0pEB9cL1+yoOF0OQSkYb7T1ji36oJ3sVYYV+Nc-_dcg@mail.gmail.com>
Subject: Re: [PATCH ath-next v4 7/9] wifi: ath11k: charge received airtime to
 the station deficit
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: jjohnson@kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, toke@toke.dk,
        sven@narfation.org, quic_vthiagar@quicinc.com, john@phrozen.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2NCBTYWx0ZWRfX2RI2N/u2LKBC
 Q1o2tINcvBzCmSiQcOfv1aaDIyJlsO4pr1WTfWRH5pnz0pUEhxuhIHnvG8kh101Uru6usgwahy7
 3JiCNdRnRUGLY2VpP7AMUpWtHcGKwUZ8vkgRvQdoSBaMxdCjpvCwDF+nM8Po6wWQCElq/3kH52a
 zsmUiKHoN0IxXJSNYnWAi8X1wsDw0C885yii4CxXzNp7bS7IwmF4iwFLXGMQrbYQco0//9hnE17
 ZVd8NXaakrW05DXzC9d5m1QZo3Vfa3jW7MDBGdwXam0qhb1Eh2hCwbPSzWotmj3DgFZbFJm8+nd
 4MyaSwBQC7oGSKBrzcQkKldCY5H70AzHYV0SddBFqI/S4S52xGVvfJgFTfZSFYmj1cHc9KYPBrD
 jvfoIykwyDj/m9o8O5B4P7zOJNM7iKPq/k/gqNDonMrIrGqhuxTxCpYkNC4cP+eTIGCdrBnq/pA
 0tC5sZLEwZlIp0ym6EQ==
X-Authority-Analysis: v=2.4 cv=AoB7T+9P c=1 sm=1 tr=0 ts=6abbe334 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=ISQwfr-Fe-Q9zp4uqk8A:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2NCBTYWx0ZWRfX7xbx/razfpu4
 DdYY+Z1Bflsi7rbRyGFjEyGeDFa2NLYpwxufzg86vdjanko5Vc+DzdTVOoRxPwX+FlKojxaL6Ru
 kOeXcFRe5RD3yfG0hifXJbhHcx4yYwA=
X-Proofpoint-GUID: dEZc5ZFeVNR1jQyIrQ6I77TT6CSubeJg
X-Proofpoint-ORIG-GUID: dEZc5ZFeVNR1jQyIrQ6I77TT6CSubeJg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290064

On Tue, Sep 8, 2026 at 7:23=E2=80=AFPM Julius Bairaktaris <julius@bairaktar=
is.de> wrote:
>
> mac80211's airtime scheduler is configured to account both directions:
> local->airtime_flags is AIRTIME_USE_TX | AIRTIME_USE_RX, and
> ieee80211_sta_register_airtime() adds the received airtime to the same
> deficit the transmit side subtracts from. ath11k passes zero for it, so
> an access point serving a station that mostly uploads charges that
> station nothing for the medium it occupies, and the deficit that decides
> whose queue is served next describes half the traffic.
>
> Register the duration the hardware reports for each received PPDU. It
> arrives in the RXPCU PPDU end TLV on the monitor status ring, which is
> subscribed for every radio, and ath11k already accumulates it as the
> station's rx_duration. Charging it once per PPDU matches what the
> transmit side registers, whereas an estimate rebuilt per MSDU counts the
> preamble and the interframe space once for every subframe of an
> aggregate.
>
> The PPDU end user stats TLV that names the TID is not in the default
> monitor status filter, so the airtime is charged to best effort, the
> access category the deficit arbitrates the bulk of the traffic in. The

This means the resulting fairness accounting is only an approximation
and can leave VO/VI deficits
uncharged while accumulating all received airtime against BE

> call is made after ab->base_lock is dropped, under the rcu read lock the
> loop holds, as the tx completion path does; base_lock is contended by
> every tx completion. A PPDU from a peer with no station entry is not
> charged to anyone.
>
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  drivers/net/wireless/ath/ath11k/dp_rx.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wirele=
ss/ath/ath11k/dp_rx.c
> index 68472e1e748a..a7b9bb295728 100644
> --- a/drivers/net/wireless/ath/ath11k/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
> @@ -5270,6 +5270,7 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_b=
ase *ab, int mac_id,
>         struct sk_buff_head skb_list;
>         struct ath11k_peer *peer;
>         struct ath11k_sta *arsta;
> +       struct ieee80211_sta *sta;
>         int num_buffs_reaped =3D 0;
>         u32 rx_buf_sz;
>         u16 log_type;
> @@ -5324,6 +5325,7 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_b=
ase *ab, int mac_id,
>                         continue;
>                 }
>
> +               sta =3D NULL;
>                 rcu_read_lock();
>                 spin_lock_bh(&ab->base_lock);
>                 peer =3D ath11k_peer_find_by_id(ab, ppdu_info->peer_id);
> @@ -5337,12 +5339,25 @@ int ath11k_dp_rx_process_mon_status(struct ath11k=
_base *ab, int mac_id,
>
>                 arsta =3D ath11k_sta_to_arsta(peer->sta);
>                 ath11k_dp_rx_update_peer_stats(arsta, ppdu_info);
> +               sta =3D peer->sta;
>
>                 if (ath11k_debugfs_is_pktlog_peer_valid(ar, peer->addr))
>                         trace_ath11k_htt_rxdesc(ar, skb->data, log_type, =
rx_buf_sz);
>
>  next_skb:
>                 spin_unlock_bh(&ab->base_lock);
> +
> +               /* The airtime a station spends transmitting is taken fro=
m
> +                * the others, so its deficit is charged for it too, with=
 the
> +                * duration the hardware measured for the whole PPDU, as =
on
> +                * the transmit side. The TLV that names the TID is not i=
n
> +                * the default monitor status filter, so the charge goes =
to
> +                * BE. Outside base_lock, which tx completion contends fo=
r;
> +                * sta is held by the rcu read lock.
> +                */
> +               if (sta && ppdu_info->rx_duration)
> +                       ieee80211_sta_register_airtime(sta, 0, 0,
> +                                                      ppdu_info->rx_dura=
tion);
>                 rcu_read_unlock();
>
>                 dev_kfree_skb_any(skb);
> --
> 2.53.0
>
>


--=20
- Tamizh.
