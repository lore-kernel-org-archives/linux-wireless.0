Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50497 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaANTZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 14:25:50 -0500
Received: by mail-ob0-f174.google.com with SMTP id wo20so67153obc.5
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 11:25:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52D56065.8060007@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
	<1389648029-23560-4-git-send-email-arend@broadcom.com>
	<CACna6ryGU_Rc-iJDJWAjjrKLteg7eyPVorasB-cR4sDhE8o8dw@mail.gmail.com>
	<52D56065.8060007@broadcom.com>
Date: Tue, 14 Jan 2014 20:25:47 +0100
Message-ID: <CACna6rwEpq2R2v6wMO8n43bO=0cMPn+q4jZ7FMoZx0XkAt0rUA@mail.gmail.com> (sfid-20140114_202553_852620_E560FE4D)
Subject: Re: [PATCH 3/8] bcma: add agent IOCTL bit values for Broadcom 802.11
 and CR4 cores
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/14 Arend van Spriel <arend@broadcom.com>:
> On 01/14/2014 07:29 AM, Rafał Miłecki wrote:
>> 2014/1/13 Arend van Spriel <arend@broadcom.com>:
>>> The IOCTL register in the agent/wrapper contains additional bits
>>> that are core specific and use in the core reset sequence.
>>
>> I'm not sure about this. I don't think we want to keep device-specific
>> bits in a commond (bcma's) code.
>
> True. We can put these in brcm80211 includes so both brcmfmac and
> brcmsmac can use it. That said the bcma_core_disable() and
> bcma_core_enable() do need to be corrected to be reliable. Patch #2 in
> this series show what needs to be changed.

I'm looking at
[PATCH 2/8] brcmfmac: update core reset and disable routines.
and it's unclear for me, what needs to be changed in
bcma_core_[enable|disable]. Could you specify, please?
