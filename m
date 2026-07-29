Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEA73EC83E
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785341061; cv=pass; b=sNHNjjupxfdun02bWmZPD11c2BRp1HCcfi6s5iFB0t72n+dKK8y4sA4295KT5rSB5tXz4+SlVC71+DcDScZI9+wFjU13n4xvA039rdaRgSHZRyAilVECWUZNx+wRCdxoaNP+QXWHub85JWKyYgePkyToq6HYfztES/Tliwz+9Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785341061; c=relaxed/simple;
	bh=+YirpcoPBY4rpOhTrO4fkmB31Gsil9/d9ea67eHUJDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SMXLnK3+1mJzHD6xZubOb69c4jUYacjdi8rAPvMNtocIK7j/jhe+W4tl5irJv0VtmTJJMxSRzEc4Lq0X/S4WWXjwFx3brV5PPrglRbr6w3I8G2UnFcwuw1JyGPwYik7noNRjuMlX26EJEJV0Iwc6i3JpBEasB6D4oTUB35jGaDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZBtQiihh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U2fHjZBE; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZBtQiihh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U2fHjZBE"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF2Uip3341274
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 16:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+YirpcoPBY4rpOhTrO4fkmB31Gsil9/d9ea67eHUJDk=; b=ZBtQiihhJvqK/79a
	pmymVMmL9BEOo5WjQ8K/EWHzIu+8qVyJHDsdSbLnyx5XD+lczdGDAkmziUVg3oCt
	H/1YCqR333iYJLF/esBLOrq75SUgCdcmA+JT3vA3z+z7ScOKMdLz0z71mLRAvCuP
	iDLtMbTZjiDgElowa8aljWHmrA5aPuBVNbBs/lhNiU8/DgYLTxVyIqkF92nx266h
	JwQHsBwhC8KC/R+Ky8i1F8BksTN6v1hgPR27Gn7CVhehXwHcIoKYnmhO9grKSvpr
	0P83+HpDDB/e7wpakjFmfJfeJ6CqPptRhD9LRZiyd8x9E7b8mnxsoY2bLsmaJF+H
	6IrLSw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqh3ms8ff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 16:04:19 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d01666c1b3so1932815ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:04:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785341058; cv=none;
        d=google.com; s=arc-20260327;
        b=KM0sodz6raA4d+cC+Xih5zbYjEx5hqg/FjS4/1wjKJaVhJw0sdf/r1w7ZCjBkUZ3hn
         PqUpkHevkt94kWLbZptNJjpwrqJjavlCrsVwH+aaQnVIrpGwiytvOGL3xC+eF6FFMR//
         RIUJ7jq6IMYH0gn+fpjOU8NKVYzB3WF4Mkowes+DGJEFJf26IH6lE3+DNNxwMH+g8f/F
         t7cg/89VrGvwBpzdNjVXDK12uR9H+ZT2TFD+CpkTm85PYRa4FMwajWOlA/l4Yr3ZAucT
         x6tay5hZ033LlSwlB/ulLAUoLqvpJ0D4p/LpIVqKj+j9Ou8vWKo3Y/OTEe2PautnPtIF
         +z4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+YirpcoPBY4rpOhTrO4fkmB31Gsil9/d9ea67eHUJDk=;
        fh=WPtGYDL1MVfmV+4cAegurOjzD6KKe8ey9CNiTG3q0Ww=;
        b=XX+ZWdstEMyipTUSBv16CQq9bZxF1bHzOMUEL1opLF29mOfmxQiknZ24MyTiE8Chhj
         3g4NLUYwS+NMbq0FpEJUKyTOF45iQjzsDdICzTJps7Gpgs4HAQuaco+ZinLLq6SpNWcm
         1wbzbsLVOa3ou0yMysmwp/ZeKpmSBhGjixIYablGMZeDfudq5Web5WgF/u7Y4/e4AIBV
         fcFxcSRsRQaAvGdIzbNnk7TevPOzql9QlT1jSTL8Dt8cPmviGTTH+ZnvIXD8iz5dzUBV
         KgukZsaYtjfsgOVBHfBpiULJB4pP3Enif5TbOULaAak9DPC9YPk/0FWfrdG7n2FnAoqw
         Cd7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785341058; x=1785945858; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+YirpcoPBY4rpOhTrO4fkmB31Gsil9/d9ea67eHUJDk=;
        b=U2fHjZBEuB7Dlnf+pVcyXivitso9GJudSGmMhb0zIV6y4GhB1TCjtlB6Yb8HNoe6PN
         WsDO3cFQd4YSzGuLOOf8aEEe/+zJ+eCDeQ/GgqHVmY5P3H1b6qHsAzU8/48JxgKPrvFc
         scSFOrD/Ss7WcwhI9WSL8v54nxKrbHmK70c5/sxpSqIy0euI0KKUui47YXiHiZSIQsX0
         N0EKayb9p6l9HJU/1PQCNgzmUpR7Uji190V2FO+EWzqAo09Udh7AQNkKdjmGgqLpFi4f
         I20SP5mO8SygQx5Joq2OvLgyR4KDZtWA7E455UtEydgGOBz2FOIOfb6QK9ix6WQfqHSn
         u0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785341058; x=1785945858;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+YirpcoPBY4rpOhTrO4fkmB31Gsil9/d9ea67eHUJDk=;
        b=mTfE3OOLpvHHHIR4ouFifWUci1jHNv6kGdeSEeby5sB6mIMia+WjD/3I7RHdK0m37q
         1dPXk3plsMsuRxVlGZOduobYWVeA82tik1c0mb6QKMb0Aw/H+m4p7KD+juo1fX25gdhO
         lcJOXFkrDkd84YVwBwIs8e/0sVOXh1uyxB7+qi3FOCU0y1Gy8oqlaJNXhkwte/XVcfza
         ZXEdGIw9I2yHis1/l+QLJt2QcAg1+/xPIDbfuq0YfJwtsQWExaiD6rwW1AC8eFth9E5F
         O2Z3fCQfTOj0yISsVXe3IwypxqOv2NyIfSJSK/MWbP5zUpJOYV4/nXSKgs7lq2/UaQkR
         OWyw==
X-Forwarded-Encrypted: i=1; AHgh+Ros3HliJ//Br2WzffYflze0rTvlvD2bn1FEHvFoL/R/j1SheKHqAgafG65q9DuRH6rBY8wka1A81PQprqyVaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh+sSGXRZUu8DA+7V5B2wqSD5392StQJQhSPwVg2nn0+SLdsXJ
	KgvqVoiouwADrWD6KuaMxjqa+6hgJepQV/V3020Vr4lcUYanfM+6fGiFURK5ncm6U7ye7PcIGhi
	/Gq6SVzjHcvOiaNJsk/K8Q6kWmWLlEn2AWM5y6OpF1dJ+dOQC7LMqYg/F0y3peV+OQ9Fs9zo5up
	7/C8nnKmiizp10uYyX2Rav+I1Q/Ti8iBvnOpj0iOxMipMuTBdSjLx6
X-Gm-Gg: AR+sD13PGj8C2riKuKUrO+6pbl5H2/l3El9ySBNpbA9+C6F/azliQKvMpdjcm0OJKZT
	39OL3PgRqNvwq0iDUle40+8WPAplcGVMt/2lDi+O2rLXcZRAecIxNIVCG5H7cMhVIBhZADDXvSt
	SwcEMy8RuTGRLw7cuVoYCuGdVnxWgVw9f14PqusaboAq1ir+1yCMdWOTgMxHRTOu5MQ8u+/Xm+G
	xDSfBjNPvTq4VukZg==
X-Received: by 2002:a17:902:f608:b0:2cf:ca85:57e2 with SMTP id d9443c01a7336-2d01e9b3e33mr79701895ad.1.1785341058395;
        Wed, 29 Jul 2026 09:04:18 -0700 (PDT)
X-Received: by 2002:a17:902:f608:b0:2cf:ca85:57e2 with SMTP id
 d9443c01a7336-2d01e9b3e33mr79701215ad.1.1785341057790; Wed, 29 Jul 2026
 09:04:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABkEBKaZOEh4OrZTYfFOj8QZHY8Ruxn2rcXL-axWHwK4o6MECA@mail.gmail.com>
 <20260724094226.227200-1-jtornosm@redhat.com>
In-Reply-To: <20260724094226.227200-1-jtornosm@redhat.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 21:34:04 +0530
X-Gm-Features: AUfX_mzOcu8W2M6mZ5O9sk34pCttGj9TQPlUjWdGWOfgGovyIkDqWdRVlqu4fPo
Message-ID: <CABkEBKZ7+Z=DL5scE7LnFQz==c3JKoUfFgfDYRf5HoLS_=fr=g@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] wifi: ath11k: use queue mapping for WCN6750 ring selection
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNyBTYWx0ZWRfX/pGqB7ZG7ncU
 oHw4arHXQO586LD1fDQgExvvjavIP8+9X2aCXF+z+Lb6ABYl8y55gJiT6PPYczSmWH3lIrloKte
 A2Qh6CPFwvkqrndw9CoRHpu/XUORFiRAPR+tojZtzKxCQH3W0HIOlphrGvtIi4nAK/8YODFQVfB
 7uLZ/HBpW1ve7dfq4AJiPzEiNmi0pKEzxM2O8amIcjI8Fnio5TwShPvcvekkM8T1p2bkXwd8Qlt
 S3ddOaJpnBOFwM3C7eV1H2w9fGgc/e40Sve0TLMLQ0fWzLz/uCqMC/IrD+6B1sd3r5w5pyW6gz9
 De9qOwYuxrF6i3ft2zLkvTXKW48jcUIAkM9j9OMztAwgroSeqw4U8YIs6LUUaicHYXEQ3Mhgh0m
 ShOqFvmaUfwBH4BnwquuOlc+wUUiQjFAY3/R7Ap4VV08XAyZYekTlNh/EY4o19Oj3h64tT2h3cU
 89iknlPCw5TkneKP3LA==
X-Authority-Analysis: v=2.4 cv=F49nsKhN c=1 sm=1 tr=0 ts=6a6a2483 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=20KFwNOVAAAA:8 a=fWcgDiPmc55ChaNYinEA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: FbXWohXZwnbnBHU0VH5bAN8wfS-3wIPo
X-Proofpoint-ORIG-GUID: FbXWohXZwnbnBHU0VH5bAN8wfS-3wIPo
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNyBTYWx0ZWRfX+q/h55s54a5x
 4o+FCoBcUnb7VYzn7d2feaQmaYHvDMJ3YnS8HtRI++fxxo2JBl7qdT1JrOkeQy8wm9VRFgqVD5p
 uDd9GXGtYJMtuuNbU1xgv5PgwZsu9Cc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290127

On Fri, Jul 24, 2026 at 3:12=E2=80=AFPM Jose Ignacio Tornos Martinez
<jtornosm@redhat.com> wrote:
>
> Hello Tamizh,
>
> This is the same mapping already used by WCN7850 via skb_get_queue_mappin=
g().
> The patch only aligns WCN6750 with that existing approach.
>
Sure thanks for the information. Do we have throughput values with this cha=
nge?




--=20
- Tamizh.
