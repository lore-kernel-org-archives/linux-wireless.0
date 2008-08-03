Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56426 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbYHCNgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:36:21 -0400
Date: Sun, 3 Aug 2008 10:36:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
Message-ID: <20080803133614.GE12118@khazad-dum.debian.net> (sfid-20080803_153623_835659_CA1FE5C3)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <200808031207.08446.IvDoorn@gmail.com> <20080803132816.GC12118@khazad-dum.debian.net> <200808031553.58030.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808031553.58030.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Ivo van Doorn wrote:
> > So, I went with BUG().  Given the above, do you still want me to WARN()
> > and return -EINVAL instead?  I can certainly do that, it would be more
> > correct than what the core kernel is doing, anyway.
> 
> No, if  notify chain doesn't check, and convention is to use BUG() in this
> case, then BUG() is fine with me.

The convention is to just OOPS, which I find terribly disgusting :-) so we
really can do whatever you want.

I used BUG() because the kernel-doc for the core kernel functions state that
for now they always return zero, AND because almost all the time the drivers
will be registering static text pointers as notifier blocks, so passing NULL
to these functions would be a very rare mistake indeed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
