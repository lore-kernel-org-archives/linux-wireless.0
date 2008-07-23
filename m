Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40049 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbYGWP3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 11:29:32 -0400
Date: Wed, 23 Jul 2008 12:27:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rfkill: detect bogus double-registering
Message-ID: <20080723152759.GC4684@khazad-dum.debian.net> (sfid-20080723_172951_981997_30056644)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-2-git-send-email-hmh@hmh.eng.br> <1216784519.13587.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216784519.13587.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Jul 2008, Johannes Berg wrote:
> > +	list_for_each_entry(p, &rfkill_list, node) {
> > +		if (p == rfkill)
> > +			return -EEXIST;
> > +		set_bit(p->type, &seen);
> 
> You should WARN_ON so it can get fixed.

I'd rather make rfkill_register __must_check, actually.  With or without
WARN_ON.

In fact, lots of stuff in rfkill should be __must_check.  Ivo, what do you
think?  Add __must_check?  Add WARN_ON?  Add both?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
