Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF2442E8C4
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784224911; cv=pass; b=bcsoekYdVFH/CTkLbYmhyA+5ENqzlUa6WqxwQfCgSCmKxxo31clQ7xqdh5GlD46mUG/Q6uBoI+z01lKjMwoKYfRBW9I4c/yZgbVWL2XTw5ShToW4ayy/kR4uAsdeZRd4UX4BWpu9iNn6GLMmd0/0OsZkf6Sf3alTRrObqe00FbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784224911; c=relaxed/simple;
	bh=NlWgQiSP7DRr4zrZ4wLm8Qq9VDA5rd981ldTnRGuLes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+kUmosbUAQVgCJAJ/vFA1QmF62LwTvKlycDkJsdVx236ZLu3/kzIMZHAdedfkwzizbRrSvecTHrrxXpMmrgE6yBj+epZ9VN/P6K+VoRBqYi631iZkZn3xJM2QnY2gzim9g0U0fnqPBvPlY8MKisZsU4DqlSkZHzc/TezGhyB1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUlRsURt; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUlRsURt"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-81ed27fe974so19752677b3.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 11:01:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784224907; cv=none;
        d=google.com; s=arc-20260327;
        b=jRZO1pN6aVCETyU8RuIChC+JDsug/W4Z35OM8kpY979BdipHtkUBKlpbC93UQ+sA4t
         aTbQyAYTCCeCboZRU0iRB0Tu8Hl8vNrAfebLTiD60ASDsYfoZo0dH9L/sVJsm08qqiov
         7XksZdNg86NZmRuTH4nYQEHZXLwJkBMd//I0RQTkz708lZ4cxXUoqYHeFxUtjVP0pAXZ
         CIcTILF4TMJw3fyrRRNrnKbVs/Saahr/ahkbTUYk5UopvPbHJHkCSlvnz2nVWt+3FMf5
         Pkr5Q3Ca9cizwU784+f/p1GKyauleczhsSvGfOQJI6sqrgogPSOdwWUd5qte7pT2wLKF
         BYCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NlWgQiSP7DRr4zrZ4wLm8Qq9VDA5rd981ldTnRGuLes=;
        fh=Elm4e3k7PHf+EOufOsY/0TGaEeyrLKuTUiN7ZCtexV0=;
        b=bsw5XSUC15R6gyGtDP4lN+PqVrStCoZriQM8FCTcD4v92YtzPd51lGrXRX98/GKkYQ
         biVDAbstqjLMurj7kAL9VONnT1DSBw1kr7iA1bFHPqqfFsGy/REGgl6d9ZdhuoLeK70p
         Yn1z3Hix0a9mISZq7Vdum+KIdKU1+0IwQ0ZYlgLBz1oT0WO9wQ+8sS25PGxmeO0syOXH
         h7qVPLb2qWxCJRme/z8W2gI4XgRsheE8BS+MC/ZIya4YujyhobtfHhV+tDl80zykRwHh
         mXWUmaDrVMiSGzgnTDnB9AvrtpF9X8SzFFgb3n7SIkxYQWnk4Y3DGmo1vw9Orv+/K5m6
         PgoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784224907; x=1784829707; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NlWgQiSP7DRr4zrZ4wLm8Qq9VDA5rd981ldTnRGuLes=;
        b=SUlRsURt/PVjDt5Wt+cQVzZLPci0i7tXIBdxziQjv51JMBMySi7Yj7Sn0HrNk00+r/
         eYVc2a6dbgKyilCnQva9r1WWtu2WlLUpAs9i34awMOl5VSvDLpDxy5gEQHVo9tyMznen
         /DV8CSABodP4BGY8GhGgQJHPEjz21HExFQyfgOaNnrDTtLITmjAQ+uQGTDCdH9p9M9IA
         orsKCRxJ0ZO7oYGTfhCWoSyODSjNtBAl/tqzp0Iq0OcgQIb0jhpuXVr30Z9ZN6ny4C9f
         IWsJukPT1+Rr/Y3EOWVU4YW44WqDdPDTVL+68ABG7yq/fPRd2xTyeRUQnhKqoIU7oay2
         0chw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784224907; x=1784829707;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NlWgQiSP7DRr4zrZ4wLm8Qq9VDA5rd981ldTnRGuLes=;
        b=JCO3eA3+Om8jGZDArI4rkrgrO9Pmvt9s3WDNTE6HBiyuy2G7d9CTDIQzrYOx3aC808
         VnG1iTRj5R8uGGac3C5tx1RfJ7OBSug8ErbEi1zi9TwG1Guf4XEpxPZLLwHbaT/JBnKB
         gglZa9crpFdfw+PFBjWClmHMtPtmOWQOKrT+F2Tm09wwF3zPpIlTe2y3SR3PCnfjFZvB
         K0ra+J0TMK3694+zoChy2GKagkHvxmEBvvuvbuv73Vguoccn84xsMnKgChDESkiJ0oSK
         eZBlQefzn8ei/h2TpXpr7BTWroR6mgGt8kv2KAPI6Jeab+3AQzwTNi+VCNjDrrdRA3OL
         84kw==
X-Forwarded-Encrypted: i=1; AHgh+RqzINfJv4n85B3+iWmlO0mskgPYmduYEKVha5PYr6RzjcbhskZYuRfT1iNkdYkfTL4kF1H990/S+VXskFndbA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkpZu5dSjZ3dbLQoNiS1nsdU4ofg6YTrj/RRIgUJMDFduHKx7q
	RW07PdS1YVu4wDMTzt+osIRgd/oP/mN39MuBXroepq1NjuW+wLiHgdWKz/ls/vLoOwL0OKJIW0U
	EVj/2vGUSg0/wrgzwuMurHWsVo217pgU=
X-Gm-Gg: AfdE7clbJy4DhgmvWCR2W/lcY9c0D2Msgoor42QtIThKMIZdEJyUkpgaoFWZg//H7kZ
	lvpDgM33eQoNuKAGxbdb4WkanJx8jXq5ncxJZmC0tmgnA3slXhMwtmom4Avj9l/xucC/rZOjAG8
	k1nuvluKG6m+Nisc5eyGICSKUsQiNJ22HcGrS51cpPWxzv3/zxpDcnbw8gkt29tC9ahfFA4D84b
	G/1ahP/2XpXqaAupVLU7tcGQim2SicJKUlg8MgzCQs+u4C6kfmncDMwe8qMoCn2nvlVV7pcI2VV
	cjmftsliTozaUau0E2VlFG6s6ZMPT3UuEnybDLUjKgB2
X-Received: by 2002:a05:690c:31e:b0:81d:7a2:f044 with SMTP id
 00721157ae682-81eedd74086mr2650237b3.28.1784224906399; Thu, 16 Jul 2026
 11:01:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712221709.7099-1-gvalkov@gmail.com> <20260715145228.GG56330@francesco-nb>
 <CADOrJmYwYs08REP3eSwiTQegcKHFLwW0gpUexhomLDtO91ASMA@mail.gmail.com> <20260716085942.GA99146@francesco-nb>
In-Reply-To: <20260716085942.GA99146@francesco-nb>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 16 Jul 2026 21:01:31 +0300
X-Gm-Features: AUfX_mwrCfcFVOdlkh0EXyX_NrDHjDde4iio3zfqW-JG-yoohhSGDLwO2m-Dnhc
Message-ID: <CADOrJmbJAfNoyAuRq5OxP17r6rCAYFFJPy-Nvj4D+1zv=heK2g@mail.gmail.com>
Subject: Re: [PATCH] wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware
To: Francesco Dolcini <francesco@dolcini.it>
Cc: johannes.berg@intel.com, Dan Carpenter <error27@gmail.com>, briannorris@chromium.org, 
	s.kerkmann@pengutronix.de, kees@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thank you! Note taken and I will try to do better when
I submit my last planned patch for this driver, soon.
I wanted to collect opinions from OpenWrt members first.

Georgi

On Thu, 16 Jul 2026 at 12:00, Francesco Dolcini <francesco@dolcini.it> wrote:
>
> On Thu, Jul 16, 2026 at 11:26:54AM +0300, George Valkov wrote:
> > Please backport to 6.18 and 6.12, which are used by OpenWrt.
> > Initially I did not know that I could insert
> > free text between the commit message and the patch.
> > I apologise for that. I am still learning how to use git send-mail.
>
> Please see Documentation/process/stable-kernel-rules.rst
> It should explain everything you need on this regard.
>
> Francesco
>
