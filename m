Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:38240 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032Ab1BRX3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 18:29:44 -0500
Subject: Re: [RFC] AI support (2/14 ssb helpers)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1298070945.25739.31.camel@dev.znau.edu.ua> (sfid-20110219_002424_959914_4197FDC7)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297980484.23381.4.camel@dev.znau.edu.ua>
	 (sfid-20110217_231646_647052_FFFFFFFFEFB25F2A)  <1298068149.23801.16.camel@maggie>
	 <1298070945.25739.31.camel@dev.znau.edu.ua>
	 (sfid-20110219_002424_959914_4197FDC7)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 00:29:37 +0100
Message-ID: <1298071777.23801.42.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-19 at 01:15 +0200, George Kashperko wrote: 
> > On Fri, 2011-02-18 at 00:08 +0200, George Kashperko wrote: 
> > > 	const struct ssb_bus_ops *ops;
> > > +	const struct ssb_bus_helpers *helpers;
> > 
> > Uhm, well. "helpers"... . Seems like a pretty generic term.
> > 
> > I think this is still violating abstraction layering. Not as much
> > as your previous attempt, but still...
> > 
> > You're putting the ops structure that is supposed to abstract
> > the ssb bus into the ssb_device data structure. That should ring a bell.
> > 
> Reconsidered it already while arranging patches for Openwrt (the reason
> helpers were in device struct was to speedup access but these aint
> called often therefore they are in ssb_bus now). Also moved

I should probably note that in my opinion ssb_bus is not the right place
to put ops that are supposed to abstract the SSB bus, too. ;)
_No_ SSB structure is the right place to put an ops pointer that is
supposed to abstract the SSB bus.

-- 
Greetings Michael.

