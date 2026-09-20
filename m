Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773F93E4C88
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 08:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789892272; cv=pass; b=rEPkDjjauHcSSft9LnM3LIgJjTKRFNq7ITwqkBgvg0aAn6I12dVhzIlkh9rfAU2KnxWW54iqLrzu6yyJ0Be83Gc7FQanigkNJbeSx2c9rG9GXFqHDfFPvALOlTgWOh4CB4JusxZ+EbLHSVJz0Nx9Hc3YsuS9WD9rDIW62lVE2GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789892272; c=relaxed/simple;
	bh=XiwS2mEFayHFkz2FqJIkfecFgIlxJfgwhQhMaxZ3j3o=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwN3zFHd1vvK2JrkkRBlksFd+2Vq+ZAni9rNPyahRIVpm/m3UGbXPSihcVqmMO3LvKyAxK03gb9g9iM2S8WzWigh5YtSuvjHP0NqmU0GJRRn/Ic+q1oMFC1rBKkejaKplI7oKwmwdcOUelYk44e/pi3lsN8pu532K+JwQumW8UI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=jZFCdHq7; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="jZFCdHq7"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a36de66c0dso19757751fa.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 01:17:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789892263; cv=none;
        d=google.com; s=arc-20260327;
        b=PhbbfbEsfOgUBWnBvdsz8/K7K/8R08LIJpjCA8lcHCKPdwzuXT6YA8HnQHHYtNPZHW
         rgp9n+QcDqIccQI6dcXRkPLgA9vEDWkGNooYqRIFfwJChPNsUMNnn7lInqPh9R2nYjUB
         3miNKR7tMjX1HTEOXufmFww3A9X/lFytjgj7X6T9Joe0B7oUtY3i7HOYoKSW2/bUw5f1
         UAUzodw9zPD2y9FycQsi7n0s5Pp9xe9gX0cqsu5Mk8TlzFjiepjfNk+KFi5Wa6nYQ4nJ
         FG+UZ+F4Do7ZOY7vu4fe5CvaYqZ5GGhaFOOKY8bty2Ncmck6BVorIL0rJjOalqTQ7k9t
         7Lcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=yjFWX7IwtHBRly0OiJSvV7I8EaYrkGy/qJuEGRHSu8s=;
        fh=n5v73YiJzxMAAE5ZePeLdT+lpUtZ9Qo7rWbrpoNNJIY=;
        b=Vs5TQw1eE9rG6HegL0w4KVQ2ugtRAg7rcv+HmLnKq7xkdMkQjOztS9+nmKFKxHzOJm
         PJmJBO55y+tSrCw4SeX/6N9FnoRJbwdaD0xmOFZCut2Zd18cyPwK3afEm5vJ7xnABbpe
         Vqq1W9UO9CR5uQtEyQZ5+fOU+lJQfZfQvXv4RzglJGg3FU7h9gLKu+fifY6HJKbA1230
         e+G9ZVQjw9fH8CYV5/5C8XPIpksrTC+WbQAw5lKnulxnpj7W+AHGv9nmQTrOmiT4PAy2
         pMH/FLvaZHchExRF8bPwhqBbW4JxvZwpa3key+DbUaruHQBGshBXe05+08kQoxPtNk4o
         U0LA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789892263; x=1790497063; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yjFWX7IwtHBRly0OiJSvV7I8EaYrkGy/qJuEGRHSu8s=;
        b=jZFCdHq7i0f0G0TmKOAAvnGkZFyZqnc60YmWjSYXtT+2YYVue+7vA5UTfZ+5KhK0JJ
         L/XhK34N+gqiYqFj8DCEFKfGJaZC6otabhzXuSQBnwN4kMstAGvdc8LrhOUCIaIBaGSs
         iQ5759o2VCSUrK6I1mZxN1XKKuHz472qCtBxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789892263; x=1790497063;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yjFWX7IwtHBRly0OiJSvV7I8EaYrkGy/qJuEGRHSu8s=;
        b=C71sI5IqEmGQUBO+fljRFqM+z8GRniIUbZ7WWkTWqOISSTiHOye77314ISVF+TiD5p
         Vqymo+rdxNDwnlnXGvTPYEcBhfesUGQ1Zt5T6b6KbXWplnjP2dtf1giGpNDBU69wDvJe
         ndNKAjoFxaBpnvaTQxjl7mcwqmpBN0YjbcC08EDVS4VI5wCWmSWPVxGkcl8NW3g6lNJb
         M3imrHvQY0d2ma/F0H+EuIbmtcBO87km4lZQfg6o5jp8c58I3PUjbknBQpV3jkiZCJ/8
         Skowkz6MGDV8iu1cQfpMXOQ8dgi2Z+rf5DWH3yVkeaePyLmGVbzIw+xpqtq52i5PajDC
         UZXw==
X-Gm-Message-State: AFuF++kopHjU6O64A2EFtNyAGP3QzMgDNkBMeHNR6OEQw8TQWaieRyoI
	aeJrJQVyMK40OR9AkY9USscGwtfgzYwIe08pN63IJ+E/x6EWxjXUr5G9VpUuG/SwyMQmXD27wDN
	zcZeQMkt9xLCIeK5RgDNL8Ftdxbo2wPJhsvdXDVErzw==
X-Gm-Gg: AYBFou2C+sBmW7WMEyNw9m6QCbeVB0HThmNVQy4tlTGlomBdtwNLn9zZgP88GT5FuQ5
	66z9L9RIf90C4V7EMKqtgKW1VveYdLzsUgprdPH0c9IXGRQaU27kFwHhAw16xqVDJcAr0XukYzX
	J3zRw4YFR8ETSLzPNg/Kh55WBkQCAIwmNwoECzKZ0zuKvEHmLHvXEDMmSddUI9ixZ+uM1gY7beN
	vUOH+tE1T9lvcQYeXW3Rdw31BG04S4+S24+tFDZK2XV0J5Bfs0lbJdq/5lT4rrppncYvt7dEIDn
	xYwFEMhXs7nojk6FkEFk11rqPfHXjsdjBOEt7wd8Ml3m0AJzWSM=
X-Received: by 2002:a05:6512:3d1d:b0:5ae:c8da:6254 with SMTP id
 2adb3069b0e04-5b8c18298d5mr2023364e87.22.1789892262999; Sun, 20 Sep 2026
 01:17:42 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 20 Sep 2026 03:17:42 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 20 Sep 2026 03:16:57 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sun, 20 Sep 2026 03:16:50 -0500
From: Kim Wooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <6afa402449db46468c3cf7af410c5acd@realtek.com>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <ca51eb88df7b4e83993af73c2f1e26bb@realtek.com> <CAH1Bc_wo3PqWiqFcWZX9xB_+99=zHOdCD1VUg0R287Z2B4ESrw@mail.gmail.com>
 <6afa402449db46468c3cf7af410c5acd@realtek.com>
Date: Sun, 20 Sep 2026 03:17:42 -0500
X-Gm-Features: AcwNN1Ue9xcjZdd_qE_50FMCoXjAzbJwXOcRyi5oDvkBOgb3PRX2B4FRjMvBXMc
Message-ID: <CAH1Bc_wKzr5n1TxKXOtcddp6AcgcYfBjM95QaZyr9763v5cF5Q@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2 0/4] wifi: rtl8xxxu: keep RX requests
 available across transient errors
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

> Are these test items generated by LLM? and how did you make plan to test
> these?  (Just curious.)

Yes, an LLM helped put the test results together.

I based the plan on the failure points in the paths affected by the
changes: the start() error paths covered in my reply to patch 2/3,
completion errors, further submission failures during recovery, and
stop while RX work was pending or running.

The tests were designed to inject failures at those points and exercise
the actual driver paths on the RTL8192EU. For each path, the checks
followed what had already been allocated or submitted, whether it was
released or retained for retry, and whether RX recovered or stop left
any work or requests outstanding. Resource counts and work activity
were recorded to check those outcomes.

> I think you want to say "this patchset is fully tested", right?

Yes, that was what I intended to convey. I consider the series
thoroughly tested.

Thanks,
Kim Wooseok
