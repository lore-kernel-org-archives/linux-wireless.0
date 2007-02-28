Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:3224 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbXB1PM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:12:56 -0500
Received: by nf-out-0910.google.com with SMTP id o25so581999nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 07:12:55 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
Date: Wed, 28 Feb 2007 16:12:51 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13004.IvDoorn@gmail.com> <1172674256.5015.15.camel@johannes.berg>
In-Reply-To: <1172674256.5015.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281612.51383.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 15:50, Johannes Berg wrote:
> On Wed, 2007-02-28 at 15:07 +0100, Ivo van Doorn wrote:
> 
> >  config RT2X00
> > -	bool "Ralink driver support"
> > +	tristate "Ralink driver support"
> >  	depends on NET_RADIO && MAC80211 && EXPERIMENTAL
> >  	---help---
> >  	This will enable the experimental support for the Ralink drivers,
> > @@ -7,6 +7,10 @@ config RT2X00
> >  
> >  	These drivers will make use of the Devicescape ieee80211 stack.
> >  
> > +	This option will build the rt2x00 library which is required by
> > +	each individual driver, when compiled as a module,
> > +	this library will be called "rt2x00lib.ko".
> 
> I think I'd prefer having a new symbol CONFIG_RT2X00_LIB that is
> selected by all sub-drivers that use it so that RT2X00 is a config-only
> symbol.

Is there any particular reason for RT2X00 to be a config only option?
When RT2X00 is a config only option, it would still require RT2X00 to be a
tristate option. Otherwise it is possible to build d80211 as module and
rt2400pci compiled in. And I am not sure if that is a desired possibility,
escpecially with the compilation errors that would produce.

It would also mean that both RT2X00 and RT2X00_LIB are options the user
can select (RT2X00_LIB  depending on Rt2X00 off course), I can't really see
the point in that.

> Btw, you really need to use quilt or such, the Date: header line on
> patch 8 is 6 seconds before patch 7 etc., they appear all out of order,
> and having them as a reply to the 0/28 would be nice too.

Yeah, I seem to have send the patch mails itself in the wrong order. :(
So the number in the subject line is correct, just the order of sending
was reversed.
I'll try to do better next time. :)

Ivo
