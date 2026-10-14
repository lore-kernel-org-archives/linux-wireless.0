Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3AA539776
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988246; cv=none; b=evzyooGrcL2PBZFMgAD6n++BuRNBQIs2i4bG0hTsgTPMUAO67dRtv4gubwgcFkOh072bi8Q9JqrklMpNQMbClyJRltptDrUDj9ZbdtAKAjY0azzTPAen3WFcocR1nlXhN26wWvCjhF7xIDAfOeFmOXQy5ITiC/waWwBVBm6aT8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988246; c=relaxed/simple;
	bh=QkAQFJqHnT/S5bkgdDjkDERPTbkiMe8cVnMjGslzzLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGrw4cx9Wd8P9J5bXcQyo/oWFF09CAfznvBojbTnN8cT2vk+aq3DYwuBnIHqv5aKwuMDzUBvVvakjLo4MWoRCQxRSIdnQDMR0gA2DMz6JY3tC0ump8sumaYL/uGZW5WXlwTD9o7Nr3nS24t5kUVPI3g0eQbKegt6ih7pxCw28xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HHP8iaiE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bkFi2eCp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HHP8iaiE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bkFi2eCp"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EBVQ0m2515931
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=bKU6SBOy9ApqE53IhaKqksj2
	pcfRhupWYTN6RzVisPc=; b=HHP8iaiEyNrZIGnMqXJOFhBpOVGYomaOnSj5VZbq
	GOReeHX/0F6tCn2aFlSgtHaodu4T/hVpjYd6uqub3EmABUEaQNb8+M89Yxth/ZN9
	cg8pJ6D0ambk7qB1Y0ACdnmY35YEd07aBpvDfrHCBcgn8Cu63/xY+qivHXHLvoKB
	0ZJSmOPOMYW1gFthBqIX6qikgQOWBTKqa+pCvkA/+GU3rba6C1spyJiWJIksC9EA
	LlbUes5Tv7GqXmtg9kqZ3pSUv28/ueNVK88Dvc8Ta9ULAfkhek+JYmOpWSBZv5d/
	7f8Q+gvuntnO4zq5i6G72ZC35G6TvmoBw3ABA31wh5/Fpg==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha470a08b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:30:43 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-7bdb408a368so641280137.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 07:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791988243; x=1792593043; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bKU6SBOy9ApqE53IhaKqksj2pcfRhupWYTN6RzVisPc=;
        b=bkFi2eCpsqERJ7MNXpLl0lCXayGPMKPQjWa3YnFCjEpdXhsL/tq8ttFlhhUEchzLNl
         WiS4DFsqKSln6bLGFnmYTdIqiKFtHAmMhTxy4ImhjsN2uMtkNcUf9f6ifX77s0mRP0yl
         DDW7GM5dFnmfy5WZh2oCQFteSYcBX2NtJkSNwyTrVBBQwGJsKNuwbN82eKrn/VaLYMEI
         1ULvvM33hWheKQ6IC2aPe4ZqVL9278rRwPWJdHQdBD1bmNKnhJRKW3L1us8/878jVtyN
         w9up9HZb2cn/MoVUE86mef/RcaVpSFG6EAOJ6EaHMGuvarZ/XGCt2YVu8CxOgX3YW+OG
         BYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988243; x=1792593043;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bKU6SBOy9ApqE53IhaKqksj2pcfRhupWYTN6RzVisPc=;
        b=C1Qi3H7q6EmAUkNySp3Mu7/HK7yeDbJn/YUICT6pLcU0ZnxJ6ugamkkgZfxK/WdUwI
         w4qCWVJbU4+ZUlZoEp4hOgkVDeWN+ub6Vg+cWOoTptXLH8z/vbYaYklUJ63BnQb+RyvS
         BQtRxroi+CKzV5jWuvtondBfgzWamEj/kycnghW4Q1F5eEgunTPKAGOxTLZHCMMENP1K
         aRR7qJmuS6KcPgnfAjPZiC/9H9SdYAx45LRJWTNLyi1pj6Q+HUz2X99lO+bbY/4AlnFb
         LqXnpQr2RO+OOOSVTEFF2GJCxdCnBSQNq6e0GajHfL0qNL8cbwMzUuDIwlKsFzs+WXhT
         1zuA==
X-Forwarded-Encrypted: i=1; AKwUvBysrxHWdh7UQkPmXTB/EQcr7ACj3Bz1CoMnFibH+DTgUL2YuDUTKbpWLchag1JcF5mSP/4cAxOkOs6qCPyRFw==@vger.kernel.org
X-Gm-Message-State: AFq9FYINy1bHSa79MQK5KLfl0XRJgwSf0f6XudGptYXMXQiQjsOTYRwy
	wHZ1EIPEIgIppSQ5bWAiPtGwHKtGkkrhxc1tQZZR6MBkUc8qdz0OTePxbwZmGTxvdT948y69ukz
	3BKu728Xx5kH30c4AQeubq9II6B0kdtWW9OnI0eJAv3C6xBCsO7qvXOdB/PJWM92LlJwEEw==
X-Gm-Gg: AYBFou3H12CLR4BlDXuXbA9KxSgmXIJ8cjlFb9Vk+o10wpCE7PImtTeqFuOrF9TKxl+
	4WV7OKmtnSOEviCuGYwx7DgV6prg1pqEOwL3ENPvWaRKsFQpeeWqu2mpo8puFwrea6pTT5Fv+QS
	9+tCvwHIg2cKgqfBu0cOprqVK/UPSJFlPZxz65HoUHAcBq6Eq07wWNxII14d1ZFJC5ZFy5Apebg
	pR05CD6oeX81eijmsokfCEv+a1ER6dTA+XMJqXAfW46TPDD9mTC7gvNB8Q9kgH3cTEQnkObb8Gf
	BdPkJTO0X5MXpvXh4GkkhOtbzs8/Bu+QGwYO1/6WTXSm86Hze40d3PeFUqeZBVSOCz75ocrba9F
	EVhUs+u47AOjeag==
X-Received: by 2002:a05:6102:1609:b0:7c3:7286:b7ea with SMTP id ada2fe7eead31-7cb372de97dmr3761489137.17.1791988242900;
        Wed, 14 Oct 2026 07:30:42 -0700 (PDT)
X-Received: by 2002:a05:6102:1609:b0:7c3:7286:b7ea with SMTP id ada2fe7eead31-7cb372de97dmr3761439137.17.1791988240627;
        Wed, 14 Oct 2026 07:30:40 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b6224f52sm39203665e9.4.2026.10.14.07.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 07:30:38 -0700 (PDT)
Date: Wed, 14 Oct 2026 16:30:37 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Subject: Re: [PATCH 0/3] wifi: ath12k: add page_pool support for rx data path
Message-ID: <as-SDRZQehtr_J1N@lore-desk>
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="R3en0U7yalSeIZv0"
Content-Disposition: inline
In-Reply-To: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA1NyBTYWx0ZWRfXzWSE1MiwWfhe
 4L68hirkWvOgevkUjt2auKXD66HdxPj+9/yyhOXIYIuOU6e51yDMCIlOnfakHf0mXFqFMNniA1p
 3B37NgZRkxcT5KPIlIZhmDJFfCaoR6ZOWJI6FYOKduGSYUiKhygZjVwIfN46zY5JxXsitEVAK0A
 e82NzvN19RJWcDlq6pfN+xafCz25ZtArYBnInv7RlizcgFneLdAzB1UBNgVLEhSkqBbFgc5MfaC
 vk7R/M2fwYBJvlyfudoAEUI2Bmw0GEysgO5GA9EqsfykPeeEv28x56YuYLSUehmkLoGVYnBXXOG
 IEKgW58OU9FEygs5y18k7SDeEObgp6PpUkbboSo9eQAg+irgVTUhAxALmOSrDgUlprWmcsFa++m
 1eCc9s9KiHBK4ZC3GbNxkpUETUDJwkCyDIGKtqt2Qi1XeYCRWJvAMG1q88Ny6Lnwlx8voScvB1n
 S/3HWr7CvVS0hCmz/8Q==
X-Proofpoint-GUID: 7nWAJ9QVrHS6f6bm578rmPS5MWhFOfTP
X-Authority-Analysis: v=2.4 cv=P6avFSAu c=1 sm=1 tr=0 ts=6acf9213 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=LpUeRXHAMchiTH5aEiwA:9 a=CjuIK1q_8ugA:10 a=vD29VgyGE-FLY0UuNjsA:9
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-ORIG-GUID: 7nWAJ9QVrHS6f6bm578rmPS5MWhFOfTP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA1NyBTYWx0ZWRfX61St5W6ryinf
 1cH4oZIPcK21FYj5ne8CYPta/n/FanKUVKj2jZVgsWlha4HCvE09ru/JmwJJp+evFuDhxJQ9AKJ
 sxJrBlEgLgC+MnLrTJjkBs84jDSGruM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140057

--R3en0U7yalSeIZv0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Convert the Rx refill buffers to the page_pool API instead of allocating
> an skb with dev_alloc_skb() and mapping it with dma_map_single().
> Fix DMA direction for reinjeced packets.

Hi Jeff,

I will post v2 of this series addressing received comments.

Regards,
Lorenzo

>=20
> ---
> Lorenzo Bianconi (3):
>       wifi: ath12k: fix datapath lookup in ath12k_wifi7_dp_rx_process_err=
()
>       wifi: ath12k: fix DMA direction for re-injected Rx buffers
>       wifi: ath12k: rely on page_pool APIs for buffer allocation
>=20
>  drivers/net/wireless/ath/ath12k/Kconfig        |   1 +
>  drivers/net/wireless/ath/ath12k/core.h         |   1 +
>  drivers/net/wireless/ath/ath12k/dp.c           |   5 +-
>  drivers/net/wireless/ath/ath12k/dp.h           |   1 +
>  drivers/net/wireless/ath/ath12k/dp_rx.c        | 101 +++++++++++++++++--=
------
>  drivers/net/wireless/ath/ath12k/dp_rx.h        |  29 +++++++
>  drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c |   5 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c  |  67 ++++++++--------
>  8 files changed, 138 insertions(+), 72 deletions(-)
> ---
> base-commit: 17e4b9ea527b6c9491bed60f646bb2eff7d8db7b
> change-id: 20261007-ath12k-pp-e8c62b54d756
>=20
> Best regards,
> --=20
> Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
>=20
>=20

--R3en0U7yalSeIZv0
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCas+SDQAKCRA6cBh0uS2t
rOYnAP4wUFa6b9CcAmU7YVbVVaZqs+enHxacDM0pPTGpcG2/OgD/btgjhhN1AXM4
o+WrMIRllKfMVVjgelgtX/CXxctU8wo=
=AUI5
-----END PGP SIGNATURE-----

--R3en0U7yalSeIZv0--
