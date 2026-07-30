Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18CF376483
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377836; cv=none; b=KVIrU7xjbjGvZI7DQOFDX85ITL+VCR+mJ6XCaPm/iLLkdHoJFH27TRGOdjBmE7NZ7RJ4Fe54afbsgJVxbF4eUoXE7JOkgEdVOTItnJreBcwglKx/2jk6tv+zsNeDNF+Ru+7WT5wYOGubiMoABl7F+rQePkjC1XcSsEMv41rZPhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377836; c=relaxed/simple;
	bh=khsmZgJKT9/IBeIlvEs/hMaMAC9DItOZ9XBcqu1LjnU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRIJ73LLgR7tO3K+m6aq/vILPJffUbjl3OpsfQpGbLt4iLEbrhr4K/7q/EpfPrxI5i/m2Yr65llwpR5ya09xI+KVX+irhRgN+G9RJ0MEvlWrFSTEYu+NvBJw1ex4iycNFMQhpCDZQrLzDA9RMApi4ZXvnedX4zmnYFAoIZttW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2ZmvwFu; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2ZmvwFu"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cee9b74ee1so13343775ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 19:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377821; x=1785982621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UGoTLKKfs4+hUb1Adf9zrnlsEvil0MdoNex4bufgTIs=;
        b=e2ZmvwFuHiF1UHhAysi5daU9rpY1HsZKKYVfOlNedkSvvDfFiQwIOaDyPamWxxr3+Y
         4YCNHxFuHK7bcWb2xbhZ6A8Eg/l9IAhyIx3s2vUc7OQgjrSzcLwE9pIbsTYyvwf90tt8
         WnLhaRVC6CPXkCDTYY7B9DtTReMWtb+3sZncUSGbiokyLGwq6zD4x5I7vaxnJw4LjEpu
         P1RlkhD04BkXSbQU481e9bfzoK6u620lbFhjsKu9Zlhebq85nz3V6TEmYKl56MStKJwn
         6V89wTx13iLBC9yphGPi1mMr9FchOaTnoqC+dFNHOpCxWYysGoe0v31dl1WF3p/niJgk
         kxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377821; x=1785982621;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGoTLKKfs4+hUb1Adf9zrnlsEvil0MdoNex4bufgTIs=;
        b=H2LoXcddchZq1rMa8AjgirSFk8I26eWS9MwszKhHB+u07P3qgsXXQBPRIGNQg/C0Qq
         5hZpkraj+OTHIb3hRhOon7TF8SxPSXtTHlxeDH5UTN5c+OOOH4Vq0UiojFJz4BDpo/kl
         WKR12Bt1JQpAx9BveA8coAJifaAAc4w74zveHHGzojuuz1cXLDuWtWiyUS6K4EEbNnWX
         F3SuhHu6/us+WxHwjMJSKNR5WuKNGN1wa5JXnYxOGVV7SbaE2HcMTAsKMWm8siqntfJ1
         7ltCZTi6ZyqMvm/2RkFykqH5MnFcUPjWcdXm3oulNBquQCm5O4CR4gi4kn1z2NAyql2e
         Ltbg==
X-Forwarded-Encrypted: i=1; AHgh+RpBnof6WDHpV/4L6Uklnu7tnp7GRULe/lwQJtHDams/7m6D2ogHDJMeQnqjKVQvnyx42LqwBonxoM6WICGSrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBbuC9/uc2lJErvCB0hszwQBwz157sEzBqClkY7pnYzIGWlyhZ
	PW13mjLtVNIfyl+N8xY0RjYR0F/X7W9kKLPimdTD8+WcvTB+Rk1TCFlE
X-Gm-Gg: AR+sD11mhucBXcBXfCCzgQHfZIRKowmcAwxRaoF2KsgHX7gO5Z/uYXFVNDYiKnIluzv
	u0KmN3o38lnzjn95yPX4k1C+s+JbaQh84lB6RNGL0Py/dlanvJGRDtishiU27TOzSXGLMMFB7IT
	BcfZ6BlElSdo7ch1AH8RPzRLOQ8T4KPVL0p7Bx3l+/rnkRFGEOzcw0xCDyrkynX9oye2peDIhAa
	QAwYylPk9Q+iRYGGBifq1n1Sk+Bn0bQnZdWDuzZSBs+qUm8W0Ka+pD7yGz6BTb0WiNMzCLh3913
	FvugWvDnaxOK5b8ynzhI4hFsJZukCcDBp/+4x0TXtXY8TBGqBf8SNtLyDU4i8TTPibDjGO7DxJ4
	1LSbzfaB7VtIclbf/7jqHMayDvx7mI3I3p3krRXT8o+M03deV9BLFGoRsC5ngNrPtys7lBgJ1Y5
	5tTpCi83XgseML6JTk+Z//j1rZaf//82KhSfoOPVQ5uw3IO205m+ii+9Qi27dOsIOFKZt0JlGWA
	xIuMUndlO6hrSEScZzZ8wnwaBLIf/FViKu3kq7UtVSopoVnG76wWYA=
X-Received: by 2002:a17:902:e551:b0:2ca:5a42:d8c5 with SMTP id d9443c01a7336-2d035e3c524mr8179935ad.46.1785377820754;
        Wed, 29 Jul 2026 19:17:00 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-203-195.dynamic-ip.hinet.net. [61.228.203.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c37211sm18553575ad.78.2026.07.29.19.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:16:58 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Thu, 30 Jul 2026 10:16:50 +0800
To: Georgi Valkov <gvalkov@gmail.com>
Cc: briannorris@chromium.org, francesco@dolcini.it, johannes.berg@intel.com,
	kees@kernel.org, miriam.rachel.korenblit@intel.com,
	wenst@chromium.org, rafael.beims@toradex.com,
	avraham.stern@intel.com, peddolla.reddy@oss.qualcomm.com,
	error27@gmail.com, s.kerkmann@pengutronix.de,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: ignore ROM regulatory hint on
 WRT3200ACM/WRT32x
Message-ID: <amq0EnoZrBA+8W+J@nxpwireless-Inspiron-14-Plus-7440>
References: <20260728103536.25012-1-gvalkov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728103536.25012-1-gvalkov@gmail.com>

On Tue, Jul 28, 2026 at 01:35:36 PM +0300, Georgi Valkov wrote:
> WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> from the mwifiex ROM, which conflicts with the platform regulatory
> configuration on units sold outside the US market. For example:
> - phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> - phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> - phy2 mwifiex 2.4 and 5 GHz, hard-coded region US

Hi Georgi,

Thanks for the patch. I have a question about these compatible strings:

>  				if (country_code &&
> +				    !of_machine_is_compatible("linksys,wrt3200acm") &&
> +				    !of_machine_is_compatible("linksys,wrt32x") &&

I checked the mainline kernel source, but these names are not found
in the DTS files under arch/arm/boot/dts/marvell/. Instead, mainline uses
"linksys,rango" and "linksys,venom".

As a result, this machine check will always fail on a pure mainline kernel,
making the quirk ineffective.

Jeff
