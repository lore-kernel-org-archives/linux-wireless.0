Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:56542 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbYDLCgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 22:36:54 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Add Realtek 8187B support
Date: Fri, 11 Apr 2008 23:36:50 -0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>
References: <200804081931.07638.herton@mandriva.com.br> <200804100143.32854.herton@mandriva.com.br> <47FEEFCE.6040006@lwfinger.net>
In-Reply-To: <47FEEFCE.6040006@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804112336.50903.herton@mandriva.com.br> (sfid-20080412_033706_411225_CE4504E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Friday 11 April 2008 01:57:50 Larry Finger escreveu:
> Herton Ronaldo Krzesinski wrote:
> > 
> > Can you open your dongle and see if you really have a RTL8187B? (as you
> > said you had to force the ID). May be it wasn't really a 8187b device but
> > another variant. I did many tests this week with a 8187b that continues to
> > work ok.
> 
> I don't want to open it as it should still be under warranty. I'm
> pretty sure it is an 8187b. When I tried it with the 8187 driver, it
> gets an rf calibration error. By using your driver with the patch
> below, it loaded and worked, at least for a while. It probably was a
> natural death, but I felt I should issue a warning, jest in case.

Yes, I'm too concerned about the fact that could be the patch that fried your
dongle. So any people playing with my patch should be careful. It prompted
me to try a long ping -f session from the machine I have with a rtl8187b, mine
continues to work ok (after one day of ping -f), but any sign of problem I will
report. I think you have a real 8187b, but anyway could be there a possibility
that it's a variant that requires different code (could explain the different id),
or is just the patch, or just was a natural death.

Anyway would be great if someone could review my patch and compare to
Realtek code, I did the same initialization/set tx power code, may be something
is wrong/missing.

> 
> I was going to hold the following patch until I had more to 
> contribute; however, I don't know if I will be able to participate. 
> Please apply the patch, as it lets devices like mine, where the 
> iProduct string identifies is as an RTL8187B device, but the idProduct 
> value is 0x8187, not 0x8189.

Thanks for the patch, I'll include your changes. Also I found today another
minor thing missing from my patch, I need to set "dev->queues = 4" for rtl8187b,
as it has qos (the four endpoints in tx code). Anyone getting current patch can
fix this for now. Sometime I'll post an updated patch.

> 
> Thanks,
> 
> Larry

-- 
[]'s
Herton
