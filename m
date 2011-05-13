Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab1EMX2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 19:28:22 -0400
Subject: Re: [PATCH] carl9170: advertise interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <201105140035.06559.chunkeey@googlemail.com> (sfid-20110514_003534_792599_E8DC06EE)
References: <201105140035.06559.chunkeey@googlemail.com>
	 (sfid-20110514_003534_792599_E8DC06EE)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 01:28:20 +0200
Message-ID: <1305329300.32461.0.camel@jlt3.sipsolutions.net> (sfid-20110514_012825_658153_23C4ED22)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 00:35 +0200, Christian Lamparter wrote:
> In order to provide multiple interfaces for a single device,
> the driver is now required to advertise all possible
> interface configurations to the stack.

Cool, thanks! Note that currently it's not yet required, but
whatever :-)

> with the standard firmware, iw now displays:
> 	[...]
>         valid interface combinations:
>                  * #{ IBSS, managed, AP, P2P-client, P2P-GO } <= 2,
>                    total <= 2, #channels <= 1

Since mac80211 doesn't allow multiple IBSS interfaces, I think you
should leave that out. And I should probably make mac80211 complain if
it's advertised erroneously.

johannes

