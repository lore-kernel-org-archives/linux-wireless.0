Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53602 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753246AbXLHLXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:23:37 -0500
Date: Sat, 8 Dec 2007 12:17:25 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rc80211-pid: some tuning test results
Message-ID: <20071208121725.58efae13@morte> (sfid-20071208_112348_036934_EB8AA5FD)
In-Reply-To: <1197110398.7472.17.camel@localhost>
References: <1196622331.7472.4.camel@localhost>
	<20071204024146.15689ee3@morte>
	<40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
	<200712050849.46760.hs4233@mail.mn-solutions.de>
	<20071205105230.0ecc56dc@morte>
	<20071205131310.6b4c232a@morte>
	<20071208044202.20c91ae1@morte>
	<1197110398.7472.17.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 08 Dec 2007 11:39:58 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Why wouldn't you let userspace set the raw parameters directly? The
> complicated scheme you propose prevents us to tell users/testers to
> "change the X parameter to see it gives better Y results". If you give
> access to the raw parameters, people can still tweak and tune them if
> the rate control fails for special situations (e.g. hardware that cannot
> report whether a frame was only retried or totally failed, special noise
> situations, whatever).
> 
> Furthermore, you can still have the simplified scheme by providing a
> userspace tool (maybe even add it to iw, once we have an interface) that
> takes the input, calculates the raw parameters as below and writes the
> results to the kernel.
> 
> Bottom line: This thing complicates the kernel, makes the thing less
> understandable for people who now what a PID controller is, complicates
> future tweaking and tuning of the (default) parameters and moreover
> could also be implemented in userspace. So my vote is against it.

I'm not so sure about this. I think that this is really specific to the
algorithm, so it looked like a natural choice to put this into the kernel.
But your points make a lot of sense. I should probably remove this from
here and send patches to iw.

> I've done a lot of code cleaning, maybe you want to base your patches on
> that. There's more to come, but I'll send them so you have something to
> start.

Me too I started to clean up the code, nevertheless if you send them it
will be useful. Thank you.


--
Ciao
Stefano
