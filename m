Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5A83CEB9D
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691753; cv=none; b=vEw4D78mzfzmODYph+FvzIh0eZLgoV8aJ9a5geI4HnsKxR9G4M3WFAC2mXPnekWqYe7Z5KeKfELd4p7db82HZyU03sHVqL2tI41dMDLxY79s/OzorOL/wBYiaqY0JNYZHbRs/23NYPKWD14BHMN509Cvjopri/KoOZqtIAL6EQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691753; c=relaxed/simple;
	bh=OdPFrJMftrJQcsg/zftnUax1tM37Nn4SeVZqAZSq4sI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m2Yvl6KbqaulQhhYlLmla99zKQtx0BpG5O8pRxQq2wg5P9SSUYWlvbWmCRulvILRdCwlHgckhIosSw1vZVXMrTwf8LL9Msq4h2wXtYSR+w+mmpR8n5cZJW96OudWdzdBy0Y8yt0DITWIFLz8N6SkizisypHkA8AKFzyXtA7CxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=TQeXkGjQ; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="TQeXkGjQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=UI8KGr+203TTDDjM2zC+E9Wn2hBAPM2hhmWuZojDsvw=; t=1790691751; x=1791901351; 
	b=TQeXkGjQ8j9m1W2W8CZcbVJ9ymTjNaHiEY+dUVgrjHfZd0C3N/MKPA6n0bYBYS1uErEKTtre8dv
	xZhr7ZLHZR+wASO/ACXCk3ALCeqhHV6wauISZs4nxAaj1uAuH4LSrKN/f4nWbwSQMnhjUSAGTnJ73
	9fLT9zKaTlH51Wn8LZmP73fqNDi+o6cqC0FE4bmQpOIrWx9fEECc9+ZuRYqRjkfmsIRAJtJ6KaX+D
	7C5yyB16l4CJ9jzcjnTSTjbyKIyFtdJRsxlA/EZx/Ly8M0xMEYfJG5ZvZw8F9a2uImSG9+5kPQTxF
	9FWt5d9+CTlexCE+d5TnI024oNz9n0VttzNw==;
Date: Tue, 29 Sep 2026 15:43:01 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: Brian Norris <briannorris@chromium.org>
Cc: David Lin <yu-hao.lin@nxp.com>, Francesco Dolcini
 <francesco@dolcini.it>, Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
 =?UTF-8?B?VGFtw6FzIFN6xbFjcw==?= <tszucs@protonmail.ch>,
 "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "lukas@wunner.de" <lukas@wunner.de>
Subject: Re: [EXT] Re: mwifiex firmware mrvl/sd8987_uapsta.bin missing in
 the firmware git
Message-ID: <20260929154301.7c45c1be@kemnade.info>
In-Reply-To: <arqp7k55wqW5ZgCV@google.com>
References: <20240605160013.6bea8d4d@aktux>
	<_pNnwoI9WHlb2EY635KdIv6t_goU-ZYp9Vav31jkFOCf9fCE9EeKdyCea2m-L8pgfsKIQvODlnQLhQqmWSYip9e6FFZwaJHL5-u5rdOS_kY=@protonmail.ch>
	<20240605174709.5043af8f@akair>
	<20240606101839.GA76158@francesco-nb>
	<PA4PR04MB9638D1FD47BFBFDDB096C778D1C02@PA4PR04MB9638.eurprd04.prod.outlook.com>
	<ZmlEny2W0nArOf1T@gaggiata.pivistrello.it>
	<PA4PR04MB96381A69AD86ED9C9E4AD9CDD1CD2@PA4PR04MB9638.eurprd04.prod.outlook.com>
	<20260925165814.567c9ab7@kemnade.info>
	<arag95IJHR5FiFo9@google.com>
	<20260926090026.22b00f57@kemnade.info>
	<arqp7k55wqW5ZgCV@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Sep 2026 10:54:54 -0700
Brian Norris <briannorris@chromium.org> wrote:

> On Sat, Sep 26, 2026 at 09:00:26AM +0200, Andreas Kemnade wrote:
> > There are rules what licenses might forbid and what not in LICENSE-CRITERIA.md.  
> 
> Ohhh, nice. I was looking for exactly such a file, but I was looking at
> a too-old copy of linux-firmware.git -- that seems to have appeared in
> the last few months.
> 
> > At least submitting it to the firmware repo (so from NXP sight a third
> > party repo) sounds like some permission for distribution.  
> 
> Reading that doc: actually, no, that doc seems to suggest otherwise. It

Maybe I was a bit unclear here. If it is submitted and accepted it feels
like some more safety.

> specifically delineates various "terms that will cause rejection", and
> it seems the current NXP license triggers several of those. NXP would
> almost certainly need to provide an updated license, not just a sign-off
> with their existing license.
> 
There are two licenses there: The one in the linux-firmware git repo
and the one in NXP's own firmware repo. But both would probably cause
rejection nowadays.  

> This seems entirely up to NXP to unblock. If they want to work within
> the open source community, then they need to learn to work with the
> rules of that community.
> 
Yes, the only thing others could do is to nag them about it.

Regards,
Andreas
