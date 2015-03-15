Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36629 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbCOIzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <20150313152751.GK5264@atomide.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<1426162154-8716-6-git-send-email-eliad@wizery.com>
	<20150313152751.GK5264@atomide.com>
Date: Sun, 15 Mar 2015 10:55:34 +0200
Message-ID: <CAB3XZEc5m0SFdZtJVj0AKu6YuDjTsd7pmNViNy3GDfj42mcdsg@mail.gmail.com> (sfid-20150315_095541_497637_FD28B6AB)
Subject: Re: [PATCH v6 5/6] ARM: dts: add wl12xx/wl18xx bindings
From: Eliad Peller <eliad@wizery.com>
To: Tony Lindgren <tony@atomide.com>
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
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2015 at 5:27 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Eliad Peller <eliad@wizery.com> [150312 05:09]:
>> --- a/arch/arm/mach-omap2/pdata-quirks.c
>> +++ b/arch/arm/mach-omap2/pdata-quirks.c
>>
>> -static void __init omap3_evm_legacy_init(void)
>> -{
>> -     legacy_init_wl12xx(38400000, 0, 149);
>> -}
>
> FYI, at least this part conflicts with the fixes in the arm-soc
> tree for the v4.0-rc series as omap3 evm also needs the copy clock
> quirk.
>
>> @@ -419,20 +351,9 @@ static struct pdata_init pdata_quirks[] __initdata = {
>>       { "nokia,omap3-n950", hsmmc2_internal_input_clk, },
>>       { "isee,omap3-igep0020-rev-f", omap3_igep0020_rev_f_legacy_init, },
>>       { "isee,omap3-igep0030-rev-g", omap3_igep0030_rev_g_legacy_init, },
>> -     { "ti,omap3-evm-37xx", omap3_evm_legacy_init, },
>
> So this function cannot be yet removed.
>
> With that fixed, I was able to iw dev wlan0 scan with series on
> omap3 evm :)
>
thanks for testing it!

let's continue the discussion in the other thread regarding the way to
merge the patches, and i'll rebase the patches appropriately.

Eliad.
