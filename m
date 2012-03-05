Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1459 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab2CEJQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 04:16:54 -0500
Message-ID: <4F548474.10703@broadcom.com> (sfid-20120305_101658_637276_3217FA10)
Date: Mon, 5 Mar 2012 10:16:36 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <4F48D997.1060400@hauke-m.de> <4F4B571E.7040704@broadcom.com>
 <4F4D34FA.8070800@hauke-m.de>
 <CACna6rxDBh-4Yb182atxvXj+peyk2=5mJAMj7H0-wzeyEzwQ4Q@mail.gmail.com>
In-Reply-To: <CACna6rxDBh-4Yb182atxvXj+peyk2=5mJAMj7H0-wzeyEzwQ4Q@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/03/2012 11:44 PM, Rafał Miłecki wrote:
> 2012/2/28 Hauke Mehrtens<hauke@hauke-m.de>:
>> On 02/27/2012 11:12 AM, Arend van Spriel wrote:
>>>
>>> Appreciate any testing on SoCs. I think I will need some time to modify
>>> brcmsmac so let your patch go first.
>>
>> The sprom part of my SoC is working with this patch on top of my sprom
>> patches, but it uses the sprom from flash/nvram for both wifi devices
>> (one integrated in the bCM4716 and the other a BCM43224 connected to the
>> PCIe host controller of the BCM4716).
>> For my BCM4716 bcma_sprom_ext_available() and
>> bcma_sprom_onchip_available() are returning false and for the BCM43224
>> bcma_sprom_ext_available() is returning false and
>> bcma_sprom_onchip_offset() 0.
>
> I guess that's wrong...? So is there something wrong with the Arend's
> patch causing this regression? Or was this wrong even earlier?
>
> I'm not sure if I should test this patch against my cards or should I
> wait for V2.
>

Hi Rafał,

It is not wrong. I asked Hauke a question about his router regarding 
this. The story for routers is that sprom data for both cards resides in 
nvram/flash, ie. the fallback sprom source in Hauke's patch. Not sure 
why that bcma patch has not yet made it into wireless-next. Your cards 
are probably pci(e) cards so those should have sprom data on board.

Gr. AvS

