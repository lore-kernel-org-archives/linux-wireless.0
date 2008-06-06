Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63340 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbYFFUP6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 16:15:58 -0400
Subject: Re: [PATCH 4/7] mac80211: make ieee80211_get_hdrlen_from_skb
	return unsigned
From: Pavel Roskin <proski@gnu.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212778061.6340.85.camel@brick>
References: <1212774672.6340.78.camel@brick>
	 <200806062024.24681.mb@bu3sch.de>  <1212778061.6340.85.camel@brick>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Jun 2008 16:15:57 -0400
Message-Id: <1212783357.29134.5.camel@dv> (sfid-20080606_221604_019692_97F978BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-06 at 11:47 -0700, Harvey Harrison wrote:

> unlikely() isn't some magic make-me-faster function, it just moves co=
de
> to the end of the function to get it out of the icache and jumps to i=
t
> in the unlikely case it is taken.  When all there is is a return, I
> don't think it even makes any difference.  In both these cases a comm=
ent
> is probably more appropriate.

If we don't more return to the end, we get something like:

compare skb->len to 10
if more or equal goto 1
return
1: <the likely case>

=EF=BB=BFI don't know much about modern processor design, but I remembe=
r reading
that even a very short jump would flush the instruction pipeline and
cause some delay.

I would keep unlikely() and let the compiler think what to do with it.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
