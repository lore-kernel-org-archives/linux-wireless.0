Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793481627;
	b=z4L9XHJE/+iTiuBH0sbVE6MvKOIjUC4nPa0r/I76Dt7ifViBvjGzpsnSedL3+Njxx3Mc
	 Z7HK0dngb32mdk1VYWEmWexOjda6rl3isbUWmmtIVMlJ73XUVaJ61vnJ3J1IIpozptB8r
	 XXQ8avHjaSdnkRRZqsxtq/DEEvUDCzXmvtmpTmLRKu0PTq+3CaJ0B3DAa03RVNu4wmvnN
	 +ICEmgoX8pwxT63jGA4469un9xaSaFs1CYtCGzJHRPFmB5iUSN6shtb7zeNX2vfAJNO/W
	 ZyrYH9nozvwhBxFIrhBPL32e889msGIUo8v7jqE/hmNE/cfpZ3sPLXxYAgWcYZlbOlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793481627;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5oO48QroBf27PsYGGHmHN7zXVNR27HEcFdEaw8Jvf4M=;
	b=t9cC3ajSUnlcur/fAuBu8paMXjyUdpQSqJDO1VICE3CM6A9fuW+QSIbYfg6haxDPKbk/
	 dsespmIXee6iwC4ET90jL30Kl7PChEnOu8Zgnynd9T3HEeTUqSICKANP5x4A3lR3n6fWe
	 d2qi6JMatZikkAbHkXh3dnVQpHfuDsC1hCZRTUiZMkqCkFzQXAYBpXaG13PKe346WAVeM
	 /ABE6EwDpVL1IMRqHmm0Od+wPJIiSPhd6IjgDa9HRc5JE+82qq0m+GzWZLszqyqieKsy8
	 BDmMOjVFr4HNATqMmYVqjaI7MMbfx2Wj+88skxl4/wT0GDWJjeh9XqVvLu0zr8cEXFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bbgVpCAC;
	arc=none smtp.remote-ip=209.85.219.44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE6C606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 21:20:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AE6C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bbgVpCAC
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91c60e30054so20491456d6.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 14:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793481626; x=1794086426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5oO48QroBf27PsYGGHmHN7zXVNR27HEcFdEaw8Jvf4M=;
        b=bbgVpCACNIJKaEXqjXPbwSCtT/Y/hMmvrJQ8UlU8JazRNUb+I4ByO46ZSWAIzFpToM
         gEd76yJjwfz4K0AT1y2UO7Gt4UjhAQARZzLwsnXY3ByYYt6D7zhEbWA+N6Kq9oFZYbzZ
         nxv/PGKp1xqQ3tCkuaDWPIp5L6GJzlO+k+03msKXCfvnm6stlGJdDigc07pFqE/FDnty
         yrncJyM82Ke3Sl53VoQRJxfaOmb+6JpBFjIchZJjBOUCltbh39Nnm3vBCOXjRMuDwpHS
         QqWclIzs6bc9mqa69c8OdAFD24mjE71ifQw7mp6Up/X5xqY80eLZTLrxTT+v/zEPngxl
         35HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793481626; x=1794086426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5oO48QroBf27PsYGGHmHN7zXVNR27HEcFdEaw8Jvf4M=;
        b=IFcccLl0a8mzI00JY1qHdsYLonqn8vdqBgAPshd9f6bHbktIdkNJNAYLMXHYK33I92
         aVnQI3Q+snecYWMtneV6DFqsNFF62NzS8cMcjuYw2V5nS/rHHwoxAU5SYEbXYgZeWgzB
         hg/zbTsmqnworQaeZTdBzCE+X4/ttTrWoHgA2Vf6WvzLQdu9vuXfDKujcMc4SKhQ3zA1
         L1YdjzR2aBHhwECT9ld3LQ5Q6AAtYt+gYbhlTZe16KufkQTyV9IA6tK5PejwK4ECSW+Z
         /q72g4fqHsoknAUCy+NNj+dDJsEphyLIlcDxq+H0JUpyt4X2ty6lRiTPIT2PFE0bjZ7c
         h1hA==
X-Forwarded-Encrypted: i=1; AKwUvBzDk7MjOKpNRwRP3mmDil2gF9Tt/innzeV0CRjDWqugE8lqZaoImFOtAGlKkd3EX9uIqx+kDUlECHh9TCt0mg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKCUV8jPWlY2Z1t/aKNCJmTwiadzWP395ytAjFQxUjJr59SS/6/
	+tBB1xQnx7fVrvVpIZygpXcWctXpmqnkv8ey2FMQLymM8z0pNXIbj2OMPZBbWtob
X-Gm-Gg: AYBFou00YzwEAETcAJIjWq5BZH/XvmngnGp5U7EB74cGgo01kOnx3WjuJER/xWQbgJY
	2h2ODV/1FYnrMmQwjaHCWlLolRSm+aTwq6v1SO+FT79Ogs0DXcok4z30DEe+5/u9ypSaLcFzfhL
	ljTHNhKNcYmPjlSI8gw/5bF9tWXMj0ZaLUKkALdwyVxt8iGjLSzvRU4cpKP22QTLk0s0IhL6sah
	90L+B/wrTQkJOCGuA7s6cZa1AQvwU5ScsPO7WwwDBPoApmB6UeGDaDLgCzxO/ffrMzLq13800ae
	GWdXChGCrgF66T7m8HgmFkmvN6W56IGUCfTIhWGK7+qKblAPM9759xZrD4GJItPYCQTEF8MSvtj
	wWaGWnDJZMyRXgUcIxbzyRBZJVycSuGRkCwqWCMMYUxN3IWtfZTZcf7nWMbLZlmLn1r+Z/JISs/
	Ng0VCB3UeSKDQWXEsxdsk8WI3YSRylza2I0pkCDMSuNwXImDsK8R/03RaL47c08j1yWTG69gM6u
	ViZmKhzeQzwUkoEmOc5lj74FYAibDUr0LJz5NSoq/znvRQ9EGNHHoWtf9lvTDRHaF4wdHmZ2Zxr
	5yTRFdJW7JCGGSAoQ8lZHyQJui4TwNjurps=
X-Received: by 2002:a05:6214:dac:b0:91c:7bae:44d4 with SMTP id 6a1803df08f44-91ca4b8ac36mr101071016d6.49.1793481626582;
        Sat, 31 Oct 2026 14:20:26 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca805239esm50019006d6.28.2026.10.31.14.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 14:20:25 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v9 3/3] wifi: rtw88: time the countdown downloads from the TBTT
Date: Sat, 31 Oct 2026 22:20:23 +0100
Message-ID: <20261031212023.3296837-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6a4c37826646abbf833e49aadee7701a3dd4e96a@linux.dev>
References: 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

> Could the TSF also be read before rtw_fw_download_rsvd_page(), so that
> only a TBTT after the download started is taken as one that may have
> sent the first count?

You are right about the bug, but the TSF read before the download does
not cover all of it. The download is two writes, the whole reserved
page and then the beacon again, and both clear BIT_EN_BCN_FUNCTION.
Measured on an RTL8821CU with a sniffer, from a TSF read just before
the download:

- a TBTT before the first write (0.75 ms) sends the old beacon;
- from there to about 0.6 ms after the second write (2.9 ms), 82 of 89
  TBTTs sent no beacon and 7 the old one;
- later TBTTs send the CSA beacon. v9 reads the TSF at 3.4 ms.

With a count of 5 and the TBTT forced into place:

- v9, TBTT 2 ms before the start: count 4 never went out (3 2 1 on
  the air), 6 of 6;
- TSF read before the download, TBTT in the download: lost in 5 of 6;
- without the back-off, so that no earlier TBTT is taken as the one
  that sent the first count: no count lost in 12 of 12, with the TBTT
  before the start or in the download.

With a count of 2 in the v9 case, a Windows station re-associated after
each of 10 switches, and after none of 10 without the back-off.

So v10 drops the back-off. A TBTT in the last 0.5 ms before the TSF
read then sends the first count twice (4 4 3 2 1, 6 of 6 when forced
there), and the AP switches one beacon interval late; the Windows
station stayed associated in 8 of 8 such switches. A lost count is
worse: with a count of 2 no CSA beacon goes out at all. I will check it
on the 8822CE when it arrives.

Mehmet
