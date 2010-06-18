Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab0FRKTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:19:49 -0400
Received: by fxm10 with SMTP id 10so497845fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jun 2010 03:19:47 -0700 (PDT)
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1276853327.3638.17.camel@jlt3.sipsolutions.net>
References: <1275395142.14385.6.camel@maxim-laptop>
	 <1276853327.3638.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 13:19:44 +0300
Message-ID: <1276856384.9114.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-18 at 11:28 +0200, Johannes Berg wrote: 
> Maxim,
> 
> > 2. mulicast/broadcast is broken.
> > this results in DHCP non working on open access point.
> > It seems that DHCP does work on my home wireless, but avahi-autoipd
> > doesn't see any neighbours, and this is annoying.
> > It can be worked around by doing (sudo ifconfig wlan0 promisc)
> 
> Reinette has reverted the patch in iwlwifi-2.6, but I think I actually
> just now identified the problem. Can you try one or two things for me?
> 
>  1) with the patch reverted, which is what presumably you're running
>     now, can you try
>     ifconfig wlan0 allmulti
>     ifconfig wlan0 -allmulti
> 
>     I think this will *break* the driver right now.

I didn't exactly understand how this supposed to break it.


> 
>  2) with the patch *not* reverted, apply the patch below and see if that
>     fixes the problem as well (if it gets mangled, just remove the one
>     CHK() line manually)
> 
> Actually, (2) is obviously more important to me, but (1) would indicate
> that my guess is correct wrt. what's causing the problem
I tested (2) and it works.



Best regards,
Maximm Levitsky

