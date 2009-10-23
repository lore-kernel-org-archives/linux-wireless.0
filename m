Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbZJWPp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 11:45:29 -0400
Subject: Re: [PATCH] libertas: remove handling for CMD_802_11_LED_GPIO_CTRL
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910220953.17995.hs4233@mail.mn-solutions.de>
References: <200910191331.20476.hs4233@mail.mn-solutions.de>
	 <1256149730.5010.39.camel@localhost.localdomain>
	 <200910220953.17995.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 08:45:31 -0700
Message-Id: <1256312731.2164.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-10-22 at 09:53 +0200, Holger Schurig wrote:
> > It's actually used by the OLPC folks; but right now there's
> > simply no mechanism to configure that ability via WEXT.  Is
> > there some way to do this via the kernel LED  framework instead
> > that libertas should be using?
> 
> They use it?
> 
> No one did bother to send a patch for the in-kernel Libertas 
> driver during the last year. Sigh.
> 
> Also, if they use it, they need a patch on top of what is now in 
> the kernel, because the current in-kernel libertas driver has no 
> code to issue the CMD_802_11_LED_GPIO_CTRL. That's why I removed 
> it in the first place.

Because it was a WEXT private ioctl and I ripped those all out and told
them no.  They still patch that (because there wasn't a LED framework at
the time) into the OLPC Gen 1 kernel trees.  Not sure they are ever
going to jump to 2.6.32 or anything though.  Just letting you know.

There's quite a few commands that only the OLPC stuff uses, but because
there was no usable userland interface for it (because we said no to
IWPRIV, and because debugfs is for debugging only) they just stuck with
IWPRIV and patched that in.

> It's O.K. for me to keep this code in (it doesn't harm), but a 
> better approach would be
> 
> a) use a new-style commands, a.k.a. lbs_cmd_with_response()

I was working on that and had converted all but 7 of the old-style
commands before you started the cfg80211 work, and now I figure after
you're done I'd go back and clean them up if they still exist.

> b) use the in-kernel LED support (as you said)

Yeah, that's obviously what should be done.

Dan

