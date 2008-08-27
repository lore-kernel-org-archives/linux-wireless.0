Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39464 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYH0XbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 19:31:08 -0400
Date: Wed, 27 Aug 2008 16:31:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Bruno Randolf <bruno@thinktube.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Message-ID: <20080827233103.GE5927@tesla> (sfid-20080828_013113_832234_D0471CBB)
References: <20080827013009.GA15781@tuxdriver.com> <1ba2fa240808271226i95a7789k481a68b09dc60164@mail.gmail.com> <200808272225.10557.mb@bu3sch.de> <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2008 at 04:11:15PM -0700, Tomas Winkler wrote:
> if (beacon_timestamp > rx_timestamp)
>     merge
> 
> The patch from Assaf just disable reporting RX timestamp to mac and
> thus disabling merging which gives incorrect spec behavior but smooth
> traffic.

We *should follow the spec*.

> Actually we've checked few cards including broadcom and various
> windows NICs

What are windows NICs?

> and non of them implements this correctly so this WA is
> probably the solution.

Disagreed! If there is hardware which is not capable of handling this
we should simply have a HW flag which specifies this to handle this as a
work around (WA). Just because some cards are not capable it doesn't
mean it should impose that on the rest.

> Other solution would be to mark leader with highest TSF and not
> reconnecting to the same station again and again.
> 
> Last solution would be to remove this merging all together but then
> I'm not sure if Bruno added this code just implement the spec or
> really tested it with any hardware. I'm not sure if any vendor
> implements PS in IBSS so this merging is probably not important
> anyway.

Absolutely not! IBSS merge is per spec, otherwise you don't really have
a real IBSS.

  Luis
