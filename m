Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43351 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYJaQBZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:01:25 -0400
Subject: Re: Guidelines regarding separate directory
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <1225447269.3535.4.camel@johannes.berg>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com> <1225399481.7931.5.camel@dv>
	 <1225399682.3690.82.camel@johannes.berg>
	 <20081030231054.ehd21qipcow4kg88-cebfxv@webmail.spamcop.net>
	 <1225447269.3535.4.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 12:01:09 -0400
Message-Id: <1225468869.21997.5.camel@dv> (sfid-20081031_170129_611642_5EF08F0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-31 at 11:01 +0100, Johannes Berg wrote:
> On Thu, 2008-10-30 at 23:10 -0400, Pavel Roskin wrote:
> > Quoting Johannes Berg <johannes@sipsolutions.net>:
> 
> > The WPA support in orinoco is limited to Agere firmware.  Maybe Symbol  
> > firmware will be supported at some point.  But adding WPA support for  
> > Intersil firmware would duplicate efforts.
> 
> Yes, I know, but wouldn't adding that based on the hostap stuff be
> fairly simple? I know nobody has time to...

OK, we'll see.  The orinoco driver was written in the assumption that
the three kinds of firmware (and hardware) it supports are very similar.
Once we are trying to do the advanced stuff like WPA, the differences
are everywhere.  There are actually few similarities.  It could be
handled by moving specific routines to separate files and using tables
of functions.

> > The only thing I would like to change in hostap is that it should  
> > default to managed mode, like other drivers do.
> 
> No, that's not true, just see
> http://bugzilla.kernel.org/show_bug.cgi?id=11802 for example. The AP
> part also duplicates a lot of mac80211 functionality.

I thought I was due to my local changes that I never published.  It's
actually good news for me that others are getting it with the unmodified
driver!

-- 
Regards,
Pavel Roskin
