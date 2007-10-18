Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:12097 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762757AbXJROtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 10:49:41 -0400
Received: by py-out-1112.google.com with SMTP id u77so354174pyb
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2007 07:49:40 -0700 (PDT)
Message-ID: <43e72e890710180749v19d3753do85c24c28bb65409@mail.gmail.com> (sfid-20071018_154945_886735_74A59F90)
Date: Thu, 18 Oct 2007 10:49:40 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Mode/Channel/Bitrate API
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1192711232.15285.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192222110.4770.81.camel@johannes.berg>
	 <200710161640.54332.flamingice@sourmilk.net>
	 <1192608587.8841.2.camel@johannes.berg>
	 <43e72e890710170715ibeee99eja865dc3291e7e37d@mail.gmail.com>
	 <1192711232.15285.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-10-17 at 10:15 -0400, Luis R. Rodriguez wrote:

> > The regulatory work can just iterate over the currently established
> > channels for each wiphy. Who defines those or how is not important to
> > the regulatory work. I'm not sure why the range approach would not
> > work here. A card usually works on a range of frequencies anyway.
>
> Right. But the regulatory code may need to have power restrictions
> different on different channels and generally wants to be able to
> restrict things for each channel,

Right but this is independent of how the driver sets his things up.

> so it'd be good to have the list
> defined right away by the driver.

The real problem here, as you pointed out to me before, is each driver
needs its own hw values for channels so I suppose it make sense to let
the driver set this.

> It seems that if we don't put this
> into the driver but rather have a frequency range there, we need to
> allocate an array of channels later for this work and that's not needed
> if we start out with an array of channels.

Right, we can provide a helper for driver to allocate/create the
channel array structure but as I noted they need to set hw values
anyway... so blah.

  Luis
