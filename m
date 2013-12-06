Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm24-vm3.bullet.mail.ird.yahoo.com ([212.82.109.194]:29343 "HELO
	nm24-vm3.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753833Ab3LFI1h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 03:27:37 -0500
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>				 (sfid-20131205_165733_059424_F6F2D350) <1386259875.4182.15.camel@jlt4.sipsolutions.net>			 <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com>		 <1386260744.4182.18.camel@jlt4.sipsolutions.net>		 <1386261738.73311.YahooMailNeo@web172703.mail.ir2.yahoo.com>	 <1386265226.4182.20.camel@jlt4.sipsolutions.net>	 <1386279479.16148.YahooMailNeo@web172701.mail.ir2.yahoo.com> <1386281254.4182.24.camel@jlt4.sipsolutions.net>
Message-ID: <1386318455.88185.YahooMailNeo@web172706.mail.ir2.yahoo.com> (sfid-20131206_092740_150875_2CDAB304)
Date: Fri, 6 Dec 2013 08:27:35 +0000 (GMT)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Re: Using wmediumd in kernel 3.10
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1386281254.4182.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

You are right, since we have retransmissions at layer 2 with a 0.5 drop probability the pings still go through, but with high delay variations.

Anyway, I tested the patch posted by Javier Lopez, and it is now working for me.

Cheers

Daniel



El Jueves 5 de diciembre de 2013 23:07, Johannes Berg <johannes@sipsolutions.net> escribió:
On Thu, 2013-12-05 at 21:37 +0000, Dani Camps wrote:
> Hi,
> 
> I tried with kernel 3.12 but I still get the same error. Just to
> clarify, if wmediumd would work properly you should see in the ping
> approximately half of the packets being dropped, because the
> configuration file has 0.5 drop probability for all rates. If you see
> that the ping proceeds normally is because the error happened and
> wmediumd de-registered.

Not sure I saw packet loss, but I made wmediumd print out statistics and
it was definitely seeing packets ...


johannes
