Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34489 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZDMVSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 17:18:34 -0400
From: Christian Lamparter <chunkeey@web.de>
To: maximilian attems <max@stro.at>
Subject: Re: [PATCH] ath: add module information
Date: Mon, 13 Apr 2009 23:18:32 +0200
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200904132244.24122.chunkeey@web.de> <20090413204430.GH31922@baikonur.stro.at>
In-Reply-To: <20090413204430.GH31922@baikonur.stro.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200904132318.32767.chunkeey@web.de> (sfid-20090413_231838_148883_720F03DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 April 2009 22:44:30 maximilian attems wrote:
> On Mon, Apr 13, 2009 at 10:44:23PM +0200, Christian Lamparter wrote:
> > diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
> > index a005b91..4bb0132 100644
> > --- a/drivers/net/wireless/ath/Makefile
> > +++ b/drivers/net/wireless/ath/Makefile
> > @@ -3,5 +3,4 @@ obj-$(CONFIG_ATH9K)		+= ath9k/
> >  obj-$(CONFIG_AR9170_USB)        += ar9170/
> >  
> >  obj-$(CONFIG_ATH_COMMON)	+= ath.o
> > -ath-objs 		:= regd.o
> > -
> > +ath-objs 		:= main.o regd.o
> 
> why do you put that in a different file and not in ath.c?
which ath.c?

besides, is this possible?
as kbuild will then generate two ath.o
- one from ath.c.
- when all ath-objs are merged into ath.o
  so we end up reading & writing to the same file?!

Regards,
	Chr
