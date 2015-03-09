Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37502 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbCIHSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 03:18:47 -0400
MIME-Version: 1.0
In-Reply-To: <2658240.aoSloEbWge@wuerfel>
References: <1424362401-8228-1-git-send-email-eliad@wizery.com>
	<2194797.iarD5YIxEd@wuerfel>
	<CAB3XZEfc3qV_o+0paM=HNdySKWwiJDfH=kJ8u0tz1ae+3ujxVw@mail.gmail.com>
	<2658240.aoSloEbWge@wuerfel>
Date: Mon, 9 Mar 2015 09:18:46 +0200
Message-ID: <CAB3XZEczvZH8rYOD-P7iuU4RSurArpRp6JGYX1X22O8tj7v8Qg@mail.gmail.com> (sfid-20150309_081859_282119_4BD149C2)
Subject: Re: [PATCH v3 2/2] wl18xx: add basic device-tree support
From: Eliad Peller <eliad@wizery.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 8, 2015 at 11:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 08 March 2015 13:13:13 Eliad Peller wrote:
>>
>> > I've looked up the what boards actually use this data and found that
>> > all of them already support booting from DT: some omap2 boards using
>> > arch/arm/mach-omap2/pdata-quirks.c to provide the data, and the
>> > davinci 850evm. Can you make sure you add the correct data to all
>> > of these dts files as part of your series and remove the
>> > wl12xx_platform_data references?
>>
>> AFAICT, these board files add wl12xx platform data, while the new DT
>> support is only for wl18xx.
>>
>
> How can you tell the difference? What I see is that omap3pandora
> (and nothing else) calls wl1251_set_platform_data(), while
> da850-evm and all omap3/omap4 boards use wl12xx_set_platform_data().
>
> The latter seems to refer to all wl12xx and wl18xx variants except
> for wl1251, based on my (very limited) understanding of that code.

right.
i got mislead because legacy_init_wl12xx() is defined there only for
CONFIG_WL12XX (and not for CONFIG_WL18XX).
it looks like only "isee,omap3-igep0020-rev-f" and
"isee,omap3-igep0020-rev-g" have pdata quirks for wl18xx (and thus
initialize the pdata clocks to 0).

sorry for the trivial question, but what's the standard way to submit
such patch? should i simply add a third patch to the patchset which
removes the pdata quirk and adds the missing dts definition? i don't
have such board, so i can only compile-test it.

thanks,
Eliad.
