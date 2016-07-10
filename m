Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38441 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbcGJU5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 16:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <87inwe9wfb.fsf@miraculix.mork.no>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-4-martin.blumenstingl@googlemail.com> <87inwe9wfb.fsf@miraculix.mork.no>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun, 10 Jul 2016 22:56:39 +0200
Message-ID: <CAFBinCD0b9=o0B4_Orwe6uJfrbexr_Jf5JDctfRDmTnh3vPPug@mail.gmail.com> (sfid-20160710_225705_892659_922E3198)
Subject: Re: [PATCH v4 3/3] ath9k: parse the device configuration from an OF node
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: ath9k-devel@venema.h4ckr.net, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 10, 2016 at 2:19 AM, Bjørn Mork <bjorn@mork.no> wrote:
> Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:
>
>> +     if (of_property_read_bool(np, "qca,clk-25mhz"))
>> +             ah->is_clk_25mhz = true;
>> +
>> +     if (of_property_read_bool(np, "qca,disable-2ghz"))
>> +             ah->disable_2ghz = true;
>> +
>> +     if (of_property_read_bool(np, "qca,disable-5ghz"))
>> +             ah->disable_5ghz = true;
>
> This is bike-shedding, but how about
>
>         ah->is_clk_25mhz = of_property_read_bool(np, "qca,clk-25mhz");
>         ah->disable_2ghz = of_property_read_bool(np, "qca,disable-2ghz");
>         ah->disable_5ghz = of_property_read_bool(np, "qca,disable-5ghz");
I'm fine with either way - I'll simply adhere to the coding style that
the ath9k devs want to use, so just let me know which one you prefer.
