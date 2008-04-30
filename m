Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765502AbYD3Unn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:43:43 -0400
Subject: Re: [PATCH] libertas: reduce command retry time
From: David Woodhouse <dwmw2@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1209587692.16194.22.camel@localhost.localdomain>
References: <200804301644.29927.hs4233@mail.mn-solutions.de>
	 <1209587692.16194.22.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 21:43:16 +0100
Message-Id: <1209588196.25560.443.camel@pmac.infradead.org> (sfid-20080430_224355_074566_16CE2798)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-30 at 16:34 -0400, Dan Williams wrote:
> On Wed, 2008-04-30 at 16:44 +0200, Holger Schurig wrote:
> > In the normal case, an unsuccessful command would be tried for
> > 10*5 seconds, or 10*10 seconds in the worst case. This patch
> > reduces this to 3*1 seconds, or 3*5 seconds in the worst case.
> > 
> > Also changed the needless del_timer_sync(&priv->command_timer);
> > to del_timer().
> > 
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> Sounds fine to me...  Woodhouse?

I think I've seen it take a few of the 5-second timeouts. The firmware
on this thing really is a steaming pile of shit. I wouldn't like to
decrease the maximum so drastically.

Also, that del_timer_sync() happens in the module unload path, doesn't
it? I'd want to see why you think it isn't needed.

-- 
dwmw2

