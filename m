Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:6131 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753562Ab0IODpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:45:44 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0767302341
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 12:45:42 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
Date: Wed, 15 Sep 2010 12:45:53 +0900
Cc: ath5k-devel@lists.ath5k.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com> <201009151216.32430.br1@einfach.org> <AANLkTiniROJatam4yA4sss3qjczT-6=jSP9QxvmDo2dq@mail.gmail.com>
In-Reply-To: <AANLkTiniROJatam4yA4sss3qjczT-6=jSP9QxvmDo2dq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201009151245.53194.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed September 15 2010 12:28:36 Jonathan Guerin wrote:
> >> Should all of the init be changed to use these functions, along with
> >> #define init values?
> > 
> > i think it would be best if we could remove the initvals alltoghether and
> > use the function to set the ack timeout. but i'm not sure if we need to
> > have them initialized to some value at the beginning. in this case can
> > we just override them later using the function. or just update the
> > initvals numerically (but no defines).
> 
> If there are no initvals, changing the mode won't init them to default
> values, will it? Or are you saying that values should not be
> initialised until the mode is set?

that's what i'm not sure about... but ath5k_hw_set_ack_timeout() could be 
called from reset so it applies the changes when the mode is set. i think that 
should be fine, but it needs to be tested -- and i think the same applies to a 
lot of the initvals.

> I've been a bit scared to post here until I had more information
> rather than a generic "uhh guys, something's not working". It's been
> causing me massive headaches with my work as I'm relying on the spec
> for timing values, but finding that the driver is doing something
> much, much different. I'm more than happy to post these things, but
> I'm not a good enough programmer to just give you patches without
> discussing the fact that I may just not be understanding what's really
> happening.
> Thanks for the help, it's greatly appreciated!

same here :)

the thing is, like bob said, that we don't really know much about what the HW 
expects in some of these registers, so unless you can prove your changes to be 
correct - e.g. by measurements which fit the theoretical model better, or by 
better thruput, it's hard to say if they are correct or not. 

so before you worry about how to make a correct patch, just go ahead and 
change those initvals to what you believe they should be. if it improves 
something, let's talk about how to correctly fix it.

bruno
