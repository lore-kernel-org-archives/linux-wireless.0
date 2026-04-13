Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AB935F61E
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2026 09:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776074090; cv=none; b=K5TpQ0PVLf3sBrhCLGY2TLuVfjfYu9VYTmpfUch7XR1H8Pqqskp81obh/61B8a7ehf7nesDaVwhBvcTR8Rjob/BKCpMdPuLNZfoDl/l6W0nmHSk4tYcbAY/8kk9onYG9b0Lb8hXrtrkNCZaFCkRJKrpmhWwLO0JefQ8pPoZ0pls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776074090; c=relaxed/simple;
	bh=c2CGlGVZqp3alRDCnZcttXz0G9aDXOjwnSxTsPk8zIQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=aglxXHPfkhskcM6eyHzZdluCxnuXsgzRMMbB24mWj4+QyBH/ZGh34dj1phtfxdZlfzHQ5YbqVPxZYTbONkaHLUhWt6Q0kGOgexp9sUkOESJX33StwcrnNa41a4nhqaTYgoTILprmgwZX8G4LNko5chforhDSZrFh3+h63hvHys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=qEG1v262; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="qEG1v262"
X-KPN-MessageId: c96836c5-371e-11f1-89e1-00505699b430
Received: from mta.kpnmail.nl (unknown [10.31.161.191])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id c96836c5-371e-11f1-89e1-00505699b430;
	Mon, 13 Apr 2026 11:54:39 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id c9672149-371e-11f1-83d8-00505699891e;
	Mon, 13 Apr 2026 11:54:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=nlt0Px8sm0nTGDMuegqkfg4UbDLjgtKHdrHsp/wHC4g=;
	b=qEG1v262gFDd1+qxSAh6xJMsb6JmvkapHys5CFk0KT/W8sqoICENBRxMP5nJhGunuFPKg7jZ/NXx0
	 y/znz+85rYN1XHH3vYcPPyEwbLAlwIbh/wHzYAgeo2JQk4yEIzimrYc5WGmYVPAoj9VQ6r3RSBmQ1v
	 b9ksxoIi1VyvnbvrKz1Mbl5X36V32h2cYAgdV+eR2SOUzrgFP53iYZSu/ammY/efoF9GjiIe7jH09h
	 3CoKIJPWfEnZoUfKunAuTDy8lUSdUPRAH8c0byV2vmwb5z18RSbnYGxyE5XXDWn3TFZsEibiDujNF/
	 OkUNg79RvK6Ov6tIBeE8KtS2U1LLoiw==
X-KPN-MID: 33|EQTl3qluFIpmTj6N5x3r3WnTBy0W4dplO4KuNiIEe2QaNq4A3cczKzDpvP80WXA
 osYBJQdPHcNo+WY7dbmI2Y9mmPu6IcG8idlnos5ll9lM=
X-CMASSUN: 33|xH4WiFy/3l1WvwjGQikdb3xy2t1tBE9NA5DZSIeeEdcWFLxFNvOTe67rDozapy9
 Wi6+Rej1jjrliCab0dwir1w==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh07 (cpxoxapps-mh07.personalcloud.so.kpn.org [10.128.135.213])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id c95c64e9-371e-11f1-b8d7-005056995d6c;
	Mon, 13 Apr 2026 11:54:39 +0200 (CEST)
Date: Mon, 13 Apr 2026 11:54:39 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"open list:MAC80211" <linux-wireless@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Message-ID: <1501198413.2134444.1776074079199@kpc.webmail.kpnmail.nl>
In-Reply-To: <2f2ddabe109c846d3635098a8004b3a5632aac45.camel@sipsolutions.net>
References: <20260401165938.3843784-1-jkoolstra@xs4all.nl>
 <538186550596da7b862eb7340047695267f8b71e.camel@sipsolutions.net>
 <675951732.2051008.1776003641276@kpc.webmail.kpnmail.nl>
 <2f2ddabe109c846d3635098a8004b3a5632aac45.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: change hwsim_class to a const struct
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal


> Op 13-04-2026 08:19 CEST schreef Johannes Berg <johannes@sipsolutions.net>:
> 
>  
> On Sun, 2026-04-12 at 16:20 +0200, Jori Koolstra wrote:
> > 
> > 
> > I just saw that it has been already applied.
> 
> I didn't apply this one though. You sent it twice:
> 
> https://lore.kernel.org/all/20260303165938.3773998-1-jkoolstra@xs4all.nl/
> https://lore.kernel.org/all/20260401165938.3843784-1-jkoolstra@xs4all.nl/
> 

I think then I might know what happened. The patch was applied but I was
not aware of it, so I resend it. Then you tried to apply it, but it was
not possible because it was already applied (I had to do a three-way merge).
But maybe I am totally mistaken here.

> and the *second* one didn't apply (and I replied to it accordingly.)
> 
> But it looks like at that point I missed there was a first one (please
> add "v2" tags etc. when doing this),

I intended it as a resend.

> 
> What's strange is that they look to be completely identical, so I don't
> know why one didn't apply and one did.
> 
> johannes

Thanks,
Jori.
