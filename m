Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A939C35677D
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 05:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788155608; cv=pass; b=cI4f3PEasuTHXzQHtSaBe2R4pQ7S2b1sagUlORQjI9Q1gUIqaSsOo/kSBc4r8Ghyl0WZ5soWJcHAECiwwPwa9lTX2hbyWMXXAhM2hq8APpuS8vCqd7qsQflxT6PkSPVp9aroGbS3gRPgD5br2fK6nt7K4kpFW6YkPpfKJWfhWt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788155608; c=relaxed/simple;
	bh=1JADuEmnChWEAQGQncBOWl5QNTF13Fu3+SRn7zk29FQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n44yQ6vR/9MjiRSEpKmvYDm3sc1cFYGnz2aNPi8m76vzhsmEpHMCuVFE0kMb7ZxTHSdkCDCcOMVdi4Qb5KCSk23Uvos+SrsJAXJIXpCEHBRZYC4lwmJXVh3YiGD82wjA2oJk9YJBIuu6nCDnWmk8JILTV2PznQHfFyPD7IFBgaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HfXIJHXb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=faqG+0h8; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HfXIJHXb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="faqG+0h8"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V52ZqO1445360
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 05:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	i6IMBdlMGgMvEJy6upP7aINcUJJT4RA76aNd/khHM6I=; b=HfXIJHXbmG2SG1Fp
	ltjoQr6H/q/Shio/qtoTZ3XfgtXnTpvCdv6SCKOyO1YGrln2btWnca9QeuJfazMq
	ND5BloJsBdorWbw89FXJzoLDyntdGJMCa119HfKawEgtXPYjX+dUTocylUPqc28S
	PnlOUP2umvRB/eCJ0A5hZFxjln4Mo2uz2NE+DQHtt36gWJ7iTYXHRjpXXocCWxYE
	b7xh5fNQDW+TtoEimtx7jgkhXezDTmZPWvWvw5vLzKJumKYtkcF6TGV4ofsirDM0
	KtoyF1QFoAFG5SYePXLF6FrSHw7qdQffXXhkSF0tjyII8Hw4xdk6/+8tXUFrrYhb
	kNUPdA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gbrkgvkhr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 05:53:25 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-398bb9a6408so543575a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 22:53:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788155605; cv=none;
        d=google.com; s=arc-20260327;
        b=pDZFChIR7NHVGAEFHvDj7gsjMHkWnoc7JxQZDLS6jBaYSR5YdV3smeAX7xrXLCULYA
         wErZ1Ewbx0eY+9bzD0uIhcLj9vjAJa8Jst6azS4+YMAL+IzzD/uf11njijxa3TEALz3g
         ztmyNodUR2ABcmwe7LGcoYUp2nT8BPnxE4/v27PcTayWYMNtSRCbPf7WC+y8Pl3M5QiY
         CVSp24KjslPcEoYzf64xTfHNIsaSw4LJReHEyP5PgvWRJCId/wVkoC6W3LT6UrSafryS
         HcWksmocKJ4kt2Wezgkt+iusYgikPK47vDOFpTVQhNCTPxq5AuzGkwUI8anD4Qkw7OtZ
         jILA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i6IMBdlMGgMvEJy6upP7aINcUJJT4RA76aNd/khHM6I=;
        fh=g/bb4fmEfdoXpPkBOr4uFY1ClE5nDZ3Qd4bJBoPMpWA=;
        b=UAwXgacp4fdUIIvBDNY6nXKqPwpbWyOWH6JwHwmcVzGT5nwZwfr9rEGScB5OT8WZAO
         a5zij4UvfBOEVYrf6RriUN2yVbHo8o4B2LgXS84Ksh/geIqWCokIlt04zmd2vDdIxY8t
         sENdE7DWIPMHdD4eLHbcXZfSKhZNUZjLdQE2gMUs/BO4Ora8hPhCWiyRa8npg9y7pMoe
         FCtImpngzXEgWv3eJE4pV+Kh3GPVz26YeoXm3kFSuYgSYOCxm9Z/ywd2HXUA4eRKe5Z+
         P2MMUPysFWiVfqu/FBxplsQaHBgObH6umNJJorfbcPpeXhOP7w3/B7VGwHAwR3v9M56J
         h6mA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788155605; x=1788760405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i6IMBdlMGgMvEJy6upP7aINcUJJT4RA76aNd/khHM6I=;
        b=faqG+0h8IaFbnmNONpQNJGIQZQ3UiwXtiNc0aZvx4ZG00bvD69n4AGqTqPZMn89Tbn
         xGkszT+iUNjYTYHI6resqCyFZdIIEpV+1FApJ/Vvdzq2GYIHNyOuyxTugIw8ewfwXYvV
         H5vlfkOYodDMC4XzJGfbtYt0qzcZKXXPLYQQU5nRzbsFFfO7HBSDiQkh7f7+ilRbA4gi
         fg0zp2ky+D5h+BLC26Wjto2LJJ6zxkGG8Lqvt+2xf+HOAufbUasUcirG4lXLARCyam+R
         6Fgm52uOzgM/Oa+lM0YFyQOvHOisvYCMddtQ25r0I3kGrmlnAJE6FX8mm9RscBaSY3HA
         qnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788155605; x=1788760405;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i6IMBdlMGgMvEJy6upP7aINcUJJT4RA76aNd/khHM6I=;
        b=tHe2FuyNo5u4NyPOQKfOv0oBbzqKDzn+KYCo0PFeC+MToP48EY8zBx+tBhESx40zgF
         UiO8YFgbF9zkTPEDvgbjgEtXUcgpqUmrexf5n6KctlRZp6hzaREK4hWVVHKNZdgqbvhp
         SHXU8g2z2vAll8LAMWzofsmhUxgVG1hms+Pa3Q4hggLqQgoimYu3WL+lVSUqh66qiidJ
         vdVBPBKn5cm8xJ/vDT5trKiVpJXb82IdkomUA/jg8wDRdJFphh2aFIqZAWgGiPvt3Re6
         Ju4Mtxd8dxV73FMkANubxFOJgOFI0xANDpf3WIzQrzLgZ05KnYj4kU6iJKEfKxUjTeb9
         /xxg==
X-Forwarded-Encrypted: i=1; AKwUvByUtXCmQOvJwqsrfnan7P7jlsKAMK4S2HhKl4jbpwBAlXZiByJA+8gKnAnNpQwIdyPUS1m0bOgk+oW++1l1TQ==@vger.kernel.org
X-Gm-Message-State: AFuF++k0irHhfof4Ydz/xloj5gIKB3zM07u1RYtJqRTjJbzjTlIpDVzB
	MYsDycPtDZqAeiilUjXvg9qAlOmrdphwtsYZLlpjwKPo8xgG0jq36XtQGM9j11b0jfmI5ptsNE1
	nAm066EykbpySdq3M8tVzGARYnk8NlfAryx1H73verrwt+/fk9OBNi+yzntlkRk6qaTz374uPgV
	4ZsM6cH/DW7671En98JJKK3QIzGs70PdSZDH00+VZv6dy8OlukszItNKc=
X-Gm-Gg: AYBFou3f4baenEKv3hKtTCCYOUFMt5EhkzbKZp388YdokAPohE6oTNx+GNUGw0JR+Bn
	xUkrVApTo3FUj08BjeU+Xgt/hxEhPNH9fBZx2i9NZK+qreSfn5BMNpOK1PnPqv6l5hKvuZtEeR+
	8/ez/NE1AoRdrRwva9/iVJva9UxJvD6tbSp2f500/rka6L9kzjkcOZ4SBfHVcqE0Kem6uzlgjuE
	K4C70/XYGSoxdi4KTw=
X-Received: by 2002:a17:90b:5285:b0:396:d28e:b52 with SMTP id 98e67ed59e1d1-398bac69412mr9638957a91.3.1788155604952;
        Sun, 30 Aug 2026 22:53:24 -0700 (PDT)
X-Received: by 2002:a17:90b:5285:b0:396:d28e:b52 with SMTP id
 98e67ed59e1d1-398bac69412mr9638925a91.3.1788155604472; Sun, 30 Aug 2026
 22:53:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
In-Reply-To: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Mon, 31 Aug 2026 11:23:12 +0530
X-Gm-Features: AcwNN1Wy8FyiBhUci_1q7jB0oOpbWXw5bqWZpvaioxq4nfOQgv6iuj3oqi8_Qkg
Message-ID: <CABkEBKYdFcUfMGj1pGmVYrdLQTO0eExq8Z+vMdjYGN+yjQ2uFg@mail.gmail.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: preserve PPDU state across monitor
 status buffers
To: Kang Yang <kang.yang@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA0OCBTYWx0ZWRfX2CMEyoiYXBqH
 NrXV+gFi+sr1icceZHtjvPKzuLSPBnT2xJf9B33fp++tgE4wGXqvIvkCOFMLxzhte5vFIK1x6B7
 JcqRfgaqoxapn5fU+rDeAxz1vQxTlrKVKRfcHqdxadK8Z62ZfroV8fuISOOoeBPXTpsR1dKp3ue
 PQVzjMqMDUGL2KcWpISdmRuwyENZbvuKNZkGhUeK5ToUhq/lTzLysOspGQ1aP/UbBUY8JiFBSFA
 myNOVFx/vbOesKE6nwR/2IbBLPvjLWu3nn2Jaz3sOtrpoXnuzf+/uWlGWVlfiZM/wyit9lRSMrJ
 gW9vQj37usdImf+T25bBFOr3UktHaTmtyICZfKW8pwkEBZ/GlI5A8ROWO1sfvbNmyxRKDsX+8d+
 msb7Ipz9wZyCXxcOXOR1UwGFd8bfho8HBw7XE4LI0ZFiZENv/DRiMUKoDvyS89LDzF25fvYrpMU
 VUP8wD1d6GPNJMKNVGg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA0OCBTYWx0ZWRfXwxNDd9FpyqYU
 eZS5C7/1APD2yKZbnJEtPHtl9Lw8iXUsbt1mo7yHPZHDzwt/2fAHcrgwuxuTdrwBwv2K0vmT2Mk
 Byq+HVYchlEe5J35GMmsjvSD1ypLzP4=
X-Proofpoint-ORIG-GUID: FonXmyliSR2RUF5HktgAjFK97rEcIYVT
X-Authority-Analysis: v=2.4 cv=Cr6PtH4D c=1 sm=1 tr=0 ts=6a9516d5 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8 a=JWBcIGGzIbbpiR4D4CAA:9
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: FonXmyliSR2RUF5HktgAjFK97rEcIYVT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310048

On Fri, Aug 28, 2026 at 12:26=E2=80=AFPM Kang Yang <kang.yang@oss.qualcomm.=
com> wrote:
>
> A monitor PPDU may span multiple status buffers. However,
> __ath12k_wifi7_dp_mon_process_ring() clears mon_ppdu_info before
> processing every buffer.
>
> As a result, continuation buffers lose PPDU state collected from
> earlier buffers, including ppdu_id and PHY metadata.
>
> This can cause monitor RX processing to fail when
> ath12k_wifi7_dp_rx_mon_dest_process() observes a PPDU ID mismatch
> between status and destination rings, preventing MSDUs from being
> delivered. It can also produce incomplete EHT metadata that triggers
> warnings from mac80211:
>         Rate marked as an EHT rate but data is invalid: MCS:0, NSS:0
>
> ath12k_wifi7_dp_mon_srng_process() already tracks status TLV
> continuations via ppdu_continuation. Apply the same logic here and
> only reinitialize mon_ppdu_info when starting a new PPDU.
>
> mon_ppdu_info persists across ar->monitor_started transitions. If
> monitor mode stops while a PPDU is mid-continuation, ppdu_continuation
> stays set and could leak into the next monitor session. Reset it
> when monitor mode starts.
>
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_S=
ILICONZ_UPSTREAM-3
>
> Fixes: 78d3d907d0f1 ("wifi: ath12k: add support to reap and process monit=
or status ring")
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c         |  7 ++++++
>  .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 23 +++++++++++--------
>  2 files changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless=
/ath/ath12k/mac.c
> index 9a775602775d..bda055a86f06 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -1502,6 +1502,13 @@ static int ath12k_mac_monitor_start(struct ath12k =
*ar)
>                 return ret;
>         }
>
> +       /*
> +        * A previous monitor session may have stopped mid-PPDU, leaving
> +        * ppdu_continuation set. Clear it so the first status buffer of
> +        * this session is not merged with stale state from before.
> +        */
> +       ar->dp.mon_data.mon_ppdu_info.ppdu_continuation =3D false;
> +
>         ar->monitor_started =3D true;
>         ar->num_started_vdevs++;
>
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net=
/wireless/ath/ath12k/wifi7/dp_mon.c
> index 016b0c38e51e..ded7d56cd79b 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
> @@ -3211,18 +3211,23 @@ __ath12k_wifi7_dp_mon_process_ring(struct ath12k =
*ar, int mac_id,
>                 goto exit;
>
>         while ((skb =3D __skb_dequeue(&skb_list))) {
> -               memset(ppdu_info, 0, sizeof(*ppdu_info));
> -               ppdu_info->peer_id =3D HAL_INVALID_PEERID;
> +               if (!ppdu_info->ppdu_continuation)
> +                       ath12k_wifi7_dp_mon_rx_memset_ppdu_info(ppdu_info=
);
>
>                 hal_status =3D ath12k_wifi7_dp_mon_parse_rx_dest(&ar->dp,=
 pmon, skb);
>
> -               if (ar->monitor_started &&
> -                   pmon->mon_ppdu_status =3D=3D DP_PPDU_STATUS_START &&
> -                   hal_status =3D=3D HAL_TLV_STATUS_PPDU_DONE) {
> -                       rx_mon_stats->status_ppdu_done++;
> -                       pmon->mon_ppdu_status =3D DP_PPDU_STATUS_DONE;
> -                       ath12k_wifi7_dp_rx_mon_dest_process(ar, mac_id, *=
budget, napi);
> -                       pmon->mon_ppdu_status =3D DP_PPDU_STATUS_START;
> +               if (hal_status =3D=3D HAL_TLV_STATUS_PPDU_DONE) {
Consider HAL_RX_MON_STATUS_PPDU_DONE instead of
HAL_TLV_STATUS_PPDU_DONE to match the declared return type of
ath12k_wifi7_dp_mon_parse_rx_dest().
This is a preexisting inconsistency, but it is good to clean it up

> +                       ppdu_info->ppdu_continuation =3D false;
> +                       if (ar->monitor_started &&
> +                           pmon->mon_ppdu_status =3D=3D DP_PPDU_STATUS_S=
TART) {
> +                               rx_mon_stats->status_ppdu_done++;
> +                               pmon->mon_ppdu_status =3D DP_PPDU_STATUS_=
DONE;
> +                               ath12k_wifi7_dp_rx_mon_dest_process(ar, m=
ac_id,
> +                                                                   *budg=
et, napi);
> +                               pmon->mon_ppdu_status =3D DP_PPDU_STATUS_=
START;
> +                       }
> +               } else {
> +                       ppdu_info->ppdu_continuation =3D true;
>                 }
>
>                 dev_kfree_skb_any(skb);
>
> base-commit: ca800a9302764c445de0da0e84d2252400a770ee
> --
> 2.34.1
>
>
Actual code change looks good to me

Reviewed-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

--=20
- Tamizh.
