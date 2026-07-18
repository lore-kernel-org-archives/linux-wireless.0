Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2481358375
	for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 07:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784358433; cv=pass; b=UbJpB0s82EnUjvHvPC8wLbKpfjCexP45/Fel1TV0n2b9gftW98k2BwqTMbMyAIJhB5o6MhH59yR994sX7CJt+8CtgCItUnm2MWnBWbXfGI7KtO+HclZy/tVBofQtyuCY+3qAvHA3R++n40qwmoHvWCdYyGhhvB2NflujoXvrWTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784358433; c=relaxed/simple;
	bh=+M8v6DxKwCONLXD09wLyUoD+U+pCg2d3K6VcmYFbo6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKdEAAdCPPcaSHdh8fxtRQBpdWDsMbm9M8TEFPHgXKWAkT3DQRwLFZ3oDuLBzoc49yQ4b7cfdupFA3waSdBO4PyldKOYgHKYtAb43nsY9ZJ7M35mq9G59pYo137abaHtnFaDlVFAep7a5J5/GpJzPqBsdyodFuWZYTnI8zduwSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FS7F0EVB; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FS7F0EVB"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-668296d0ff3so3110109d50.0
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 00:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784358430; cv=none;
        d=google.com; s=arc-20260327;
        b=Y96UV/aGvWucfKF3IKgsoPR7ZCAUWLGL+g0hlYz6IWt/lOiyIgPCiyvj8HEH8UpD7B
         iJ+kJUs5RAJIM+mAEZQyRnC7ZPv1VhGBEmsV5ILToNnCEBVBVjjWpQelPVlYwOh/oxws
         URvUzSZYJeBm4Nmwq+GrKeG4cnhQac/51Y1V9G/5w/TpUVziImC59XVCKDLlTUyCNe0I
         vZPHDVZSoRrCi3Nu5tHhBZDQu31oTorCjx1QtiPgQcBdvsc1cdrf9O+TPv37X3KXT5Jd
         csP4kb/v+wcYNC93v1w0fnjQAv7hS8dDXLuuEGyDwhFALSyxO0J1FQPybTzDCAiNr0h8
         akdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wmSIkFJSqyaKz3/VEwKpr/MGHtYZvKLOlp0Bt0CKKUU=;
        fh=GTkPA/PoCsQzGirjjpQGONz0IvlvKas0n5l7qHj/m7E=;
        b=i/G8uyDxe/jqWIkHi428K5YZoSGH/rx/EUl9DAgjF7gqu6vp1Tmt33ynDRV9IIsFDW
         C7Jtoce0gJ2m2/ZqgJyVnbdbTcl37fw8zpZmYgT0MNPPkeCzLdcJWEKBEItjerNjL+rp
         /6jtah/C5j74R5lQ011Zc5WKb1h5zQlliRWdhFEYfvkuiECOWc7DG4XVyMrIKKiWN7Gg
         OBIcsOP1JPsk6E1IfKeysDg4D4yrS1Cg7FqYh31+oktb6coRUsKAQLuWlrE3GGuS7td0
         JQinPoOhyJnVsi//fgqi1l1v5LFABB7w7zEclkdyB78afOipZRxvnRYnB+vFfxtOZxKy
         nN3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784358430; x=1784963230; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wmSIkFJSqyaKz3/VEwKpr/MGHtYZvKLOlp0Bt0CKKUU=;
        b=FS7F0EVBN4UWmgHd+4a8STXBHxQwKD9ew/0uBdv4KQI6qN4KAeSFKYVU7ZLU9w8jKT
         giZkUHEeirNIdJgcvHY2NzzOAthltN2P5NzAoB+SzeWeEoE/byh+zneVkA6A8b7aAX0w
         KYcpUkukjV7YWpwE86rWbsbPAEhAo4pUKly67GtVY13yb+I0Avaja95ajQ87D3eE//2F
         OIMOv2V0jBCwJnSm+RnuT1QGIf2IzHoIoFOAYCbfKZzcA214xVRS+IbhhzGwYerHrW+/
         i+7b6ZcW/hykwmJQ4RQtEUOo0nu9SU+OSjTKIVG59pSET1XhQvpKqBLQqeZt0Tpu8hmP
         e43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784358430; x=1784963230;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wmSIkFJSqyaKz3/VEwKpr/MGHtYZvKLOlp0Bt0CKKUU=;
        b=Id8bqxnK0RrLu+FrmmGM7OhqPQ6Tzhc8B547ipAHmd2bpUNJviugfz5faTVAFwy+ET
         QALhr5mxOqSIGVVYfiQgwtutXRW5mO2cnk4NnVuKjg46Q3o9AVI89puASCcBhPC0a4fZ
         P8Qxxi/HBe+u/FHhoqAaMCYDwiF8HnoapyXB5fav8e0X2ICRbTC86gWuZUjnXt44lox4
         O58JhT7RR/s/u8IiFCo0xnKzCxmaioLCdKvGHz3GhelV1Lee1bkZpDUaZn3yOCowAYeY
         I3xjMo3c82PEd4bGtCcSwAGeA8/l3xK608Hsc4w6ToZI5Sl4Pw7pSHx7p7X6gtDLVFMW
         I+tA==
X-Forwarded-Encrypted: i=1; AHgh+RqS4J/wVu8lYMuTOh+x6FpcRRAxtDMzHAcX/FC+Twa4bk+tWn1W4vHsj7hKoMfQBJr8TBFNwRdRUyD8AYLgJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtCxNw17MqoGYpz/4JdVVTXtF3+8stgRDvpjw6DtBqH3pKTFbI
	f6LFI9Yoi5gYA/NNeMLU283lthhdBkvM5Xl/AZE4OJuQne4QCEahOQ0pcVlm+hW7xYK2ovG/jUi
	A7xJC/izdnEPqqu/W9GueHEJXtz/Jqug=
X-Gm-Gg: AfdE7ckgb7mVBUXWOiwQ+4W3hugT/wlwI4ZdUTcVyQ9xRT4uYngyi7p6foi/1JyQJhJ
	Yt9DWtYM2u2FC7zaCCjQcDTaLjLyNvPBY2I7qRS/LPK1vcOSDgPS6oO+0Ke3Bj/m8BFnvdWo7Cy
	RIuRopniL7s9jXaazVw9tT87GJP3Uq3W0nW5m663Ws+xUO09FHrzA1ng60ynDbphk5CR5FFhZLA
	a9Vc+oZRQ6e3eYzV3d7B599aXhbYN+IBFa5+lB17PwOaXsbUZqZff97XU5cJe2Z
X-Received: by 2002:a05:690c:6d0c:b0:80c:85c6:898a with SMTP id
 00721157ae682-81ef266218emr20230547b3.57.1784358429733; Sat, 18 Jul 2026
 00:07:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715064042.1988288-1-lgs201920130244@gmail.com> <faf48c76-373a-42c1-9c69-cfbc5178640a@oss.qualcomm.com>
In-Reply-To: <faf48c76-373a-42c1-9c69-cfbc5178640a@oss.qualcomm.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Sat, 18 Jul 2026 15:06:57 +0800
X-Gm-Features: AUfX_mwQ4-arHf0bC-CsIAMvfm-Hm1rvw6GpPIJETr6Tid6aJ6SrX8LIeHodJIg
Message-ID: <CANUHTR8DHt+dABWn1KmnCJNZhjY2NASqGwPp2SU7CSrhjhOe1g@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: ath11k/ath12k: release QMI handles on late init failures
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, Anilkumar Kolli <quic_akolli@quicinc.com>, 
	Sriram R <quic_srirrama@quicinc.com>, Shashidhar Lakkavalli <slakkavalli@datto.com>, 
	Kalle Valo <kvalo@kernel.org>, Venkateswara Naralasetty <quic_vnaralas@quicinc.com>, 
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>, Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	linux-kernel@vger.kernel.org, ath12k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi Jeff,

Thank you for the review.

On Thu, 16 Jul 2026 at 08:59, Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> On 7/14/2026 11:40 PM, Guangshuo Li wrote:
> > ath11k and ath12k initialize their QMI handles before allocating the QMI
> > event workqueues and registering the service lookups.
> >
> > If either of these later initialization steps fails, the functions
> > return without releasing the initialized QMI handles, leaking their
> > resources.
> >
> > Release the QMI handles on the late failure paths in both drivers.
> >
> > ath12k_qmi_deinit_service() uses ab->qmi.ab to determine whether QMI
> > service initialization completed successfully. Set it only after all
> > initialization steps succeed. Keep the ath11k assignment unchanged
> > because ath11k does not use it as an initialization-success guard.
> >
> > Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> > Fixes: 088a099690e4 ("wifi: ath12k: fix error handling in creating hardware group")
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> > v2:
> >   - Set ath12k ab->qmi.ab only after QMI service initialization succeeds,
> >     as suggested by Baochen Qiang.
> >   - Fix the same late initialization QMI handle leak in ath11k, as
> >     suggested by Vasanthakumar Thiagarajan.
> >   - Drop the Reviewed-by tag due to the code changes.
> >
> >  drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++--
> >  drivers/net/wireless/ath/ath12k/qmi.c | 13 ++++++++++---
> >  2 files changed, 18 insertions(+), 5 deletions(-)
>
> Please split into two patches, one for ath11k and one for ath12k
>

I will split the ath11k and ath12k changes
into two separate patches and send a v3 series.

Best regards,
Guangshuo
