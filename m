Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380AbZIKUMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 16:12:33 -0400
Date: Fri, 11 Sep 2009 13:11:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: devel@driverdev.osuosl.org, ath9k-devel@venema.h4ckr.net,
	Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
In-Reply-To: <43e72e890909111043m78411058i86e61909a35412f@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0909111308120.3654@localhost.localdomain>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>  <1252632895-11914-4-git-send-email-lrodriguez@atheros.com>  <40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>  <4AA9F22C.3090007@gmail.com> <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
  <alpine.LFD.2.01.0909110720210.3654@localhost.localdomain> <43e72e890909111043m78411058i86e61909a35412f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 11 Sep 2009, Luis R. Rodriguez wrote:
> 
> > In fact, if you know what kind of IO op it is (ie "it's always MMIO"),
> > you'd be even better using "writel()" directly,
> 
> Heh.. you realize I tried to document such a thing a while ago and it
> seems you opposed it [1]?

If it's mapped with "pci_iomap()" you should use ioread*/iowrite*. 

But if you know it's always MMIO, and you use just ioremap() to map it, 
and then readl/writel.

It's the _mixing_ of the two that I object to:
 - pci_iomap() - can do either MMIO of PIO
 - readl/writel - always just MMIO
should preferably not be mixed.

(Sure it will _work_, but I wouldn't encourage it)

			Linus
