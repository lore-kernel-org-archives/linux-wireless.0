Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2BC40DFD5;
	Mon, 13 Apr 2026 06:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776061203; cv=none; b=IIpDG9153gvcWjBVXEYWrtqOwU/fFNXL3XvPPQcS2lMWrneHKL2YLTqd9OFyzY0USQih8AwewA5OPjJk7YiqNYyeSnyZkuc5shjogKW2EALkiQglyzkUt7eBOkDFT5PXDOzxGTIoZE9kk2Wfh+o+A7IC9gUMiLXrD6OHE+SxtOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776061203; c=relaxed/simple;
	bh=gvGdjv4uLb7Hp6ZtEwZOKMUvc1gAjF5U2GE1K+NZIJ0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tuaZ1ZHKlEFI0X6s4K7RFrXIowJpJqBGgV+/NOKdGEQN4bWcM8dGNhptRhwE5NQwB8OkyyIjyCBRUoVEFJPd7qhDfLQ8djo85um2dJ+Efgm+YUYWq0YN/sQMy2YUZKH+l40KnWGPEkGWiqHuiXH3xxs45GRuzqhrITReUnKCjGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=prKGKSVN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="prKGKSVN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=gvGdjv4uLb7Hp6ZtEwZOKMUvc1gAjF5U2GE1K+NZIJ0=;
	t=1776061202; x=1777270802; b=prKGKSVNIa2cOojtHCk4zkDHCpS/A9mv5g2ia4u2MsbYLNQ
	zWUTgbuajCTVeXiRtyhCExuI6vVkBlLAp1l3ZFXEmzQhiaVyfsRlzxz3Vyl3IhpBbJtpjGWg8JePy
	0A2KLVjcjkRkA8sPYYDrdGpmSl9saZZhv2z6odFVKWoa/ihgHX/uFQFJaHz6PIl9Mty/e+oxXWumh
	aSN8r+DEmG5BXFrT1iNWx2O2PSv2EiA7k6m4e4bisxHgPaQURbaSLQgYpZqpB89BFYekXlmy49O8H
	zfNNSIevaWN7HA5W8q4ZnMLnz3pRsi0MhNejyBsVCoyN7vDdbd4anlzUbHo3RgxQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wCAeI-00000003gx9-2n5F;
	Mon, 13 Apr 2026 08:19:54 +0200
Message-ID: <2f2ddabe109c846d3635098a8004b3a5632aac45.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: change hwsim_class to a const struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "open list:MAC80211"
	 <linux-wireless@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Date: Mon, 13 Apr 2026 08:19:53 +0200
In-Reply-To: <675951732.2051008.1776003641276@kpc.webmail.kpnmail.nl>
References: <20260401165938.3843784-1-jkoolstra@xs4all.nl>
	 <538186550596da7b862eb7340047695267f8b71e.camel@sipsolutions.net>
	 <675951732.2051008.1776003641276@kpc.webmail.kpnmail.nl>
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

On Sun, 2026-04-12 at 16:20 +0200, Jori Koolstra wrote:
>=20
>=20
> I just saw that it has been already applied.

I didn't apply this one though. You sent it twice:

https://lore.kernel.org/all/20260303165938.3773998-1-jkoolstra@xs4all.nl/
https://lore.kernel.org/all/20260401165938.3843784-1-jkoolstra@xs4all.nl/

and the *second* one didn't apply (and I replied to it accordingly.)

But it looks like at that point I missed there was a first one (please
add "v2" tags etc. when doing this), and then I later picked up that
first one because it had in fact compiled.

What's strange is that they look to be completely identical, so I don't
know why one didn't apply and one did.

johannes
