Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310FC4CE671
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791219050; cv=pass; b=QxlIsyTbQdwoTb5So8J+kUUyOIrxz4jHhDtujjZpQyH6lIFcqWj0NqW6y6JBtF0CW6UXxWOwuTq5j/A0ZoGYUQd9wAu3yQFLaTlNhoyJncRfeuno56NPSqOe4LvV+5sqPp5gg8Yx05wnfFieB8bp8TX4sN6bZpI+0m2eRFTf4MA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791219050; c=relaxed/simple;
	bh=Q5bEQNNXDkZhEHk+o9hidTvXzFCLdcCycoDgksfDDBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lA8+wdObDUHP8GhskKoajgLf3huq3nPdqMckrtRHSr53G/PHBAbvB8gNLuDIGUSh0/k2njz7Dp6cLwoM192fxEzb+Hqf/KwZTOdK38JsZnyjmi5oD2PWrCDr5WjWGtuzGuKyH+FhobYHf+dSXxn/4rJzZFCf6QXd3GizmYnUnP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SWvsjAzk; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SWvsjAzk"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-48ed460be50so1131178fac.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 09:50:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791219048; cv=none;
        d=google.com; s=arc-20260327;
        b=RE15km35nGjvfOU6No6H9/x94+G+5+FvbvQPscq0V6BYgmKDzQ3iBUHGG978J7de1U
         Vix72CNXsyYS3BYc4cp/tyhfpFFXkGzom/imwZHk1ccqxQzuJb7Z2fGtZvDpYrWnMhDM
         arfLrybwBJH81IuhyUNUrlf4dEfce98Ifx0KVnsiGF90GkbS4XVC+XAPuPr1pBeuPx09
         sgyaPiHZe5UuLcQPUGQ+Sm1PWSQeOsAmdVu1JA7++k2a+jSnIO2ynxtZKGvGYN8ZYrGn
         BynRYXfSE9+gJh4m4wyzixcvpZh0hGF7baGOIKAaD9XFmvxl8D7trwPPWBCcdF6703xw
         3pgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Q5bEQNNXDkZhEHk+o9hidTvXzFCLdcCycoDgksfDDBQ=;
        fh=PzE+yNk1+H9P28i7dXT3td9QH9l5pWLY4R8uppsTCxw=;
        b=SlG0ceq+BzoxrHprHucBgyrW5wZjxp8Tqq0XkxRatwRkd/WNqiItR1RhrSxJcJ4V0b
         f8vTyTa1U12999agnOIgQngEstDMRInHCs6MqS+9gCr4402cRGbHfAtN8PthqKG8Nsds
         o1BAJAgwRHUCrmTD1yosGqL49BxaIqvYrcyydmSSPvkmVqbBahc26xKnR9QitWPOFMrA
         Rlt4qvaTO0esgX/wRKUcF39yFzvg+wl3E3WtbCnBLGgDCrPw61lAF0tKdKVPt2x7AQ8n
         rQjTSs7EkWQYPv5quZ9SumbChO7y0tYE5gn/EYXiyPpcu/MwCXEVYhODOJ428EMp9+bV
         fYfg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791219048; x=1791823848; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q5bEQNNXDkZhEHk+o9hidTvXzFCLdcCycoDgksfDDBQ=;
        b=SWvsjAzkyHzUhTPj4aMhCk7arhV/KxwFnHhNlgosAH9UXEazEnXp8HGRuduScSm+Xx
         FNSz63r0/H35/QH/SUUk+y7IO6sQk3arjidg5DBRH6gmN7a+uQcsn218CX+Zvw5GX2yY
         BGmY6JtchlTSTise7rnucEdbAkqLy5UqWYQiBrzYZsyb/TFoTj5dJXY4k0K+fWEbHXIw
         QF7VBe55y7WRpB2oS3A208b2ALJ4/MB2PwAgHv/pQdVsE07nNd+xoC1EM9e3UVjygNAM
         I5XeO5teEYgGEbY8EjMR0kd4B6Yo3udi2gzcP8HWcTCkQoCS21/ENGYC5Z4i1aDA+kws
         GPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791219048; x=1791823848;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q5bEQNNXDkZhEHk+o9hidTvXzFCLdcCycoDgksfDDBQ=;
        b=0PqwCx8YrLycA3j+DGA5vZVOI9Ncj/JPr0p+C+gPexoa9vb4lT2xAaXuMncSXVOy5N
         KQ9ppPXnP0k3TTRxZDIlaRPxIyuXIGQvlaZLGNdJOGlVb7xZK6Csf5J5ur/lYnr5WuI2
         h5zKhNtZ3Y128eT19Kj4Lpb54yokvjjpmVn2LkzmsYukE+LrpattGt1uNVT8BYejylcH
         j+Y5YpLPqOsKm/wO3BVktRa92yh0FbqFnQYVOzqWNga9c2NSwRH8RS72W55k02ZkvnpR
         Z3Y3Xy8ow2agC7t90+hKFNxginO3uQnM6mlvH/vIRchCIpLKOyozWU1lXVWEV/v0eCbz
         hI8g==
X-Forwarded-Encrypted: i=1; AKwUvBzko7NyRT2lTgyqIzCrAFmp8pQDcfdz9tFR9GrcrOAIN1UcL8EEInWi/YQ8yUE8aiTVFH7sib/l8wtaWDa6uw==@vger.kernel.org
X-Gm-Message-State: AFuF++nsiTcwMYf6TguDzbllUwu7wdWYJ5RH0rD3e8RgJgqLd40keUIv
	wf3wjbuy1XojlE3WFVlmy3ZmwpOmA+nfsqTUMm/VYKYie6rQFAi1xfBjv0gIbwkPvrrKQI4bnlY
	+zMI6XxMD18/wY4yS3CFQj6kzAL/wlQ8=
X-Gm-Gg: AYBFou3ktO26Owbz+NxrHTQZdD2Aez02sw1ClYtrU49SXTYZJvKfGLfLF47d9gQfiec
	T1R1UAran6Vj8hkEAYcGUN+Tc12NDFK47xbHIkMexOpN6na//bhyFrbUdyj2JvdHrCYaeOhzx4H
	NgkFXO+oXdqZsyX7BVpS33wXtjYOpUDOe62jk+CBU1th9ZVrM4k3noA2xQjkxLwmfXXPUyhm/4f
	3BOFQYzfTCK60lup8tM9+XzfRa1gn3/zQQqhNo0U6BOjDWrptkCHlfkiJqQDDfTkcZU/6it9bBH
	sfU/x0tkkbN/FurGaqqltvqrG+7akruedB0vUGxKhEbvBsCVa2mx6WMnFZBt+/jD7Rtz58RPhf2
	WOZ8kgRsyTT0L
X-Received: by 2002:a05:6808:1795:b0:4e8:2150:299 with SMTP id
 5614622812f47-4f679fe2a10mr7854866b6e.23.1791219047967; Mon, 05 Oct 2026
 09:50:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004165132.4313-1-franzelfranzel@gmail.com> <d791e70f-9c3f-4916-94de-8d76517339bf@oss.qualcomm.com>
In-Reply-To: <d791e70f-9c3f-4916-94de-8d76517339bf@oss.qualcomm.com>
From: Dale Whinham <daleyo@gmail.com>
Date: Mon, 5 Oct 2026 16:50:16 +0000
X-Gm-Features: AclHuK86rNmj1WNp2rnEYWCTMSv7GKXC5kLWAnqBi1EywA_4Cfr2oGHSi5bAdpE
Message-ID: <CAFcmK8haaN=O+aqvcRr4t6jc6dr4Bf2QDDPso-aT_frqEfSPWA@mail.gmail.com>
Subject: Re: [PATCH] wifi: ath12k: skip hardware rfkill setup on Microsoft
 Surface Pro 11
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: =?UTF-8?Q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>, 
	Jeff Johnson <jjohnson@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, =?UTF-8?B?SsOpcsO0bWUgZGUgQnJldGFnbmU=?= <jerome.debretagne@gmail.com>, 
	ath12k@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 5 Oct 2026 at 14:37, Jeff Johnson <jeff.johnson@oss.qualcomm.com> wrote:
> my preference would to to break this out into a separate table-driven function
> so that if other devices have this issue they would just need to add to the table.

Indeed, as far as I know Microsoft Surface Laptop 7 (aka. Romulus) is
also affected by this issue.

Best regards,
Dale
