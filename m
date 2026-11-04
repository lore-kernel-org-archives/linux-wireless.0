Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793794976;
	b=5Gg0KnmFV1R6lEriGDOPNUBugGAB7ESOYLRinSuSlcYRCoZi2UfhdDuDQjP0G2WJ0OXS
	 jFADLu3j+7bT9Jvr+iLeqrjo3OcWO6pABZKcaNvahX5x6Ys00lXiKA7hcn+GRfsDPiaSl
	 9rhYthE7oYVQ4ri2eZ0CIE6Mi879tjSxrCmRmSP1j2KGPrJk13PG82/GvqdYg1kNAVlzC
	 i8XpPfzivhtL5u50vj8luVqVnwGEyjwPLaFUyzd+q2+N62eenwiMaFJoqZCphhOZ8xobD
	 AgIHHoygJslHbDSji5c0ksZS9GalO+G/ucRTNdzrCuC220oKC9Zr9lhq0bWVtZ7i87g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794976;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=183EDRlIYqF3DbyMYN1EctpLaHksbiQlPyf2iMSb/VY=;
	b=WGKrFrddRCM6CzeJ39FTitGKomZSbYRpxfF//KsIjU0AwpQQcUJwpKlLEwxgWRZw95Ys
	 c/8JCjDbKYOPZJBZebUs8Bi1/9jLS4MsWuZJDj0zCM4lTGoR0sjOFZlTdWSf+KEsDTlKP
	 /LL01Cn1svT1fJgCqbzUbiaL37Bf/HCDbquTUC0URN3RDDTXRJRUqBEEr9soH74tnBxtR
	 cwzVeehiZ4IqZT2BK+1V1hKYoNnDNmj3YjlsXBmKjXPN2gGyYYvMiaIN7Yo6md5gEpnM2
	 f10rT2ZpTnvn/20UaJJfhuebrwV1d0o33F0isOFyYFhOI/GfCjyInZKyJZHVOSbV2ag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e++URqAP;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D6EuVVFB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83822606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 12:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83822606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e++URqAP;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D6EuVVFB
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4BZuvI608415
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 12:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	183EDRlIYqF3DbyMYN1EctpLaHksbiQlPyf2iMSb/VY=; b=e++URqAPjV2+uBWv
	KvBE8IHNar7e9Ek+2QCX1cFhh/bL+ASAp2foyPDAdL9q9O+XxAoukzmKsil3gQ27
	/sqVAoGWJFgQisseGrkL9QT8vy1v57Twv6jBdox55WwwGTHMM0G4B5Xn4ps/qU8L
	8/xTMY9ZEJjJsoZFer5uw1Q3SUF9IAzAv3YpyhP+XxzWhaETK0Q9KoBtXoZNCrVF
	D10+R22caa9YS784MiVBkQ8UJ8sTkqy7FqlyR24ZX6mdA/+Z9F4LqPVnvo8/GXcT
	7tGhxFsBUo7aheLs9SLHZeAMzyPJCRn/8IVj/6aIwCKxBK7DYoIYYBppcKNhCuqj
	5ifgwQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hr3r807j1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 12:22:54 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f5844cb60so113972385a.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 04:22:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793794974; cv=none;
        d=google.com; s=arc-20260327;
        b=LmbnAOrUYYgLbmAqW4pNLwcip3GhsnBFL0yIHmTRNPRabGMH4/97CpUwFdwlPrl517
         N5ym6NSSnWFlIiLD1DiMJN32IslllYtcHfkJ7aIvxOTcEB2tgk2i26lXWqwlwL0eiHo+
         h+2e+eRyRmsoPeTvaxaQUqOrtJa2Bn2HRkNKId7ayLmQc9CRoP4VKIhbwDk74urSS6So
         5wowrLiK72w7ztNMcZLA1gquFCU4dfkmic9VztDvcFAGePFUX9IRJDF3Z5n6AVNbiRAJ
         hXcA2nCpadOKIMFQ4+8g09lwecKgqJtN8/ABcaIuZMQ/gLrHxkKznjsxqjOl1zwyaCFm
         4klA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=183EDRlIYqF3DbyMYN1EctpLaHksbiQlPyf2iMSb/VY=;
        fh=GwzLdbz7IF4kediNrcLSesXNnpORLnUoF4Ds25IZPEQ=;
        b=jfVz7WCCsYoctXrJz++IjMuLuWpzatj6wRSdTmpv9f9EkyOT5VsMtE/QQ6K6UwyaXz
         PBUXvp0eDvKplm+QLvOZJvsBfVVBjm6vqRL24BT2GnajHAmv8VX+TOiBGHwzdR0LrySc
         GuPJTV/wKnb2LM6bgAz1JgAs+y9TTpfQ6PwtUhTYY6Wo42MeCxDcnI3G8HEWoTejaxwx
         rYkAtfPHaDu+84+1QyfrH0KSBwqlhmlK3jsgI3h7nvoAWUOJjWo8yecexAcUV1xnxpvq
         zEBrZZ7YboVnem5SPd6sXdJgdPAKCacxwB0jwcX+Pwep9xClIdS1Q+BFqoFNo/d86TwJ
         fiIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793794974; x=1794399774; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=183EDRlIYqF3DbyMYN1EctpLaHksbiQlPyf2iMSb/VY=;
        b=D6EuVVFB33Fw7/xXPWv1osSp1SMSsV53nADdpp+kIz6HCJtpULB1iZ7mNXj5z+gfsG
         D7J7sHHWnMYSqtQUmL9mYRVUhwOtwRuUcXsz695CA1KRirM0PnxPZtoQg4hcwcSYzQTJ
         5Ux8CU3BOmHvaH5oI+M9WCEkp7aKviRBiOa/ouGdTfdVQMYnELo+QjEa0Se0/jzZG8QW
         KWm64O1X072Z486H3l/8S0Zik8QZUSpFj5AGMnWmxoaMzPEJRUytTPcysV7MzcAXjZOR
         QhmMyXcaXGmw7osTrTQ0g2OT9OL9gx2iLJaWdxWT8k6+ZVHhb3g1iIqixZ6g3XRJ2D3P
         Vxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794974; x=1794399774;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=183EDRlIYqF3DbyMYN1EctpLaHksbiQlPyf2iMSb/VY=;
        b=x7qaXK9x7e74xqqbfDt10nc5ox32SlLgwy31qs0lSPy4yAoaZsfupwMt3NZbQlTOze
         TBFoXRImih9g58ZV3T1skydPk8qAlRcKAmLhfEkqz5PCbtMm5tJaOC0jw3QaeFa3ZKb+
         572bvnTttgwF4urdnyIbw8FOfUKDXvLDN/urHk/AYo0mfxD6JL7hhEsC3nfREuUENVd1
         PXTp71Oar4PuEvB6qInfWSp+VqM2WQYf/+wKEZW8ew5xWUIOmWAk08g4BrT+ijQrQV1J
         DleqX3JElcg+ReAksr4g2v+TkCZb+xlEICzPBLBkNByivICmjzdSB8aYdKRAeHufCxYp
         7irg==
X-Forwarded-Encrypted: i=1; AKwUvBzdBxkRI5gCk6KfiGMmVbWyRiWnviX18Iyh6Aqo4ABTc1l+AbXwoBEKatE8mov6eRwtd8IqbZVpBsbjsEBfkg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9R2EXLkcczi8iEJAl4Jj9U98PfPvANXSIuaE4oIL4Am65DJ6Ak
	2LTfHyUXO9aU5D+5GYss/U7mosYYpc6TYJYxYa6jNszHSqCiBqcvqfqFKkisWspxhVNV54WXFy5
	Ei1Yw/keAXLVONrWzxHElNjm+2BxxA4ElGww4cpyekOI0m/izdSbUaMSw81RP0Pdh8c4zzNCjyu
	reHbcMaaDvINyM/HoGWnuOuoE7YDjQDJoO3peL8/RlWr6LHb0dRFuzTK8=
X-Gm-Gg: AYBFou2d12587fDNMP5ECTCB34cYQg0AJxLaQtHoEEsTMYKD4/Vxa6XJ8DUVtdRs04w
	vi0OtFIpbi9dbDGzpZG59mo6TOxKwWBCxq+BEtLYPCmJn8/BOuD9RgqnEh4rQ3ahKdZz4iiiQLp
	To3c3DXzGt7qeUBjA3kuJvM2gtgoU+eWfFByvAdCkwN3sLV9St0XuKfv1ZOfKRY99bGkBMp+dMR
	lpmBnm+axK2U+xlhL+WTKcLmzUW7n418EVJHQsPWC6APr83YFlJ+k0GHd5rhNqPSlirwGHjQ/E=
X-Received: by 2002:a05:620a:1d06:b0:93f:16d4:3c0a with SMTP id af79cd13be357-944214cfe6emr2450264585a.4.1793794973620;
        Wed, 04 Nov 2026 04:22:53 -0800 (PST)
X-Received: by 2002:a05:620a:1d06:b0:93f:16d4:3c0a with SMTP id
 af79cd13be357-944214cfe6emr2450260885a.4.1793794973130; Wed, 04 Nov 2026
 04:22:53 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-db9e3c75b3-wifi-ath10k-1@mail.sdu.edu.cn>
In-Reply-To: <20261104-db9e3c75b3-wifi-ath10k-1@mail.sdu.edu.cn>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 13:22:40 +0100
X-Gm-Features: AclHuK-6UGyqTawQ41_TfIwEP-0YIAdV-QtuDRMs9UNfsFep-kXTj67L-wbAe80
Message-ID: <CAFEp6-2xed2JR-kX2a3cbTTtTF3nUX7rNS0hKMew=tn72Tv1Og@mail.gmail.com>
Subject: Re: [PATCH] wifi: ath10k: Fix potential CE configuration leaks on PCI
 probe failure
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: 6gCvfBltu-0YOVSkfP3HTYSQQtkObo1W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA0OSBTYWx0ZWRfX7guyBMSQhEHX
 8m16K+3Md71HqrNVn3OrYe3GzFW/B5WW/mFG0JxLXUAcjgtCiXECyDUlUMNgDvgBYXXOheetCHj
 uS3hfy+/MNK5NH9Ff43UIq7SiAH+b5k8aW9lu0jsxY1i3KGtxto1NefxZO6zF7QV56KmMg3zE0S
 gJ6acqj/myf3+EvfEZ08LaXsmpNdlMzG2HjaJp+hy9fktQXHAph3KgRkkFGfW9p08q5Z4TMyblE
 V4a5u0iZmCLkZd/sxziDrTOJ3q7QW7tbIeuWkM7oDswxWVQuBKPKbKHt2xabCgOUKJuOwJsHYk3
 LhVrb0/i2N7pOg/Ij/kRDen237Q9DHbkA3yGa9OCkmEYCcFfxe8G6Z0n98K+rgXpN3qm1rDJjOx
 tSa8jMg6KJohJQQyRMQWgUEU3cV5buDC3bxdzmVLmyMoa2MAzRNdN5BisUo7N2Mb1Bsa/rtHCpq
 XNaC9GVGBCXxEPwVKqw==
X-Proofpoint-GUID: 6gCvfBltu-0YOVSkfP3HTYSQQtkObo1W
X-Authority-Analysis: v=2.4 cv=UuP2pOwB c=1 sm=1 tr=0 ts=6aeb239e cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=DVFfUGNISCTMBdQC5joA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA0OSBTYWx0ZWRfX6NQvdW0a4Bjw
 CfPetjinY0mXRCVlbu5kvpW1gXxs5Sv6VsVj1qxQc0O5Ws2J67WNePRpOemt6LUK8ccMhj/7wHS
 lLtbL35ERgwxeWXNeg7qRpf3u4ydTg0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_04,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040049

Hi Guangshuo,

On Wed, Nov 4, 2026 at 3:34=E2=80=AFAM Guangshuo Li <liguangshuo@mail.sdu.e=
du.cn> wrote:
>
> PCI claim, wakeup or IRQ initialization failures bypass
> ath10k_pci_release_resource(), leaking the three configuration arrays
> allocated by ath10k_pci_setup_resource().
>
> Free the arrays with the CE pipes on the common unwind path. Keep
> the later hardware cleanup separate so the arrays are freed once.
>
> This issue was found by our static analysis tool under development.
>
> Fixes: 1cfd3426ef98 ("ath10k: Fix NULL pointer dereference in AHB device =
probe")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> ---
> Validation: x86-64 Clang W=3D1 changed-object builds passed with
> allmodconfig and allyesconfig. No hardware/kernel runtime test or full
> linked-kernel build.
> OpenAI Codex assisted with source review, patch implementation and
> commit-message drafting. The submitter has reviewed the changes.
>
>  drivers/net/wireless/ath/ath10k/pci.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless=
/ath/ath10k/pci.c
> index 335bc7c488e4..f3c4fe13f76b 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -3716,7 +3716,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>         ath10k_pci_free_irq(ar);
>
>  err_deinit_irq:
> -       ath10k_pci_release_resource(ar);
> +       ath10k_pci_rx_retry_sync(ar);
> +       netif_napi_del(&ar->napi);
> +       ath10k_pci_ce_deinit(ar);
>
>  err_sleep:
>         ath10k_pci_sleep_sync(ar);
> @@ -3724,6 +3726,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>
>  err_free_pipes:
>         ath10k_pci_free_pipes(ar);
> +       kfree(ar_pci->attr);
> +       kfree(ar_pci->pipe_config);
> +       kfree(ar_pci->serv_to_pipe);

I understand that ath10k_pci_release_resource() is not entirely
symmetrical to ath10k_pci_setup_resource() and tears down more than
what has been initialized at this point. However, would it actually be
problematic to use ath10k_pci_release_resource() in these error paths?
For example, is there any issue with calling ath10k_pci_ce_deinit()
when the CE layer has not been fully initialized yet? Using the
existing helper would avoid duplicating the cleanup logic and keep the
resource teardown centralized.

>
>  err_core_destroy:
>         ath10k_core_destroy(ar);
>
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
>
