Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58838 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbbJNIAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 04:00:46 -0400
Message-ID: <1444809642.3054.6.camel@sipsolutions.net> (sfid-20151014_100049_630517_4C2D7E9A)
Subject: Re: [PATCH] ocb: use correct "MHz" instead of "MHZ"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Wed, 14 Oct 2015 10:00:42 +0200
In-Reply-To: <CABAco3BpY-hU=9MGzovyUfyRgXMynikNbUD3cScievczq2qsKg@mail.gmail.com> (sfid-20151014_093604_196513_8DA0F8F0)
References: <1444635356-19975-1-git-send-email-ola1olsson@gmail.com>
	 <1444727650.1961.10.camel@sipsolutions.net>
	 <CABAco3CLCtFOofHMbJSz-Okcc4BM4nnVwO5By8DeZUYJrsCt6Q@mail.gmail.com>
	 <1444805527.3054.4.camel@sipsolutions.net>
	 <CABAco3BpY-hU=9MGzovyUfyRgXMynikNbUD3cScievczq2qsKg@mail.gmail.com>
	 (sfid-20151014_093604_196513_8DA0F8F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-14 at 09:36 +0200, Ola Olsson wrote:

> Correct. I have done a macro to utilize the gcc "__attribute__
> ((unused))" and I fully understand that it is not an elegant 
> solution.
> I don't want to convince you about merging it since I wouldn't do it
> myself. :)

Yeah, ouch, I don't really want that. Perhaps you can add -Wno-unused
-parameters to your Android makefile.

> > I don't see anything with -Wmissing-field-initializers.
> 
> Hmm. I'll try to find out why I get these warnings. Mostly, it is
> about changing "{}" -> "{0}" on stack allocated objects.
> This is what I get when compiling at 
> 0ee571d57b8b631658d1a35ad9a906610d6145d3
> 
> $ mm -B -j8 2>&1 | grep -i missing-field
> external/iw/scan.c:1863:3: warning: missing initializer for field
> 'type' of 'struct nla_policy' [-Wmissing-field-initializers]
> 

Yeah, ok, so technically IIRC ={0} is the standard way of doing this in
C, but everything seems to accept ={} as a natural extension of ={.x=y}
I guess? Not sure I want to fix it - doesn't really seem worth much.

johannes
