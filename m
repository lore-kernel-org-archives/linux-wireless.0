Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F74B3F3290
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785854804; cv=pass; b=mUX55qOTKk2HpAK24hK9M4KjyiMOdA76y7Cvnc4DRa2WfY0+6fwOEc+y21l0XlEGFcNYE7vfZW5jTGXyyX7bDcdjfwO8y/LqD/4Aqi35jHDh0383h77kda9Y8mg8PsDV3EW6tGdptjyN0iilEhkag17lfKlYCrgsM+mlYHuQJQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785854804; c=relaxed/simple;
	bh=MFcT/tz6fCPY+vA0U3OjUJ4vitNffd+8i+dhbs6U3/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FN0zr2Yo7Orm4t9VxBQPMHhQ/HANBmZhKYkUMZ/wMnRRdKMKXIM+BgBRtq0yoYqsSQVrGYx6ccFMR6pZp7zqNqq0v3IqXvkEEeFHbmcswPl+QLWfn49W39U5o6MCh6Bk9/Dc7d9wSdJdAz68dhXxEQj+Xujvzo5dT09n8CcWzjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iTQpmFHv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aJWpCtSi; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iTQpmFHv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aJWpCtSi"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674CXAWV3572494
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2026 14:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cMe7HamvFjV9vzZd9tMvY7/ryWgZDVKZqFf9/89ydCw=; b=iTQpmFHvkM99xv8y
	CEg3UjD4AVDq0NsjuoH8Y8qSDEAcN0UIGUZMbaSjwu5YBfIzSpbccY2yLJLkFWoF
	dPF97FpwWKAwbtfmhbt5zswgInt8BeEydvinC7ynm9qfVO6v++By43WBGq9E9UNI
	cHnSOyjP2FcsGCozcNUAdG+PK0lcg3HrK9QiGfx1QfZMY5fRYu2Q7Cbd1xdKC3LH
	XY4ig6cA2xnqXWf53pxGVYs/LlvUIuBKILnaeC5LPWDNw7PlKFK5iEusazuo2LI1
	8GfRVvHL5wQG3NsYm97Rpe3DmKMhqgucEfWCcc7e3EnfMbJk2oitd5gypHUi9odL
	LNvgeA==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fu2syku41-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 14:46:42 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8f39a46efd9so8747016d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 07:46:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785854802; cv=none;
        d=google.com; s=arc-20260327;
        b=mmIlnEn5XiU1D61Il7flfWXXqSEHpjXqyLTkS5PAyp/ZGB5SLjpqzA943cvy9ZPJO8
         xajhi5VlICO+m7KCEyYygHw5vRUOTuN8g63j7t/R81pDax/lN1KlGkYGAEg0/KlfkPeB
         biW/7D/Q/W2Pej5oLaPcIQFQHfpf+DE8/ty9QJldemm0ZFS3Kf3SLFfFLuT0eH2/6aTx
         iIaAD31Sgn/UHik0Ht4P3QVu9GqIEjXSchac84NL0jBd7UDn2vl2e9fJhZYSrWedmf3v
         MBUGO/RU/d1Vh3cXVmBsiGmjFkhF/xGVqhvlRNjTygdDzgxsW5F4asOex6AZcHYyYpk1
         ShDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cMe7HamvFjV9vzZd9tMvY7/ryWgZDVKZqFf9/89ydCw=;
        fh=q82d6kwBj/jM4FET3PDaEcNwN/ecoOzrAB+rQFgTUds=;
        b=P0z+XQgIa2ESW3CLQhtWpsEp5fOV/wbnrIOnzt5ZzxQvGYkxH/agN+3XqS0H+hJI0i
         m9zQeJpJDnQfnY+OBlNj2WEcmLUyIc35X1nFzag/Ql1MF2OVwOga90NnqxfjuXYIle3Q
         DdHnbOZfbP/QKF6of3Ul3CA+k88j3/2j1W8uJeUU4S+Ndmi18W1unn2tzLg4IMth5uCw
         2Z6AxfG3F3Wl6WL5+nFFEsAP3n/prLg8QU2MOTJvYEvEhCsdiBR9GwTjuFuok/cmkFcq
         MS9R0J9+HoYup/ccElOnQeDv7e1VYE+XNdCkwzVH4ntV2mJmz+rmrSsdyvt63p3w7IVe
         I0cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785854802; x=1786459602; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cMe7HamvFjV9vzZd9tMvY7/ryWgZDVKZqFf9/89ydCw=;
        b=aJWpCtSiwvHPFZ5QI9zG4OnkiP3Dm8Z5HPSE3T0t+wsSha9geyRlwK8EJ9jSfukMkX
         LjdL/htpI1oZSXBBwF5RTfGbHfWe0KLM24ODMJGKnosNM1Xyi8PYrRU8yCzzDzAL4agd
         Hfbpl9M397XBO1q7RRMgYcBkQQMD2y349phkP9RynQZYy7mFrTb/GyGcGkUpmSGExF9U
         eZ6ThnzI8Lxd7uyrOQusIMgYt8SJekKWheiiMFwl0UrGU59YWdJFY+xQ8xYJ1LJZ2ptb
         HBNMuk7HP77zZgAMTaldLnHX6G4LE5vHk438fWSfkdtDffMFM3wcGbgKEIIVn28CRHj8
         nCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854802; x=1786459602;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cMe7HamvFjV9vzZd9tMvY7/ryWgZDVKZqFf9/89ydCw=;
        b=lOPfie3T2xhVY0FtIxN15wFcE8KvUn2mTvKqkGJseyxKTl1/3z8V3EVxn2eYKbV0Y7
         Y5L5ctKaN0VlRZEhKTTwcraAJTJnFUS/GPr1SYwdXdtHz30DVfe9Jua81c1oHIy57UVe
         ek5JEf9DFwhQ38d7jcRFSFPuBl/+2+yiaFaraDg/UAZPVhiwyNSaSWx3vVrv/bJEEJ4P
         rX/RBGj3q9E9QQufi2FHSNmHEusOo21kP9HQ/5dsMHUkEPWSWcf3CKGx630v24PoRTg6
         QzhgjbXHve4d/jCWMkfKbnTGo+mS79IDVsYbHb/xx0qHCaldAcEgswRXXUnxMw0zlkHh
         GTBQ==
X-Gm-Message-State: AOJu0YwZLqO4FlNv1K3X16NB1/PmF3UaU7NOwv2VsphEK34TyzP0HiR3
	/hasDqD7QdQVdtUJEJfoXtLM1LQqNL0PGc8fuReW7sOJ375hWOF33RVlb/hta5r/j32NYJIcLVy
	Zv2AfiVurbDlKVe1UBPKa2VDN/6djF/zk6I0aqEsAT89NU1zIo5ty8HnOF04bwLWFwUMM0wutB4
	Ra+s6c8Xw7ksXzlq6PnpKsOt4S4SgpUv8ufLflh8kj4Hs1
X-Gm-Gg: AR+sD10ab/xvp/j+Bs048jR0yISgmbNRQK7ePocedTEA96izwKS/ZxmabjhjGaHyvuN
	+SD2EOAMZ3sIp/r+kltnrYpSxCc0uuTqtUFcQc/gg8vJ8x1M7VvbSo12ibybO7ngPvmZSxuwFi7
	mNsoph3WvoCgSVzC22QT66iueQFaJkp8xfq2QCBttnG1zXgEScQM5NYHd1/A==
X-Received: by 2002:a05:620a:a206:b0:915:9da9:b541 with SMTP id af79cd13be357-9363188be1cmr662679085a.10.1785854801723;
        Tue, 04 Aug 2026 07:46:41 -0700 (PDT)
X-Received: by 2002:a05:620a:a206:b0:915:9da9:b541 with SMTP id
 af79cd13be357-9363188be1cmr662674085a.10.1785854801361; Tue, 04 Aug 2026
 07:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716095552.25995-1-jeff.chen_1@nxp.com>
In-Reply-To: <20260716095552.25995-1-jeff.chen_1@nxp.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Tue, 4 Aug 2026 16:46:30 +0200
X-Gm-Features: AUfX_mwB48jjsz39xfVQsCK3y7FZyJ7IMj8fCPhV9NUyZ7UKzrX0_plG0NGfV0s
Message-ID: <CAPx+jO9bd3PDFGN+F_1BULJhrsBXAxEn0OdGFkuLp+xM-kwqiA@mail.gmail.com>
Subject: Re: pull-request: nxpwifi-2026-07-15
To: Jeff Chen <chunfan.chen@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ulfh@kernel.org, johannes@sipsolutions.net, francesco@dolcini.it,
        wyatt.hsu@nxp.com, s.hauer@pengutronix.de, jeff.chen_1@nxp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=TIh1jVla c=1 sm=1 tr=0 ts=6a71fb52 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=NEAV23lmAAAA:8 a=pGLkceISAAAA:8
 a=uJiPk3ZOfwjsr01SAfcA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDExOSBTYWx0ZWRfXyBuAfVFOWS/W
 nMukxvKCHHWeYAwVvXM0GrG2zgU0BPQYX1aeDzvIk77xq2jhhPU4q712M/WEbiDCIBY0h2F0NST
 +jC/PWtMfbIJuUXzjkbqOHXu+B1CDag=
X-Proofpoint-ORIG-GUID: 1QLr5Kz0k6SFbBX0G5UWDzDshOQdl7iD
X-Proofpoint-GUID: 1QLr5Kz0k6SFbBX0G5UWDzDshOQdl7iD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDExOSBTYWx0ZWRfXyNVFjFNPxVp1
 RkX9Gnd10ATkqLw+3MHQvcTr8m0kn6gc9CAEM7ed+uJQOG79GvASXv3BGlgaZW7gEHAks5rqKt2
 FtO0wg1j4hJByJJon0XTbFfuNlpSEQcwuw9cZqSdKd6dWb31N8QNOOuaLc3paKIEFZ3ztC4mJHY
 2/uKtKdZHeUtoq6QlAfAiAMLvdV32/+P0BLgYokINcRXExy8rN+zW8ZPiO/A681Ifq78r+q3fll
 qLN3l7FNZwf/N7209v5cwayPE35pUFd/mk/+9BftqQ7ojgcW50F4pqAUJaUJEid88e8PkYF21t6
 uCkm8vVJtpNZ160kFDxWAbziBmEcugNsSt1qTos3eYady0+w4O4M2RJ7ys3SheIRrLAQwLUVce+
 SERFqNsQVT6t3RNYFHnyxUshTDe5IhRmDuPLVcJ3qRobs6P4g78hPrpGkffKopUvabQLwIza39n
 hIEZyf8jCtGRuxAMMpA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040119

On Thu, Jul 16, 2026 at 11:55=E2=80=AFAM Jeff Chen <chunfan.chen@gmail.com>=
 wrote:
>
> Hi Johannes,
>
> This pull request replaces the previous nxpwifi-2026-06-12 pull request,
> which was dropped following allyesconfig build failures observed in
> linux-next.
>
> The symbol collisions between nxpwifi and mwifiex have now been fixed
> and the driver has been verified with allyesconfig builds.
>
>
> The following changes since commit ac798f757d6475dc6fee2ec899980d67407145=
96:
>
>   wifi: mac80211: Route (Re)association req/response to per-STA queue (20=
26-07-07 10:16:31 +0200)
>
> are available in the Git repository at:
>
>   https://github.com/jeffchen71/nxpwifi/ tags/nxpwifi-2026-07-15
>
> for you to fetch changes up to 73b01e57ed3e3d6102c0cbcb21f62086c5429437:
>
>   wifi: nxp: add nxpwifi driver for IW61x (2026-07-15 20:52:52 +0800)
>
> ----------------------------------------------------------------
> wifi: nxp: patches for wireless-next
>
> In nxpwifi, introduce initial driver support for NXP IW61x Wi-Fi chipsets=
.
> The driver supports 802.11ac/ax, SDIO interface, Station and uAP modes.
>
> ----------------------------------------------------------------
> Jeff Chen (2):
>       mmc: core: add NXP IW61x base ID and block size quirk

I realized that I didn't get to ack this one, apologize for the delay!

Anyway, for the record, the patch looks good to me!

[...]

Kind regards
Uffe
