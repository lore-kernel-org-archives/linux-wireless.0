Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56651 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab2LTKZS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 05:25:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TldJi-0008Se-1z
	for linux-wireless@vger.kernel.org; Thu, 20 Dec 2012 11:25:30 +0100
Received: from aslw039181.ethz.ch ([129.132.39.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 11:25:30 +0100
Received: from dantard by aslw039181.ethz.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 11:25:30 +0100
To: linux-wireless@vger.kernel.org
From: Danilo <dantard@unizar.es>
Subject: Re: Incoherency in iw (or mac80211 or drivers) behavior -- possible BUG in iwl4965
Date: Thu, 20 Dec 2012 10:25:04 +0000 (UTC)
Message-ID: <loom.20121220T112036-707@post.gmane.org> (sfid-20121220_112523_258414_829A6099)
References: <loom.20121219T172801-213@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Danilo <dantard@...> writes:

> 
> Hello,
> I figured out that the command: 
> 
> iw dev wlan0 set bitrates legacy-5 24
> 
> has different behaviors in different devices.
> 
> With iwl3945 wireless cards, it fixes the rate at 24Mbps ALSO for multicast 
> frames while in iwl4965 cards, it doesn't.
> 
> In both cases I tried with ubuntu linux 12.04 and kernel-3.2.0-32-generic 
using  
> iwl4965/iwl_legacy driver for 4965 and iwl3945/iwl_legacy driver for 3945.
> 
> I've also tried with compat-wireless-3.6, same result.
> 
> What's the expected behavior? 
> 
> Thanks in advance,
>  D. Tardioli
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hello,
I answer myself:
I've tried with ath5k-compatible card and it behaves like iwl3945.
It means that when fixed the bitrates with a single value, the card always use 
that bitrate ALSO for broadcast frames.

The iwl4965 doesn't behave this way.
Any suggestion on how to solve the problem?

Regards.



