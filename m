Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2GIIDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 04:03:50 -0400
Message-ID: <1341821025.4455.5.camel@jlt3.sipsolutions.net> (sfid-20120709_100356_460443_4A366349)
Subject: Re: [PATCH 7/8] wl18xx: don't send static global struct to FW
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Date: Mon, 09 Jul 2012 10:03:45 +0200
In-Reply-To: <CA+XVXfdEqQyiyDQoAddCjC9bhH+WqmANiqf_wUCEJFi7=xG5vQ@mail.gmail.com> (sfid-20120708_160818_442044_B37D5738)
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
	 <1341732211-25871-8-git-send-email-coelho@ti.com>
	 <1341740110.4987.4.camel@jlt3.sipsolutions.net>
	 <CA+XVXfdEqQyiyDQoAddCjC9bhH+WqmANiqf_wUCEJFi7=xG5vQ@mail.gmail.com>
	 (sfid-20120708_160818_442044_B37D5738)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-08 at 17:08 +0300, Arik Nemtsov wrote:

> > kzalloc (which is pointless -- use kmemdup) alignment is sufficient,
> > then most likely you could just put "__aligned(4)" or something on the
> > conf.phy struct member and not allocate memory at all?
> 
> Yea we need 4 bytes alignment. The kzalloc is a sort of convention in
> the driver (see acx.c), but probably here we can use kmemdup.
> We can't use fancy __aligned(4) notations most likely, since a
> usermode tool also parses these header files, and it's not too smart
> :)

This seems like a rather bad excuse for making the runtime code more
complex and less performant ... I'll let you sort it out with John
though, I wouldn't let you get away with this though if I maintained the
tree ;-)

FWIW, I think your actual problem is that you mark wl18xx_priv_conf as
packed unnecessarily. Otherwise it might actually get alignment, at
least on ARM I hear.

johannes

