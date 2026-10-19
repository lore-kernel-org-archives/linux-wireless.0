Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE3F4F1835
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792420094; cv=none; b=EG/HkY2TbTG+vAVhgOH811X5cZ04TxRgl5+2zEMgko9CyakCM5PGeQQTmXwz0jaF9Q2EDnwuAfRyPQpMWKgyaZuLPbt06RB9YM8JF/4nuUCQV93lcErezFviklZBKseRQTKp4m2hCHTbJhweYeocEpahcAHRkJLUCUjpli+vMDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792420094; c=relaxed/simple;
	bh=3OjwI4WsqBlCu0GlSodqPhw0ocvlJ4NfTkumZ1TN/68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mc4AWMeW5NvQyx81TjIrjWB83VIx+gPScU6s0CFwazHSsJFcogFZaCu8A0jUthfvHwJ3hoQNKhhLwrtH3QOV0b1Xwn676KaYf7I1fDqKN4YJrx1K/1Zv4jNUHR2SVwcKB34vgp4eJnPtPeOw+bFL6aJS3NgMwC13Eq93Jc3MQrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=RynQJP87; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="RynQJP87"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 42E2C1FB78;
	Mon, 19 Oct 2026 16:28:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1792420090;
	bh=dfkfOjV72YKrLO18oBDAbPFTDNuzOjYHc6+t0RX76N8=; h=From:To:Subject;
	b=RynQJP87gbjWkqq76lD+Ro7KOZXrbkf8QaQIF/qyzBlmv19Rg3jfos7MbUeyGHOaV
	 cdEUH4xO92IRMpIA/z7xUnIJiRiMjge5b7zphD4pROzO9MagriJ1JWIIuwyqiaQu39
	 x71JK7UEx5GEGxHP5OXkmPj8qqmeJnZy/xcbpeBhyXwF9Dxp3w2kOkEdyhuka/MDCz
	 9115XFE9Ho8nrt/NHaFkiesTqSikrNaFcaIBxfHSDOQo3fiQ8MW3kY1VnvfKgBNwtO
	 AYhQsVFVH/7wP18kVx+4GBvGpzbVVcBbomYPhih0uPCaPiINwiFPOt7fTJUZqAtg+/
	 DROW8dLzkYoIg==
Date: Mon, 19 Oct 2026 16:28:09 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Francesco Dolcini <francesco@dolcini.it>, jeff.chen_1@oss.nxp.com,
	linux-wireless@vger.kernel.org, briannorris@chromium.org,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: Re: [PATCH wireless-next v2 1/2] wifi: mwifiex: append hotfix number
 to firmware version string
Message-ID: <20261019142809.GC118352@francesco-nb>
References: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
 <20261012123624.3147417-2-jeff.chen_1@oss.nxp.com>
 <20261019141347.GA118352@francesco-nb>
 <6b94b803c6424227f6ebc044e0ff2e6b90c180c9.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b94b803c6424227f6ebc044e0ff2e6b90c180c9.camel@sipsolutions.net>

On Mon, Oct 19, 2026 at 04:16:01PM +0200, Johannes Berg wrote:
> On Mon, 2026-10-19 at 16:13 +0200, Francesco Dolcini wrote:
> > 
> > > +				case FW_HOTFIX_VER_ID: {
> > > +					struct hw_spec_fw_hotfix_ver *hf;
> 
> > > +
> > > +					hf = (void *)tlv;
> > 
> > I would not abuse the void*, you know the type you want
> 
> FWIW, I tend to disagree, spelling out the type again for no real reason
> is just noise. As far as I'm concerned you can do whatever you like in
> the driver though :)

I would say that your opinion trumps mine on this regard.

And it changes nothing on the generated binary, in any way.

The reason I prefer it is that (void*) will silently cast to everything,
and having an explicit type might help in case of mistake introduced
with some future refactoring.

Jeff, up to you, we can take the patch as it is.

And I'd like to have this in the driver, it's something we are missing
and it's valuable.

Francesco

