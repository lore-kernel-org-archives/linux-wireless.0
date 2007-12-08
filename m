Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51790 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750949AbXLHKkC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 05:40:02 -0500
Subject: Re: rc80211-pid: some tuning test results
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071208044202.20c91ae1@morte>
References: <1196622331.7472.4.camel@localhost>
	 <20071204024146.15689ee3@morte>
	 <40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
	 <200712050849.46760.hs4233@mail.mn-solutions.de>
	 <20071205105230.0ecc56dc@morte> <20071205131310.6b4c232a@morte>
	 <20071208044202.20c91ae1@morte>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 11:39:58 +0100
Message-Id: <1197110398.7472.17.camel@localhost> (sfid-20071208_104012_515866_B9397934)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-12-08 at 04:42 +0100, Stefano Brivio wrote:
> I run further tests. It looks like I found out the optimal parameters for
> minimizing latency or maximizing throughput or maximizing reliability.

Great. I haven't had much time and probably cannot find more time this
weekend, so I still haven't done much testing.

> 
> Best throughput:
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 1       8        11     14       10     12       3      0        1
> 
> Best latency:
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 1       8        15     12       8      16       2      1        1
> 
> Best reliability:
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 1       8        4      15       8      15       3      0        0
> 
> While a general good setup looks to be:
> 
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 1       8        10     15       9      15       3      0        1
> 
> I would then adopt a system like the one outlined below in order to take
> into account userspace parameters.
> 
> We have Three userspace parameters, ranging from 0 (don't care) to 5
> (care the most). I don't think it makes any sense to have more granularity
> here.

Why wouldn't you let userspace set the raw parameters directly? The
complicated scheme you propose prevents us to tell users/testers to
"change the X parameter to see it gives better Y results". If you give
access to the raw parameters, people can still tweak and tune them if
the rate control fails for special situations (e.g. hardware that cannot
report whether a frame was only retried or totally failed, special noise
situations, whatever).

Furthermore, you can still have the simplified scheme by providing a
userspace tool (maybe even add it to iw, once we have an interface) that
takes the input, calculates the raw parameters as below and writes the
results to the kernel.

Bottom line: This thing complicates the kernel, makes the thing less
understandable for people who now what a PID controller is, complicates
future tweaking and tuning of the (default) parameters and moreover
could also be implemented in userspace. So my vote is against it.

> 
> Starting from:
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 1       8        10     15       9      15       3      0        1
> 
> We add:
> For every threshold point:
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 		+0.2	-0.2	+0.2	-0.6
> 
> latency points:
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 		+1	-0.6	-0.2	+0.2	-0.2	+0.2
> 
> reliability points:
> rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
> 		-1.2		-0.2				-0.2
> 
> I'll now try to implement this sorting out the fixed point calculation
> issues.

I've done a lot of code cleaning, maybe you want to base your patches on
that. There's more to come, but I'll send them so you have something to
start.

Mattias

