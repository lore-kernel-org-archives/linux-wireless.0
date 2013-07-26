Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3GZIED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:04:03 -0400
Message-ID: <1374825838.8248.6.camel@jlt4.sipsolutions.net> (sfid-20130726_100412_322496_93F3E720)
Subject: Re: [PATCH 0/2] beacon measurement (beacon filtering disable)
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>, emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Jul 2013 10:03:58 +0200
In-Reply-To: <87oba1yggl.fsf@purkki.adurom.net>
References: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
	 <87oba1yggl.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-17 at 07:10 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > We have beacon filtering (to reduce host wakeups) in our device,
> > but for some measurement/debug purposes we need to turn it off.
> 
> TBH I'm not really fond of this. I'm not really sure what's the use
> case but first this sounded a like a factory test for me, not something
> which a regular user would want to do.

Yeah, in a way that's true. FWIW, we could also connect it to testmode
and not worry about it for upstream, but it seemed that others might
want/need similar functionality.

> Can't we connect this to power save? When disabling power save we could
> also disable beacon filtering and would not need a separate command.

I'm not so sure that's a good idea. While superficially beacon filtering
is related to saving power, it's really a different thing - it's about
CPU/host power while powersave is about device power (RX chains etc.)
Connecting them, in particular where disabling beacon filtering isn't
even supported by all devices, doesn't really seem like a good idea,
particularly not for any tool that would require such functionality.

johannes

