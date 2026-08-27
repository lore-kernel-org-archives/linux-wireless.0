Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA5F4252D9
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 19:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787858450; cv=none; b=O6XraAAGDPGLXKyU4X3vtIiBL0PrdsYxmD6pATP8spUQMg1OEf9u/O3x0N30mbmx7ukoc5JWFxdzdciX16II52/fN7Jh6vIUH2ATF+pEf5yD0YwJKHZIepENC+LkN++Cw9OQ1JZuS3FApE/TEMolKzWMfc+y2nUOMAy3u2Hy/qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787858450; c=relaxed/simple;
	bh=LeKjYL5+yTA3NfXPZPt+LEC+alaKDyr+SYK1msxENcw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=JgBu30DHsAjQYcCN6WMaiixckoPyWtNck8qVEqaRaahAdSiYWddOor9yYNvbeg9A97K0VO9BgrA71ciJMAt64kKlSYoCILppYiskxST08j7Cem36N/RyuuB1mUPpXjOzDgqbCL3K0cvf8Qcl2ki+n+ZWPzdkCIM/B9puii4tR6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b56HiDHt; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b56HiDHt"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a17211b9ecso277522a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 12:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787858447; x=1788463247; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7ci6gaSLreVAxo6xpjQcp/WLCj5FsRQyspYgaCCbiJs=;
        b=b56HiDHtqXbkkf38mIOvROZrY6+RRLalGOHF45mQYf4iEk30V/dTzTezFR1+Yzf/4H
         oJwf4ruwnnumjHlxsj3NuURTyV3jJkzW0uNMsTyVdlGs+pBPSp4e6kfklmBDx9WrJOfL
         9ncAKpK+lV+u+ZQl9CewAhZ747gmki+zXOO9jz0iZ+m6TakMZmq0I1wp43uIdhMK35Ln
         gMvlhUGxM6BCnCHG7GgPSGpDyN4+nxYYJcxw7XeiAJZngtGredkwVI/3/HE3c4gbxHyi
         9GGp4IjZlJ36dP/rK5disPAC9wuOwuQpcfKrnFhAvE5I9vTpedQofKt47pJZvinN0Ebt
         Wgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787858447; x=1788463247;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ci6gaSLreVAxo6xpjQcp/WLCj5FsRQyspYgaCCbiJs=;
        b=SMoPqIYwuF/NFIvaxUFoUEC7aqIENIXSeRxLKNLrk+fe/e7C8cQOVSAHHp1FRIgzxO
         U+PcuJAHu9+7/B6ZvwOT9oRv7uIM57keP6dLJgPWHusBEJpULLZX39GfJwICV7+Gp3aq
         KDW/G4okS9eBRC2sPux85KJfR+F2gWObCcJLTJ6X1LTKvCG7fW7NgCKQzK7fFrLHA+oe
         pJDa51yXPby5LD6WDbMBmw3B1SjsoqT6fd6cnw8OohK2yFDacJu1n8RtJtCEhSl4f0jz
         QCADuvrvZ52UsRbSC14tsvUMQL+O81VpKYWEjMhsOYVN9B9IctRbZDm97CbhgrGvPKNs
         2ing==
X-Gm-Message-State: AFuF++mbNe8AoS9bk6rG+TihzF/fWa0MiJMCFEUnBAEiLq2uJwjTU2KE
	RGLZxefQhtv03MM60F5ZZAYxJeF1fanasY+735sE81dBWic0GH4igzqyUaDONg==
X-Gm-Gg: AR+sD13jTvshO/sLJ+yvcIIhKhgMTbaZDnf4AwvblQFDMqlB3Zkn0cwsOyMZP1ltt36
	0H8dbhfbq6LLtpVCHUD6uvAqcFCOf1hGilJyiE8E09Jsq5YP1NWGAHvLOLidVAZPD338TkFCdgD
	QwWG4uW0xI/Zr2/iAoimo8jTn2mr9OhoWhTIWNAknApuIxn5DS9LUoyoafSWhg11/1Bhlshcgzj
	35orPrNyv6kJ3ml3W3N1f+uBP2nM57UfHnMvqf+Bjam+Gt9EMkUuEPCz7fRx8wip/RXZfYpSfwW
	noNfv7J8e0ozGH1xnmBswz+V6f05UuVAwTLQY198KuQmqlRCAkVZMbHe4EbcNRB79AHtBQrf7ou
	a1Nb/V95jd5QPq/NwJ0IOQte2Fxyx3lK9cl0Yd1JB3bv7cWiDKfZz7iLcx1JXc8stv0VHPCOTEF
	48rMr4GeNjSAIl0GspMewzLjMozXmFVGVD6ejOY2IP1FlkKYZNl8Czvj1yIz56U6V8YZCz/94gi
	GreBA==
X-Received: by 2002:a05:6402:3605:b0:6a4:ae1:333a with SMTP id 4fb4d7f45d1cf-6a60d39964cmr614064a12.12.1787858447016;
        Thu, 27 Aug 2026 12:20:47 -0700 (PDT)
Received: from ehlo.thunderbird.net ([217.196.163.190])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5de8d0b71sm6269444a12.9.2026.08.27.12.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 12:20:46 -0700 (PDT)
Date: Thu, 27 Aug 2026 22:20:44 +0300
From: Bohdan <boulderobscura@gmail.com>
To: Mark <markmunene827@gmail.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BBUG=5D_iwlwifi=3A_Comet_Lake_PCH_CNVi_AX201_=28?=
 =?US-ASCII?Q?8086=3A06f0=29_fails_with_error_-110_on_warm_reboot?=
User-Agent: Thunderbird for Android
In-Reply-To: <CAMSTZOkWe9C2pGS75zX=_H4_Up6B6qSddkUPeaU8=br0geh-xA@mail.gmail.com>
References: <CAMSTZOnSYZjqj4AyBpLg2hQfRs6JYZA5H26MwQ+G2WMGgNzBkg@mail.gmail.com> <025FFEEC-E57A-4C74-BF1E-D273253F4D9A@gmail.com> <CAMSTZO=2dm21hYcKKeDGCTb4KJ6R0ukDAFBQtsp4QVzPmCfcSg@mail.gmail.com> <1EF6CC70-90BC-4B9F-9F96-9DB1F3A69F1E@gmail.com> <CAMSTZOkWe9C2pGS75zX=_H4_Up6B6qSddkUPeaU8=br0geh-xA@mail.gmail.com>
Message-ID: <AC809A9E-A3B7-4DB4-A267-7A183F60CA72@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

So, the firmware does not really tear down the state before going to sleep=
=2E

Try this instead of modprobe:

    echo 1 > /sys/bus/pci/devices/0000:00:14=2E3/remove
    echo 1 > /sys/bus/pci/rescan

Also, disabling Intel AMT may help, re: [1]=2E Could be Dell screwing up B=
IOS yet again=2E

linux-firmware version could also be useful=2E

[1]: <https://discussion=2Efedoraproject=2Eorg/t/wifi-not-working-on-dell-=
latitude-5420-intel-ax201-device-is-unclaimed/169425>
