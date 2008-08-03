Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60337 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122AbYHCN2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:28:21 -0400
Date: Sun, 3 Aug 2008 10:28:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
Message-ID: <20080803132816.GC12118@khazad-dum.debian.net> (sfid-20080803_152823_644922_560C74B6)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <200808031007.48877.IvDoorn@gmail.com> <1217753845.4721.1.camel@johannes.berg> <200808031207.08446.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808031207.08446.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Ivo van Doorn wrote:
> > BUG() never returns. Same for all the other places you pointed out.
> 
> Ah right, that doesn't sound too good. I don't think rfkill should
> become a blocker like that. WARN_ON should be sufficient. :)

It would, if anyone ever tested the return from notify chain registering.
But the core kernel doesn't do any checking when registering notifiers to
the chains, and always either return zero or OOPS outright when it attempts
to dereference a NULL pointer (at least on 2.6.25)...

So, I went with BUG().  Given the above, do you still want me to WARN() and
return -EINVAL instead?  I can certainly do that, it would be more correct
than what the core kernel is doing, anyway.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
