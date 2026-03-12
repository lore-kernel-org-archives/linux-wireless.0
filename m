Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549B3AEF39;
	Thu, 12 Mar 2026 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773306792; cv=none; b=aHeAWNNeRK0wZOrHD9+vJ1bITBOWXfoHoJruWslI9srC1S6SRcH+NOwQGoRBa/MJB9Edku3hivQ6YbwawrGaPXBVTHuNDxNgPKdhZKOhSPUsPy+NkURTAEruhhhI8kaDcucOCN/4OeSDCj7YoTXCpLh1ZG0qHf0sSD1RCjx7pPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773306792; c=relaxed/simple;
	bh=cHaupY7WB1Miy6JDkP7JVGAj9kMXerZbt2q1Pxhb36o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TEixLWQi55XhuzSaV6++Q2Omd4UwfvTPw1ybJbP8T+qF8yAs3jkZ5/xZMMRQX6nOAPhVvidJZHwmOGqMlnEsp3c5+OQXhf0PofQiA1vdluEBtl8JOefTmxb8YKe1Nw/txWFid5DAqmXCSNSQvHEOZ4ctRkKyohLlXYFSbqpotAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=kCYeAG+B; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="kCYeAG+B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cHaupY7WB1Miy6JDkP7JVGAj9kMXerZbt2q1Pxhb36o=;
	t=1773306791; x=1774516391; b=kCYeAG+Bc0l3B1Afp2RtHshIue3iHH7ujK00OYjo56wsgb6
	guj9lXfwcBzU2ncN7H9RUc04BgVGkn718Vv4Y4uOHVa2IFBvtwdTuLcI/DL+lVAXBNdkzbLfx3t59
	3+lLil32TnSVa4G9CyqhgFD/afkVuKDDSqt5PUn98fAfiEBbaEmD/UTE98Puddyr6i7BcLWEYYWD9
	+y+LppjtzGdGNQuEg6FzIBC4tWQ5Y5NYEHssECvJFt4m5UJVMZARA9rE6DfpuU9qMjtY+CYXWKRzL
	elX3NPq2qL2iViHtPr/tMJJeJdRvCataD7nXOY2JqOrdnuiO6xt6tkRZUdEGbIhg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w0c6O-0000000Fl56-23ox;
	Thu, 12 Mar 2026 10:13:08 +0100
Message-ID: <075c9a062664609a81a722883ee17e7c728b08bc.camel@sipsolutions.net>
Subject: Re: [PATCH v10 00/21] wifi: nxpwifi: create nxpwifi to support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	francesco@dolcini.it, wyatt.hsu@nxp.com, s.hauer@pengutronix.de
Date: Thu, 12 Mar 2026 10:13:07 +0100
In-Reply-To: <abJ/qONShVDAuyhI@nxpwireless-Inspiron-14-Plus-7440>
References: <20260305143939.3724868-1-jeff.chen_1@nxp.com>
	 <9b0144261da2ce7f5ef0a533928732cc43459e40.camel@sipsolutions.net>
	 <abDh2mBYTqbhKz/H@nxpwireless-Inspiron-14-Plus-7440>
	 <8ebc201c976f11cce4802e9e34c1f479ee190ac8.camel@sipsolutions.net>
	 <abJ/qONShVDAuyhI@nxpwireless-Inspiron-14-Plus-7440>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-03-12 at 16:56 +0800, Jeff Chen wrote:
>=20
> Right, understood. The IW61x SDIO IDs currently appear only in linux-next=
, not in wireless-next,
> and the patchwork build logs confirm the build failure is exactly due to =
these IDs being
> undefined.
>=20
> For v11, I=E2=80=99ll add a small temporary patch with local fallback #de=
fines (guarded with #ifndef) so
> that wireless-next can build independently without relying on any cross-t=
ree merges. I=E2=80=99ll drop
> that patch once the IDs reach mainline.

That seems kind of ugly too.

Ulf, do you rebase mmc.git's next branch?

For whatever reason, Jeff sent you the requisite IDs for the driver
rather than putting them into the same patchset and getting your ACK,
and you have it as commit c0b68bc25efe ("mmc: sdio: add NXP vendor and
IW61x device IDs").

It _looks_ like that's in your next branch only, not mux or fixes (but
I'm getting slightly confused by the branch structure), perhaps there's
a chance you could drop that?

Or maybe the less bad option would be to just have that commit twice in
both trees? I'm nott a fan of a local define that we have to clean up
later...

johannes
