Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47032 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab1EMXji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 19:39:38 -0400
Received: by fxm17 with SMTP id 17so2069464fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 16:39:37 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] carl9170: advertise interface combinations
Date: Sat, 14 May 2011 01:39:34 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <201105140035.06559.chunkeey@googlemail.com> <1305329300.32461.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1305329300.32461.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201105140139.34401.chunkeey@googlemail.com> (sfid-20110514_013945_794963_12CA5210)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 14 May 2011 01:28:20 Johannes Berg wrote:
> On Sat, 2011-05-14 at 00:35 +0200, Christian Lamparter wrote:
> > In order to provide multiple interfaces for a single device,
> > the driver is now required to advertise all possible
> > interface configurations to the stack.
> 
> Cool, thanks! Note that currently it's not yet required, but
> whatever :-)
"currently" :D

"I want to make you aware that I plan to remove the
WIPHY_FLAG_ENFORCE_COMBINATIONS flag again soon, so that all
drivers that don't advertise valid combinations will not be able to have
multiple virtual interfaces."

> > with the standard firmware, iw now displays:
> > 	[...]
> >         valid interface combinations:
> >                  * #{ IBSS, managed, AP, P2P-client, P2P-GO } <= 2,
> >                    total <= 2, #channels <= 1
> 
> Since mac80211 doesn't allow multiple IBSS interfaces, I think you
> should leave that out. And I should probably make mac80211 complain if
> it's advertised erroneously.
what about "valid" configurations like:
1 IBSS + 1 AP [STA/P2P make less sense]? 
(only one IBSS)

Regards,
	Chr
