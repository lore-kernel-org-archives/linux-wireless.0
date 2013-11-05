Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:42716 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3KEQ01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 11:26:27 -0500
Received: by mail-ob0-f182.google.com with SMTP id wn1so8825099obc.13
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 08:26:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5278B68E.5070807@mail.ru>
References: <5276491F.20207@mail.ru>
	<477F20668A386D41ADCC57781B1F70430F45757E63@SC-VEXCH1.marvell.com>
	<527703E6.8040504@mail.ru>
	<477F20668A386D41ADCC57781B1F70430F45758053@SC-VEXCH1.marvell.com>
	<5278AE8E.9060203@mail.ru>
	<5278B1EC.8020000@broadcom.com>
	<5278B68E.5070807@mail.ru>
Date: Tue, 5 Nov 2013 08:26:26 -0800
Message-ID: <CAMcMvshB-y8uiA-cKe2_yKbUtmY4za2zBALwNXRaHqSfnTdA5w@mail.gmail.com> (sfid-20131105_172631_495670_8F2A1A1F)
Subject: Re: mwifiex_sdio on chromebook
From: Paul Stewart <pstew@chromium.org>
To: Alexander Varnin <fenixk19@mail.ru>
Cc: Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 5, 2013 at 1:12 AM, Alexander Varnin <fenixk19@mail.ru> wrote:
> 05.11.2013 12:53, Arend van Spriel пишет:
>>>>
>>>
>>> It is ported at most already and mainline kernel works good on
>>> Chromebook. It is just peripheral problem.
>>
>> Not sure how chromium os architecture looks like, but you mean to say
>> *you* ported code in chromium user-space to work with
>> upstream/mainline kernel API's?
>
> No. There is work doing by somebody from google or somewhere else, by
> making mainline kernel work on Chromebook. Kernel 3.11 is the first
> mainline kernel, that is able to boot and work on Chromebook. Working
> parts is MMC controller, display controller, keyboard, etc. Not working
> is usb, wifi, rtc, temperature sensors, etc.

There doesn't appear a lot of effort into getting 3.11 working on the Samsung
ChromeBook yet.  There is some work on 3.8, which has more
architectural similarities to 3.11.  Offhand, the 3.4 version used a
"regulator" setup for controlling the GPIOs that performed power
sequencing and setup of the part, where as in 3.8 this work was moved
to the device tree.

Therefore, for more insights into the changes you may have to do for
3.11, I'd suggest that it'd be more informative for you to look at the
differences between mainline 3.8 and the "chromeos-3.8" branch of
https://chromium.googlesource.com/chromiumos/third_party/kernel-next

> By a tradition of open source, as I am interested, and I have experience
> in kernel development, I have decided to debug wifi issue by myself. I
> don't know, why I should port anything. Everything that was needed is
> already ported - there is Chromebook device tree in kernel, there is all
> required drivers. There is just a problem with powering up Marvell wifi
> chip. I don't see, why fixing it requires any complex porting.
>
> One thing worth doing is to compare 3.4 from chromeos and 3.4 mainline,
> and find, if there any specific wifi changes. But there is possibly not.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
