Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35661 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbCOIng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <20150313150047.GI5264@atomide.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<1426162154-8716-3-git-send-email-eliad@wizery.com>
	<20150313150047.GI5264@atomide.com>
Date: Sun, 15 Mar 2015 10:43:35 +0200
Message-ID: <CAB3XZEcOytqpJ4pWoemLS3d+DCeA8C75MencDfGn_vhfEYrduw@mail.gmail.com> (sfid-20150315_094346_397035_ABF79BDA)
Subject: Re: [PATCH v6 2/6] wl12xx: use frequency instead of enumerations for
 pdata clocks
From: Eliad Peller <eliad@wizery.com>
To: Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Luciano Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+Kalle

On Fri, Mar 13, 2015 at 5:00 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Eliad Peller <eliad@wizery.com> [150312 05:09]:
>> From: Luciano Coelho <luca@coelho.fi>
>>
>> Instead of defining an enumeration with the FW specific values for the
>> different clock rates, use the actual frequency instead.  Also add a
>> boolean to specify whether the clock is XTAL or not.
>
> Thanks for doing this. Just one comment on how we're going to get this
> all merged. Chances are this will cause merge conflicts between the
> wireless tree and the omap tree for the platform data and dts changes.
>
> Can you please separate the wireless changes in this series so we can
> do this in the following sets:
>
> 1. Add support for new things to wireless driver
>
> 2. Switch platform code to use the new support
>
> 3. Remove support for platform data with a follow-up patch
>
the series will still be dependent on each other (e.g. (3) must come
only after (2) was applied), so i'm not sure that will be very
helpful?

> The other option would be to have the whole series in a immutable
> branch against v3.0-rc1 that can be merged into both wirelss tree
> and omap tree.
>
i think that could be easier.

or maybe you can just take them all through the omap tree? the wlcore
tree is not under active development, so i don't expect conflicts
there.

Eliad.
