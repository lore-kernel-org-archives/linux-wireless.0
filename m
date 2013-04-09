Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:46812 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab3DILVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 07:21:12 -0400
Received: by mail-wg0-f54.google.com with SMTP id a12so6684371wgh.33
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2013 04:21:11 -0700 (PDT)
Date: Tue, 9 Apr 2013 13:10:28 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: always pick a basic rate to tx RTS/CTS for
 pre-HT rates
Message-ID: <20130409111028.GB27875@magnum.frso.rivierawaves.com> (sfid-20130409_132117_284408_00536FD3)
References: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com>
 <1365503356.8465.37.camel@jlt4.sipsolutions.net>
 <20130409105535.GA27875@magnum.frso.rivierawaves.com>
 <1365505512.8465.40.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1365505512.8465.40.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 09, 2013 at 01:05:12PM +0200, Johannes Berg wrote:
> On Tue, 2013-04-09 at 12:55 +0200, Karl Beldan wrote:
> > On Tue, Apr 09, 2013 at 12:29:16PM +0200, Johannes Berg wrote:
> > > On Fri, 2013-04-05 at 12:06 +0200, Karl Beldan wrote:
> > > > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > > > 
> > > > When the 1st rate control entry is a pre-HT rate we want to set
> > > > rts_cts_rate_idx "as the fastest basic rate that is not faster than the
> > > > data rate"(code comments).
> > > > But in case some bss allowed rate indexes are lower than the lowest bss
> > > > basic rate, if the rate control selects a rate among the formers for its
> > > > 1st rate control entry, rts_cts_rate_idx remains 0 and is not a basic
> > > > rate index.
> > > > This commit sets rts_cts_rate_idx to the lowest bss basic rate index in
> > > > this situation.
> > > 
> > > I guess it's a good thing you're looking at this code. However, I'm not
> > > sure what you're doing here is correct. In this case, the PHY mandatory
> > > rates should be used. See 9.7.6.5.2 "Selection of a rate or MCS":
> > > 
> > Thanks for looking at this.
> > 
> > You are quoting the chapter for "control _response_ frames" which does
> > not apply here (even CTS-to-self are not control response frames).
> 
> Oh, oops, confused. But then you look at 9.7.6.2 "Rate selection for
> control frames that initiate a TXOP", which just mandates that you use
> any rate that the receiver supports, so why bother doing basic rates
> etc. at all?
> 

This chapter precisely, however it reads:
{
"If a control frame other than a Basic BlockAckReq or Basic BlockAck is
carried in a non-HT PPDU, the transmitting STA shall transmit the frame
using one of the rates in the BSSBasicRateSet parameter or a rate from
the mandatory rate set of the attached PHY if the BSSBasicRateSet is
empty."
}
 
Karl
