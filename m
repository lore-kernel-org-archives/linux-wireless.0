Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590217;
	b=JhFyeMPmDlIXK5tWkxOJv2fG41/WqJWCiJaaSGXrRzS9vpDH5XxOitkpYOO3LYwTgkvm
	 rd3GvkvH+O2x7xGLqhzG8y8OhpSAT9xzgilGquWKq0x+HPbs20vmqGkw0DWZjx8M6O6P4
	 9+yTFUhkQDuB98zLN6RHH0jqpZrr1lAnUOjaWdQnN2QFCJkAqn7JQn2IxmXE9YgpMgRcp
	 gsUWIVBcKOGJ8dllybimAlj257fmPvwajhiXVVoZox+Q0e72m9CaNh4Ra4BwbMPi2Xswg
	 JHbFn4a2f8mqNmsrQYJNe43fjHjwNOr0hBZ1zGA1Ql8cPKnKP765RLMsJ2AVAmJgVgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590217;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=qUzcINOW4+vTzSj9EqdHh/10B+1ledKafSW+c2vSXlU=;
	b=RlGUVwRfZ067sWXWt7FWXlbh4rH0CLnMQ/9bwMmm44wnqJZ1JYg1yU2ire9tYju5FpqA
	 DXzp7r34Z5Ef1VBCDFLKxVZsjYHNRRAcTCjzkWPZBWxnqU4MXJrfeZgHgZcwgTUuIhF+o
	 BO4aCefuh1pQPGldq28c+UOa37SspOYBPmXHSSY1dNxSJHs9bqimnpEzuU4qCEkL8u49t
	 FLyj6ZzuSZyFUrDoa6OeSmpU3u0oI9+koA0bs8OQpFfKAFRZJasnQ4KNO8Ci1Q75HnXco
	 gaqg1H1NfJ1hN8SgUWJBb3pjs2ZMRFS/PbxvyY+VhhlrQEKLhDtZSGBzpdA1eOuPryA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=YURqYCE6;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ukhrdi+3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD63606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AD63606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=YURqYCE6;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ukhrdi+3
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBg78J544091
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qUzcINOW4+vTzSj9EqdHh/10B+1ledKafSW+c2vSXlU=; b=YURqYCE6ackpOhgt
	Q4dmC4inkPlAj6q11OZt9J9E8juowMyGfttZC6P01O+cPJaOlSxrdw90bJ/BS8do
	LsOyXt0KL1ZAIVtX9q1/58nV7b6ZblI0bm19XNoG3qEfOEDm4ktz7lSwQX4XCblI
	3yJ4ihx8+V2TfZHQq7NcmcsA4VxB+6DhRb1sVa6IcjxIR6igwKCGRySbb3tNmoNv
	sCNPNXkTBtj/hVLJgGZmYoQnsI+nvH2JXuganjckTZ5pN7parSphiSjTm4xstfOr
	z+AtuePsy0ABC8yN5HsykReJ5h5jZ91/Oo4WPnXnd1sbIjaDK2Tqbd2fWdxoDTNC
	DpHwig==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hetj490bk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:43:36 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-917a109c937so10465856d6.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792590215; cv=none;
        d=google.com; s=arc-20260327;
        b=aI5/PAU3CmEZ0qYGuC1mtkm8fl/pdNKmnGAIzvjQr997Sxe7JuweHFcBVZ0IzBp21U
         psicVqUGeCbG4v1nv8x8lMV+74L4sG5JZEawnm3+DCmK9JOV4QNGsfZWPkRMkqgMuhmz
         O2SEkpjgIMatvfmFgkDDAVJTfexJ40F3r8VIDuOME4iCyw5fgJXqYXcvHTBE0EbiRHQK
         CYxTs0vKoIM7pVlNdZsbObHFlog16ylakngIpfLhtSEyJOgikiMtX4NntBtcgXzUMNm7
         GOMTTvnm/Wc+HWBIoXsdwSTgWrKktnVXDroeOXsfDJbF/i5XFZPvKVNV7Tfcz4iwgzdw
         oqOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qUzcINOW4+vTzSj9EqdHh/10B+1ledKafSW+c2vSXlU=;
        fh=uxW5OO66DuFEX/7Mua1Gj4ORbWfvb/WKazo/87BtAD4=;
        b=dfmnwx9P53Yb9lJ+Gy0LhfDNRw1X9GfkQjkFQpH1NzOTpR3GE1zYGsLK73KcofDOzk
         rUY5MH8xZHAV8hLqXr/Ysm1T47Lx8sjYOXBC81Q3T6LnZmzj9ihzPUffuILellKMUtXw
         AHib7YOZLueVleCzGwKb/a5ecDSympc8GBmCrFLTgEYhR/S15aUEo4eY9KWkhyWTjjaD
         GBZ81pNGCEWWRlhCqhnJR7ER2//vlI3k2+z7COdnmFeb47VWtW66IQGkULDkh7XxgL8M
         fLiQK+RHeuOi7SBW84wzS8Bg9Y3g3FaSfM2lMRmQyTTcGbayItT0Py/15ceExmx2wBGW
         u20Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792590215; x=1793195015; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qUzcINOW4+vTzSj9EqdHh/10B+1ledKafSW+c2vSXlU=;
        b=Ukhrdi+3CDymJKBsr7qRxLyFmz65HQexmbOD4TMiKXQ6BVGD1vQ4SK+vVbziRv3yiB
         ePJdco2guvSVdFe0VnKvYhntm1Fo48vLm0MusTNq/Sk6RiLUs4AEC7MEcccS1rc2tsJX
         j0brdpjvwE3CY5W1XwsAEiVjb6mkokCWoU1+fEMiX6f73BQwd94G6tdhhnH3l/JfhFPP
         5TdBRm9z+/X3Bvg/kjAE1qekTAKbsf59wUIM3D0MpNYwJTV4ocn5/puWcRoMRdMNW4UO
         DeoIBvtQ0EFTcdzDKl0uGulfQtVkablX3KdqdvMKod8kppNRpU2gbx6CoogyxrPRUQql
         GMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792590215; x=1793195015;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qUzcINOW4+vTzSj9EqdHh/10B+1ledKafSW+c2vSXlU=;
        b=w9ruhEOr3focg9Xy5PA5n1FZtucNxp4S741aObaifqlaw6VhIe6+sUYhUl+2sbCSV0
         9WxOQChDvEsMae1HUUgEe1RBIxhkla35u/SvRRqEpKUvdPZnzCbxYDz3eBQ1NcPdTF0v
         t4haIvIAyCri3OfqeEJnb/tiyeHI9qJzXucttdBwpN92PhNGrhqo6iLOMNiAyfraYmUC
         5SaU6ABMRjKDMsJki6iqCfCGSSqJzDeELZSGfI3NPIdJsKt74JsUW8/hrmSg47snv24+
         h6PcqkyG25/LwApkV9ymvm5OZIQFGVfCVhaQp4iu6wMncopg7YD6iRYIytoMbsUkero/
         LUKw==
X-Forwarded-Encrypted: i=1; AKwUvBx0GabXL3R+nr01gVa1n+XbkoNp3r7E7Xkh0WTY832ENg6I3sybqJEQS0YJBFUszWxzr2YOEsi/A33h+fJlNw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK8OeLJFA+ERtS2tocOAVAmIrL82yr44/99icihr0ELzny5NgF+
	5J8Q9JV/PtotmHqj8dHE5eYVqAMI+xkA6U/VrQGxcTVJmDmoI2lW9cdyBYxSP4pX/J5zU721Mco
	wu6IFpoQEaw4DiTAk3Dk/Gv0EdW3OHLHYj7L8GqZLJinDYYNuhB17MLM9rb22PChV1TzOmqWBK6
	aWflm71roMSfctvNueq7/cR3vI3gSyPt42gWGtcZTDCrtf
X-Gm-Gg: AYBFou0p+ukb6HnFAtG9TrlV9SeHxmPXarbT6CpZXjPg+6+Ti2K5+FejxRmQS6AxtMX
	SvXLsvHE1hJQ21Y65n7U0D20EQaPIykri52Yi7M1an1hpLJN4uZjWFWLrDOSrwjJ5bxk+f7SK+M
	fRm7268/lm22P49OR/WvAi0Svvd7W8ekyUZKlaGyd2pAEJl66jKsrzZrIs+2tJGaFSx4BPH0tAb
	ZkwZVf10j3L3S4rQ6GnaXo8YaWHI48dFr/GDr8Lnz903/xXypi4IvYdme19zuNhP0jK3RZ69/Y=
X-Received: by 2002:a05:620a:6011:b0:93f:11ee:ba1a with SMTP id af79cd13be357-93f57f91849mr395280685a.48.1792590215008;
        Wed, 21 Oct 2026 06:43:35 -0700 (PDT)
X-Received: by 2002:a05:620a:6011:b0:93f:11ee:ba1a with SMTP id
 af79cd13be357-93f57f91849mr395274685a.48.1792590214318; Wed, 21 Oct 2026
 06:43:34 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com> <20261021-10k-sdio-crash-v2-3-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-3-5df80bf16e86@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 15:43:22 +0200
X-Gm-Features: AclHuK9bkKR-qO0jcN1FEgG42syrJGdmYfU_hxWhaF-M615PIzoLQ_M5jA6Oi34
Message-ID: <CAFEp6-2p3vFY2ARd5bftVAQj2FxweaTFvdXyJr4nWBZSRyUD8w@mail.gmail.com>
Subject: Re: [PATCH ath-next v2 3/8] wifi: ath10k: also wake remaining blocked waiters
To: Kang Yang <kang.yang@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: H9R2s4Vso3Y4ZHF9l40-jNCuD1mMCfb6
X-Proofpoint-GUID: H9R2s4Vso3Y4ZHF9l40-jNCuD1mMCfb6
X-Authority-Analysis: v=2.4 cv=N768hG9B c=1 sm=1 tr=0 ts=6ad8c188 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=ICYLl7Pk4l7hwN0V23EA:9
 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA1NCBTYWx0ZWRfX/iColq620oDx
 C6Jh4hH3m77ckeSrpm+e5fp6z3QfT/b7Efzt+TTHrCcd4/111wIcG9xjpSpfFlAUgPq+hm4ggjm
 c3+RnwxXYbWzXwg4HCz7/SdhrTiahUQ8mlZpnxN60LPb2qxlLMTCnCAJk+VEfyUW2qeWNYGbuwQ
 9AqNDP8Ds0bmhaeYs9RLvs60M6LUBPrCEy2xzqmIe30dNVhvTeHDz2rMlE/sxXngeBZSZ+9w/1a
 W/AUUqb0LZgkIddJT0ez+ZHqv2xX1E4jNyO5HfTovfu6i+qApsLERG8i17LNkBogJAkafZNCV9v
 aJsh62OkYf1Jvjkyh3wKb54ogu4URxhJPehCXqiX0XbQhAqiiXUnxw9rLSCP1L8a3oJgTuHzS55
 jQ2ACHyWweJk8Xri2xEoeZbxTCExI+DhLydBgTRcdRwacFjsJUQZTdy7ZnCYPK0QQdVIIWLHC97
 4LklL4OfkV8aBaQ1BsA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA1NCBTYWx0ZWRfX9SAcM2OCJco6
 nfJBJciJf6V60MMFnQgVlI9IKj0X23VeCQC7H/ATw19rbNzseZJrqp+e5/AiHBqtoKq9wpClP44
 PIimDOOBABUoke0jK+gZ3WBZ7jzQQ/A=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210054

On Wed, Oct 21, 2026 at 11:09=E2=80=AFAM Kang Yang <kang.yang@oss.qualcomm.=
com> wrote:
>
> ath10k_core_wake_all_waiters() releases callers that would
> otherwise remain blocked after the driver has given up on the
> device.
>
> However, peer_delete_done, target_suspend, wow.wakeup_completed,
> peer_stats_info_complete and wmi.radar_confirm are not included
> in that list. Callers waiting on any of them continue sleeping
> until their individual timeouts expire, even though no further
> progress can be made. The WoW and suspend waiters are on the
> suspend/resume path, where these extra timeouts consume the
> watchdog budget.
>
> Add these completions to ath10k_core_wake_all_waiters() so
> blocked callers are released immediately instead of waiting
> for unnecessary timeout delays.
>
> peer_delete_done is the only one of these that is never
> reinitialized before its waiters run. A completion left over
> from a wake during recovery would make the next peer delete
> wait return immediately, so reinit it before each peer delete
> command is sent.
>
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189
>
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

> ---
>  drivers/net/wireless/ath/ath10k/core.c | 5 +++++
>  drivers/net/wireless/ath/ath10k/mac.c  | 3 +++
>  2 files changed, 8 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 93140f1ffb7b..677e582b87e4 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2500,7 +2500,12 @@ static void ath10k_core_wake_all_waiters(struct at=
h10k *ar)
>         complete(&ar->install_key_done);
>         complete(&ar->vdev_setup_done);
>         complete(&ar->vdev_delete_done);
> +       complete(&ar->peer_delete_done);
> +       complete(&ar->target_suspend);
> +       complete(&ar->wow.wakeup_completed);
> +       complete(&ar->peer_stats_info_complete);
>         complete(&ar->thermal.wmi_sync);
> +       complete(&ar->wmi.radar_confirm);
>         complete(&ar->bss_survey_done);
>         wake_up(&ar->htt.empty_tx_wq);
>         wake_up(&ar->wmi.tx_credits_wq);
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 8e604697d6c2..45a3082d5a64 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -843,6 +843,7 @@ static int ath10k_peer_delete(struct ath10k *ar, u32 =
vdev_id, const u8 *addr)
>
>         lockdep_assert_held(&ar->conf_mutex);
>
> +       reinit_completion(&ar->peer_delete_done);
>         ret =3D ath10k_wmi_peer_delete(ar, vdev_id, addr);
>         if (ret)
>                 return ret;
> @@ -5890,6 +5891,7 @@ static int ath10k_add_interface(struct ieee80211_hw=
 *hw,
>  err_peer_delete:
>         if (arvif->vdev_type =3D=3D WMI_VDEV_TYPE_AP ||
>             arvif->vdev_type =3D=3D WMI_VDEV_TYPE_IBSS) {
> +               reinit_completion(&ar->peer_delete_done);
>                 ath10k_wmi_peer_delete(ar, arvif->vdev_id, vif->addr);
>                 ath10k_wait_for_peer_delete_done(ar, arvif->vdev_id,
>                                                  vif->addr);
> @@ -5952,6 +5954,7 @@ static void ath10k_remove_interface(struct ieee8021=
1_hw *hw,
>
>         if (arvif->vdev_type =3D=3D WMI_VDEV_TYPE_AP ||
>             arvif->vdev_type =3D=3D WMI_VDEV_TYPE_IBSS) {
> +               reinit_completion(&ar->peer_delete_done);
>                 ret =3D ath10k_wmi_peer_delete(arvif->ar, arvif->vdev_id,
>                                              vif->addr);
>                 if (ret)
>
> --
> 2.34.1
>
