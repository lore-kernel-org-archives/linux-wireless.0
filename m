Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44388 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760356AbYHSVxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 17:53:20 -0400
Date: Tue, 19 Aug 2008 18:53:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rfkill: use strict_strtoul
Message-ID: <20080819215310.GB29336@khazad-dum.debian.net> (sfid-20080819_235325_468799_27DEB921)
References: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br> <1217699786-20672-3-git-send-email-hmh@hmh.eng.br> <20080817181617.GA30679@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080817181617.GA30679@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 17 Aug 2008, John W. Linville wrote:
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

It is the safest way (read: it won't go wrong if we change user_claim and
claim types) to do it AFAIK, and the compiled is in charge of optimizing it
properly.

> > @@ -410,7 +418,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
> >  					    0);
> >  			mutex_unlock(&rfkill->mutex);
> >  		}
> > -		rfkill->user_claim = claim;
> > +		rfkill->user_claim = !!claim;
> >  	}
> >  
> >  	mutex_unlock(&rfkill_mutex);
> 
> You seem to be doing the only assignment to 'rfkill->user_claim',
> using a '!!' to condition the input?

user_claim is externally accessible, I thought it best to play safe.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
