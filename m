Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13521 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYEWO6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 10:58:00 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Johan Adolfsson" <Johan.Adolfsson@axis.com>
Subject: Re: [PATCH] libertas: before sleeping, check for a command result
Date: Fri, 23 May 2008 16:57:42 +0200
Cc: libertas-dev@lists.infradead.org,
	"'Dan Williams'" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"'John W. Linville'" <linville@tuxdriver.com>
References: <002701c8bce1$04097010$0137550a@se.axis.com>
In-Reply-To: <002701c8bce1$04097010$0137550a@se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805231657.42433.hs4233@mail.mn-solutions.de> (sfid-20080523_165806_879529_A973BB96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I have experience a couple of timeout and resends and after
> sending another commands I get the response from the previous
> one, and the patch seems to solve a couple of those for me -
> still se some problem fetching packet from  firmware with ret
> = -22 though. And it could be dependant on how much debug I
> have turned on..

Keep in mind that maybe the firmware actually really takes ages 
to complete a command. David Woodhouse reported this.

In my case, because I had the proper debugging statements in my 
interrupt handler, I knew for sure that I already received the 
response. Can you verify that, for the comment timeouts you 
noticed, if this did happen or not?


> But, shouldn't the above priv->event_fifo check move before
> cur_cmd  as well?

Maybe, my change to the thread was just a shot into the dark, I 
don't claim that I fully understand it. Maybe Dan or David can 
help you with this.

> I have no clue what kind of events we are talking about here
> and if those can be processed independent of if a cmd is
> running or not, just trigged on the comment.

The kfifo contains hostevents (e.g. link lost, deauthenticated) 
and command responses. Hmm, not sure if the latter is still 
true.
