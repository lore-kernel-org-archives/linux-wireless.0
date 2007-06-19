Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:23033 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751220AbXFSEux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 00:50:53 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: phy mode, channel -> freq mapping (was RE: more nl80211/iw tool code comments)
Date: Mon, 18 Jun 2007 21:50:50 -0700
Message-ID: <285925A4DF50FC408669C6302216838D112212@sc-exch02.marvell.com>
References: <1181759017.29767.117.camel@johannes.berg> <20070614142925.GA24414@charon.n2.diac24.net> <285925A4DF50FC408669C6302216838D024899@sc-exch02.marvell.com> <1182164508.5924.19.camel@johannes.berg> <1ba2fa240706180525i561b0abex6c39d18e7b7b461e@mail.gmail.com>
From: "Sandesh Goel" <sgoel@marvell.com>
To: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Cc: "David Lamparter" <lists@diac24.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The so called "turbo" mode extensions provided by various vendors
roughly fall into 3 categories

1. MAC extensions such as frame bursting, aggregation, using more
aggressive transmit parameters etc
2. PHY extensions such as using proprietary modulation/coding, MIMO etc
3. RF extensions such as using larger channel width, also sometimes
called channel bonding

All of these have been adequately addressed by 802.11e, WMM and 802.11n
and there exist modes which allow these to be done in a standard
compliant and interoperable manner. In my opinion, the linux wireless
stack would do well to stay away from the proprietary extensions and
thus minimize confusion. 

At most, we could allow an API for enable/disable turbo mode which would
allow the specific driver/firmware to do whatever magic it wants under
the hood without polluting the rest of the stack.

Thanks,
Sandesh

-----Original Message-----
From: Tomas Winkler [mailto:tomasw@gmail.com] 
Sent: Monday, June 18, 2007 5:55 PM
To: Johannes Berg
Cc: Sandesh Goel; David Lamparter; linux-wireless
Subject: Re: phy mode, channel -> freq mapping (was RE: more nl80211/iw
tool code comments)

On 6/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> > I think it is cleaner to define a parameter called BAND which can
take
> > values 2.4 GHz, 5 GHz and so on. Then, the combination of BAND and
> > CHANNEL will uniquely define the operating frequency.
>
> <phymode stuff snipped>
>
> > I wasn't sure if this has already been thought about. I look forward
to
> > being educated if I am missing something.
>
> Good point. I hadn't really considered this but a/g or n cards really
> make it necessary to distinguish here, and regulatory stuff would also
> benefit from defining it that way.
>
I have to agree that the phymode lost is relevance. and band channel
couple has more meaning

In this context, what atheros turbo phy mode is? What channel, band
does it operate?

Thanks
Tomas

> johannes
>
>
