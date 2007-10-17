Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:28164 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbXJQOPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:15:04 -0400
Received: by py-out-1112.google.com with SMTP id u77so4343079pyb
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 07:15:03 -0700 (PDT)
Message-ID: <43e72e890710170715ibeee99eja865dc3291e7e37d@mail.gmail.com> (sfid-20071017_151509_937239_6E737D20)
Date: Wed, 17 Oct 2007 10:15:03 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Mode/Channel/Bitrate API
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1192608587.8841.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192222110.4770.81.camel@johannes.berg>
	 <200710161640.54332.flamingice@sourmilk.net>
	 <1192608587.8841.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2007-10-16 at 16:40 -0400, Michael Wu wrote:
> > On Friday 12 October 2007 16:48:30 Johannes Berg wrote:
> > >  (a) the driver registers which channel center frequencies it can
> > >      operate with, it could in theory just be a range (e.g. 2400-2500
> > >      MHz) or more practically be list of center frequencies.
> > List would be best, but..
> >
> > >      Just
> > >      contains frequencies and possibly hardware dependent values for the
> > >      frequency. This is done in "bands", something like
> > >      FREQUENCY_BAND_2_4GHZ and FREQUENCY_BAND_5GHZ, "bands" replace the
> > >      current "modes".
> > Being able to just register frequency bands would work for many (but not all)
> > drivers out there and would be more convenient than listing everything.
>
> Yeah but it doesn't help when the user wants to enable/disable certain
> channels or the regulatory code needs to, so it seems we need to go with
> a list.

The regulatory work can just iterate over the currently established
channels for each wiphy. Who defines those or how is not important to
the regulatory work. I'm not sure why the range approach would not
work here. A card usually works on a range of frequencies anyway.

  Luis
