Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39909 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaE0PaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 11:30:12 -0400
Date: Tue, 27 May 2014 11:23:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: chaitanya.mgit@gmail.com, mcgrof@gmail.com,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [regdb] Add support to parse 2000mW tx power
Message-ID: <20140527152357.GA5694@tuxdriver.com> (sfid-20140527_173017_240334_65DDA67F)
References: <1401089962-10720-1-git-send-email-chaitanya.mgit@gmail.com>
 <1401097086.29704.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401097086.29704.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 11:38:06AM +0200, Johannes Berg wrote:
> On Mon, 2014-05-26 at 13:09 +0530, chaitanya.mgit@gmail.com wrote:
> 
> > @@ -74,7 +74,7 @@ function parse_reg_rule()
> >  			power = 23
> >  		} else if (power == 500) {
> >  			power = 27
> > -		} else if (power == 1000) {
> > +		} else if ((power == 1000) || (power == 2000)) {
> >  			power = 30
> 
> This seems like a pretty sick thing to do to start with, and certainly
> power=30 isn't right for 2000mW...

Heh...it was like that in my original version!  

> Can't awk calculate the logarithm?

I probably didn't know how to compute it in awk.  I still don't OTOH...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
