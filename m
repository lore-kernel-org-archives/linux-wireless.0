Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695504F30CB
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 16:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563762; cv=none; b=CyARmg3ogdRmJr/BZ5I3+RmmZvOw4CG1tc+dXyra43uE0dVYTYIeZhs2OcGRVqwThl77apdfPbUlyayxsUksgBc1JXp/Z267sMfseAU78zfDYutkgmoc+E/6Zs5q7zzNamIeezNUEerX7qI8+kR5kB2xFbq3purQnWbBzEwkDAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563762; c=relaxed/simple;
	bh=DObaq6Nb/58jUtIY5nWlM2D34IXl0uCF6VmogrMWqoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eo0lloLsTGgJ2rv0e6PuvYDHXpvagk48ImmVDgklfWQSC2WuG9L5xWKW7eTctOAkIryRp3g1t/xB/JhfphFvJZqO3IbtTlnYZjgKlCLNo7Z/bvLCtQQtCIE6DeNoUHhh6JER41mL6uT6BMagPi+1Gwn7aPaR1vsN68GjFcepkl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=agO31pXR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=E6lOjE33; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="agO31pXR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="E6lOjE33"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699GHAsJ2700101
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 16:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=DObaq6Nb/58jUtIY5nWlM2D3
	4IXl0uCF6VmogrMWqoM=; b=agO31pXRIqFKIObPsE7A9dd/HaNlDYbKRj8RZhqr
	PalWJ9+eJO53bLKhwm8gcU02xPqxk/VHrb2OTAgEFvglkPiGXUWucWY6yVENceTz
	xLlytE2n2iqAgrXBOiI4iLDCCSckkv1FwirAkUTGNNI4TGjFAvQDCnAMBLDBHgFv
	0lu01GoCxIpxOzUOI1kX+zjzslylIxZ2yxtzIuiDlZHl9gjqcp1Mh0hBX57xpNF+
	q9zvk3jKTUtBlK2LZIZ2MDqocRiAsOKU8WkV+e3SKGHHFHWCQfraMTlVzd70vtW9
	XDAyS9YXeds9e0uMw4+bs5spOWEz8XQZ+GMvnTLRigPESA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h71f2gqbp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 16:35:55 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93e92aad34aso915857285a.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 09:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791563755; x=1792168555; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DObaq6Nb/58jUtIY5nWlM2D34IXl0uCF6VmogrMWqoM=;
        b=E6lOjE33G86WyEHauALEaFNzKObRGwGw7qes+eABzOKzsAkrrAxnNhO/0gYt63UluC
         ifA+uUZIE/wAGrn2kUeHvOXgjPKPHVea7uMTn4GRuu00A8IM3N2EwPY1iNTs9vI9/tSE
         /WvstrPRqWCo+vSlz/GAiO10SgLgHZjt08WqhovikXKGvZBxiSNwOmG1zDwKH+xHQ1qO
         pyu8bF/NecCMayi+MaWcSpYZqX5MhnB6w/nUh3b6i0pMgrKBhSQtNfN9TjmCyktQ5nAc
         C7TybmQPEXoW14rrgKClnaN6GzZN9AnLx2hcQlnExzlA/to1+VBJw41UnfxhW2tImF1Y
         M2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791563755; x=1792168555;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DObaq6Nb/58jUtIY5nWlM2D34IXl0uCF6VmogrMWqoM=;
        b=mlqCFzYEt+u2ubb3L7ab9d4ubPy9Ghmw5hl1LymQt8sUQM6O6KuXx82rfAVfuRWJe4
         GemH1TQqJUNOF44nuVImofD4upSpUIkj7IgoNZmevBDGUFm3SuvUZn4qnk7xy7nwhThY
         15DeXuPTgYOTos45sZqFYkq4p0Y+9mDj3ZCEE5jeBeWol2RU97tt98IOdA1imF5Vw/qe
         NoEy/e9Y6jXiyX0ULE1bbEPllq5Dxy2XTP4y1pzXVPYYPoMvHLWuYFj9zDVZoDdVj4SK
         3jmGPALbHAolfyNGaz7s+uHhAH+UFt54TS2Wt0z3lW+PKbraRPOrICH7e3MoPo4Ulta0
         VMQg==
X-Forwarded-Encrypted: i=1; AKwUvBw2Kb5xJ75Nr6LKZk2HbmN0KwDfoOvqzbfS4ZHHnlcu1Mrs2CjVOVcBuiyAuIrJhvpd0k1g49ue6ne+6m7nHg==@vger.kernel.org
X-Gm-Message-State: AFuF++n1bEh8WXF1VQmBQWQJyvwiekV8hyU09knh2ch9D6YyjbJCRr5a
	HnNOlIi3Ksg/SdKqEaRP3olo37yk/D/KW2fAHo2rLClebYOfMnKamo0KMD8zwK+xp3WgdAUtLG2
	jtlSONkop/oqkBGICZsqfW0VZTwMIriysW9omVszQSg+yAIhNTK5EuI0gGPdodhUQANl1dQ==
X-Gm-Gg: AYBFou0kdAuquOyei+9WKxdDRu18djZCX4fRqcv9Uhed/dSFZGNwPzKfwVUdrK44of3
	0QpiWKpgfOqaDipfR5v2Lo0Td0YxRv4Mq8Au9mdR278Ngj8ty0eA8CZD4en8cH26zt1v6dadMIV
	uPozEjmjcdfnM8JwJ98Cs+0JPB1oqvxTI26KhNK3hLGmmWu94B7Q/4BizMsO6yHDqpAv6C7pbAe
	mB9xY87DjVIAi8BVOZYZfHs1OuAfzzRfO3exqmsv4/529LdtBPdtKZ1rd3YMPHHSEoK9pC496J3
	1OfWORoVbfVfpCQamZoi0+0yNKSulnx2ZssjIrtEf1P1CCiQpqA5BqbVVSKyIyxzBUS9hFrMlIr
	93CR54BeCvLEzxQ==
X-Received: by 2002:a05:620a:40d5:b0:93a:f9:614a with SMTP id af79cd13be357-93ebd21ffc4mr360474085a.34.1791563755151;
        Fri, 09 Oct 2026 09:35:55 -0700 (PDT)
X-Received: by 2002:a05:620a:40d5:b0:93a:f9:614a with SMTP id af79cd13be357-93ebd21ffc4mr360466885a.34.1791563754373;
        Fri, 09 Oct 2026 09:35:54 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18beabbd0sm79141685e9.12.2026.10.09.09.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:35:53 -0700 (PDT)
Date: Fri, 9 Oct 2026 18:35:52 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>, Kalle Valo <kvalo@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Subject: Re: [PATCH 3/3] wifi: ath12k: rely on page_pool APIs for buffer
 allocation
Message-ID: <askX6OVi1grqRgL7@lore-desk>
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
 <20261008-ath12k-pp-v1-3-68f888cd7eec@oss.qualcomm.com>
 <934b1a06-48ee-47d7-b985-c3e7221d7880@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="l3vmZ+iRSMM9VSjr"
Content-Disposition: inline
In-Reply-To: <934b1a06-48ee-47d7-b985-c3e7221d7880@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: 10CWPCBN73JFu5E_Ad7hWwaO1PiGWEuw
X-Authority-Analysis: v=2.4 cv=GpbXaU1C c=1 sm=1 tr=0 ts=6ac917eb cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=NEAV23lmAAAA:8
 a=VF8GH8uOMsmr12UB0xUA:9 a=CjuIK1q_8ugA:10 a=v5oEB8NXsXvYOpEHCQgA:9
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA2NiBTYWx0ZWRfX0usp3MMqw1Db
 qQD9i2k/M0az0r1kbywo+arnb6KClpdPMnpB8f/hs6y+3mRcqWalTepmAifoGrX1AsG17l1qIRR
 uNey7Zgk/U7018IgG5fj12VScWoNPyc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA2NiBTYWx0ZWRfX1GRHADWA2og5
 fEXmO0cO/Xwm1KWIhKlWUnB6UUAK/Cq/gXEwhaIgJeOGIT85Qhx8yLdt396XA7GHe3zxU5T4WAK
 BLja3HI/Bw2ZT08g8jupJIZvcAxkg96N70u7HCk2gERZfg7fQzvmIyUJKWwIu6cEl83P49zpJOs
 gZECJmlRVB7V1Q+uQG+AZgVWDLQak+1mIFPgSv7tvJUyqHozQdgcKDKnDm/6RmqRw3J0++2V/xU
 T5V7MEaIvDOADbM5JCg6jNBEamyOtUAcBMvnO6VVhZbtp/AqHpyQ7yb30Nf9eDa1n5WcsOadnW0
 miLACKJv8eek3/nWUliG+Ql53CjdPtAeJClyhZQfYpaZIQCEXwbR1TJUzlzK93LvdyGJeayNTSb
 CdxrymgWgQ8VCheOPUWUnTOJMLYXnz/XLXiMmbXcUg/FCNve47dXkvyDZppva/ef3QyhslXEoJw
 t2KnYZnnwNRB4e+3t2g==
X-Proofpoint-GUID: 10CWPCBN73JFu5E_Ad7hWwaO1PiGWEuw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_04,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610090066

--l3vmZ+iRSMM9VSjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 10/8/2026 9:16 PM, Lorenzo Bianconi wrote:
> > Convert the Rx refill buffers to the page_pool API instead of allocating
> > an skb with dev_alloc_skb() and mapping it with dma_map_single(). The p=
ool
> > handles the DMA mapping and buffer recycling.
> >=20
> > Add a page_pool to struct dp_rxdma_ring, created in
> > ath12k_dp_rxdma_ring_buf_setup() and destroyed in
> > ath12k_dp_rxdma_ring_buf_cleanup().
> >=20
> > Update ath12k_dp_unmap_rx_buf() to sync page_pool buffers for the CPU
> > instead of unmapping them, and guard the teardown paths
> > (ath12k_dp_cc_cleanup(), ath12k_dp_h_msdu_buffer_type()) against
> > page_pool buffers. In the re-inject path, sync an already mapped
> > page_pool buffer for the device instead of mapping it again, and fill t=
he
> > descriptor with the DMA address stored in the rxcb.
> >=20
> > The monitor, CE and TX paths are left unchanged.
> >=20
> > This is just preliminary support: the goal is to use a single page to m=
ap
> > two separated fragments of 2048B.
>=20
> why? please always justify your motivation in detail when the change is n=
ot trival.

my main goal here would be to avoid running dev_alloc_skb()/dma_{map,unmap}=
() on every
rx packets but rely on page_pool APIs in order to recycles and keep pages D=
MA
mapped. I guess this way we will have even a smaller memory footprint.

>=20
> Besides, instead of preliminary patches, why not just send the full suppo=
rt in a single
> series?
>=20

I would like to implement it incrementally (you can find the code here [0])=
 but
I am fine to squash patches in the next iteration.

Regards,
Lorenzo

[0] https://github.com/LorenzoBianconi/wireless-next/tree/b4/ath12k-pp-dev

--l3vmZ+iRSMM9VSjr
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaskX6AAKCRA6cBh0uS2t
rAjgAP9+/vCFXrWVv8wk90HKCBooT91BNHMFIuDkxFDsi1KL1QD8D7PLpUa4QlHm
5Km0lZSSNj/IuFwXW5yPH5ao+pRBAAE=
=gbSU
-----END PGP SIGNATURE-----

--l3vmZ+iRSMM9VSjr--
