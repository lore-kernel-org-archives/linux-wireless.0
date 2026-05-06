Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022738E5DF;
	Wed,  6 May 2026 20:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778099440; cv=none; b=qna+qbXZ49I5Htcbs4YdX8DGv2r6OLIpiOY75AjNEgc/HtPRz95OuhtPCQkW0zvobpOSftbXbBnREmgy8u/qd+QxMh4IT+Rl4oUfwtDyIwLR3ezgrf7QZU42kuHNUcqSKIIpTW3BfX/SuC/rS6VWDJjURACz7G2yPPRSHi6MExQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778099440; c=relaxed/simple;
	bh=cZ4K7ZkH4CjVGbTtDtaWxsP03k1adkRewc2QXSuFhuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Utu0a6PxcLomvi+xMDAfUGszO8UR0zrHvwvTl4XbDDL3YtZgundLPnp6gGB7o79uJSPCfh/db/DI4lZo34VuLB493SHrF2QkprXzu8Aj5u6nKLO3Do+s6EIPCmf8MqbajUaGln18bh5gRfdzsejLYBnDLsizmBi8ew9CpjoGOHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=qpIAfWAz; arc=none smtp.client-ip=198.252.153.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="qpIAfWAz"
Received: from fews04-sea.riseup.net (fews04-sea-pn.riseup.net [10.0.1.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx0.riseup.net (Postfix) with ESMTPS id 4g9n7y4j0Wz9tNS;
	Wed,  6 May 2026 20:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1778099438; bh=srk9N6x4OS8mAV/nGLNUxRKHC22Lg0AqoTFTMh9gocc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpIAfWAzjvB3ANhLP4mYlw7OUGtndDH4GtMtzx5RRjSX6IPzGg4X8R/VTejqTLVPS
	 qERoxHriCHfyGLAv6f2bFF2XWQxBALCz508JrG+4tXCqd5xYrdhKDIs64HFpkcyQBh
	 8Nti3L5GX3tnVfs4WPiKoJ5c/XT/fIwH/uwsHnSI=
X-Riseup-User-ID: B5D412F198E8899EDABFE04F17A73459F0107F3AED606021FB1B88E15F0B1FD2
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews04-sea.riseup.net (Postfix) with ESMTPSA id 4g9n7x3hdDz5wV9;
	Wed,  6 May 2026 20:30:37 +0000 (UTC)
Date: Wed, 6 May 2026 17:30:33 -0300
From: Santiago Ruano =?iso-8859-1?Q?Rinc=F3n?= <santiagorr@riseup.net>
To: Kyle Farnung <kfarnung@gmail.com>
Cc: Kyle Farnung <kfarnung@outlook.com>, Jeff Johnson <jjohnson@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"koike@igalia.com" <koike@igalia.com>, 1132343@bugs.debian.org
Subject: Re: [PATCH] wifi: ath11k: Add two missing Lenovo IDs to the quirk
 table
Message-ID: <afuk6c0n-TXXUySs@voleno>
References: <20260423211458.458911-1-santiagorr@riseup.net>
 <IA2P223MB1199153665E2AFF709BD2F52D02B2@IA2P223MB1199.NAMP223.PROD.OUTLOOK.COM>
 <aeuH2chCSi57RYVU@voleno>
 <CAOPSVF3=BmOUw5+nnk-EYnpP_ff7wXsFAaz6sHbw-brLy-HojA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOPSVF3=BmOUw5+nnk-EYnpP_ff7wXsFAaz6sHbw-brLy-HojA@mail.gmail.com>

El 26/04/26 a las 10:44, Kyle Farnung escribió:
...
> Feel free to just merge yours and I'll withdraw mine. I'm regression
> testing the WiFi disconnect issue I'm encountering, so I'll just focus on
> that. In the meantime this seems righteous.

Thanks, I've just sent an updated version

> 
> >
> > >
> > > I have the same "wake on power removed" issue, but I have another issue
> > > that's more annoying where the wifi just dies randomly. I only have the
> > > wake issue when power is disconnected, not when power is connected again.
> > > I mostly leave my device connected, so I only realized the behavior while
> > > doing the regression testing requested in the other patch.
> >
> > I've also been hit by a similar annoying wifi randomly dying issue that
> > you describe [deb#1132343].  With the patch that I attached applied to
> > 7.0.0, my P14s G3 AMD laptop has been running for more that 3 days, with
> > several suspends / weak ups, either with power connected or
> > disconnected.  And I haven't encountered that problem since it booted so
> > I concluded that the patch fixed it.  But chances are that I am wrong.
> >
> > [deb#1132343] https://bugs.debian.org/1132343
> >
> > The latest bad version I tested where the wifi died was 6.9.11.  I plan
> > test the patch on top of it.
> 
> 6.9 or 6.19? My issue started between 6.16.10 and 6.17.4.

6.19, sorry.  And I confirm it is still present in 7.0.3. But my P14s
Gen3  machine has been running on a 7.0.3 patched with
https://lore.kernel.org/ath11k/20260423211458.458911-1-santiagorr@riseup.net/
for more than two days, with several suspends and no wifi issues.

However, from your comment at
https://lore.kernel.org/all/CAOPSVF04q6uvVdq8GTRLHBrVMdpt9=o9wVcFMc6f-yhmSBcZqQ@mail.gmail.com/,
I read that you are concluding that the culprit for the dying wifi is
rather 79266fd78df1 ("wifi: ath11k: HAL SRNG: don't deinitialize and
re-initialize again").
Could you please confirm that you have been able to reproduce the wifi
randomly dying issue with kernel patched with
https://lore.kernel.org/all/20260330-p14s-pm-quirk-v2-1-ef18ce07996b@gmail.com/?

thanks,

 -- S
