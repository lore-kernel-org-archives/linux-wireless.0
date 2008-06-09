Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:20908 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYFIQZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 12:25:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2168184wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 09:25:02 -0700 (PDT)
Subject: Re: [PATCH 4/7] mac80211: make ieee80211_get_hdrlen_from_skb
	return unsigned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213002931.698.65.camel@johannes.berg>
References: <1212774672.6340.78.camel@brick>
	 <200806062024.24681.mb@bu3sch.de>  <1212778061.6340.85.camel@brick>
	 <1212783357.29134.5.camel@dv>  <1212805460.6340.91.camel@brick>
	 (sfid-20080607_042423_652950_5D44593F)  <1213002931.698.65.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 09:25:01 -0700
Message-Id: <1213028701.5974.11.camel@brick> (sfid-20080609_182507_122888_7027AA69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 11:15 +0200, Johannes Berg wrote:
> > unlikely() isn't some magic make-me-faster function, it just moves
> > code
> > to the end of the function to get it out of the icache and jumps to it
> > in the unlikely case it is taken.  When all there is is a return, I
> > don't think it even makes any difference.  In both these cases a
> > comment
> > is probably more appropriate.
> 
> That's not true on ppc where you can actually tell the processor about
> the jump likelyhood for its branch prediction.

I was unaware of that.

> 
> > On X86-32 at least the generated code is exactly the same with or
> > without the unlikely()s.  I'll put them back in a follow-on if people
> > are really attached to them.
> 
> Please keep them there, I think they make sense for normal operation.

Kept, will be in a v2.

Harvey

