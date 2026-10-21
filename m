Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590880;
	b=cUksPgnB6J5peTehh+y1rCCwcYaqeVo9wNs5jVTqgHOMlim3Uk/bpLZfi3daCLhSWivf
	 HOb93IBYFxbbXBoQh2bZ7Nuwbh8MKCVSW8eRgo+kuJWVjpMQZW3qpUTKwaVaqeLhPvnyX
	 AZlAH8IPkMF6Wi372+SlOqPIViCbnjXDKYWk39NjIc3H3uEWWwndoVEHueFlSLnjives0
	 kWWdy8WKlLhIauRu/TgijpZlFUFb1VezyythOJhBX7UkGjdCEgjBiYSUeH0i2GmXRtR7x
	 H9pPF1RGGPeh4cPuIyERaeUuNOKv6si2xH5i6l8xZ9n04fYHLryXwDKoD04J7geaaSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590880;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=t41uoanVR+TXtC4gloJCUo97Lt9PNgCNxsrVHBM9JuY=;
	b=E9N5P/bGWI8lisMamAR6QVq1umHzVqULs+Exk5IwZ4jCj2nJu3Y2NY1OvK+XhzrmyFxH
	 a5UQrNIaRM2yn7esxmFDOXKDXc8GKFNqjyN/g0yJLgSNv6aWivdWrXuu+4caPHDYLTJvR
	 qNgEmj6j8hlATz9msQH5lf4B7c4ohBm+ZL0cNrV7hh977SLkqM4icTZ4VTjnbH5/BM4Ez
	 ye6AcTyi2FjGk8AxILh2y8o64DqJq/f3cdViqDO4OucPvS5VdFBCQABYuZnhJxN3hfwd4
	 B3TbSyT9Cbi51XuYvIzpMLp9pawKt8C4okNOx39v/zAXfsOem1caCuRrNQMnBY5jsAA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CHV23s4v;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QgVjRTIU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDEE606A31B
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FDEE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CHV23s4v;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QgVjRTIU
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LDN9oq402866
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t41uoanVR+TXtC4gloJCUo97Lt9PNgCNxsrVHBM9JuY=; b=CHV23s4vIghmqWbv
	3OTLp80UMjT0y9JoE3lNnRy7kqp7gqFxzRI1UwO5nNP14DtZiRzQoqWQsH663p7x
	DaJoYsdKakE2Vwgo0KLALU28mpFqAEQihoHyRFLhEc9kerwPSsZg1bdn2mLrvdxT
	mnyNsZKYNAvFECMV/cu4CA+EvKC4SJHC/w1xAiZqRQRzIGthFEdnhdGtuurIDRKq
	hFT5yxuAgxspQylAOe6y3C/A/iXxFjTQCfQn5maeNNX4ya4js+zsfmpYl7wLrX3O
	9hvEnMQLbY2Elb/eiphFd16IBofjwBOlLUD+tOJZNUSe5/T/hHODWNR6gJwf9pVR
	WiAZNA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hex7vr4aw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:54:38 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f33438950so171734185a.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:54:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792590872; cv=none;
        d=google.com; s=arc-20260327;
        b=VccEdHJwd82eV7Rv+snPR+tdCU9igWFxT2BlKRdfYM7HElFUoxM3+qAoSbRV03WrPC
         8FeOv0ePRzkrFAQBOUGuLoASU2YZjGRiXVNcuvj8nDG90i9Cfj6oaqwud9LegZd5pfbN
         ed3Ai3PhCxPYxOPkTzB/p4EX2MWVf5Q1GrByZGt+GnrS/DuIPGnKH1uUFwFfjli1izIA
         nBSzj1LuytRgGDe5AHkHrHNUou8JwNoNj4xus0Of6wKmTdP7ZAZTMZB/+HPiClcseS3I
         ZRaBm9/v5qRAtwmio7CG9NS3NNnGSdTZ2+zr7NDAt2dp1lC4CugPOc9bdqVtFQpVQIzU
         1JVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t41uoanVR+TXtC4gloJCUo97Lt9PNgCNxsrVHBM9JuY=;
        fh=mmIKWraoUdOxpTq4+voNbe/6SpCguoAytUavCnS92xM=;
        b=fSt0pD4m36rB3iyYkfmSeBBDhG6W0ZRcAvtO85R9CI4h4x4sSm27pnGfpuvd9/312z
         yRn4+RXDLYf9uckT+0OZxaOiDCGmUisgW74IZnJNYPEiCjFwR5IofoIwSgDjyWIPqeDP
         +iv/gFPlAtB7+ilDLcJ0dh5aUgQKgHNv07qbC6BFwDMFaSr6T1+d9mH8Aag4aVfmWPVK
         dxBr3SCzg1Xa5zXVHqOLBu+/BZpSh55wh4CQEPA6G+VdHAazt58afJ022Idr4DBNS1eJ
         XBJt3uV6WhtXZCVKeN9XoN+yCi6hF2jiIys2ZKOB1O6DQ1081Ngy/qPbk37eM6UB/O15
         Zb+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792590872; x=1793195672; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t41uoanVR+TXtC4gloJCUo97Lt9PNgCNxsrVHBM9JuY=;
        b=QgVjRTIUKiNZKvkAYFre6o3V7/yVC+PmUTFABkAPTDcfhOK+XEbdtCUyj7TUcjfcEm
         l6co4KK8p6aoEeP41wlrfrKx7vVgN5dZgRJha1rTaz21i9NRc2wpI6HdwzA3h9PNzzlw
         rXu+X7xgCP25XcP1myn82/EoytK80K6cGrJ4f0wyinEet7jbBF4/ukRNrDVgHjCvCytD
         +7XjvkLJj7YnalLelm+LyBkWixHoFoEGaJFpZ6Sem8L+asBeex6pY8VhiIp69PsILwkP
         gYSr4SpfZyPcanUCx1o+/+jmr8gKKlJowQyHN41AfxlLBZELMRvIpAWHkJXAyozu84uD
         hErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792590872; x=1793195672;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t41uoanVR+TXtC4gloJCUo97Lt9PNgCNxsrVHBM9JuY=;
        b=lRA9eEuxShkROyt5pnySUrkAwfGJIVnaaodVnQA0w3Gl9M3AD/iQ9BIorGyEPKme+l
         6uVyfdvQnanH6PcwosHSwok9sugH2ZgoEzjgb25rdhCfUa0vcyw9JFmQdyAbfrGGy87H
         +ppXQIAVY0gpMjaZYlJSI80Cjwop6zivgiHiPo3iDqZlBbRAtF/ZLWtb52VoSeD7tIdE
         7MSVBhdjCqTg1OG2VExClVNS0rEgjwLu5vpXVrloEVc7pDDNNfgbvvjcYti7fez11iS4
         psz6PSQuqWP/YbMUbUqYXUSRO69NMX5M32JFLAKpYz4J4bmhGKoATb3QO8nIPk8LthG8
         iqyg==
X-Forwarded-Encrypted: i=1; AKwUvBxhjb8OD+4OzTGjWRh06OsXLGE9+Au46jGuC6MUZszI1W6/Cguqe8zOszJN5vqQ25vGczP66H9HEG9jt4AZSw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLJ6Ja55vcKpKDcxvjtp4qtDahj2g/5usjXSF2gMeNgiRvDbTBw
	DoYjcgIEvrsjU2tGDKlkOiZp1ykDO3IZy52kZuvT2O4aJRFY6x8RywulNMVclw3gGcwCCFfOQQo
	9MFedUAz5c2Dz2x8L0LrfyN92Ij9l3QypI7klJwrTrLyX1A+02D9Ns1vmZG0KFs821U67cINZmo
	968G9ep9CGnVdoI01YozYuKdbsaTOWSLeJbampDA6dFvN7
X-Gm-Gg: AYBFou2IUzsBrDRwuXA8izp9GfcZIG3Qevw8fCqql9WDlqOz6rwD1LXMzW6LT0ZhvGI
	EYYhaskRYv/r5fzwA4avncAdVntho9I/Xpn2kA0ZazUhFL1c1hAjHMfbq5fbn4ZTsgo5es7uM+u
	kLkyHpn6QJ7CBgCyODARbDGo63Cx8zzq0B12gS8P4YZTkid9t6wxTwzc+6Wpm32ln9fPzjc0xfd
	LYID0IGT2fAV7xhRfVxzDuvTISBpnqDk49mPoW+LKSY0IOfaxnYDrNC65sgCgvxmeRoxC1Kuaw=
X-Received: by 2002:a05:620a:4398:b0:93e:c12c:f137 with SMTP id af79cd13be357-93f5803fd22mr421246485a.82.1792590872471;
        Wed, 21 Oct 2026 06:54:32 -0700 (PDT)
X-Received: by 2002:a05:620a:4398:b0:93e:c12c:f137 with SMTP id
 af79cd13be357-93f5803fd22mr421240085a.82.1792590871734; Wed, 21 Oct 2026
 06:54:31 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com> <20261021-10k-sdio-crash-v2-6-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-6-5df80bf16e86@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 15:54:20 +0200
X-Gm-Features: AclHuK9frjvxrPgqG79PX0brsm6qD44pye3rZNMkfk_0YWYp84LDbfiNcLFomHE
Message-ID: <CAFEp6-0WLtOCGQbhybo21WWX_ZbE6_nRVQLq-Hqddc-+Vvvafw@mail.gmail.com>
Subject: Re: [PATCH ath-next v2 6/8] wifi: ath10k: hard-block the radio when
 entering WEDGED state
To: Kang Yang <kang.yang@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: wsHtM9supfQ_YS6emR4saY-deZNU_MQa
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA1NSBTYWx0ZWRfXwbPZA7ih38B7
 CEFh3sDe5IoHNQhaVcufR/htv8Cb9BX3+1O+vjWGSkIc1N/gfsvZVcT0+znSLnAZgWxCT7m0Dtm
 BX/0SrstB1TE+CCvG9navUE4PyNq0g4=
X-Proofpoint-GUID: wsHtM9supfQ_YS6emR4saY-deZNU_MQa
X-Authority-Analysis: v=2.4 cv=e4uT2qp/ c=1 sm=1 tr=0 ts=6ad8c41e cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8 a=d_Mx3J29_csdZ0INFZkA:9
 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA1NSBTYWx0ZWRfX9Ea+yOcGsqhQ
 aXB/dhvBvYcftTqOiAPmp/gZ81rLB8yL3pDlVbc4/fkCr+3v0WfsxP0qAWycB/PxCSqnCAk7uVq
 iyw9VzLrflawEhic5Xpq0EQdNfCcfsDgEr538g8VCFwxMA01rvLU1kJ+H9llUHM+ppNHx2S3DMe
 E/3IvKf+g5xoQn2D2EK49z8o3aPRQSdrcw9MbY3n/aEgE8/0FumprJqrxeCcymp73QzvbH5oEe+
 QJ0wK+pezO/3nU/9WmDmEwdl6d0WW9DA3v3xYGnIU1GkhQTi/y54YTO4dVwIs65koj8qq12XeQ3
 F04vLpBbr3k5yvis+XqIPZv7O8N4/9TBwAr3foCn+iYzuhJbXIGOkI3Zxq+n0ERrl2rCa6SQfOq
 SfmG4cu4RS/T+Pw4k+tAD9LjrSrYq5z5AZWHUoc0TxWVlMIUVJm0/7FxtPMuNK5x/MUJsld105h
 y8mZhlZg3LAO4NEUx3Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210055

On Wed, Oct 21, 2026 at 11:10=E2=80=AFAM Kang Yang <kang.yang@oss.qualcomm.=
com> wrote:
>
> Once ath10k reaches ATH10K_STATE_WEDGED, the device can no
> longer recover and remains unusable until the driver is
> reloaded.
>
> Userspace daemons may continue issuing scan and connect
> requests, which the driver can only reject individually.
>
> Mark the radio as hardware-blocked through rfkill when
> entering the WEDGED state so userspace stops retrying
> operations against a device that can no longer operate.
>
> Both WEDGED transitions already route through
> ath10k_core_enter_wedged(), so adding the call there is
> enough to cover them consistently.
>
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189
>
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 6b6b80242cd1..66585cfa6d96 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2521,6 +2521,14 @@ static void ath10k_core_enter_wedged(struct ath10k=
 *ar)
>
>         ieee80211_stop_queues(ar->hw);
>         ath10k_core_wake_all_waiters(ar);
> +
> +       /*
> +        * Signal the radio as hard-blocked so userspace (e.g.
> +        * wpa_supplicant, NetworkManager) stops looping scan and connect
> +        * requests at a device the driver has already given up on. The
> +        * state is cleared only when the driver is reloaded.
> +        */
> +       wiphy_rfkill_set_hw_state(ar->hw->wiphy, true);

Using rfkill to signal the wedged state feels like an abuse of the
interface. Have you seen similar handling in other wireless drivers?
Wouldn't wiphy_unregister() be more appropriate here?

>  }
>
>  static void ath10k_core_recovery_check_work(struct work_struct *work)
>
> --
> 2.34.1
>
