Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc2-s26.bay0.hotmail.com ([65.54.246.162]:52240 "EHLO
	bay0-omc2-s26.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbYKJPNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 10:13:16 -0500
Message-ID: <BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl> (sfid-20081110_161320_885070_5238FAAD)
Message-ID: <49184F82.9070102@hotmail.com>
Date: Tue, 11 Nov 2008 02:13:06 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com>	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>	 <200810251325.07916.mb@bu3sch.de>	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com>	 <1226149894.3610.8.camel@johannes.berg>  <491653A6.20705@hotmail.com> <1226220992.3614.16.camel@johannes.berg> <4916F1C0.1040703@hotmail.com>
In-Reply-To: <4916F1C0.1040703@hotmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

On 10/11/08 01:20, Shaddy Baddah wrote:
]> So you can see that skb->data is not even 2-byte aligned. And my debug
> leads me to believe that the problem is this line in zd_mac_tx_to_dev():
> 
>                  skb_pull(skb, sizeof(struct zd_ctrlset));
> 
> A before and after of this line gives me this output:
> 
> Nov 10 00:47:17 trad kernel: [ 8239.534065] 
> drivers/net/wireless/zd1211rw/zd_mac.c:376: skb fffff8003d0d8fc0 
> skb->data fffff8003d874cd0
> Nov 10 00:47:17 trad kernel: [ 8239.534092] 
> drivers/net/wireless/zd1211rw/zd_mac.c:390: skb fffff8003d0d8fc0 
> skb->data fffff8003d874cdb
> 
> Perhaps there needs to be some padding there?

Ok, after a long hard slog at trying to understand all this, I'm going 
to have to pause the effort. I am beginning to understand the mechanisms 
in place... however, I am not totally sure about anything. My first 
impression though is that before control is even passed to the driver 
via zd_op_tx(), alignment issues have already hit. As far as I could 
tell, at that stage skb->data can already be on an odd byte boundary.

Now, all this is very confusing to me... largely because I don't fully 
understand what an SKB is. However, it would seem to me that the 
sunlance driver would use this mechanism as well, and AFAICT, that 
driver (even if it isn't a wireless driver) does not suffer from 
alignment issues.

I have much digging left... but I would greatly appreciate the offering 
of opinions as to whether this problem lies deeper in the kernel than 
the zd1211rw driver itself. I get a sense that I'm being a little 
disengaged... but that's totally cool. I understand the onus of at least 
trying to contribute a fix myself.

 > Also, I've just had a look at the git version of zd_mac.c, and I notice
 > it is all change there again. I would feel uncomfortable having studied
 > the 2.6.26 code to have to start again. Is it expected that I use the
 > latest available via git?

Ignore that. I was looking at older code (via web git).
Thanks in advance,
Shaddy


