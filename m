Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57969 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2DONEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 09:04:41 -0400
Received: by eekc41 with SMTP id c41so1085467eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 06:04:40 -0700 (PDT)
References: <1334448592-16391-1-git-send-email-xose.vazquez@gmail.com> <4F8A6CB6.4080006@01019freenet.de> <4F8A92A5.8090707@gmail.com> <4F8AB8F9.4060503@01019freenet.de>
In-Reply-To: <4F8AB8F9.4060503@01019freenet.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <201C9B63-C214-4D44-B3D0-44948F9DE260@gmail.com> (sfid-20120415_150509_995662_2390DAFA)
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"IvDoorn@gmail.com" <IvDoorn@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800usb add more devices ids
Date: Sun, 15 Apr 2012 15:04:39 +0200
To: Andreas Hartmann <andihartmann@01019freenet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 apr. 2012, at 14:03, Andreas Hartmann <andihartmann@01019freenet.de> wrote:

> Hello Xose,
> 
> sorry for double post - I accidentally pressed the wrong answer button :-(.
> 
> Xose Vazquez Perez wrote:
>> On 04/15/2012 08:37 AM, Andreas Hartmann wrote:
>> 
>>> Did you test them? What did you test exactly? What exactly works, what
>>> does not?
>> 
>> NO. NOTHING . I DON'T KNOW. But...
>> 
>>> It doesn't mean anything, if they work with the legacy driver.
>> 
>> ..., the chips in these devices are *identified* . They perform so well
>> or so badly like those that are already in the driver(rt2800usb).
> 
> This is an expectation. The mentioned WUSB600Nv2 is one proof, that it
> isn't (always) enough to successfully identify chips and derive, that it
> behaves like other brands using the same chip. There have been brands
> with this chip, which have been working fine (supposedly), but this
> special brand didn't work at all here - even though it uses an already
> known chip.
> 
>>> Linksys WUSB600Nv2 e.g. works fine with the legacy driver, but only
>>> limited (if at all) with rt2800usb yet.
>> 
>> <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/rt2x00/Kconfig;h=299c3879582da14e12ca00d7f11184da8c61bed7;hb=HEAD#l83>
>> 
>> config RT2800USB_RT35XX
>>    bool "rt2800usb - Include support for rt35xx devices ( *EXPERIMENTAL* )"
>>    depends on *EXPERIMENTAL*
> 
> Chance :-)
> 
> rt2860 (PCI) chipset (rt2800pci) isn't experimental but is nevertheless
> broken since 3.2 [1].
> 
> I'm seeing a fundamental problem (but not just here :-)) regarding QA. I
> can't see any QA if there is done any change. Ok, I don't know all and
> maybe, I'm blind, too. But I'm willing to learn .
> 
> That's why I'm wondering: When are all these appropriate devices going
> to be tested? I think, a good point would be during development and not
> after they have been released (means: "experimental" was removed). If
> the ID's are committed, it should be ensured, that they really behave as
> expected.

Andreas,

It is impossible to test each and every device that uses a Ralink chipset. Therefore we run tests on the chipsets only, and simply list all devices that contain these chipsets.

Granted, we are having issues with some of the chipsets, but that should not prevent adding other devices that use the same chipset to the driver.

---
Gertjan