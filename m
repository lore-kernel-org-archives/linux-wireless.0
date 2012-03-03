Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34683 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2CCWov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 17:44:51 -0500
Received: by wibhm2 with SMTP id hm2so1266373wib.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 14:44:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F4D34FA.8070800@hauke-m.de>
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
	<4F48D997.1060400@hauke-m.de>
	<4F4B571E.7040704@broadcom.com>
	<4F4D34FA.8070800@hauke-m.de>
Date: Sat, 3 Mar 2012 23:44:50 +0100
Message-ID: <CACna6rxDBh-4Yb182atxvXj+peyk2=5mJAMj7H0-wzeyEzwQ4Q@mail.gmail.com> (sfid-20120303_234455_926781_B7FC2678)
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for SPROM storage
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/28 Hauke Mehrtens <hauke@hauke-m.de>:
> On 02/27/2012 11:12 AM, Arend van Spriel wrote:
>> On 02/25/2012 01:52 PM, Hauke Mehrtens wrote:
>>> On 02/23/2012 10:52 PM, Arend van Spriel wrote:
>>>> Wireless Broadcom chips can have either their SPROM data stored
>>>> on either external SPROM or on-chip OTP memory. Both are accessed
>>>> through the same register space. This patch adds support for the
>>>> on-chip OTP memory.
>>>>
>>>> Tested with:
>>>> BCM43224 OTP and SPROM
>>>> BCM4331 SPROM
>>>> BCM4313 OTP
>>>
>>> Does bcma now support the same features regarding sprom and otp as
>>> brcmsamc expect it does not read out all the attributes brcmsmac reads
>>> out or are there any features still missing? I am just asking because
>>> the code used in brcmsmac is ~4 times longer.
>>
>> I started on using bcma sprom content in brcmsmac and indeed there are
>> some entries missing. The change in this patch only provides read-access
>> to the srom data. As the chip comes up for read-access there is not much
>> programming need to accomplish that. The only feature that is not there
>> is that on some chips OTP can be powered down for power-saving. The
>> current chips supported by BCMA don't have that.
>>
>>>> This patch is in response so gmane article [1].
>>>>
>>>> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426
>>>>
>>>> Cc: Saul St. John<saul.stjohn@gmail.com>
>>>> Cc: Rafal Milecki<zajec5@gmail.com>
>>>> Cc: Hauke Mehrtens<hauke@hauke-m.de>
>>>> Cc: Larry Finger<Larry.Finger@lwfinger.net>
>>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>>> ---
>>>> Determining the offset for OTP sprom data turned out to be
>>>> easier as it boils down to reading a register. This change
>>>> collides with patch posted by Hauke:
>>>
>>> I will test you patch on my device soon and will report if something is
>>> wrong. If you are sending a non RFC patch in the next days I would
>>> rebase my patch onto yours. The code searching in the SoCs flash chip
>>> will be added to run if bcma_sprom_onchip_available() returns false.
>>
>> Appreciate any testing on SoCs. I think I will need some time to modify
>> brcmsmac so let your patch go first.
>
> The sprom part of my SoC is working with this patch on top of my sprom
> patches, but it uses the sprom from flash/nvram for both wifi devices
> (one integrated in the bCM4716 and the other a BCM43224 connected to the
> PCIe host controller of the BCM4716).
> For my BCM4716 bcma_sprom_ext_available() and
> bcma_sprom_onchip_available() are returning false and for the BCM43224
> bcma_sprom_ext_available() is returning false and
> bcma_sprom_onchip_offset() 0.

I guess that's wrong...? So is there something wrong with the Arend's
patch causing this regression? Or was this wrong even earlier?

I'm not sure if I should test this patch against my cards or should I
wait for V2.

-- 
Rafał
