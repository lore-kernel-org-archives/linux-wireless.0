Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37717 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974AbZFKVFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 17:05:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: compat-wireless: ridiculous build speed
Date: Thu, 11 Jun 2009 23:05:33 +0200
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
References: <4A30CE70.4050605@web.de> <43e72e890906111148w1c242bd1qf97cb668a98f883e@mail.gmail.com>
In-Reply-To: <43e72e890906111148w1c242bd1qf97cb668a98f883e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906112305.33675.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 June 2009 20:48:13 Luis R. Rodriguez wrote:
> On Thu, Jun 11, 2009 at 2:29 AM, Jan Kiszka<jan.kiszka@web.de> wrote:
> > Hi,
> >
> > while watching compat-wireless-2009-06-11 doing baby-steps building all
> > its modules, I wonder what slows this down so horribly. No other
> > external module build package I know is that slow (I would say *at
> > least* one order of magnitude slower than normal). Is this really required?
> >
> > [ Hurray, it's finished! ]
> 
> I think the many depmod -ae are the culprit. This is in place to
> account for all the crap of madwifi which may be present or older
> drivers which have been renamed.
> 
> This could be improved. Patches are welcomed.
> 
> Ps. Try building with make -j 2, etc.

-j does not help. It will hardly build in parallel then. There's something
that serializes most of it (implicitly).

-- 
Greetings, Michael.
