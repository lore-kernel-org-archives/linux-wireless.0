Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B052DB78B;
	Thu,  9 Apr 2026 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775717659; cv=none; b=IzQHjB8KLBMrXFSfQBQlhbbXg4XVFLeg8higmD1hXYoWF6iAYW5+l+2IQwxl04lJrDT/FDS7DNLg9m0b7jmmbp25MShiyl2eeR5SqQvMsecJ+ZPojNKB7qSRuVaRMI+W2EWBLVt26Mx/dPFcgbDNKY96sE9WC4Wrwpiw3UDGxXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775717659; c=relaxed/simple;
	bh=Zb0LOaVxzFxSe9JcuDcqkcKRC3k08ZgW/BX6RYDGlgQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DN0MX1xKgvU9w6KYxUJ8u+e19F6fzTADRk7XcHY6b5d6fj4GaQOnGjn+Njw4o0wuiV9QfeFpcD9SszYFn8/B8AqfF+5WsSOSitHTYfhGxuUb/wvdCEjeDIQvnY1OxV492qTrtJIzREuFdDHD12SwZzr/xV2Bd2eUqg79pyrViHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=DXDZAhJ2; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="DXDZAhJ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Zb0LOaVxzFxSe9JcuDcqkcKRC3k08ZgW/BX6RYDGlgQ=;
	t=1775717658; x=1776927258; b=DXDZAhJ2NozMpViyJjMWUQjqPyeV5D5zqCLtqKh7UezmJ1W
	Ndq9CIGFRiTgmpjd9qUgmdPYiWQXZ1xzn3ZQlyWlW+F734eeG21irLMNCkEVag3keSvumhuOWcnqL
	YcQHhpZtbAkf0fBhJ5aejOCtMPBdpUzFbAImzeBbkeZFKfJkYpDP5OyOIeaGAjSduWaojmmsqpPRO
	tI2BOijviDwZktDWUH+BR5Zai4Ww/PvX98Y7t9izgMUTX9YHoWSHPASSxgyvOWlLnaGiKCT7AbnbU
	70NpHnmFoAYWmq1AF3vZl69wR0PPNrGiaBsiyweGtIGALi6skDm7gmj9YoXQgwBw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wAjHG-0000000FZY8-1iLz;
	Thu, 09 Apr 2026 08:54:10 +0200
Message-ID: <bc9c98d0579ef69d9892b3840028ac0e19a551a9.camel@sipsolutions.net>
Subject: Re: [PATCH v10 00/21] wifi: nxpwifi: create nxpwifi to support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	francesco@dolcini.it, wyatt.hsu@nxp.com, s.hauer@pengutronix.de
Date: Thu, 09 Apr 2026 08:54:09 +0200
In-Reply-To: <adcblxRaTTyEvVWN@nxpwireless-Inspiron-14-Plus-7440>
References: <20260305143939.3724868-1-jeff.chen_1@nxp.com>
	 <9b0144261da2ce7f5ef0a533928732cc43459e40.camel@sipsolutions.net>
	 <abDh2mBYTqbhKz/H@nxpwireless-Inspiron-14-Plus-7440>
	 <8ebc201c976f11cce4802e9e34c1f479ee190ac8.camel@sipsolutions.net>
	 <abJ/qONShVDAuyhI@nxpwireless-Inspiron-14-Plus-7440>
	 <075c9a062664609a81a722883ee17e7c728b08bc.camel@sipsolutions.net>
	 <acPm666IO+nso5to@nxpwireless-Inspiron-14-Plus-7440>
	 <4ccf21800166b28cc28c72b0b1cf2672b43af8a9.camel@sipsolutions.net>
	 <adcblxRaTTyEvVWN@nxpwireless-Inspiron-14-Plus-7440>
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

Hi Jeff,

On Thu, 2026-04-09 at 11:23 +0800, Jeff Chen wrote:
> I will keep the SDIO ID change in the current nxpwifi patch series so it
> builds independently in wireless-next during review. For the final merge,
> I will send a pull request and include a precise cherry-pick of the SDIO =
ID
> commit from the mmc tree.

I suppose I should have thought of this earlier (but I didn't pay much
attention to the timing when I had just come back from vacation); at
this point, unless all of that happens _really_ quickly (the next day or
so!), it doesn't matter because the merge window will open on Sunday,
and then we'd get that commit anyway from 7.1-rc.

johannes
