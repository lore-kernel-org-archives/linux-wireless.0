Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab0LBRWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 12:22:05 -0500
Subject: Re: "Kernel bug detected" when using pktgen together with
 mac80211_hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201012021809.41623.helmut.schaa@googlemail.com>
References: <201012021731.09440.helmut.schaa@googlemail.com>
	 <1291307938.3481.48.camel@jlt3.sipsolutions.net>
	 <201012021809.41623.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 18:22:04 +0100
Message-ID: <1291310525.3481.49.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-02 at 18:09 +0100, Helmut Schaa wrote:
> Am Donnerstag 02 Dezember 2010 schrieb Johannes Berg:
> > On Thu, 2010-12-02 at 17:31 +0100, Helmut Schaa wrote:
> > 
> > > Unfortunately pktgen keeps a reference to the skb and thus pskb_expand_head
> > > triggers a BUG when called from mac80211. I worked around that issue by adding
> > > a skb_copy for shared skbs.
> > > 
> > > Maybe, someone else has a better idea on how to fix that?
> > 
> > Oops! That seems like the right way to fix it though.
> 
> Ok, thanks, I'll send a patch then. I guess we cannot use pskb_copy due to
> (for example) our own fragmenation list usage, right?

Not sure, we can't cope with non-linear SKBs right now...

johannes

