Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58162 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaAOPpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 10:45:52 -0500
Message-ID: <52D6AD19.9070307@broadcom.com> (sfid-20140115_164603_533184_9AFF479A)
Date: Wed, 15 Jan 2014 16:45:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/8] bcma: add agent IOCTL bit values for Broadcom 802.11
 and CR4 cores
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>	<1389648029-23560-4-git-send-email-arend@broadcom.com>	<CACna6ryGU_Rc-iJDJWAjjrKLteg7eyPVorasB-cR4sDhE8o8dw@mail.gmail.com>	<52D56065.8060007@broadcom.com> <CACna6rwEpq2R2v6wMO8n43bO=0cMPn+q4jZ7FMoZx0XkAt0rUA@mail.gmail.com>
In-Reply-To: <CACna6rwEpq2R2v6wMO8n43bO=0cMPn+q4jZ7FMoZx0XkAt0rUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2014 08:25 PM, Rafał Miłecki wrote:
> 2014/1/14 Arend van Spriel <arend@broadcom.com>:
>> On 01/14/2014 07:29 AM, Rafał Miłecki wrote:
>>> 2014/1/13 Arend van Spriel <arend@broadcom.com>:
>>>> The IOCTL register in the agent/wrapper contains additional bits
>>>> that are core specific and use in the core reset sequence.
>>>
>>> I'm not sure about this. I don't think we want to keep device-specific
>>> bits in a commond (bcma's) code.
>>
>> True. We can put these in brcm80211 includes so both brcmfmac and
>> brcmsmac can use it. That said the bcma_core_disable() and
>> bcma_core_enable() do need to be corrected to be reliable. Patch #2 in
>> this series show what needs to be changed.
> 
> I'm looking at
> [PATCH 2/8] brcmfmac: update core reset and disable routines.
> and it's unclear for me, what needs to be changed in
> bcma_core_[enable|disable]. Could you specify, please?

Basically, the whole sequence in bcma_core_enable() and disable() is
derived from aiutils.c in the original brcmsmac mainline patch (or at
least it has very, very close resemblance). It turned out this sequence
was cooked up by software devs, but the hardware documentation states
another sequence, which is what Patch #2 implements. For this it needs
additional parameters. You know what, I will create a patch for this.

Gr. AvS


