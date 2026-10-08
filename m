Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470143A6F17
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791471923; cv=none; b=MLxiSEo9vsEthk90kpSm/64SfOL8GCZudib9zxlODatwCpaqIw9dL4Gsg2GuSBfxFMr4k/MuDD0BU5RWyMQJsbKqYANepEwMamR9bc+4mWESnKbfv5pU82+zfCV2YAZt9b2a7ZJsKQ/DTs70XvUSJ2FJPoqgZ0Rmur7k9yKnB9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791471923; c=relaxed/simple;
	bh=mGyfskTzhz0WOEno9MStECHUYmt+pDJWeLrQg+iRKEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MeFY/c1yR7s5EY2PL4alyaFGiXjUnOA5TY0Q8BlU7Xzw3pTSWRg7Uyw1TgdZnfKX99YZdvoCuNTdJlLWGhXaAgr9ZN63rDC1ncbxafYajRH/C8rvG0ncMH0mKe5g5kjCrUj3zsYyEbrMHFgAz8DmduBl+V7JhGs+dNW1UWv3x5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pC0y3p5u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Hs0W7VlJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pC0y3p5u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Hs0W7VlJ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698EVXqI070529
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 15:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=kv50HkcJaAwj1X8YYLMMAgml
	yDTg6+rpfqYO/vB0gT4=; b=pC0y3p5uYjSZR0ZbTSl3M5CjReBAHW/nBPlYQocq
	VD6N3BrY1ymr8iGeWFfHrXzS6OMAqsbqvqaj+PS+0Av/DGd6cyvcRlDODF9hnJPt
	n6aB3FZYw2B0ylJ6LjYL73D0BCEpplsuJL2xSFsHRC8PYajLAiWdbGjhuc2X9b4d
	/2Yp0qO8UUn+ZZkZhooEcGpXq63aVdDzqnsNVv3EK5dWQSw0m09jSXBGqF308xMu
	Ijw8laItcEwH6lUWONwu7m4D70nYZ0N1dRI6V4E+K9V1Lyc2+lZ/CQfmgLqMTrYW
	Tzo5SEN2N44BkBgiaww6QsSMKHSJRsnkvQcREAl8HucTJA==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h60sgb110-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 15:05:18 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5d777524de4so985800e0c.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 08:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791471917; x=1792076717; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kv50HkcJaAwj1X8YYLMMAgmlyDTg6+rpfqYO/vB0gT4=;
        b=Hs0W7VlJjocH83gjQH2HhQovRNbgQo/1NmtjAO6qBFSmG76AuIWGV6kKHS+Moob3EL
         D/g5AGNiiN4Wb8FanzaQcXD3Ul5fnV/y/ghYI45U/5kVlOLvYrnG6Y1s/9+ll1vfs5R+
         6VvX2PcXM3uYo5NaXOuTt5z2f7Fzo5M6Nn/MC/6WJGwJNzz0INP0jbEpLXBCisHzj1rM
         qoV7UGay+AocaiIuVzK6IwtlN8trBBwNb40Qg1cJGF32agGn7GfTjMAXilqVYVkqbePh
         0Y8XHAoxJy+6SgsnNg2Ksh4bZPBiHZ52sxlT1KxfV4jCLIB87f4WgS76BSfPPCzz91+G
         1mzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791471917; x=1792076717;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kv50HkcJaAwj1X8YYLMMAgmlyDTg6+rpfqYO/vB0gT4=;
        b=VI+HIXNVRE2FLocVwB46UnrT13jeVmKka5tLjlMhO9cS7C8TO1GY+gdwZsnVpqx110
         tBFfRkkGYT0aPUq3fOFglJue1r7wVa9rh/Aer6vkuF66gIputobv9EZDyjju2CWdbqRK
         8qdEv2oGbMwiIIWVbOZIRKIQyl4o/Bubcjy8m6knM7moFlH3yhLIpCkPWgb4A+CTpB2p
         Jsg4Kynbw5hgXy6/XftsvAfaLCtX20ddXQwtL403w9VXOyB89EucA86EXNQ3TBZ7ZRBT
         ym6K2Q+43I4UecdJnufERNHtwo6+2F5Q8WfG9RN1bKXmmA9eo7J4Ul8lzdwXd6+rXHm+
         Ulgg==
X-Forwarded-Encrypted: i=1; AKwUvBwlu9uDKQxzmSjbScp96KC+HAObFUg/sLU8ZAd31HTAXvEYUwPtOjzHRvcYN6isTzatbIS7TlnQ3GWEsd87Mw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIQhuGTh36hAFJUxNWtyS2lI9KkdsrTndzj5rHCB9K7BHnv4n58
	SSfi4kgjKk8mUyADFolNKaKlw5iZH04xUmY36EB/V9pGEpY1L+6X5dYBBtlN8aUKBVPTD9ttLkZ
	Q/h1VpXmwSjLE0zbIZ/nJjtczCEfg1P+lcAn7Qloutu5k2kucSFqwlVptzVmrNMyI/aEQQg==
X-Gm-Gg: AYBFou3IX01j8kdJV5zRR+Z24yCzdOy+aUuEufGGSYnvpSSaMXfKa96EXMQwq9My0Va
	ztMpr6TC9let+qVflHLiw4WZgzE4M1f+hL9FhuDZ4c70FWYBV3Ny400AYBuY/oHHa075t7a4tKN
	aBZZaAUzLQzYF1Kto0jRAmicgQgzhWuSOjWvCAfWy0PvZDifqQlhWItNxhlgkUkztG23GfQbLJk
	ptdrXwpHqJlgH6ASN0hgaZAuiOysa3pKlReMjP1ZQfiLpBoXzasHaAZOXGI1PtKFoPEMrW7w+TO
	OIJ1X0hnFl5w9XmSkGu0KjJ1gkvBXACSIvND6T+/jKlWCqC7E4lL2OlEinleRpso8aRc4+mwqRz
	gAAb4mIEd+BxF2Q==
X-Received: by 2002:a05:6122:8b81:b0:5df:12d3:e99 with SMTP id 71dfb90a1353d-5e82ae07fb3mr811396e0c.16.1791471916298;
        Thu, 08 Oct 2026 08:05:16 -0700 (PDT)
X-Received: by 2002:a05:6122:8b81:b0:5df:12d3:e99 with SMTP id 71dfb90a1353d-5e82ae07fb3mr811322e0c.16.1791471915160;
        Thu, 08 Oct 2026 08:05:15 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843cb288sm98046005e9.4.2026.10.08.08.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 08:05:14 -0700 (PDT)
Date: Thu, 8 Oct 2026 17:05:13 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Subject: Re: [PATCH 1/3] wifi: ath12k: fix datapath lookup in
 ath12k_wifi7_dp_rx_process_err()
Message-ID: <asexKZv9_Y5soQZX@lore-desk>
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
 <20261008-ath12k-pp-v1-1-68f888cd7eec@oss.qualcomm.com>
 <5f55176d-12a7-47aa-97ae-9a2ea071d815@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WWNr85YoYd/pGTWO"
Content-Disposition: inline
In-Reply-To: <5f55176d-12a7-47aa-97ae-9a2ea071d815@oss.qualcomm.com>
X-Proofpoint-GUID: UwkYRn21JXsSrDTmK4vopPSAK_1p2nmy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA2MCBTYWx0ZWRfXwUJ1jpEWRQy4
 +TiazNKVsr2AVyUxmCyUgREGnALGzfvxh6NtWkq49Fizs7OxTUMpYdrUMuzU5zWUyfqAYNVWoqK
 ENh9C8soC3bNM+0Sq47kB7zBSyx2FCQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA2MCBTYWx0ZWRfX0O6jp6AVcM1u
 i5QP9F7k6XRtl+RrnbXZYWHNjJ3P4eKUQCo8fl7nBxUqEbzoHpXHgj9RFXcm4jK4pt6yw2Bfd8t
 TJ03mBceVTGG7OK2SirWzB98ZAyjHcMQsBRvXx2y28E2AMtUOIBZYNHTWnozTGy2Kpil9Drh2Te
 Ia1vUGl9JuSPomjnB5zpAkZfbSAksZgR8eImqCuENjN9jh9fIzCOHIPjs35LqFxsxA5OM+inP3O
 e/wJGxzkzZ9+WSFoxzOMHKUoqTRoXiJaMGFVD/xpVSA7BEWyrD/ILg8vCy/HqlP2t4OykKjmSmh
 XB8wq21fZY7Zl/h1sdpy1/4Xf5Hk0JUMZU8BKRUoMC9fEjaqNRtKHygKuJtVJ0k9uocOqJf/t7l
 M3BlZWRbju1sp5JF6LFbZQblmHs7Uo/Wwf0R5WpbwM0ndcXBuh0qQDRiAoMLpnzkKg4m25vZTyK
 Du3uYs7Jhr1IpUT+Kgg==
X-Authority-Analysis: v=2.4 cv=DfWCOftW c=1 sm=1 tr=0 ts=6ac7b12e cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=0XBF_llQh2_0MlobpeUA:9 a=CjuIK1q_8ugA:10
 a=3iFN0n3oArMhL2KwSckA:9 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-ORIG-GUID: UwkYRn21JXsSrDTmK4vopPSAK_1p2nmy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_05,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080060

--WWNr85YoYd/pGTWO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 10/8/2026 6:15 AM, Lorenzo Bianconi wrote:
> > ath12k_wifi7_dp_rx_process_err() resolves the per-pdev datapath with
> > ath12k_dp_to_pdev_dp(dp, pdev_idx), using the local 'dp', while
> > 'pdev_idx' is computed from the owning 'partner_dp'. As dp_pdevs[] is
> > indexed per ath12k_dp, this picks the wrong pdev when the REO exception
> > descriptor was sourced by a partner device in a multi-device group.
> >=20
> > The error is currently masked by the drop condition that only processes
> > same-device fragments (partner_dp->device_id =3D=3D dp->device_id), but=
 it
> > is still incorrect and would misbehave as soon as that restriction is
> > relaxed.
> >=20
> > Look the pdev datapath up from partner_dp, as already done in the other
> > Rx processing paths.
> >=20
> > Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0=
_SILICONZ_UPSTREAM-3
>=20
> Tested-on is not an official upstream tag but is an ath-specific tag. The=
re
> should be a blank line separating this tag from the official tags.
>=20
> No need to repost for this, I can fix it in my tree.

ack, thx.

>=20
> > Fixes: 9e0ee04f818f ("wifi: ath12k: Refactor data path pdev struct")
>=20
> If this issue is masked then IMO we don't need to backport to LTS kernels=
 and
> hence should drop the fixes tag or add Cc: <stable+noautosel@kernel.org>

ack.

Regards,
Lorenzo

>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/ne=
t/wireless/ath/ath12k/wifi7/dp_rx.c
> > index a32c804403e8..633cb91b9e5d 100644
> > --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> > +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> > @@ -1536,7 +1536,7 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_=
dp *dp, struct napi_struct *nap
> > =20
> >  		rcu_read_lock();
> > =20
> > -		dp_pdev =3D ath12k_dp_to_pdev_dp(dp, pdev_idx);
> > +		dp_pdev =3D ath12k_dp_to_pdev_dp(partner_dp, pdev_idx);
> >  		if (!dp_pdev) {
> >  			rcu_read_unlock();
> >  			continue;
> >=20
>=20

--WWNr85YoYd/pGTWO
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCasexKQAKCRA6cBh0uS2t
rIVxAQCaXh5SOgMv9efSXCjBSNkPEHRSHj6+sKy3Q0PmDjQjAAD/UPxa3Hl3FZPT
O4fmW6y334gp9+GmVAdxMQjYuirMEAE=
=kLwg
-----END PGP SIGNATURE-----

--WWNr85YoYd/pGTWO--
