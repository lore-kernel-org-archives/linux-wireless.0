Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:47111 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790AbXJPXws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 19:52:48 -0400
Received: by nz-out-0506.google.com with SMTP id s18so1365529nze
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 16:52:47 -0700 (PDT)
Message-ID: <1ba2fa240710161652y4bbc29d0x289bac8e0e8f023b@mail.gmail.com> (sfid-20071017_005251_186109_35F3DBF2)
Date: Wed, 17 Oct 2007 01:52:46 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: Mode/Channel/Bitrate API
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <200710161640.54332.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1192222110.4770.81.camel@johannes.berg>
	 <200710161640.54332.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Friday 12 October 2007 16:48:30 Johannes Berg wrote:
> >  (a) the driver registers which channel center frequencies it can
> >      operate with, it could in theory just be a range (e.g. 2400-2500
> >      MHz) or more practically be list of center frequencies.
> List would be best, but..
>
> >      Just
> >      contains frequencies and possibly hardware dependent values for the
> >      frequency. This is done in "bands", something like
> >      FREQUENCY_BAND_2_4GHZ and FREQUENCY_BAND_5GHZ, "bands" replace the
> >      current "modes".
> Being able to just register frequency bands would work for many (but not all)
> drivers out there and would be more convenient than listing everything.
>
> >  (b) additionally, the driver registers as flags
> >      - whether it can support G mode short slot operation
> >      - whether it can receive B mode short barker preambles
> >      (both of which are only relevant if it supports 2.4 GHz operation)
> I haven't seen any softmac 11b hardware that doesn't support receiving short
> preamble yet.
>
There are old AP  can be configured to use long preamble, so it shell
be configurable also in station.

> >  (d) now, selecting a channel by frequency is unique, but we need to
> >      give new options to select short slot, short preamble and allowed
> >      bitrates.
> Short preamble? What would the hardware do with this bit?
>
Will use short preamble ? In B/G it should use long preamble if not
configured otherwise.

> > Does anyone see problems with this?
> More specific examples of the API you have in mind would be helpful.
>
> Thanks,
> -Michael Wu
>
>
