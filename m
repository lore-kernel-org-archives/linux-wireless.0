Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.224]:13777 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbXHON1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 09:27:54 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1716761wxd
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2007 06:27:53 -0700 (PDT)
Message-ID: <1ba2fa240708150627g58bfbf37n5677ea3fff4c9025@mail.gmail.com>
Date: Wed, 15 Aug 2007 16:27:52 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: warnings in iwlwifi
Cc: ian <ischram@telenet.be>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1187179344.3998.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1187133051.31200.26.camel@johannes.berg>
	 <46C2E992.5070805@telenet.be> <1187179344.3998.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/15/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-08-15 at 13:54 +0200, ian wrote:
>
> > >     le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
> > >
> > > looks totally bogus unless you somehow do macro magic to define the
> > > RX_RES_PHY...MASK in little endian...
> >
> > iwl-hw.h:#define        RX_RES_PHY_FLAGS_ANTENNA_MSK            __constant_cpu_to_le16(0xf0)
>
> > I don't understand how this would generate the warning though
>
> Ah, so there is macro magic. Why that, and not just convert the value to
> CPU first and then mask? i.e.
> #define        RX_RES_PHY_FLAGS_ANTENNA_MSK            0xF0
> and use
>         (le16_to_cpu(phy_flags_hw) & RX_RES...MSK) >> 4
> or something?
>
> > > Maybe it's time for you to get a cross compiler or better yet buy a
> > > big-endian machine and actually test things on that? :)
> > >
> >
> > No need for these drastic comments, for two warnings imho ;-)
>
> :)
>
> I'm spammed by warnings right now in my kernel build for some reason.
> I'm guessing gcc got a bit more trigger-happy or something.
>
> > I'm predicting that patch will arrive on linux-wireless soon too.
> > (took me quite some time to figure this out, because I was looking at the iwlwifi git)
>
> Alright :)
>

I cannot get this error in my environment can you describe yours?
Thanks for your input
Tomas

> johannes
>
>
