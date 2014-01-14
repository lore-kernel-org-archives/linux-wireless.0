Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50066 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaANG3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 01:29:37 -0500
Received: by mail-ob0-f182.google.com with SMTP id wn1so6925945obc.27
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 22:29:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389648029-23560-4-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
	<1389648029-23560-4-git-send-email-arend@broadcom.com>
Date: Tue, 14 Jan 2014 07:29:36 +0100
Message-ID: <CACna6ryGU_Rc-iJDJWAjjrKLteg7eyPVorasB-cR4sDhE8o8dw@mail.gmail.com> (sfid-20140114_072939_717873_A5EF9EA6)
Subject: Re: [PATCH 3/8] bcma: add agent IOCTL bit values for Broadcom 802.11
 and CR4 cores
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/13 Arend van Spriel <arend@broadcom.com>:
> The IOCTL register in the agent/wrapper contains additional bits
> that are core specific and use in the core reset sequence.

I'm not sure about this. I don't think we want to keep device-specific
bits in a commond (bcma's) code.

For example, I can't see PCI defines (like linux/pci_regs.h) having
any device specific bits in this shared code.

Our case with bcma is a bit more tricky, because we have a single
register with common and device-specific bits at the same time. So
maybe I'll find another example.

What about USB? Let's say linux/usb/ch9.h. There is a struct
usb_ctrlrequest that has bRequestType and bRequest.
bRequestType accepts some common values like USB_DIR_IN,
USB_RECIP_INTERFACE, etc. They are defined in the same file.
bRequest values are device-specific and you don't have them defined in
the above file.
That makes pretty much sense for me.
