Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50551 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZC0PA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:00:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill-input: remove unused code
Date: Fri, 27 Mar 2009 15:59:02 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1238159804.4452.4.camel@johannes.local> <20090327143608.GB24288@khazad-dum.debian.net>
In-Reply-To: <20090327143608.GB24288@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903271559.02276.mb@bu3sch.de> (sfid-20090327_160029_818108_A8662EB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 March 2009 15:36:08 Henrique de Moraes Holschuh wrote:
> On Fri, 27 Mar 2009, Johannes Berg wrote:
> > There's a lot of rfkill-input code that cannot ever be
> > compiled and is useless until somebody needs and tests
> > it -- therefore remove it.
> 
> Just so that you guys know, that code *is* tested :-)
> 
> I'd suggest that the code removal be done leaving a comment in place, like this:
> 
> /* Currently, code to implement EV_SW SW_WLAN/WWAN/BLUETOOTH/etc is not
>  * in place since it was unused and was therefore removed.  Please look
>  * at past history to check how it was supposed to be done, if you need
>  * to implement handling for EV_SW.
>  */
> 
> Because that codepath is _not_ the most obvious thing in the world to
> reimplement without hitting a pitfall, so people better look how it was done
> once in time...
> 

In practice this stuff does bitrot.
So in my opinion it's _not_ a good idea to lookup some old code for implementing
a feature. Instead one should think about it and understand the stuff and then implement it.
And if there are pitfalls that are not obvious after one completely read the code, one
should consider a redesign.

-- 
Greetings, Michael.
