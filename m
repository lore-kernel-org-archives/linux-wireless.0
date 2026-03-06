Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7D633CE92;
	Fri,  6 Mar 2026 09:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772788787; cv=none; b=tNLo4WwWsLdtBEqxkmHTo7R15KTtIuIgDwT5oLAdIOfEH4WBa7ndLYe1CXrM6vBr9qnsYqa81VSnR5B87HseEdUBb4bwbDPYll+iqdcr4xUdroBPEy6HQtlnMCueVPL/DA8C3gKRTrbvQYVe60UyoVMF4kdhhwtY4hDXrlLYmUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772788787; c=relaxed/simple;
	bh=DTdDp/qdWBWlTQffCtM1PFYf6mAxY4nasY5pibFsqbo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Va7YiM8BWm7FDeJKVYnibnHyqCe/zaXOrO6q9RMmYW765BzvHILHmLSlml+8cJXzSVDJgn+7xvUV6Mmbz2zP/UfEJsY3HvGMRNOdtKvBiyYGEFYqF57NtX0hmCuSS1gL2FwkEQaShoKhbLUBz5oKhwkBaFz2mDyWzPuDl+bQtog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xMhQmdgV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xMhQmdgV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=DTdDp/qdWBWlTQffCtM1PFYf6mAxY4nasY5pibFsqbo=;
	t=1772788786; x=1773998386; b=xMhQmdgVZtwVwlibf0Eob+vjgt1okNqm8qfMJ2zx7r9SLAO
	qb9CoQMIuGpp5uR6lQXK8dxQSbVg09504VOgKzzDMq3CTdI7ALiPGyYN8LbcfNWLxp4XrOp57Ufae
	bDx3tXK3KJH95kzV64XibEi5Oa3l7wnYWK7eSL95/rYPSYDPAKABbJRC3QLZjg6IKkywMHl9VDknK
	VW8FAF3N7eH+UeDCUjXtn6rSqxus80MDD+BhuXA3VotnpQUbNzqJP6JBT47Xnmf5omEIGSIO6U8N8
	7HPPJYszwcCKgxU3zWjCZHYHDsEFXwk2ijaSfmD3IB3JYOcIw0b0uzo8Ay1yBO0A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vyRLU-0000000A0ZH-0xFt;
	Fri, 06 Mar 2026 10:19:44 +0100
Message-ID: <9b0144261da2ce7f5ef0a533928732cc43459e40.camel@sipsolutions.net>
Subject: Re: [PATCH v10 00/21] wifi: nxpwifi: create nxpwifi to support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chen <jeff.chen_1@nxp.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, francesco@dolcini.it, wyatt.hsu@nxp.com, 
	s.hauer@pengutronix.de
Date: Fri, 06 Mar 2026 10:19:43 +0100
In-Reply-To: <20260305143939.3724868-1-jeff.chen_1@nxp.com>
References: <20260305143939.3724868-1-jeff.chen_1@nxp.com>
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

On Thu, 2026-03-05 at 22:39 +0800, Jeff Chen wrote:
> This series adds a new full-MAC Wi-Fi driver `nxpwifi` to support NXP
> IW611/IW612 chip family. These chips are tri-radio single-chip solutions
> with Wi-Fi 6(1x1, 2.4/5 GHz), Bluetooth 5.4, and IEEE 802.15.4.
> Communication with the external host is via SDIO interface. The driver is
> tested on i.MX8M Mini EVK in both STA and AP mode.

How exactly was it tested, it doesn't even build ;-)

There are a couple of things I'm not a huge fan of, in particular the
whole "IOCTL" layer which is reminiscent of wireless extensions (but
thankfully those aren't used here), and while I can't really review 35k
lines here, I don't think I have any real problem with this now.

As I also just said to Lachlan, I think you should probably send a pull
request with just a single patch adding the driver once reviews settle.

https://lore.kernel.org/linux-wireless/b71d0932b10b5c446681cef588cfcf6f869f=
3fca.camel@sipsolutions.net/

johannes
