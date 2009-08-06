Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:23396 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbZHFKMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 06:12:41 -0400
Subject: Re: rt2800usb: memory corruption?
From: Pavel Roskin <proski@gnu.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1249195641.23166.12.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <1248948326.8823.4.camel@marge.simson.net>
	 <1248955916.7995.47.camel@marge.simson.net>
	 <1249104348.7146.60.camel@marge.simson.net>
	 <1249124154.8236.5.camel@marge.simson.net>  <1249172514.3043.7.camel@ct>
	 <1249190209.7486.4.camel@marge.simson.net>
	 <1249194546.7634.4.camel@marge.simson.net>
	 <1249195641.23166.12.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 06:12:34 -0400
Message-Id: <1249553554.24439.11.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-08-02 at 08:47 +0200, Mike Galbraith wrote:
> P.S.  I'm no longer considering moving box away from router (and if I
> ever do, I'll use repeater instead), so wireless connectivity via this
> adapter is a dead issue here.  Since I have the hw though, if anyone
> wants patches tested, feel free to holler, and I'll give them a spin.

The fix is here:
http://marc.info/?t=124942266800001&r=1&w=2

kmemcheck wasn't helpful at resolving it, as the problem was with
writing after the end of allocated memory, not with reading
uninitialized memory.  SLUB debugging nailed it as soon as I took care
to understand what it was telling me.

As for the issue you found by kmemcheck, it's most certainly unrelated.
If you can reproduce it with the rt2xxx patch, consider reporting it to
the netdev list.  It would be helpful if you find what line is
triggering it and include your .config file.

-- 
Regards,
Pavel Roskin
