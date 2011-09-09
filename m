Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63470 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab1IIRgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 13:36:06 -0400
Received: by yie30 with SMTP id 30so1057768yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Sep 2011 10:36:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E6A1AB7.8080605@lwfinger.net>
References: <CA+TXxM3EgGZmo1F9GS+-QNWfTTgWFD4XHvG31JH=kabrr=ES=A@mail.gmail.com>
	<4E6911C2.2030309@lwfinger.net>
	<CA+TXxM0EOBs2x+6jh=0uwDTMTUD+9ZXQ8W-ZR+=TjSARV3kAeQ@mail.gmail.com>
	<4E6A1AB7.8080605@lwfinger.net>
Date: Sat, 10 Sep 2011 01:30:24 +0800
Message-ID: <CA+TXxM23gnbt5JG+s0QTCFm0Ljcc8nZnXH9PNkBaqqhBwMcVYA@mail.gmail.com> (sfid-20110909_193611_799787_53B77028)
Subject: Re: mac80211 driver for RT3070 wifi card does not work on big-endian platform
From: Semigod King <semigodking@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed two lines of code:
                static const u32 wcid[2] = { 0xffffffff, 0x00ffffff };
                rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
                                              wcid, sizeof(wcid));

Do you think the first line should be changed as below to eliminate
platform difference?
                static const u32 wcid[2] = { 0xffffffff,
cpu_to_le32(0x00ffffff) };


On Fri, Sep 9, 2011 at 9:55 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/09/2011 07:05 AM, Semigod King wrote:
>>
>> Larry,
>> Thank you for looking at this issue. I will try your code change tonight
>> and let
>> you know test results. I have an openwrt cross build system ready on my
>> freebsd
>> at home.
>
> That will not change a thing. Other than trip some sparse warnings,
> le32_to_cpu() and cpu_to_le32() do the same thing. On little-endian boxes,
> they are a no-op, and on big-endian platforms, they both reverse the byte
> order. Switching the call only makes it clearer what is happening.
>
> I am having trouble getting Ubuntu 11.04 running on my Macbook. The OS is
> installed, but no X at the moment.
>
> BTW, please do not drop the Cc to wireless. I want to keep the ML in the
> loop.
>
> Larry
>
>
