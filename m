Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63326 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab1IPHMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 03:12:16 -0400
Received: by iaqq3 with SMTP id q3so1977646iaq.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 00:12:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E711AFB.7030806@lwfinger.net>
References: <CA+TXxM3EgGZmo1F9GS+-QNWfTTgWFD4XHvG31JH=kabrr=ES=A@mail.gmail.com>
	<4E6911C2.2030309@lwfinger.net>
	<CA+TXxM0EOBs2x+6jh=0uwDTMTUD+9ZXQ8W-ZR+=TjSARV3kAeQ@mail.gmail.com>
	<4E6A1AB7.8080605@lwfinger.net>
	<CA+TXxM23gnbt5JG+s0QTCFm0Ljcc8nZnXH9PNkBaqqhBwMcVYA@mail.gmail.com>
	<4E711AFB.7030806@lwfinger.net>
Date: Fri, 16 Sep 2011 15:12:15 +0800
Message-ID: <CA+TXxM1uTOdhqWrTPQtvfY6tm5bQh6tXSxchF12eW6zwo-r-Qg@mail.gmail.com> (sfid-20110916_091222_961671_F3BCD93E)
Subject: Re: mac80211 driver for RT3070 wifi card does not work on big-endian platform
From: Semigod King <semigodking@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,
Thanks for your work. It seems the driver works with your dongle &
platform. In your patch, the code changes are just refactor besides
efuse reading part. I tried your patch, no luck. Any r/w operation to
the card causes segment fault.
For changing
  static const u32 wcid[2] = { 0xffffffff, 0x00ffffff };
to
  static const u32 wcid[2] = { 0xffffffff, cpu_to_le32(0x00ffffff) };
, my understanding is that rt2800_register_multiwrite always write
data with assumption that the data is little-endian.

I have no other big-endian platform to test the driver on with regular
linux. So, i have to stick to Brcm6358 based wireless router and
openwrt.



On Thu, Sep 15, 2011 at 5:22 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/09/2011 12:30 PM, Semigod King wrote:
>>
>> I noticed two lines of code:
>>                 static const u32 wcid[2] = { 0xffffffff, 0x00ffffff };
>>                 rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
>>                                               wcid, sizeof(wcid));
>>
>> Do you think the first line should be changed as below to eliminate
>> platform difference?
>>                 static const u32 wcid[2] = { 0xffffffff,
>> cpu_to_le32(0x00ffffff) };
>
> No, that kind of thing should not be done. Internal data that are not
> specifically set to be little- or big-endian should be in cpu order. The
> conversions need to be done when writing to or reading from the device when
> the order differs from that of the cpu.
>
> The changes were minimal. Most of the time it took me were in getting Linux
> running on my Powerbook G4 and getting the code to compile - I had to work
> around a bug in gcc version 4.4.5 on the PowerMac platform. The patch I
> needed is attached. The performance of rt2800usb is not great. With netperf,
> I'm getting about 5 Mbps for the netperf MAERTS, STREAM, and SENDFILE tests.
>
> Larry
>
>
>
