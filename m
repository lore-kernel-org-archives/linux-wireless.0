Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63018 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbXE3VYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2007 17:24:08 -0400
Message-ID: <465DEB75.9070400@lwfinger.net>
Date: Wed, 30 May 2007 16:24:05 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	mabbas@linux.intel.com
Subject: Re: [PATCH] mac80211: Implementation of SIOCSIWRATE
References: <465c68e1.+11Pl6vbVkaPA39A%Larry.Finger@lwfinger.net> <200705292345.50212.flamingice@sourmilk.net>
In-Reply-To: <200705292345.50212.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Tuesday 29 May 2007 10:54, Larry Finger wrote:
>> From: Mohamed Abbas <mabbas@linux.intel.com>
>>
> So.. how much of this is still from mabbas now?

Only a small fraction of his original patch is left, but he contributed about half of what is left. 
I think he still needs credit.

>> +	/* value = -1, rate->fixed = 0 means auto only, so use all rates
>> +	 * value = X, rate->fixed = 1 means only rate X
>> +	 * value = X, rate->fixed = 0 means all rates <= X */
> Only the second case actually works with this code.
> 
> When a frame is being transmitted, the rate control runs this little bit of 
> code (rc80211_simple.c, line 255):
> 
>         if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
>                 sta->txrate = sdata->bss->force_unicast_rateidx;
> 
> This means:
> 1. If force_unicast_rateidx is set to 0 or higher, the tx rate will be fixed 
> to just that one rate, and..
> 2. sta->txrate is automatically set from force_unicast_rateidx as necessary.

I'm testing a revised version now.

Larry
