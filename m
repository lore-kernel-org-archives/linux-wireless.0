Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966420Ab2ERSFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 14:05:53 -0400
Message-ID: <1337364344.4802.15.camel@jlt3.sipsolutions.net> (sfid-20120518_200615_455431_883247F8)
Subject: RE: Possible regression regarding multiple WLAN_EID_AP_CHAN_REPORT
 in beacon frames
From: Johannes Berg <johannes@sipsolutions.net>
To: "Drews, Paul" <paul.drews@intel.com>
Cc: Paul Stewart <pstew@chromium.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 18 May 2012 20:05:44 +0200
In-Reply-To: <6008DE3C35C7C04D85C2A4C813D36515481E5C76@ORSMSX101.amr.corp.intel.com>
References: <6008DE3C35C7C04D85C2A4C813D36515481E4C99@ORSMSX101.amr.corp.intel.com>
	 <1337033085.4303.32.camel@jlt3.sipsolutions.net>
	 <CAMcMvsiZzjxPucyDLW-farQR4mfGECu6_yYfgNao-zi-faK2Gw@mail.gmail.com>
	 <1337033976.4303.33.camel@jlt3.sipsolutions.net>
	 <6008DE3C35C7C04D85C2A4C813D36515481E4EDF@ORSMSX101.amr.corp.intel.com>
	 <1337093429.15553.2.camel@jlt3.sipsolutions.net>
	 <6008DE3C35C7C04D85C2A4C813D36515481E564D@ORSMSX101.amr.corp.intel.com>
	 <1337239289.4524.11.camel@jlt3.sipsolutions.net>
	 <CAMcMvsgWPuL9cOihOF_wynhYGNTQ8i0bbkg1MC5MAGiYYrKgLQ@mail.gmail.com>
	 <6008DE3C35C7C04D85C2A4C813D36515481E583A@ORSMSX101.amr.corp.intel.com>
	 <1337284215.4687.4.camel@jlt3.sipsolutions.net>
	 <6008DE3C35C7C04D85C2A4C813D36515481E5C76@ORSMSX101.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 17:31 +0000, Drews, Paul wrote:

> Ok, I have a version of the patch that I'm happy with at this point.
> () Builds with no errors or warning and works on 3.4-rc7
> () Passes checkpatch.pl
> () Does static-initialization of the bitmap in a way that lets the
>     author specify the values in any old order.  One incremental
>     line of source-code per value.  Pretty easy to maintain the
>     list of values.
> () Relies on constant-folding to keep the bitmap initialization compact
>     without extra footprint in code-section or data-section.  This
>     all works with shift operators instead of (shudder) bitfield operators
>     I originally thought I would have to use.
> () Uses the standard bitops, no need to roll-your-own
> () Is 32-bit and 64-bit compatible with one #ifdef in the
>     "boiler-plate" section of the code.  I don't see a way around
>    this #ifdef

Wow, that's pretty impressive :-) I gave up way earlier I guess.

> +#define ALL_MASKS(idx) ( \
> +	CONDITIONAL_MASK(WLAN_EID_SSID, idx) | \

> +#define CONDITIONAL_MASK(ordinal, idx) \
> +	((BIT_WORD(ordinal) == idx) ?  BIT_MASK(ordinal) : 0)

...

> +#if BITS_PER_LONG == 32
> +static DECLARE_BITMAP(singleton_map, 256) = {
> +	[0] = ALL_MASKS(0),
> +	[1] = ALL_MASKS(1),
> +	[2] = ALL_MASKS(2),
> +	[3] = ALL_MASKS(3),
> +	[4] = ALL_MASKS(4),
> +	[5] = ALL_MASKS(5),
> +	[6] = ALL_MASKS(6),
> +	[7] = ALL_MASKS(7),
> +};
> +#elif BITS_PER_LONG == 64
> +static DECLARE_BITMAP(singleton_map, 256) = {
> +	[0] = ALL_MASKS(0),
> +	[1] = ALL_MASKS(1),
> +	[2] = ALL_MASKS(2),
> +	[3] = ALL_MASKS(3),
> +};
> +#else
> +#error "adjust your <asm/bitsperlong.h> defines"
> +#endif

And we don't even need to touch this directly, nice!

johannes

