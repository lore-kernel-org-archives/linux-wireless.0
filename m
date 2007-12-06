Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44446 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbXLFPJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 10:09:06 -0500
Subject: Re: [PATCH 0/5] libertas: allow easier command playing
From: David Woodhouse <dwmw2@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071205213044.GA5659@tuxdriver.com>
References: <200712051757.52053.hs4233@mail.mn-solutions.de>
	 <1196874408.12263.9.camel@localhost.localdomain>
	 <200712052057.32996.hs4233@mail.mn-solutions.de>
	 <20071205213044.GA5659@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 15:07:42 +0000
Message-Id: <1196953662.13978.543.camel@pmac.infradead.org> (sfid-20071206_150959_095982_2DFA6241)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-05 at 16:30 -0500, John W. Linville wrote:
> On Wed, Dec 05, 2007 at 08:57:32PM +0100, Holger Schurig wrote:
> 
> > However, even with me having write access to libertas-2.6, I'd like
> > to keep posting patches to the mailing list so that more eyeballs
> > are seeing them and can speak up.
> 
> Amen

That makes a lot of sense; I wouldn't want to encourage you to do
otherwise.

Unfortunately it isn't a substitute for _testing_, as demonstrated by
the totally broken patch 'libertas: reset devices upon disconnect rather
than module unloading', which completely fails to issue the reset
command because it always gets -ENOENT from usb_submit_urb(), when
calling it from within the disconnect function.

Thankfully, we aren't forced to choose one _or_ the other.

-- 
dwmw2

