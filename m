Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60455 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558AbYEAV5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 17:57:10 -0400
Subject: Re: [PATCH] libertas: reduce command retry time
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200805012330.57750.hs4233@mail.mn-solutions.de>
References: <200804301644.29927.hs4233@mail.mn-solutions.de>
	 <1209587692.16194.22.camel@localhost.localdomain>
	 <1209588196.25560.443.camel@pmac.infradead.org>
	 <200805012330.57750.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:57:01 +0100
Message-Id: <1209679021.25560.594.camel@pmac.infradead.org> (sfid-20080501_235654_037156_D2F22B0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-01 at 23:30 +0200, Holger Schurig wrote:
> > I think I've seen it take a few of the 5-second timeouts.
> 
> Do you you know for which commands this has been?
> 
> 
> > I wouldn't like to decrease the maximum so drastically.
> 
> How far would you go?
> 
> Or: maybe there is another way to make "pccardctl eject"
> work reasonably fast in the case of a retrying command. Any
> idea?

Does it set priv->surpriseremoved? We should honour that.

> > Also, that del_timer_sync() happens in the module unload path, doesn't
> > it? I'd want to see why you think it isn't needed.
> 
> I thought that del_timer_sync() waits until the timer has been
> executed? If yes, then that's the wrong thing here, I want to unload
> quickly. Makes no sense to wait till the command_timer finally fires
> and re-sends the failed command.

No, it just waits until the timer has been properly removed. If the
timer was set for some time in the future, it doesn't wait for it to
happen naturally.

-- 
dwmw2

