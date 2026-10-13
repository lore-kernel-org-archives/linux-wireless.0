Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEC31D8E01
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 00:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850560; cv=pass; b=uCxn9Tt4iBGdyeXcvLEWScy9XhtQnH1aYBlX0Lh4xGqKcrLbhkVd/xgCYe9TwSgKT2phzlqG2eY5vl2pKNuwdMoGwXcWDD7GYmLmvEDs9eacpkTBrprnkeRaLQUIhOrmmwAofD5lW2QDNsKgH0BSypd2aRYR7mAaTzhXS5raqbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850560; c=relaxed/simple;
	bh=pHxN670nTvs1SKv0ysH9qz0K2rs/uzf0jySAKyVqBoQ=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U95k9gjaFwTmregkp7IGoJzOphEgnq9u7lVDbRhcuSSWBTDG4KRP3eXp5nZE8OPQBsmTAN+uE4kdnQ3ALWgQUODSyHrG+41/heLPMwmcC5OIg4BuRd6F479FU6voZTaAKnSMiIrijVd7CWn39oas45/JpJNoxkrPkrr4EAIWeYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=kLcxJ/Mv; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="kLcxJ/Mv"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3a20f06cce6so34978421fa.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 17:15:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791850554; cv=none;
        d=google.com; s=arc-20260327;
        b=E56v+pyxPYoNrbiYthjvH2ka+zzcGBorR6zL0c99Gp4C9tj7txovteILsqBUnpdK49
         4fMOQoZUxEPQoRfu20pKE5K5stdR9trHLspnAWkJ3vlgfyh+HgxrKYJW1QIxLOc+UBrg
         F8evXWOkafdBnLHOTiGJ9P1ytDHkwm5daCgmkVp1n3gpFReJQnCDGN5Mp7jIWy8IPnYC
         8P3Ymfs3VE2ljT2lWv8iDBFJPFVBBlYzNEVwTL8y2K3l0WEm1O6w4Dt4B3H25lo3yVXr
         i1vHWKspstRBbZARsnnLED8aoD45TWPXa2laa6Wn1TZ4LkRBnN4ioZc+onbC7c/IB4Qp
         JaAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:dkim-signature;
        bh=pHxN670nTvs1SKv0ysH9qz0K2rs/uzf0jySAKyVqBoQ=;
        fh=QsMHYYh+xa9UR6YBtqLoAf9rzeZXo5Gn51GBzK9Ullw=;
        b=Axv7m+FaDhpnEE+qIerJ9CmWilpzKEVkkSJLFqnBygLLTizHL1GY+UIj8nFkRq6mjC
         Dn2cqCubKIB8ASwH/f77JptQzj21Y1MppUhm2t+iu8e4ZbHeJwHq54cSPr/yyeFi/WdU
         Wc75hddYImkkxPbH9P/HU00LQgEK2chATaB9au3ObhgwMyrI5cfRSW9gOuK+jlFUp5Zn
         y4UGdvkwOGfnoVa8tNCu2AyJKuaUFNNMhxi2mutk05YDdH4CpkcJYwsvy9E5E1ZOsS6N
         galbXBF91364kqUJfYnLYvSlV32E7ZtLK7ucqAW9S9Ds4MNLsQHOUrmPwhWxa7jYsLoZ
         9jtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1791850554; x=1792455354; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pHxN670nTvs1SKv0ysH9qz0K2rs/uzf0jySAKyVqBoQ=;
        b=kLcxJ/Mv4cqfhx696LTAHTGIRpIUqhvCwaTJdOlmnuUi9nsDnQAVcZ5QY25TZ86kYr
         3ofI3GHcibTrWYCPbCt5nv573UbeBqcqz/I2nfADiattlrMSXJWW16IOtP71I28GnVIp
         u0WDImTRN1zRaQ+ttAxsouq/CEcW9MWbQ5DCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791850554; x=1792455354;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pHxN670nTvs1SKv0ysH9qz0K2rs/uzf0jySAKyVqBoQ=;
        b=YSixqsmXgtD3R7Z53PAwPz+YinNJNDsOvTanr7HXqlJhgVb+gdhbJzX4GuPwIEhbaB
         ukAIAEZiBDawR10sp1vynbv2jQsr0lrQQcAcHwNwEwFS7bYrkNRVwlf+D9uIH+uoyEz6
         bPJ/G2vKmMu852vSRMWLVJYHb73jb8hsJeQOa1YhbV06LbUZ3PO4X0D+5hG5/I1ulr8/
         tq+F3r5uDs/u2QwTOFRneV3dBKGJamh7nhYRppX9l7Xae8G0kjbgj2Xo6wx3yRlsmyEY
         99Qa4xuN4W7Y1zy1GtxlhEWINBpWI079QUPab7guyxMHanLkuzIQvWrhXK4LppqOJwCj
         OAAg==
X-Forwarded-Encrypted: i=1; AKwUvBxF1uaWCr6XrKTWr82nmBeRvovDrZf2qB/IApmcihf+DULJPRuqbabflcJzeaTlkb+WX+wWptXGPIQ0tLckpA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLwv6TRYCMPN8ywk7k04pKlKdqQFbs8Jrgx2d+mRmo5T676wShL
	moEdo7ibv4Q/NSCabZyBAGil8yK+RgQ7aiiR70YN4M06VbAE9xFRpNLVxCzjXUkal5rKk03Tm+S
	oUKHuyd1fGDtiHjLm2GRB5goQVXFHmCOEj4RJ6RtbgkqZHuWMrAZR
X-Gm-Gg: AYBFou2DWOi1YRz8R4hUGxJ3X+z7acsaKwvZkVgd+IGkYkBoqfzjnyVsLHfcXAvZ9dO
	640tJhjGX+jHSmDU0dm8kE3uBTUPsTn5jQSF3sGPkv0A+tNBpOoqzI+ByhP1mnoEAh2R/DWp5Ul
	k9rx7Cox7zM8hUOltzW2TjyqHeNMtxS7+ckqVsl0XSZOeDbmK8jXBgjGylz4EdlZGJXGnEVXYln
	SW3EnBnwHvViup6MRDAAbPUANyBD70AlNpxoAyNrGGpxY3lBgSfma+w/cgUJ67GB7ylvSRfXZSH
	Em8s42kBQLCAqSMXx2Cyu/76AFot1hDYdBizqHHomY0xE6Yg7pDJDvVWb3O4UqKZJhksT6GJ3DH
	800Rmdu7+Ki+m1IPK363matnE3/cZl6aT
X-Received: by 2002:a2e:be88:0:b0:3a6:62bb:906e with SMTP id
 38308e7fff4ca-3a9c2b34d90mr26665431fa.20.1791850554283; Mon, 12 Oct 2026
 17:15:54 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 12 Oct 2026 17:15:53 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 13 Oct 2026 02:15:39 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Tue, 13 Oct 2026 00:15:20 +0000
In-Reply-To: <1fc8c339df1944afa6186197337edda3@realtek.com>
References: <20261010-rtl8xxxu-usb-dma-v1-0-e670d9c08fdf@khu.ac.kr>
 <20261010-rtl8xxxu-usb-dma-v1-1-e670d9c08fdf@khu.ac.kr> <1fc8c339df1944afa6186197337edda3@realtek.com>
From: =?UTF-8?B?4oCN6rmA7Jqw7ISdW+2VmeyDnV0o7KCE7J6Q7KCV67O064yA7ZWZIOyghOyekOqzte2VmeqzvA==?=
	=?UTF-8?B?KQ==?= <5mghybrid@khu.ac.kr>
Date: Mon, 12 Oct 2026 17:15:53 -0700
X-Gm-Features: AclHuK-y2NnSiDu1NX9MesgaAauRNR31ntVb3h9H4LXcDaqAPNJtZ-xqh-GtBjA
Message-ID: <CAH1Bc_yOhZ9oqreJOLKb5RDFEW=0Zid=h4xu9oTR51RDwj_bww@mail.gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtl8xxxu: isolate the USB register buffer
 from CPU state
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

> Cool. How did you dig that?

I was repeatedly power-cycling the AP to test recovery of a persistent
queue in my project. After fixing a separate NetworkManager issue,
some reconnect failures remained, so I started looking at the driver.

I was testing with four Raspberry Pis, and different units would hit
the same failure across runs. On a failing unit, RF_MODE was corrupted,
and restoring its initialized value brought reception back.

I narrowed it down to register corruption during scanning, then traced
the register access path. That led me to usb_buf sharing a cache line
with the mutex's waiter state, which can change while a USB transfer
is in progress.

With the buffer allocated separately, repeated scans no longer
corrupted the register values, and ping traffic kept receiving replies.

Wooseok
