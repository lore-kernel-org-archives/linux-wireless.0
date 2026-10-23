Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759258;
	b=3fedigvk5cL14YY/w3JbB4TVNyFcskyY5IbbmTvvy3pbTlEn885kA0Djq3WRV/4Rk5mn
	 D4EHI6ZLoAqHcQfaC0hdqnqIBYghc3XCR7eI8wjtCF/xmXN4BqABIzdGJiCWsGKL/1eux
	 FWFTuA0dO9TNp4zF/t/i8Kiyjlm+XsHf7f84tiptJpCq6wbOkwEysMuEQoOsie+5Ro8Bq
	 IEaeY5wxuFtdEgdFB8nMqDyWpKU/t2wmDi2MSTpn35MEcCg9GjoQxi+WEubMrjdLnmrgo
	 Qrd2dWwaGRQDaeswa+pSm2a7NJUXcavDbBEB6dImQ9IlnUNxVcdZQThSifIHq422aSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759258;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=cqkqY1y9HuDExVdKYbZx0vPUsrpuqxqANSFJ6jeRl+8=;
	b=kn7LKYIMQevi5lNVGTvS/sxWODDFYRx4HQo+FiKleduYoOMf/aQ1nOvHHcmrrGBVGX4y
	 MQQaZkZ9qVNzLUuVdlAOrqf00F+e3bNf1JjVFIqud1C4y9nJ7IcRj+5SfnY2iv7mloH00
	 KniB8lbTryCINJDbKudiAICFGsC0teqZWybnVOe+rPtC8PPdr0BthrgnvtF/bzjZry+xz
	 L9+ITVl5D3GRUSgg6rPPyj9TiJLZDYzpam3EZpogja0Jd24Pu2vcAsKlUrS64zfT5Hfpi
	 T/nzn3WKOXu51VfrkdwvW4k1keWmbU6DkAVJ/UcrKKstzQnWfd1NiDU0Nf4xIp0/5sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=E9Afo9DA;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NfQVwbXV;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C039606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 12:40:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C039606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=E9Afo9DA;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NfQVwbXV
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAAbDV2509175
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 12:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=cqkqY1y9HuDExVdKYbZx0vPU
	srpuqxqANSFJ6jeRl+8=; b=E9Afo9DA5pCfEYGeinsqRTMYWR97o8d6zvGJHg29
	Mz75jOipb1r+rCdgbUtm7+4ceUUQtgcTEBuZfxYRtOvruMMzOzOMaJCg3zWCiGa2
	voBlyfRJeCYxh2fdGQQO1//MH/N310VIDgGsDsJTovOhpOFABmAQB/nJoCCkB8RD
	uhIuqZXpkKjmDEknNnAgaSu8R2GFM516jRQfgv/LpkjiYoNMb8yi3flKGNsomvbn
	NvprdTccKxarUEa9a23HvFRI7BSN+9x2GRV2oA7dRkbOpL+pMbaxuC5MZsY7xGyd
	YWXJnRl3hhR6xyPAaP9i5EseSw8MQuqXJqhHBlUndjS57w==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsykb3vs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 12:40:56 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f2005ce21so146808285a.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 05:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792759256; x=1793364056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cqkqY1y9HuDExVdKYbZx0vPUsrpuqxqANSFJ6jeRl+8=;
        b=NfQVwbXVtBEFRowBf9uaTTFAVIZp/Cng4+w+zD6a+uTf1QHbejfvyfNoyx4Cbm5tA8
         Qp8Qg/pVP9UnkkIAEWNxPr6gJxGvxhtr/DFGFXpw7cFX0vzCi5G/ajaDysIVbHV0Umb7
         eAQBmdv2GMlRHdk7bWFPHmcgalUml1UaAKgSmcM7v2o6smWBfj4qqOn1LN1rx/jyIXij
         bE02WLr7E3iJUBbPC+ECKEutLQ5E5eRcLwaZyGS7VDRLGpfju2vnqqjrc7ddGoFROuJI
         coKt6kd9X1xOCHVmipV+rL64VFPMGh3I9U9uZEZqk70EfK6NI+MTBJyfcSx3gF6e3fuK
         Gu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792759256; x=1793364056;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cqkqY1y9HuDExVdKYbZx0vPUsrpuqxqANSFJ6jeRl+8=;
        b=hYoaIo3ICKrA+MxbDYK6n4dwwg42Detnbitb9k2QDDxpyPm2XOwHmE3jFCUfZoZSJw
         dWMFk+0ChsPtC0PpsdZji26nYT+2gHXsu2n+Ec6pfWipEyCULtXeUze7GpTLz0xhCOvQ
         EmfKy6y9UQ9Y93PtMtMzDZfuBvjvfI+jpTQ2g6gl1nIuGTs0lhwvYKFLREDsTXrJ4Unw
         NWR2cuoH5JS5veUNUbskPC/msNWM28omg20FonHfPsxgpyUO9fPUyvtI3q7LQ5Svp3cL
         erJbXm8bCMH47ovmHOcEbXuRyYHcEeMy8fkNiC6F5CGxEI1Tt0kmyHhA0Yq0fIZZ8wzK
         La/A==
X-Forwarded-Encrypted: i=1; AKwUvBz7fKoyMJcXn5wnr73YgI+K02xseIioQYAbNHHV/6i8vqbzGdWX5zR2C3uZXsDwO9/HIqSQzOFj+scQiUInFA==@vger.kernel.org
X-Gm-Message-State: AFq9FYK50AU5VzLjB4ZFyXEV8IhosEAT3Q4CAfijhzuQOqBz7LTnltx8
	LoCwOngO6UFf7N+K16/kcewhZ8ZLNzzmi4/eelvE5rUbx4Mi++/jOJPVtt/OCcmdOxlNOQoluWo
	vFUkqBigTTshR3nYiju0agenhOkdgDMjubP1zJBw+V0wvYb+HYjYvNQLjZQ7h8MyWQt6oTg==
X-Gm-Gg: AYBFou2PeTDwKi5+HVGnTufnXEDOVU8lJKDuBA5HqzmOQwxevQJ3KdUBUZBFL0Jt4xN
	X40P1kJ9noiI54NZd3hCxfqWzhsm8YqfY0dxMqRkrlm+Ow1+ESeqlBm3ng0c17/ujbJHoPwDNxH
	TfMza/3GCsFvf1sIvdjkvqKUE0/ZFrfi2/zm6eeawXU2gfW22T7P1iXd4WiV1fumuUjgmZBRrOW
	TvG0jf33AO2vFnK8+grWJhK+tnCkhvzFTzM5KzJYhbIoPAZnEXKYYNbmCHMup69IoG6TgMogLcs
	qS0qnRorBgkpfunkmPZBIRsxrVWAWBapaYNpdJfinULtoa6Op0oCk2G54g93mxKcgNF42TndIfW
	tNiKQYcRFtg947cM6eqAscAdSDyzYdXqH0YOpVRbJuVnIK4kb
X-Received: by 2002:a05:620a:4490:b0:93e:4dd3:bbb1 with SMTP id af79cd13be357-93f6f91a39dmr367480085a.19.1792759255605;
        Fri, 23 Oct 2026 05:40:55 -0700 (PDT)
X-Received: by 2002:a05:620a:4490:b0:93e:4dd3:bbb1 with SMTP id af79cd13be357-93f6f91a39dmr367475685a.19.1792759255034;
        Fri, 23 Oct 2026 05:40:55 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3804cbd1sm4881269f8f.39.2026.10.23.05.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 05:40:53 -0700 (PDT)
Date: Fri, 23 Oct 2026 14:40:53 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Subject: Re: [PATCH ath-current v2] wifi: ath12k: fix DMA direction for
 re-injected Rx buffers
Message-ID: <attV1TkT-pGiU-ZT@lore-desk>
References: <20261023-ath12k-fix-dma-mapping-for-reinject-packets-v2-1-9f436a26dd72@oss.qualcomm.com>
 <2467a07c-e215-4cfa-82ac-22214a144dae@oss.qualcomm.com>
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
	protocol="application/pgp-signature"; boundary="zIoI+Sq/aIvOtaD/"
Content-Disposition: inline
In-Reply-To: <2467a07c-e215-4cfa-82ac-22214a144dae@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA0OSBTYWx0ZWRfX78Fbu/PIJkGS
 9WmY0OTihxswUZzvntLpOAQah4gsMWbwWjP/n7+rw20zBft6vp0HURvVYfInlSfmekiR9eW0ImU
 PT7Ep9N5dzTtBuO+bgbroSPj64bK28YqzrX6IvqGDRFuutP2pAPbAptVjyDJ6nyWnkianeNVj1l
 O2xW2pXShJBC6LinzUIWVy9NMe1Wh20/+3IWXEDZtTWgEs3DqAKOvT4lJWf3lqkIuCkIVhdRjZg
 6+phvKnlXKHt82TVq8u8J9owCjT2ZkeSoBdWhThpMI00piCP4JD97rS9lrPnKj79eteF6EOsEBL
 O/docDP0GAlGD3alyxUl/r8On8ob3r81pkY1X45r2HKLWlF1xbR6h15t1yejDTeXZzp8ErhFKXH
 CkKjo2gCSsixoyKCheWcujceJhz/IQmh2u7JTb1pNIg6es8vO8hhz+U3arnAOUSyu1by9LIJf4F
 GqfzdycuRVv3FO5gSbQ==
X-Proofpoint-ORIG-GUID: 5R15SpcaGmK5UYs8XnanbK0hCkFi6nwT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA0OSBTYWx0ZWRfX4aF5tA6Yxb0w
 2E5HkEsh5S2Ek3fPLLXxBzP9pcOah7g0cBTHTEfRAM41Js69i6e+/mVkEM/KThgLmKEFmhD/3Mw
 YJEJMr47lbtSv2L8+XeWy2TmtR70BDI=
X-Proofpoint-GUID: 5R15SpcaGmK5UYs8XnanbK0hCkFi6nwT
X-Authority-Analysis: v=2.4 cv=GLKdgeNK c=1 sm=1 tr=0 ts=6adb55d8 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=UEhgMTqEtwQYctlcQgUA:9
 a=CjuIK1q_8ugA:10 a=Y_mCc7UgKoaLYVoAt08A:9 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230049

--zIoI+Sq/aIvOtaD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 10/23/2026 5:25 PM, Lorenzo Bianconi wrote:
>=20
> > @@ -983,8 +980,8 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject=
(struct ath12k_dp *dp,
> >  	list_add_tail(&desc_info->list, &dp->rx_desc_free_list);
> >  	spin_unlock_bh(&dp->rx_desc_lock);
> >  err_unmap_dma:
> > -	dma_unmap_single(dp->dev, buf_paddr, defrag_skb->len + skb_tailroom(d=
efrag_skb),
> > -			 DMA_TO_DEVICE);
> > +	ath12k_dp_unmap_rx_buf(dp, defrag_skb);
>=20
> buf_paddr has not been updated to skb_cb->paddr when we reach here. v1 has
>=20
> rxcb->paddr =3D buf_paddr;
>=20
> before jumping, so v1 is good.

Right, my bad. I will fix it in v3.

Regards,
Lorenzo

--zIoI+Sq/aIvOtaD/
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCattV1QAKCRA6cBh0uS2t
rASRAP9/h1Ne68h3DFwA4hlbveqXV+DMJH1NDbXYR/ZZui957wEAsfqzec/SjqfN
XzXA9xbhpgRJyXKU7e2ZfLdvki+DPA4=
=9Eui
-----END PGP SIGNATURE-----

--zIoI+Sq/aIvOtaD/--
