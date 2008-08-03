Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:64199 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYHCNah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:30:37 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2111627ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 06:30:35 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
Date: Sun, 3 Aug 2008 15:53:57 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <200808031207.08446.IvDoorn@gmail.com> <20080803132816.GC12118@khazad-dum.debian.net>
In-Reply-To: <20080803132816.GC12118@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808031553.58030.IvDoorn@gmail.com> (sfid-20080803_153040_072146_C8E1C8F7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 August 2008, Henrique de Moraes Holschuh wrote:
> On Sun, 03 Aug 2008, Ivo van Doorn wrote:
> > > BUG() never returns. Same for all the other places you pointed out.
> > 
> > Ah right, that doesn't sound too good. I don't think rfkill should
> > become a blocker like that. WARN_ON should be sufficient. :)
> 
> It would, if anyone ever tested the return from notify chain registering.
> But the core kernel doesn't do any checking when registering notifiers to
> the chains, and always either return zero or OOPS outright when it attempts
> to dereference a NULL pointer (at least on 2.6.25)...
> 
> So, I went with BUG().  Given the above, do you still want me to WARN() and
> return -EINVAL instead?  I can certainly do that, it would be more correct
> than what the core kernel is doing, anyway.

No, if  notify chain doesn't check, and convention is to use BUG() in this case,
then BUG() is fine with me.

Ivo
