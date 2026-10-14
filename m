Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2419B415F07
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 06:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791959559; cv=none; b=IRAP2hENxqcEvrshDmTo79rl5ub46qMr+4XalBD+6jvJZFTLUj9cVgDU6gCap2VVUZaXUbbe/ioJH5eZuq0e65qEMMhR3CI4lXmN4TctyLixsrw9mns2i6jm2aQrglFeG7mPKbJab3VHoAkIk3corrUE74SWczjzNx1MlgYKkZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791959559; c=relaxed/simple;
	bh=sjyGjuaOo9/vHcb+IbTS2DVHgGpXc3OSvwGNsBFoIOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZngOZDKtIHDxoN5xA2HeTWh8+xImIYsM2iQs8RJk/eINfgSelbc4gzfejMhp0J3//Q83nd5dOsJlN5+JsqSSghDXGPGakXzDpn2iSMh64BCFbEvUp2wDhEDY/Uwmebv9/6KUJOyLiufhG1VY27cX6mABrTKKAqjZK0UXGvW4vgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaPSQ+49; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaPSQ+49"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso4774645e9.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 23:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791959554; x=1792564354; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sGb7Qa4j3zof/aea6Plo5mYkv/zYwHfFJsnUJBas6Vc=;
        b=KaPSQ+49Qwowgz+kcOrISKyKkzZl2B6+6ZPsapvt77qs49ktbU3hTz/1MYv/51u8es
         pcVzVOfaFUmBXFcQGC6URo+bUk/YhpXnzUVHQ8xGsl3JA5WHcVNH2SgrEfzsGqWGaNKu
         V/rnjr/zeb1cIhWWr44ITDJAYwvXU1YBka/AJSN7pbEuFPtNdHzFwI7/qFDNTwuWszvD
         y1D0f12Zj36WIfBJJ4xbqH3Dn8LWVGxNWy+t9UUJXnNiVq8uUjUXfci2DXNrCvWVvyQ6
         9peJR0x8M5SyQ40Pu65SkDOe7VCJ3TMD2wWI7tSrUNGRgVUiF+wpfOCRbOn14nzSruXs
         T5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791959554; x=1792564354;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sGb7Qa4j3zof/aea6Plo5mYkv/zYwHfFJsnUJBas6Vc=;
        b=wkgP3mOv9uVPvgozpYQFO14juUcmKR3Y3sbkMKoADXGRBkXsNwSnl5/3nFxHoYMZUx
         N6sy7WpZhxbeyNw+5Gz17UQhaT3HJpsVqoGOfk6o4CZJEBk+AZp2RKqm7MYXsmkNftrn
         MkfPejOVZCRuIFW+5vja7OLwK+43easLE123tenNTVPl3DOhyfedqHcCS/gugD7O2Eai
         gdJye0LmvF4pMf4Y1tsxybr7wHtGoGAQaRT72GsxsE8prvVGA2AimR8RP6wJB7CVGIo8
         UKP5PNm8RVijtio++2zl3asbNzu5PhwyoDdj7vhzzpM9aL/f1pVTMGu2/i8wQ0rL7z4q
         cF4g==
X-Forwarded-Encrypted: i=1; AKwUvBxFk2PHx1GdSeFOnNS/EG9y+rtXn9GfWUKdzyE4aBYoRX4Q1LsjGvMhAXQ7HCaJl7q3JBv0s4osBFPeFzyL0w==@vger.kernel.org
X-Gm-Message-State: AFq9FYKtZvnU9BdZsifoxA0OTz1UWLl95z9+IarYyOJ4QUvgWh4NOKPU
	Pk4I9de66Nkol6H9zQ378fBgZCI4qCEABkdmrGOzIfl9SelKjJ/rM0D+gMwpuPqe
X-Gm-Gg: AYBFou3A4CcYi56wiwUAxY3pngx0J8dliD0KyJQuy4LJFxzIcWFxD9AjM1pfg5uKxGP
	g9lMnciM2AttXOEYYrbPY/1T4I/22tES83M39cGbHHVm02OkNn+UpsJQj2C77tavpGVfxKOWPVT
	P97HJL9hUfMhZkvbx2/QgLG5dUXxdpmD/g4XGQbFxeDZXUoBLKJPnvej2wF82vXKTzi2phWu8fx
	TtJXCZC0UZKb1pS15f9OsdzGD/YlWPY1SGx98QGGcmV1wqDM3I9mmMW/yGjOqyxUc1unANg5/4Q
	/exidCAj842EdQ+yjpcR6RA/qwja4jVUYR05fqZTKxsOFcmo7nyFKOiZtPNnSEA4CkvJRCtJL37
	CssqIXP3xdQ7h0uqs6fOEjHVCMnvb295uDiuaesjIUtOrqbZzL96scBn0xe7rPv3ZrmiaKvy4rn
	uD2XOHYkYBsq60+cHcjFPvxKPoB7vXNUGxAgWjGJkRICi4/A17L+9qVLJpkFEilbNEmvlf8e1c0
	A7nzV/aRdHLt39txtvwsGhDFn0sdCLWLxRVQmvANyNCVFjHV8OZ7hJAxESVIo8HI1153C5a8KD7
	AxhLjgR68CZGxRFnxw6KyoZQE7Zwcrl6bhSKb/GB0mUY/BvM7MzAGma6QAu+WbmP971SpOpdzco
	=
X-Received: by 2002:a05:600c:6289:b0:4a1:a475:d885 with SMTP id 5b1f17b1804b1-4a1a475d8acmr123458085e9.34.1791959554036;
        Tue, 13 Oct 2026 23:32:34 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-aed1-da01-ddff-863b-8308-ab16.310.pool.telefonica.de. [2a02:3100:aed1:da01:ddff:863b:8308:ab16])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b481b7f8sm30442425e9.3.2026.10.13.23.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 23:32:32 -0700 (PDT)
Date: Wed, 14 Oct 2026 08:32:30 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: jeff.chen_1@oss.nxp.com
Cc: Jeff Chen <jeff.chen_1@nxp.com>, 
	Francesco Dolcini <francesco@dolcini.it>, Johannes Berg <johannes@sipsolutions.net>, 
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: nxpwifi: fail the firmware download on a
 poll timeout
Message-ID: <as8hr5eop0BBot33@gmail.com>
References: <20261003192256.78255-1-kmehltretter@gmail.com>
 <asw9+ftcdKi10UUU@nxpwireless-Inspiron-14-Plus-7440>
 <20261014060943.3492064-1-jeff.chen_1@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261014060943.3492064-1-jeff.chen_1@oss.nxp.com>

On Wed, Oct 14, 2026 at 02:09:43PM +0100, jeff.chen_1@oss.nxp.com wrote:
> From: Jeff Chen <jeff.chen_1@oss.nxp.com>
> 
> On Mon, Oct 12, 2026 at 10:03:11 AM +0800, jeff.chen_1@oss.nxp.com wrote:
> > From: Jeff Chen <jeff.chen_1@oss.nxp.com>
> > 
> > On Sat, Oct 03, 2026 at 09:22:56 PM +0200, Karl Mehltretter wrote:
> > > nxpwifi_sdio_poll_card_status() returns the result of the last register
> > 
> > The patch looks good to me.
> > 
> > Could you shorten the commit message a bit? Please focus on the root cause
> > and the fix. The details about how it was found and tested are probably not
> > needed.
> > 
> 
> Since we're approaching the next merge window, I'll apply the patch
> with a shortened commit message.
> 

Yes, thank you. I hadn’t had a chance to shorten it yet.

Karl
