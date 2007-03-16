Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54366 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753557AbXCPPj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 11:39:27 -0400
Date: Fri, 16 Mar 2007 16:39:25 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <jkm@devicescape.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: cfg/nl80211 primitives
Message-ID: <20070316163925.4a2d209e@griffin.suse.cz>
In-Reply-To: <1173382607.3248.65.camel@johannes.berg>
References: <1173219649.3503.50.camel@johannes.berg>
	<20070308004940.GC31388@devicescape.com>
	<1173380977.3248.55.camel@johannes.berg>
	<1173382599.3020.34.camel@localhost.localdomain>
	<1173382607.3248.65.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 08 Mar 2007 20:36:46 +0100, Johannes Berg wrote:
> On Thu, 2007-03-08 at 14:36 -0500, Dan Williams wrote:
> > I'd basically expected that this was the model we'd be using anyway.  A
> > user tool wouldn't have to:
> > 
> > set ssid
> > set key
> > set authmode
> > associate
> > 
> > but instead bundle all those up into one message to netlink with the
> > "associate" command or something.
> 
> Right. However, as far as I understood some people at the wireless
> summit, they'd prefer having one command that bundles all the settings
> and then another one that applies them. Maybe it's just a
> misunderstanding on my part and this whole thread is pointless?

I think I was one of people who differentiated "config" and "action"
calls. The problem with wext is that we don't know when association
should take place. (When setting a parameter? Which one?) We need to
have a well defined place at which association occurs. I don't care how
this is achieved as long as it's fulfilled. One solution is to have a
separate (that doesn't mean it cannot be bundled with other commands)
"associate" request. There are surely other solutions.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
