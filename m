Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38932 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYHQTcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 15:32:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] rfkill: use strict_strtoul
Date: Sun, 17 Aug 2008 21:31:52 +0200
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br> <1217699786-20672-3-git-send-email-hmh@hmh.eng.br> <20080817181617.GA30679@tuxdriver.com>
In-Reply-To: <20080817181617.GA30679@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808172131.52721.mb@bu3sch.de> (sfid-20080817_213221_678541_7FE1BA9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 August 2008 20:16:17 John W. Linville wrote:
> On Sat, Aug 02, 2008 at 02:56:26PM -0300, Henrique de Moraes Holschuh wrote:
> > Switch sysfs parsing to something that actually works properly.
> 
> > @@ -402,7 +410,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
> >  	if (error)
> >  		return error;
> >  
> > -	if (rfkill->user_claim != claim) {
> > +	if (!!rfkill->user_claim != !!claim) {
> >  		if (!claim) {
> >  			mutex_lock(&rfkill->mutex);
> >  			rfkill_toggle_radio(rfkill,
> 
> This looks a bit funny.  Is the '!!' in front of 'rfkill->user_claim'
> really necessary?  Especially since...

You can remove the !! in front of rfkill->user_claim, because rfkill->user_claim
is bool anyway. The compiler will implicitely apply !! to it where it is needed.

-- 
Greetings Michael.
