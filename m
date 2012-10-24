Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63458 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259Ab2JXQFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 12:05:00 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm2so4435239wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 09:04:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5087CA82.5070902@broadcom.com>
References: <5087035E.9010609@lwfinger.net>
	<5087CA82.5070902@broadcom.com>
Date: Wed, 24 Oct 2012 18:04:58 +0200
Message-ID: <CACna6rxysanXp-TYwcet_76s4OKtEZCnmh61GkjL5cRwrb6xRA@mail.gmail.com> (sfid-20121024_180508_078276_58A21FCA)
Subject: Re: Driver for USB device with ID 050d:615a
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Franky Lin <frankyl@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/10/24 Arend van Spriel <arend@broadcom.com>:
> On 10/23/2012 10:51 PM, Larry Finger wrote:
>>
>> Arend and Franky,
>>
>> I recently purchased a Belkin N600 DB USB dongle on Ebay. I wanted to
>> get the model with a Realtek RTL8192DU chip. Instead I got a version
>> with a Broadcom chip, which lsusb identifies as
>>
>> Bus 001 Device 005: ID 050d:615a Belkin Components F7D4101 / F9L1101
>> 802.11abgn Wireless Adapter [Broadcom BCM4323]
>>
>> I have since acquired a different device with the Realtek chip, thus I
>> could return the Belkin device; however, the cost was minimal and I will
>> keep it if there is a driver for it. Is it a brcmfmac device that is not
>> yet in the device tables, or is it some other sort of unit that may
>> never be supported under Linux?
>
>
> Hi Larry,
>
> I went digging and this chip requires a different driver model (basically a
> split stack between host and dongle). This model is being abandoned for
> newer chips so we decided not to support it in mainline linux.

What do you think about listing not supported chipsets on your
brcm80211 wiki page? Thay way users will get clear overview of this
situation. I think I already heard similar answer about BCM43236 V2
(found by Hauke in his router).

Btw. your http://wireless.kernel.org/en/users/Drivers/brcm80211
doesn't say anything about BCM43143, which (I believe) is supported by
brcmfmac.
Oh and one more thing: I believe putting minimal kernel version
requires is also a good idea. Something like:
"BCM43143 - supported since 3.123"

-- 
Rafał
