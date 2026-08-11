Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE15379EEC
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786484281; cv=none; b=jVeEchC2I+K/+KaQ0sCxMOX6MwqJwucFTt3DO48v/qIHkNTZXxs7AziQZAjGee835sVplhDgubpu4ucb3OO2AeEOJ/FZpX+LKoRY7InD8pE3LrIvV4u2EN7YvEZ46+8sIInxlUrIjobrShxu5wMGVXmQvvO71xYx9qLlOs0qBjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786484281; c=relaxed/simple;
	bh=EENKOAEi1CFTMk1kxLlEmyAv3Cgs5woDZ6jeYsRg27k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKFhZbqvdlEQVMXvayjXjoF1oSp7xcV2HDHCrUrMkuctEBkY9eYaZL4OqkInDVZOOrXbR5iXt3Ce2hcHZ3rN+8Vt94GlWHciFmw1TnWto2Ji7owgNbZVPv8WwDH1/EO1Z8vhFxftdnR3Shsmx3dn1n8smgy9+QmF9mjj1ALaI2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=iUCzvugb; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iUCzvugb"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so288611a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 14:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786484279; x=1787089079; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OkNpzuLg/ZEm+U0gq0svKhvkhZF0MHipzZTh1fWVnbU=;
        b=iUCzvugb+cf9HHOlRRWC2X2qTdY/jzs3IlKvd2DLJIny1dkoTt8FFG+WoWIzsyaPKn
         viTekqfJcNrYsQAALu+2JE2hZO5lrvS6DtRYAcH3qJ3U8fz9KIIzFLe1+q9HpxeubUwu
         xVtradCFomZUxHQGFczoMNFJ5pm32GMPM9CY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786484279; x=1787089079;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkNpzuLg/ZEm+U0gq0svKhvkhZF0MHipzZTh1fWVnbU=;
        b=WIQDWoeXXTmd7AslMDWpZ3QruVBGZsoAefZ6m4PbM6Mu7e6Ijmy2s6iGIqJNYwHreF
         /zuv8jjpPx3eJk1tw11fnmjkC7ito4fxUwkhTg/IpMO6SLPr9dfEm0znBjuKZ/5bk89X
         qtLJvnv9gibymz6lB1VD16bAELn9wGV7zk7QRGQ9IizCuNzESXWOdBAhDkWS7501j90d
         BG8MHtosEPAMMsk5bwMWxW/6LwkdEQh+Ve2MuH8AAYcs71GLYEjgX2HUGcMn3MpUuOJB
         Iy4tL62rlJOJNpyOD4hgACU/qavkeEbwJPXx5w6d2wwnUEU63/9fW2svnSgHFos2zBwj
         HOqg==
X-Forwarded-Encrypted: i=1; AHgh+Rr4gW6ZR7jgtKJUM2dXo4B6xayA/YraJbTZB4K78KunwmNFOyosQFdCC/ShOqywknsRPMj5BSNcgHHGC39rIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMKGpyW7aUGg8fB8VvQHvsO6K5caCbB/4IcKybTRPMuftYmVBi
	n0L0BP2sil1PXdrfd96UbeiqCEnJDbvvUx2auo3GzDDatntywANJSmMGfVYoumbLSQ==
X-Gm-Gg: AR+sD10ZaPbe4WjNplLpJzAzdknkKU1Ep3mzRv6LbH1StPNuJ0QLqfeYT5yn4uqvx1+
	e2pS2TOGpGOfu/ZKhHCLxaKY+uEDe1dbT673xWcVhcabWJJxk4yNrk9+h+v9fT3OL1IaCUOh4FN
	VZA34FGb/m61Clh9byep1ooW/+LcK8PLks/JQqDx6/gnYqY9/+osIWaDNzQa5SaQ6PNOalMEZzE
	fgXcg+ImzTT2zcK3OEgX516yQtg5n7VrbwoXC0sgaSYDiwGH/HWYTz2aETKemYJ28UXQIZdqYVr
	ao0YXj3G1s7/hYeCuF/4d7d3UZol9uSUC1wSERznsktF9BtRTGJ876YsbXgvRGpzCIIUYqpyxiI
	KbyoPFY6F5E4Ub0D+rQahKt77jyYSfRUxkH9Q9PFu0TdPrTockcNzzG5rHnquf9wGVZmSeNbc62
	N0F1ohlsccO8reYNE0aMxqWtyIUm9H7OCOWHO8+AZ7gaZjZnB6EcNQnIlg2cARDq0vRuzSj3sjg
	wj0gG9CUX+2jaDyYesUecIYJTPap6Sxsq939w==
X-Received: by 2002:a17:90b:384d:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-393013c423dmr53082a91.4.1786484278807;
        Tue, 11 Aug 2026 14:37:58 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:79fa:d268:80cb:4947])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-31d39e5ebe8sm1112555eec.21.2026.08.11.14.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 14:37:57 -0700 (PDT)
Date: Tue, 11 Aug 2026 14:37:56 -0700
From: Brian Norris <briannorris@chromium.org>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Jeff Chen <chunfan.chen@gmail.com>, Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH v4] wifi: mwifiex: validate event lengths before copying
 bodies
Message-ID: <anuWNJn3BnZDsrxB@google.com>
References: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn>

On Fri, Jul 31, 2026 at 10:20:02PM +0800, Pengpeng Hou wrote:
> mwifiex event packets contain a four-byte event cause followed by the
> event body. The USB and SDIO paths copy from data after that header using
> the full packet length, so the source range extends four bytes beyond the
> skb. The SDIO path also reads the event cause before validating the
> packet and publishes oversized events without a copied body.
> 
> Reject SDIO events that are shorter than the header or whose body exceeds
> the event buffer. Discard them through the same free-and-break contract
> used for unknown upload types. Retain USB's existing error path, apply the
> same body-length upper bound there, and copy only the bytes after the event
> header in both paths.
> 
> Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>

Acked-by: Brian Norris <briannorris@chromium.org>
