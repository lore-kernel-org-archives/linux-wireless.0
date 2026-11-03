Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793704102;
	b=lsxLlLHcTGkRXAS6m8EzSKRcyVHFNHk3qK1f9+1ShIO80nOwL3VfVvLu84XDXmIVm/dG
	 V4DMkMJT/izEHaXbFphJX53zxq3ALfhSQCm2aqOXux6o0HoFFX/rfHlFEE87g0Yuw1SaT
	 /uEx2SlTDsWYa1p3C1PgHQF8sAnvWrQ5ejrxwEERwRgRqw5Q9BTxmcCZH9LctHIMa6M52
	 PvqfdzUY8Qty8qgxfAYiUZDl+jncOUxSDuCDR56wPVb3a30YwsCOKY+nN9cyCigUyUOF7
	 ++NGMDRLJEpeSCMJqMRu0CNawFxNHwNnouo82UfTx1Sy0lHQ9KhOEjnQRMeXnH6HjWw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704102;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/Zp3HhZWdOqhjmPq6xmi/Tj3ka8PFrAOHqU0dCBIgo0=;
	b=xF9OzeJ2jRJolyiCOBMWzSYFR6RXq8gP7tUyUPwAsyAA0TbB7RUWs/zaNJFOCNLvobPp
	 hBxYUuFnsfyrTSe1x3Z4h7f9UP8e2m/UUh0JYKXV85xrLh9qw2qejfT81v07hM3+K8J9M
	 lq0JYWl145HS/rBTK0w4CzaplxQQRU6jNIN/ZEnnQ2ytGj6SCfOBRuazAQSK+JtZa3g6k
	 KwATaFSUDhknvlp6ExplEVHuk2iuJVzskckBHxYVw2UtntADnVjvrxlUwuxTwdb4QL0U1
	 xl+v5+zPTx6NQgfLgbNzQy4+OpRXHEJZSUpMWBNk7GmbNolDCZglXscObpk8UkByw2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nagashi.ma;
	spf=pass smtp.mailfrom=nagashi.ma;
	dkim=pass header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=I96VemwD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A56F606A824
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 11:08:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A56F606A824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=I96VemwD
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so6071620a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 03:08:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793704095; cv=none;
        d=google.com; s=arc-20260327;
        b=I8QR0BjSiyePrA3AXqLtlTlXdGU7+6aLQEEdieiYQEUjGyDNyh7MtD4bBI7csyIXRW
         rQtZ44A3g10E72hanV9LDAOXjPJKOvLUhxLu9Wx446sYaIgr8gcvyH7LCNuRoScqdw56
         X25rg5wPyclh6RwhHlBHmiq6oBW5xqnHcHLg9rryb2v8Dkb6U/sXOi8YFvPq+Fwx2Vpj
         LhmcJH9UpWHbyp0Ekrt+n3D3DldliQvXT+Ki0l0xXWJLtF6pQotNcqqGmto3BC9KaO47
         MFC8v3ydAw55BL3RKJ9UeoyBhCYoVjLvseiDM5kmdGmzutMO8FRJ0Kd4PZ/zGRQztTYn
         kHrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/Zp3HhZWdOqhjmPq6xmi/Tj3ka8PFrAOHqU0dCBIgo0=;
        fh=n6EH5wwnJYrcu+jtqLMh/a4iI5zm17+bayRl5RBo2Zw=;
        b=JE+WfFgub8gpquSSU+9vPblF6gs2nILTbyq5cynFj0fBEWIy1FFznaN1P8BKrITX1S
         roKlqd6Yb3t7HRJ32VddqCVdG2fGFqwBA8JSwpR4cDxGzyjM3WAr//vne75STQRLkl2u
         DWyJPDjegiv/kH7/lbiMH6UsZ0hY02srS74Ic6hT6z9nr6L0eHKs8NUEVzAHemXbQlkP
         kV4HTJ0vaEsHwLYBteFHDt28itSB25mWUo7EYRM5v9/VahzPlmfhQeVA6yV1tGTVAsGc
         uH5BM8nNBTO8seBbsEXyHs5VX6kN34/jh12BJQlTxaqazrN8vXJF+cAOE9nAHvrF5lEo
         cX3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nagashi.ma; s=ggle-ngsma; t=1793704095; x=1794308895; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Zp3HhZWdOqhjmPq6xmi/Tj3ka8PFrAOHqU0dCBIgo0=;
        b=I96VemwD8UABTkS0R80cL5UJ+UXdgwlGOs2uVLe+HOw51zymBi1kiFDDbjAflBNFri
         AMnj40ZNXvXs0vKhzB2htENOXORq1TvkDep3e0z8m2GywBWQNrzY1iqdda/ehL8Iotq9
         R9NImmkPoneUMLL1tElYwvwWQlrpziFmNd7akvYkenYgB3QHLt1NkFA+KwtCNrzw8a4V
         VKS60F4IEONZBhVLn6tQYMHvP0Eo85ZYlrQxDsr4XRu9r9pM6X7bmnld03n0Q7lZZYPg
         4U8xq7dHrMWlEl/wuXUqC1KYScVCTKkVahmISNx3j5a2y7O5ECcME0plf9xxsOYw7bhH
         2q7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704095; x=1794308895;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/Zp3HhZWdOqhjmPq6xmi/Tj3ka8PFrAOHqU0dCBIgo0=;
        b=yFVDqp5k1WtiF4T4ehB+bDy3w47wXly0bu21W3S35uFrvUEnPpNpw455Fdpjy7CiWR
         O98k7kK7aAGbYoHpRU5+hS5215fNKq9wKXcPzG2kQDCFtvc1VnFXh4+U1duuGKpFNBtC
         v3Psx3kWVLgeaPilU21Zu0mfGUTnarblxMq1abLKkgHevr0bDRB9SclAEXNms53/knaB
         0TeXMahCg1lldxnzdpQfC4PWZVSK3a7qPtSH2TQvTrmXkPTthy7u5JKZXcLIGMhvIXc7
         DW+OlRs6n3DXInxtSVghAzdFoF4HXfrPzTcF6TaqFOrRtz1/MIUERI9BBkLfJMrjCdzB
         90OQ==
X-Forwarded-Encrypted: i=1; AKwUvByGqzXOki0pxqo6UgT9RoIAHnTJruREk5svSFZf+ygOkpZsSB8ZXGl/xbewDX8VVGiFB6zFQxC70Vov/vyEzw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIpGVuI9duJmZFlmdZ4DbEOuZxVnRVylSGK/LA8FQZDQYxbWCWi
	YTHAYGcPx8Ydvljz/TjNIVtJMh9kdbRKnQ3VnZQwj5A6XuMKaJ3t7kFyWuCf2nF8HQBDfbiHq+T
	ms1UjmVBj8+0bY33+N3io9CICP/akQH4ZRRTZRe3H
X-Gm-Gg: AYBFou32T8kXOIbFG6xpd6y7Ch+Lh3vFiHcMzde+P4Ne7zWhBKlGB9z5h1Of1oSuJTP
	WzWJixMq8jU7P9MfVlTwBd5x1yW93wo8yWrxIQHlCib1MH3kQKNqMy5gphrA5a/5cGv1tFx/3gc
	CTm0NqLIGLOS/aZr4sJax71HYevTbnRDfsneAPX7p1a4nSb+/X8uLStkiV19DPkAjUNhYyZ9+34
	wZc42VjN2nqgdFhe7PeGKyvaLzNg8lyYs7bI80znRusX6OwpbJUGfjGCcJctEILCsJIt8Tee2Qb
	KF57Ja4VC19lSA+wren6TrjFyrAWcANeWnLMfrRti5GjahMB6g0sd6/MPiq6M2SwGDbJ1o5iWqM
	0ldX0BX9qI4WJKiCYgXRrVWidf+8ODsi4liONTfnJJZo4o0tUfuyLwFPUUWlKgJDoTkOYntTRiC
	ejefJz50kimdBwKeIga8LmZc/eA31oxoLfbP5ps6UgPtoOrEPr1pDNRBM=
X-Received: by 2002:a17:907:3f1d:b0:c49:9231:5518 with SMTP id
 a640c23a62f3a-c4ca7a40254mr1059160866b.21.1793704094661; Tue, 03 Nov 2026
 03:08:14 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
 <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
 <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
 <c45bdcae-63da-4552-9e35-59ec6a71621a@gmail.com> <CAFEp6-36Fc15uDWSR=v+xCMhERbkhggZOBoEFTF7pAcRLz_vFw@mail.gmail.com>
In-Reply-To: <CAFEp6-36Fc15uDWSR=v+xCMhERbkhggZOBoEFTF7pAcRLz_vFw@mail.gmail.com>
From: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>
Date: Tue, 3 Nov 2026 20:07:48 +0900
X-Gm-Features: AclHuK-tO3aJA8d_SmuLc3ZoFMk8WdJMtEnlyIJzjfGwrGOn0GHRV9smb-wnHEg
Message-ID: <CACB3TC+NVYPbNKeOu9aAnRaCUTTon4PAO+kp_QbLqL6qd37aeA@mail.gmail.com>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on WCN3990
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: "Conn O'Griofa" <connogriofa@gmail.com>, Jeff Johnson <jjohnson@kernel.org>, 
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Heidelberg <david@ixit.cz>, 
	Fabricio Akio <fabricioakio@gmail.com>, Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
Content-Type: text/plain; charset="UTF-8"

Hi Loic,

On Tue, Nov 3, 2026 at 10:20 AM Loic Poulain wrote:
> For change request I think the best for this is probably to follow
> board like change:
> https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath10k/boardfiles.html
>
> Please, keep me in CC.

Thanks. I'll send it to the ath10k list in that format, with you in CC.

One question first, about which file to change. In linux-firmware, the
shared WCN3990/hw1.0/firmware-5.bin goes with wlanmdsp.mbn
WLAN.HL.2.0-01387 (sdm845 boards such as db845c and SHIFT axolotl).
qcm2290 and shikra have their own firmware-5.bin, picked through the
firmware-name DT property.

My comma four runs WLAN.HL.2.0.c10-00459, which comma ships itself. It
is not in linux-firmware, and the comma four device tree is not
upstream, so a per-board file would not help anyone else. But I have
only tested the bit with c10-00459, not with 01387, and I don't have a
db845c.

Is that enough to change the shared file, or should someone test 01387
first?

Also, the page says Kalle adds the files. Should I address the mail to
Jeff now?

I worked through this with Claude (AI). English is hard for me, so AI
helped write the English. I ran all the device tests myself on my comma
four.

Thanks,
Shunsuke Nagashima <shunsuke@nagashi.ma>
