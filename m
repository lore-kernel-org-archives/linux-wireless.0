Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:65235 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaANQGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:06:00 -0500
Message-ID: <52D56065.8060007@broadcom.com> (sfid-20140114_170603_903399_1D90E7C2)
Date: Tue, 14 Jan 2014 17:05:57 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/8] bcma: add agent IOCTL bit values for Broadcom 802.11
 and CR4 cores
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>	<1389648029-23560-4-git-send-email-arend@broadcom.com> <CACna6ryGU_Rc-iJDJWAjjrKLteg7eyPVorasB-cR4sDhE8o8dw@mail.gmail.com>
In-Reply-To: <CACna6ryGU_Rc-iJDJWAjjrKLteg7eyPVorasB-cR4sDhE8o8dw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2014 07:29 AM, Rafał Miłecki wrote:
> 2014/1/13 Arend van Spriel <arend@broadcom.com>:
>> The IOCTL register in the agent/wrapper contains additional bits
>> that are core specific and use in the core reset sequence.
> 
> I'm not sure about this. I don't think we want to keep device-specific
> bits in a commond (bcma's) code.

True. We can put these in brcm80211 includes so both brcmfmac and
brcmsmac can use it. That said the bcma_core_disable() and
bcma_core_enable() do need to be corrected to be reliable. Patch #2 in
this series show what needs to be changed.

Regards,
Arend

> For example, I can't see PCI defines (like linux/pci_regs.h) having
> any device specific bits in this shared code.
> 
> Our case with bcma is a bit more tricky, because we have a single
> register with common and device-specific bits at the same time. So
> maybe I'll find another example.
> 
> What about USB? Let's say linux/usb/ch9.h. There is a struct
> usb_ctrlrequest that has bRequestType and bRequest.
> bRequestType accepts some common values like USB_DIR_IN,
> USB_RECIP_INTERFACE, etc. They are defined in the same file.
> bRequest values are device-specific and you don't have them defined in
> the above file.
> That makes pretty much sense for me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

