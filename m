Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64819 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967057Ab2EPKlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 06:41:50 -0400
Received: by bkcji2 with SMTP id ji2so451516bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 03:41:49 -0700 (PDT)
Date: Wed, 16 May 2012 12:41:33 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce : freeze after connecting to network with FW Power
 Save on
Message-ID: <20120516124133.69f57311@destiny.ordissimo> (sfid-20120516_124154_175870_41CE75F7)
In-Reply-To: <4FB28834.4000803@lwfinger.net>
References: <20120515152951.7cc4f84b@destiny.ordissimo>
	<4FB26D6B.2030005@lwfinger.net>
	<20120515170405.7f6510f2@destiny.ordissimo>
	<4FB28834.4000803@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 May 2012 11:45:40 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :

> On 05/15/2012 10:04 AM, Anisse Astier wrote:
> > On Tue, 15 May 2012 09:51:23 -0500, Larry Finger<Larry.Finger@lwfinger.net>  wrote :
> >
> > I'll try wireless-testing then. Are all rtlwifi patches in
> > wireless-testing ?
> 
> I think that all are in wireless-testing.

Ok, problem is reproduced with wireless-testing, too. I also have hangs
when unloading the driver sometimes (loaded with fwlps=0), but I wasn't
able to get a trace either.

> 
> > (This problem was also reproduced with 3.2.X)
> >
> >
> >> to say that I cannot duplicate your results, and that we need to explore the
> >> rest of your system to see what is different.
> >>
> >> Is your system 32- or 64-bit? How many cores in your CPU? Have you tried
> > 32 bits, SoC is an AMD E1-1200, with 2 cores.
> 
> My search shows that the clock rate for this processor is 1.4 GHz. The only 
> system that I have that can run the RTL8188CE is 2 GHz.
> 
> >> connecting to more than one AP? What is the make and model of the AP that needs
> > I've tried two different APs, with and without keys (open and WPA2)
> >
> >> to have power save turned off? What is the mode of operation?
> > One is a Linksys WRT54GL with dd-wrt(WPA2), the other(Open) is a
> > carrier's set top box/router (Freebox).
> 
> I thought the locking in the Power Save routines was OK, but perhaps there is 
> some raciness that is exposed by the difference in speeds. The lack of 
> diagnostics on the netconsole is a problem.
> 
> Do you have kernel debugging turned on for the lock diagnostics, and the Detect 
> Hung Task configuration variable? Perhaps we can get some logging that way.
I enabled the following options:
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
But it didn't detect any lockup yet, and machine still hangs. I'll try
CONFIG_PROVE_LOCKING.

Enabling CONFIG_DEBUG_INFO seems to make the problem go away...



> 
> Have you tried the vendor's driver from www.realtek.com? I don't think it will 
> make a difference, but it could be worth a try.
Nope, not yet.


> 
> Larry
