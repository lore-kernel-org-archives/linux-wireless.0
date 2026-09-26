Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF42274658
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 07:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790406045; cv=none; b=iuCyb2DWizaeTXZfJ0ZbkbkgDb6I3yKnwH1YmHNyyjCKJqfMUQ2LzW4rAiCOmj++0biKca1z2SRC9zyt2SUs/7lBk3QLB8+rFT3tngctMsJGb/WZJyc77n/LEkfPW3MfO1MZp3B5H8FfvlRii7Kpu/tuUhEivEgogLcEBT9ZjPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790406045; c=relaxed/simple;
	bh=fkHy2QRrC5ESJ9xdBOXt6a3B4fKvvVrykffU4U22+5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hNXBzNkQRBPtQKIl4ml9kBQ6hf83PhisqY9znQ+Ox//A/UfVIX+Y+ndeCg8iZDzbeE1mw4cCu1G981NCp+G38KctAfe0zkih9EmIz/Tuijfc8+DJKsLMz0B/xtxZAvKeUEMwTAQakqqgTZ35uPPqRLnrt4ANhpSpxZ4ecSMsC3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=jGR1xOcI; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="jGR1xOcI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=M/FcFSIa0wWtwRh7uVhb2hmR+wUAgWX3VOJzlETWQNU=; t=1790406044; x=1791615644; 
	b=jGR1xOcItG5OzjA5fH2ZgrKZOL5E4cPzqQEze4k7yT6YhL1l1NsMORM5Hs+1VYGviMNTwaYwSfh
	L0u+nq/3854b5vzr1qW8ws9ILUzubE5CDAKbhkbsyC3dcD9XooJ7j0HUPYJmLLErnHomuHT9gl1xn
	iTXHRLjHeTM323xjXIGU8yKu706iDNhOPTCT+xfNrNIrIMO8oXA8ldSmoQ5OFsYph3F9jT6E59GEs
	G6h/jC81rWFwyDNj4GPqnVKIAzrPnsT1kny54kmkjKnrsr2xmvWsw9oAhOozj0iDFqozIDcEZ5NnL
	4m6q7iGCp8FN3gH+cLpbrw+G2Pi/nNRx83nQ==;
Date: Sat, 26 Sep 2026 09:00:26 +0200
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
Message-ID: <20260926090026.22b00f57@kemnade.info>
In-Reply-To: <arag95IJHR5FiFo9@google.com>
References: <20240605160013.6bea8d4d@aktux>
	<_pNnwoI9WHlb2EY635KdIv6t_goU-ZYp9Vav31jkFOCf9fCE9EeKdyCea2m-L8pgfsKIQvODlnQLhQqmWSYip9e6FFZwaJHL5-u5rdOS_kY=@protonmail.ch>
	<20240605174709.5043af8f@akair>
	<20240606101839.GA76158@francesco-nb>
	<PA4PR04MB9638D1FD47BFBFDDB096C778D1C02@PA4PR04MB9638.eurprd04.prod.outlook.com>
	<ZmlEny2W0nArOf1T@gaggiata.pivistrello.it>
	<PA4PR04MB96381A69AD86ED9C9E4AD9CDD1CD2@PA4PR04MB9638.eurprd04.prod.outlook.com>
	<20260925165814.567c9ab7@kemnade.info>
	<arag95IJHR5FiFo9@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Sep 2026 09:27:35 -0700
Brian Norris <briannorris@chromium.org> wrote:

> On Fri, Sep 25, 2026 at 04:58:14PM +0200, Andreas Kemnade wrote:
> > The License terms have in 2.3(b):
> > "(b)     to copy and distribute as needed, solely in connection with an
> > Authorized System and for use in combination with a NXP Product,"
> > 
> > If I read it correctly, the firmware cannot life in such a repository, since
> > the repository is used by different machines. Is my interpretation correct?
re-establishing context again: "such a repository" means that fw packages as
e.g. alpine packages and then put into the official alpine repositiory.  
> 
> I'm no expert and am not providing legal advice.
> 
I am not either, but there are NXP people in CC hoping to say something
more official or finally un-stall this issue.

> I see there is some roughly similar (but a little weaker-soundging)
> language in some existing linux-firmware licenses. e.g., "permitted
> solely operating in conjunction with <company> authorized products".
> 
Often it is restricting *use* not *distribution*. 

> I also see the linux-firmware README only says:
> 
>     Your commit **must** contain a `Signed-Off-By:` from someone authoritative on
>     the licensing of the firmware in question (i.e. from within the company
>     that owns the code).
> 
> I take that to mean that linux-firmware doesn't really try to own the
> licensing rules. They defer to the company that owns the IP.
> 
There are rules what licenses might forbid and what not in LICENSE-CRITERIA.md.
At least submitting it to the firmware repo (so from NXP sight a third
party repo) sounds like some permission for distribution.

Regards,
Andreas
