Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747652;
	b=Vb+ecXkKD5WHChTCEjD229gKOBTWOR4aK0bl06v5vickYs8lkxVUuVKyl8pPZRfgOwiV
	 JR5fymCmRZAvQPHsNivDpai0ndZriZgjYUUM5vwnGIjL3+nU6YS89jG7lqiNfPaBS89bV
	 4lf4ml/BicgPirPjkSmFiLUti312zsNOeRTH2mY76YraHBNwpRC2iiv8WRInrAce/9Nay
	 SUp91OyRwdQk3hWmGaAE6580gckw77g/wt5llm0nXI80UnKiIEjC8y0Q80lTSwD8W6nH8
	 IyKBNKSboL+pxfb1ytKuqcCQQ+xWfQkgEjtdnW01MTIRBP6e9uthbXYtzyZTmopmBfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747652;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9lv12kc3XOEh/6mGhcZ4j2RuF4+816x28PJz0CFe5p4=;
	b=uUp3qTkHJJ9McKxrvWHd1ciGMBvYc7rPfSzjZNVUFSqbEoCXkTl39e1Nm1MTECdWzTZD
	 N4ztrrk3aqtpsZauh0UgDj3lZq1wuZRG3wuTrcmIwxqiH71MDqJi9tw/Eq8NdAqbFloqb
	 AL4g/5OLznt7OSmBfibrvo5bjXtX3FVOeuDCDwEnBAvAVMobqLvV3tpfC+l8L1WZl8CyB
	 FCOzgM+S/S3Jalh+dac1o7RI1Rt6svU8MdqcXbbzomdNnGpV7hC1OS4jXYBYKqaV3UL+k
	 yTY3zXOc+Ulr68OL4J2ujpbUMR4uzpvHES8/P2w6MysLS5ZBscNwqqqNb3NcQWzdjjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cLxLNcLT;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=A8rYR3JW;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0027606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 09:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0027606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cLxLNcLT;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=A8rYR3JW
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7F5L61200725
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 09:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=9lv12kc3XOEh/6mGhcZ4j2Ru
	F4+816x28PJz0CFe5p4=; b=cLxLNcLTOB7rE5wD+i2jf3tDh/3SXKV+/eOM6peS
	9SqGbjkViRMUAwiTJKhXRTWUh5IJp+M9K9glLIzD7uhH8pVY6Cc7l/Fg3Q8rBEh9
	nlavNho7GKFI1AsRCpO4g2YOwV2u3x6hMCwoJoaTJjHejOgEAkR5mcoNxdw0CbA+
	YPItldyXJDMQWkQMitw38Lbp4Da3plgs7yH+Kx+5D+lOuZU0VEY2YyEjE48CBkbY
	63ha2rpwJ8XI60lUT8XwUWwJ3LrmQQBLciy1RYddVn755R8Whk3N0EyjfrlyhJSy
	comnGSSN6vM774x71nzqf4rOLv0+6YcWBDTpKUeu/zAhog==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqms2xt1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 09:27:31 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93909014c85so123881185a.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792747650; x=1793352450; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9lv12kc3XOEh/6mGhcZ4j2RuF4+816x28PJz0CFe5p4=;
        b=A8rYR3JWWWd8B8fqYJuQdjjoh3BSx0Ij+rIuKzp9YsVbq+erF9ZmBVUgDsiuHux+sj
         qOtML872knip7RH7WsuVAkR2F71uctiQoq94jdAlGK59/kWPFIMs3HKxJdDV3KGHvTJD
         H8oaoEMJTwSWTigvxW4sxcoRUHkLk2kBoiqDXF+YfQCLdPrL+sn9fUv78ldwSVZymJtq
         puMzZpYzVhfv8YJQ28RFAua9I3VDVjdPXD9mONaljZa0NrmeJJaUIY301+xiVxdKeUhI
         MHxp31UuJrRvDA4chDUZSuDExXCKmVeCelhnl+4qPhMcmYUG/hDBegAO4pFSPe6LUOZs
         xHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792747650; x=1793352450;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9lv12kc3XOEh/6mGhcZ4j2RuF4+816x28PJz0CFe5p4=;
        b=LTz8ULh6TlZSAQxDpcm2VYxU0PKpADGDMDkGra0bVK6KJOhwPQ5UGHJnrwlBSzgO0e
         HX4bPjl4JGtXf6WwD5tor0hTcZCcAOiCz+bjaHn9x6LRZCdpUGQdHLHtWuUVIdliVrpo
         dqpNlnieX29jtC5cxUs+g+mikWVwI5AkBOwurq+TiumpcoFPpWEiTUa7A8LG/ku58C7a
         HAPESD5Mlw4p02jwy8wxz80aPds9BoDQ9JmVH74vsEX9hKneA5ExxifIEZXPkDGc5Bc4
         jTC6Xdg8ptIM4/5vi2pv/Yx6BbJ9mvjp9g/C1O2vGyZpAKJQ6a872qSmObGAT71tz8Ro
         dtEg==
X-Forwarded-Encrypted: i=1; AKwUvBwZ3zo+glVr2fYqykDOYzR6dSdbaJG2faMDaFlk3RwDZWXgiW1ZwBl913+YYOUqqjPn1w7cdYRbintWVEpixA==@vger.kernel.org
X-Gm-Message-State: AFq9FYK1TNurXZoy8T5xpCiSQJTjS1t4hpCKs/BnIRPcKsH1eAVtWGLd
	38a8xFZbX8tgpROsGLeomkl+TVl+eAzTMAneCwMhzWYpGwGyriREs8eHYpcSjD21SLMZ/UKlsRv
	G9aS4dH7A96fV7y6B9YG51dq3LUzk8ekJjaBL5sd4KFPIomyAAlHeC7GA74rzE/Rwi8fv5ifK+w
	CdNw==
X-Gm-Gg: AYBFou3OoCkeadbKSIaII41vq1uS/krE7LD8FZSnFNInUa92rip5jVWFB3KVeYfVFMe
	mkoB3hjYyTP5A8is5cDO5vJCCvfNJKua5CrWrFIUrexJkj040eofw1W+ft9om2HoAhx1a3sATeW
	WIZfwlgBRGfhldqDriQa9KK9+4KNSWZBVUzSp9akePJ3fBx6m6aaUwxcPOyzOpGX53ECznhYlDj
	IpGkRQTbgilJ9YmUS7uM8h5P7EpBt+gcsmWVorYiXEPS7d9vioHY/ISTPUls7dBTuSLT2zOFpz9
	X5WPNrveX/MygG5+uo8YE4Lo4TWJgIVEFZoigG2yDa1TdfS9BWWTQruBwqYaf/cfWoiIGw73T3S
	ME4g8N/w6xSU=
X-Received: by 2002:a05:620a:4505:b0:93b:e5e9:23d9 with SMTP id af79cd13be357-93f6f78710emr325900285a.23.1792747649994;
        Fri, 23 Oct 2026 02:27:29 -0700 (PDT)
X-Received: by 2002:a05:620a:4505:b0:93b:e5e9:23d9 with SMTP id af79cd13be357-93f6f78710emr325897885a.23.1792747649444;
        Fri, 23 Oct 2026 02:27:29 -0700 (PDT)
Received: from localhost ([93.144.6.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a211bda21dsm54466305e9.11.2026.10.23.02.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 02:27:28 -0700 (PDT)
Date: Fri, 23 Oct 2026 11:27:27 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Subject: Re: [PATCH ath-current] wifi: ath12k: fix DMA direction for
 re-injected Rx buffers
Message-ID: <atsof77Ru3vW4l0s@lore-desk>
References: <20261017-ath12k-fix-dma-mapping-for-reinject-packets-v1-1-b94860e18ba4@oss.qualcomm.com>
 <41eff135-80fe-4820-b9c4-48705159a013@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HZrZ1ts+FdlZCftW"
Content-Disposition: inline
In-Reply-To: <41eff135-80fe-4820-b9c4-48705159a013@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzNyBTYWx0ZWRfX2vk35Hm77uti
 O/cgbaEU6Yw515crx188XHtNPG/RBgg9faNpdfD4xAaUTic/o6dfus6GcKsCgr2xUGOW6sKR+pN
 h63NAlShZtjoIN6mZe+tFitGSg4A0+k+0UJknCZxJ0UPRC7GLiolR0IgVKF1Ib6smv8EhnQkBjs
 NbTXy+rLI2qRXXwDmPHIRvB0YlkuWzULI2HUJMMeygBmdkuYZa0d5Pg0YEbGSiTRw+Pi1bjYIxD
 kElK4x+8YfSNFN2IIQc6k8sQqh2/GO+FY6EYreK8Lx4dx0apxoO+h8KB3c7/Ywm7NoDHdnpzrOM
 qB0LFRWPAhJM6cOXqedqkxJI30zLrtpeaE0zukJAgNPTRRH87u11GVD1BdReQplXq3bn+lH+6KN
 RGNoCLRwbEvCHmBC3oPGQQyQ9WpU9uDHcHyQxCq9FFn3ogXHQyPMibmLI7w/ZXOq1ZKR4Eb03w1
 iD5WtzyUe0Bg7i8vI6w==
X-Proofpoint-GUID: jsEfSR9q6HQcbKT8pd4GHKwIc5sq_jUs
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzNyBTYWx0ZWRfX4WlYjaNr+qyM
 Xi3OCN4jlv5HNzOPyRpqD+H+NhLVmCWoTJQs/WP3ZV5COAoha0aQ9J/tgWv4u5wu0DzvSxAsrHh
 B3g5wIXohMLyWprIrEPf/m7BgnlWXmU=
X-Authority-Analysis: v=2.4 cv=UdbE26SN c=1 sm=1 tr=0 ts=6adb2883 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=MzmxzcrYCnjYavR0kDUA:9
 a=CjuIK1q_8ugA:10 a=EDCNbuhR6sifr4SWXDUA:9 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: jsEfSR9q6HQcbKT8pd4GHKwIc5sq_jUs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230037

--HZrZ1ts+FdlZCftW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 10/17/2026 5:16 PM, Lorenzo Bianconi wrote:
>=20
> > --- a/drivers/net/wireless/ath/ath12k/core.h
> > +++ b/drivers/net/wireless/ath/ath12k/core.h
> > @@ -149,6 +149,7 @@ struct ath12k_skb_rxcb {
> >  	u8 tid;
> >  	u16 peer_id;
> >  	bool is_end_of_ppdu;
> > +	bool reinjected;
>=20
> rxcb->is_frag already identifies a reinjected frame, can we use it instea=
d?

Hi Baochen,

I agree, we can use is_frag and drop reinjected field. I will fix it in v2.

>=20
>=20
> > diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c
> b/drivers/net/wireless/ath/ath12k/dp_rx.c
> > index 8fa0e90b4531..0003cc5a3720 100644
> > --- a/drivers/net/wireless/ath/ath12k/dp_rx.c
> > +++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
> > @@ -138,6 +138,7 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *d=
p,
> >  		if (!rx_desc)
> >  			goto fail_dma_unmap;
> >
> > +		ATH12K_SKB_RXCB(skb)->reinjected =3D false;
>=20
> These skbs come straight from dev_alloc_skb(), which clears CB area insid=
e, so this is not
> required. But for readability purpose I have no objection to keep it.

ack, I will drop it in v2.

Regards,
Lorenzo

--HZrZ1ts+FdlZCftW
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCatsofwAKCRA6cBh0uS2t
rPThAP9iSya+erfxLC2cUfy5puh3lne7T29gwCslj5ZZ6DbaRQEAzUPMdOy6EFaF
9+0cOYXh9y8wc1ywO4X5CrChESUTXAU=
=Buzo
-----END PGP SIGNATURE-----

--HZrZ1ts+FdlZCftW--
