Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:21152 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAOPdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 10:33:36 -0500
Message-ID: <52D6AA49.6000707@broadcom.com> (sfid-20140115_163342_875276_4AA0A934)
Date: Wed, 15 Jan 2014 16:33:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
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

Hi John,

Given that I agree with Rafał's argument, can you drop patch #3 from
this series. I applied the other patches using 'git am -3' and that
works. Let me know if I should resend them.

Gr. AvS

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

