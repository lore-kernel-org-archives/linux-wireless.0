Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792804484;
	b=o1nzxCxNU266JzVfQiYw6zxR4LaWA8qng/Ar1nXlAvJsHocnAT3yHFphM3hpQPDzwIB3
	 stDx0rjk3RcU0STIBEtfH6SscRqNfi14+niWMU4q/jYZ3i3uQO+vSkbBW3pXOLccLlndq
	 7/jwtj1QiXNdmkpaLQVoajgvFQ3NxlL9F6mVm9wzhfb3U27u0Ejn5aqvKTyQy8SVpdXsO
	 Ca8eiddbJmMniHpgvJ/ATidWpFYchoyBHl/ZMr0rP5+OHOk8hoDo+LRzbUYRFBYAissEn
	 dkQGwn63RqelMyG7Xd+VrhYOmZXPy11aI7pBwDyuPg82AWbzVee+Ew7/xblfjnFdCIg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792804484;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=lW3J89fIlZE1k/PGBlzPqSNLS0AejPIUQeZxW/w7Yuk=;
	b=qHtsJYpMnl/fxugguC3q3ssA8W7yPM7VVMJle92crTB5zwJlpZ1GyRXaD+7hOxNI4zRT
	 yr0H2NAfaEODpgbIE2ALWJn+PvjAZHRxa5pytNz/YI7PBiGdht4E/Q60X5sF4HmruFvNL
	 95sba8k9n79FwrxzFWA8lL1N6JsKMR2JLjauxeic/4HP+aFvOPmYHaRLnfwYGovzP7JhI
	 uYpK8qXLM7TN3BHGmHc/qSUnILNJ3Ifd/jwG6UxD+I6n3MW6ktAZCUiM+yOdDte34imjv
	 xL+ZLeEuWkV+N01XaIYcTcLAalvqIxJqS4KNdbgtqhroCEn3ciS0sQ8imn7MqY3gosg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="PeR/C5vd";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90260606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 01:14:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90260606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PeR/C5vd
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8acda240937so11811197b3.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 18:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792804482; cv=none;
        d=google.com; s=arc-20260327;
        b=BBqOjWbilY2sIGI6g1EZ11qpCW+8us5mx23v0JsznV4+548YlyyuAbs9ESlkVrw745
         NUzAE/a+JxGX6u5516Q7h/VKKB24tywhzMkbOAWS+uxiSWNWiFtrNfzPPfrwuNHVBaQh
         VP6gLeCjAQx7ZWniDYGYHKo0hWXKdw6G+DS3KxcJccO3p/yF/krVNkrbeOkPdMdzHSYr
         X6b7TuHErS0xJiNE/3I9q/ZbWseHj7bk471Jh1Dw34sulxLb6hHSHOTTDYbQdoDcb2No
         ni2TuasffyilbyIhci0eZ4x59mjEI7neoudrHqkHDk/1nwic2KANyWLFuGTUUUZULdA+
         YiBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lW3J89fIlZE1k/PGBlzPqSNLS0AejPIUQeZxW/w7Yuk=;
        fh=p2F4HyNdVSJxhPf/cX02TL4UkUC2KiAGYxXBNXmtRNs=;
        b=Hjd6S985y+Ajg7C77FY0Adtd1Abk+BLa8Y8QmOKauDVqX01dfH4AfANwCymYkhhm6j
         LufEpi16TG/kfiMXihD/p309knE1wpr0/FHVV8eC60clNleUyqX5lbwBVZin4c2Rstse
         pMmkpcQKRAEQLbmp6V+FiJf+mMzfOrhV6Kp4+8WSYs/95/mVhZYHDyZY1Al/SV8Q16jG
         JABzjNOaO7V/xO8GBkjHY3nojDAaBjt4Iu2V5g4uoqUrHpm1D8uzryShG7Ijk1OyXreU
         HBDscmcLxveMw3nfSHupBA1EqLrJ8VxU7VQku7k+QxlyTG3sFyyrF8EGmL8czwMkW/4C
         sLXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792804482; x=1793409282; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lW3J89fIlZE1k/PGBlzPqSNLS0AejPIUQeZxW/w7Yuk=;
        b=PeR/C5vdkN+oty461dcEsTpC98mgTKpCOBl+XDpClyxyoK47hlznmj9MHm1hcaDf2F
         huhsaPOWr6Q1fsnZqXiJSgC1NgXD3Egyz5YMb4ziPyP9PyoZbbLtKM8gT/82hiLKJm4a
         iTDXDcQFEiltS3o4AVjK0834yCTJYpIisdRlTm7EF4rpjz9/41fKIChpNrJ/HdyqSrvd
         g7aStCDFpJ/E0zljaYSnaxi6rluNAf0drcmwc6lECHYQfB0Kqhvas4A9lDq4cxQsd0Vo
         teXpABMj+SnZCHS5tXDfA6R3gYHhENrOnbBeH1WvPiPioXuBT/JvhdlckLkbGQyRFq2a
         QZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792804482; x=1793409282;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lW3J89fIlZE1k/PGBlzPqSNLS0AejPIUQeZxW/w7Yuk=;
        b=h61k8JrnzvzQpOEGPYNNYOpPVHUx5yH75KKjFFuuFQIdBMU6i5X254ppguvC+LjPjx
         CxzpVEHRB7zm5OXR9EA/yvgmWXFoYZ7xXt9z9saVFKawc7TY6kykSKN74t7JAgb620f+
         r1vr1ScBe/MJ24Wszx1iz25hITy4wOaVEJwY9Nu0Ftc7OSajDD6SggxfW/pJFxwuFjlM
         2cxA46XiLztGm1/Ul5mDkIS0uSIY2qli/zbNRe53bpcJfxMaWal8OCIAxT4AZfbZo3u3
         FzRZoQ8jQnuIrQabZAqga33laSz0hB1byNLXmhlKOeWZIGe73HRClHSxE4JgGTY1LXmd
         NWOA==
X-Forwarded-Encrypted: i=1; AKwUvByE5OcjfMsabjde0JTWLVyhQo6y2F9VjF5c6NMaL7ACgTtertimdIc/CM8HaO0ClSW6O1SF6b+XPVvLYoRLXA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKYM7CHbng6C5VXK3gWWgH8s1QR1PWoU0BkdlV++Ftl/ziFOEm6
	QaiX6leafHTnM03rDV35+c0f8o1oI2ELf6SUn/Rf65GOTxPjL4VNAuvbGWG1UXMUXBSh93rC6AN
	yL3d04eguuUoZCZBSglQfqinluoD5ny4=
X-Gm-Gg: AYBFou39pcUkvoFgVwjDxwQnvMS/ZRPaV4VewR94PfWw52RY5UylGbIDDQrkbsUC2yd
	TBvWqdz0GPZLM230DDmZDs9h2fUJhyAzAHzSwXcl7no3O389mO2wN4HRO/Sj8net8U6hLDMtP1q
	Vau5aQLHwV/df3cCHIe4fsEJFyK2N8fUGLaDOUsRRcIg2vnnUPwMrRSrqxnjWslTaxOXyKy0HSH
	WPjxUbpudYim4CBXs5sFYMAbUnjiLapQOpz+291Ubg757BFhpO1DdDcbTBISNyfsVaqWnmNW6w6
	fWc5vyrLe50Y8OuHh5htEYXLyr2vbG9JLK2hk//IghMENA9loqb5ltYW790zHiZ0TbqCoHYQTF2
	nH9jcjewduzklQr3Nv+p+FFnI1yR/OJdfq66p
X-Received: by 2002:a05:690c:6603:b0:8a8:8f62:eb3 with SMTP id
 00721157ae682-8b166c81772mr5841787b3.62.1792804482650; Fri, 23 Oct 2026
 18:14:42 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023110052.650519-1-toke@toke.dk>
In-Reply-To: <20261023110052.650519-1-toke@toke.dk>
From: Evan Severson <eseverson@gmail.com>
Date: Fri, 23 Oct 2026 18:14:30 -0700
X-Gm-Features: AclHuK8xgnLqkOOBZDrevHzfPB7m2goFQmZThL31mMg8x-OpahF-jiXSeRKElKM
Message-ID: <CAPoPjSd_CedgO6ghSs-vX-O599vVQyEaEniWfz0QpmfmV2YGCA@mail.gmail.com>
Subject: Re: [PATCH] wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Johannes Berg <johannes@sipsolutions.net>, Alexander Wetzel <alexander@wetzel-home.de>, 
	linux-wireless@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Tested on the QCA9563 AP from the report with stock ath9k. With a
station held in power save under downlink load, the TID froze in 5 of
5 runs without this patch and in 0 of 8 with it.

Tested-by: Evan Severson <eseverson@gmail.com>
