Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.194.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422695;
	b=rtEAEdZbvCfpbYrLLncxi/2/HZTE1ZEaKvsp3BT9QRV6HP3qjffw2rNRa5KaYhaUJx6i
	 sTOaDDfJtA4mC9WZWHdSm4wNipRt+EyNLbGJZGqWdsg68EgH4bXBfwzNbRmIxHxV5ya2C
	 KTNovyskmI/yJLqMWsdCArKsjTNSLCn4bHcXY0kN5eRfvcp82v08p2vsx8KnyWWgDspsv
	 BnKAnFn6gaWfuLJxqZQJ69SLEyVhgtPQhjbRK0QbN5uB76VhtUTXe0NhZzxA6uyypd4qs
	 XqAEFJOX1E8GhuELwhYzFwRfZWAsBMapeu/NP6f23hkmvhL7jXpRjA16VAyZqdj0dow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422695;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=qmln5cEV25ZAWEHD7qA3oI9nNi3QjOqCyJ5NW9VZbvs=;
	b=npXVx1WT7VuZjV8DegKsqRQIIqO5+L6uRq/ClJP3EBG8Y7q06L5d/5hlxW42XN31Wi+H
	 WKntWQOQswP0+IhbdliF1sH9h4yji9DFi4nyoseLHgwoa+j/Wnx5fasqYFLy9y8aLnRpj
	 JRZr+IRuw+hOuNDt5Pr4hNBXYy7sDDKWl1/KGYL2BZoy7KK5z7qpf/x69vcaqjZQH/hHG
	 adj+ejMf7pu5wOk6VOR//eTF/Q/O2FQK51GlRiC2lxga1ZybLMOyE7qqcfSxzHXb0Dx5D
	 YBHC4TY0Q8Usjp4UGmnDtRNoCQRDjSuRasYV2PE/enrq12dF19efWYLhzTRH8uss4/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=dolcini.it;
	spf=pass smtp.mailfrom=dolcini.it;
	dkim=pass header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=cxmNA4lW;
	arc=none smtp.remote-ip=217.194.8.81
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4221560892FD
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 15:11:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4221560892FD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=cxmNA4lW
Received: from francesco-nb (93-33-82-233.ip43.fastwebnet.it [93.33.82.233])
	by mail11.truemail.it (Postfix) with ESMTPA id C4C4A1FC0F;
	Mon, 19 Oct 2026 17:11:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1792422685;
	bh=qmln5cEV25ZAWEHD7qA3oI9nNi3QjOqCyJ5NW9VZbvs=; h=From:To:Subject;
	b=cxmNA4lW+9WtdcCN6CxJgLQd0zvT2ybwHeTDue+abdVLIKLTKHWuCHgb+y4caOwjV
	 gHJ4drYCjPRATcppaH/NuP2/sQlZQIWA+H2uiW+9y7r03oJG9+fASw6TUh+o+5kIbI
	 19nIn3w5Z/YgRASWVNHsIg21oZohx2GmOBZQlfzRQK/Gsbi6MoXu9VngyyE+FoXJW6
	 JoVWij3lLbr3gjH9JiZssFIFLnU/0wE5PjaLRHHgAEZUgNKx0kOub+pVKos29zxYTO
	 hspcfu7YIVdAMtfBVJWAn3TNNosW/QhFVhj9txPgjrgPohgYSO1Iw/2pkt9WbxllHx
	 MfEx/Yx5jQvnQ==
Date: Mon, 19 Oct 2026 17:11:20 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Francesco Dolcini <francesco@dolcini.it>, jeff.chen_1@oss.nxp.com,
	linux-wireless@vger.kernel.org, briannorris@chromium.org,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: Re: [PATCH wireless-next v2 1/2] wifi: mwifiex: append hotfix number
 to firmware version string
Message-ID: <20261019151120.GA3162@francesco-nb>
References: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
 <20261012123624.3147417-2-jeff.chen_1@oss.nxp.com>
 <20261019141347.GA118352@francesco-nb>
 <6b94b803c6424227f6ebc044e0ff2e6b90c180c9.camel@sipsolutions.net>
 <20261019142809.GC118352@francesco-nb>
 <c90d2612d4ea4a49e41c93b45133329440a4c727.camel@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c90d2612d4ea4a49e41c93b45133329440a4c727.camel@sipsolutions.net>

On Mon, Oct 19, 2026 at 04:49:57PM +0200, Johannes Berg wrote:
> On Mon, 2026-10-19 at 16:28 +0200, Francesco Dolcini wrote:
> > 
> > Jeff, up to you, we can take the patch as it is.
> 
> Wait, we're discussing mwifiex, not nxpwifi, didn't I already apply
> this?!

Yes, already merged. Sorry, I missed it, all good.

Francesco

