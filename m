Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43848 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZDFKMw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 06:12:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: b43 WARN_ON
Date: Mon, 6 Apr 2009 12:12:10 +0200
Cc: wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <49D97CF5.4040808@lwfinger.net>
In-Reply-To: <49D97CF5.4040808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200904061212.10398.mb@bu3sch.de> (sfid-20090406_121256_408308_6EE884A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 April 2009 05:54:29 Larry Finger wrote:
> Using the latest rfkill patches posted by Johannes, I am hitting the following
> 
>         if (WARN_ON(!wl->rfkill.registered))
>                 return -EINVAL;

I think we should simply remove the warning.
In the previous rfkill implementation I had a reason to _not_ warn here.
(It had one valid codepath where it was called. I don't remember the details...)

Anyway, please feel free to do a patch that removes the warning (but not the check).

> 
> in b43_rfkill_soft_set() as follows:
> 
> ------------[ cut here ]------------
> WARNING: at drivers/net/wireless/b43/rfkill.c:77 b43_rfkill_soft_set+0x38/0xb3
> [b43]()
> Hardware name: HP Pavilion dv2700 Notebook PC
> --snip--
> ---[ end trace a1ef19d1571fdb71 ]---
> b43 ssb0:0: firmware: requesting b43/ucode5.fw
> b43 ssb0:0: firmware: requesting b43/pcm5.fw
> b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
> b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
> b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
> b43-phy0 debug: Chip initialized
> b43-phy0 debug: 32-bit DMA initialized
> Registered led device: b43-phy0::tx
> Registered led device: b43-phy0::rx
> Registered led device: b43-phy0::radio
> b43-phy0 debug: Wireless interface started
> b43-phy0 debug: Adding Interface type 2
> b43-phy0: Radio turned on by software
> 
> Larry
> 
> 



-- 
Greetings, Michael.
