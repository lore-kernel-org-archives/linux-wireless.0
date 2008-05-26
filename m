Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from miranda.se.axis.com ([193.13.178.8]:40267 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYEZQPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 12:15:43 -0400
Message-ID: <07f501c8bf4b$985d1a70$6401a8c0@ADOLAP> (sfid-20080526_181547_292795_2756FE85)
Reply-To: "Johan Adolfsson" <Johan.Adolfsson@axis.com>
From: "Johan Adolfsson" <Johan.Adolfsson@axis.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	"Johan Adolfsson" <johan.adolfsson@axis.com>
Cc: <libertas-dev@lists.infradead.org>,
	"'Dan Williams'" <dcbw@redhat.com>,
	<linux-wireless@vger.kernel.org>,
	"'John W. Linville'" <linville@tuxdriver.com>
References: <002701c8bce1$04097010$0137550a@se.axis.com> <200805231657.42433.hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] libertas: before sleeping, check for a command result
Date: Mon, 26 May 2008 18:14:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


----- Original Message ----- 
From: "Holger Schurig" <hs4233@mail.mn-solutions.de>
To: "Johan Adolfsson" <johana@axis.com>
Cc: <libertas-dev@lists.infradead.org>; "'Dan Williams'" <dcbw@redhat.com>; 
<linux-wireless@vger.kernel.org>; "'John W. Linville'" 
<linville@tuxdriver.com>
Sent: Friday, May 23, 2008 4:57 PM
Subject: Re: [PATCH] libertas: before sleeping, check for a command result


>> I have experience a couple of timeout and resends and after
>> sending another commands I get the response from the previous
>> one, and the patch seems to solve a couple of those for me -
>> still se some problem fetching packet from  firmware with ret
>> = -22 though. And it could be dependant on how much debug I
>> have turned on..
>
> Keep in mind that maybe the firmware actually really takes ages
> to complete a command. David Woodhouse reported this.
>
> In my case, because I had the proper debugging statements in my
> interrupt handler, I knew for sure that I already received the
> response. Can you verify that, for the comment timeouts you
> noticed, if this did happen or not?

While trying to find out what went wrong I believe I stumbled
on a cache issue since our sdio driver didn't invalidate the cache
and the DMA is not cachecoherent.

Possible something for others to check in their SDIO drivers
as well.
Ran into some weird problems when trying to verify if it solved my problem 
though, so I will get back with more info when I get it up and running 
again.

Best regards
/Johan


