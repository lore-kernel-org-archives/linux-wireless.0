Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37807 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469AbYGSNnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 09:43:53 -0400
Date: Sat, 19 Jul 2008 10:43:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] rfkill: document the rfkill struct locking
Message-ID: <20080719134349.GB11269@khazad-dum.debian.net> (sfid-20080719_154357_117049_36170EF1)
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-4-git-send-email-hmh@hmh.eng.br> <200807191439.02853.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807191439.02853.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 19 Jul 2008, Ivo van Doorn wrote:
> On Tuesday 15 July 2008, Henrique de Moraes Holschuh wrote:
> > Reorder fields in struct rfkill and add comments to make it clear
> > which fields are protected by rfkill->mutex.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> >  include/linux/rfkill.h |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> > index c5f6e54..630b573 100644
> > --- a/include/linux/rfkill.h
> > +++ b/include/linux/rfkill.h
> > @@ -89,13 +89,14 @@ struct rfkill {
> >  	const char *name;
> >  	enum rfkill_type type;
> >  
> > -	enum rfkill_state state;
> > +	void *data;
> >  	bool user_claim_unsupported;
> >  	bool user_claim;
> >  
> > +	/* the mutex serializes callbacks and also protects
> > +	 * the state */
> 
> Please move/copy the comment into the kerneldoc above the
> structure declaration as well.

Done.

> >  	struct mutex mutex;
> > -
> > -	void *data;
> 
> Not a real problem, but the data pointer doesn't need to be moved,
> since it is only used for the callback functions. So technically it is
> under the protection of the mutex as well.

Ok, I won't move it then, since it means any changes (not that anyone
should BE changing that field) would need to be under the mutex.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
