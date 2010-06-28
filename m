Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:30116 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751885Ab0F1BXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 21:23:40 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0121368217
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jun 2010 10:23:38 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values - thanks for a fix
Date: Mon, 28 Jun 2010 10:21:47 +0900
Cc: linux-wireless@vger.kernel.org
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz> <201006271120.11785.br1@einfach.org> <4C26FD91.10140.F4D6B@jafojtik.seznam.cz>
In-Reply-To: <4C26FD91.10140.F4D6B@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006281021.47132.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun June 27 2010 16:28:17 Jaroslav Fojtik wrote:
> Dear Bruno,
> 
> > > I hope that this patch would not influence performance or any other
> > > functionality.
> > 
> > no it just fixes a regression i have introduced in an earlier change.
> > thanks for reporting and testing this! i will send the patch for
> > inclusion on monday, then it might take some time (few days to weeks)
> > until it apperars in compat- wireless.
> 
> Thank you for explanation.
> The patch surely improves signal strength measurement and I recomend it.
>
> Anyway, when you look at the magenta line here:
>   http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi
> 
> There are big drops in measured signal. Did you fix all places?
> 
> Before this patch there were short peeks from -78dB to -71dB.
> After patch there are short measurement drops from -62dB to -70dB.
> 
> The week charting simply averages it:
>   http://78.108.103.11:11080/cgi-bin/rodga_1week_big.cgi

i guess this must be the same situation as before, no?

how many antennas do you have attached to your device? it might be interesting 
to check if you get more consistent signal measurements by disabling antenna 
diversity, setting it to a fixed antenna. you can do this by using a debugfs 
file "echo fixed-a > /sys/kernel/debug/ath5k/phy0/antenna" (or "fixed-b")...

btw: when the signal measurement was low, did you see any negative impact on 
the thruput as well?

bruno
