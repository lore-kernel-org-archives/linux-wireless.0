Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:8519 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbXB1Spd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:45:33 -0500
Received: by nf-out-0910.google.com with SMTP id o25so641665nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 10:45:32 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: split RT2X00 option
Date: Wed, 28 Feb 2007 19:45:28 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281926.38820.IvDoorn@gmail.com> <1172687756.5015.65.camel@johannes.berg>
In-Reply-To: <1172687756.5015.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281945.28426.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 19:35, Johannes Berg wrote:
> On Wed, 2007-02-28 at 19:26 +0100, Ivo van Doorn wrote:
> 
> > Make the debug(fs) config options depend on this new
> > config option.
> 
> I like that.

:)

> >  config RT2X00_DEBUGFS
> >  	tristate "Ralink debugfs support"
> > -	depends on RT2X00 && DEBUG_FS
> > +	depends on RT2X00 && RT2X00_LIB && DEBUG_FS
> >  	---help---
> >  	Enable creation of debugfs files for the rt2x00 drivers.
> >  	These debugfs files support both reading and writing of the
> 
> If you think hard about it, this also solves the problem of having
> drivers built-in when the debugfs module isn't. 

Actually it doesn't fix that problem. :( It remains possible to
compile all drivers into the kernel but keeping rt2x00debug.ko as
module. But the solution really would be:

> But couldn't you just  
> link the debugfs module into the lib module instead of making it an own
> module? I don't see any point in having it separate since there will be
> a dependency anyway.

My words exactly. ;)

Merging those 2 modules has been placed on my todo list,
I'll try to have this done as soon as possible.

Ivo
