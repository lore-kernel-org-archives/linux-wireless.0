Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3252 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab1HVWOJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 18:14:09 -0400
Date: Mon, 22 Aug 2011 15:13:52 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Tomasz Figa" <tomasz.figa@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>, hharte@broadcom.com
Subject: Re: BCM4325 support in brcm80211 or newer versions of bcm4329
 driver
Message-ID: <20110822221352.GJ2250@broadcom.com> (sfid-20110823_001412_808525_5B6C6AD6)
References: <1514181.3grperja2F@flatron>
MIME-Version: 1.0
In-Reply-To: <1514181.3grperja2F@flatron>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 14, 2011 at 11:31:09AM -0700, Tomasz Figa wrote:
> Hi,
> 
> I'm looking into running current Linux kernel on a platform equipped with the
> BCM4325 full mac combo chip, but unfortunately the shipped DHD driver (v.
> 4.217.*) is outdated and designed for stock 2.6.29 kernel with much hardcoding
> done to glue everything together.
> 
> I did some reasearch and it led me to a newer version of the DHD driver,
> designed for BCM4329 (v. 4.218), which after some modifications (BCD protocol
> version 2, some event IDs, etc.) started to work on my hardware, with one
> exception: waiting for RxCtrl after sending an "iscanresults" request times
> out. I'm attaching driver debug output at the bottom of this message.
> 
> A bit more details about my hardware: a Samsung S3C6410-based board connected
> to a BCM4325 chip using 4-bit SDIO interface, without dedicated IRQ pin (using
> SDIO IRQ feature), so undefining of OOB_INTR_ONLY and HW_OOB and defining of
> SDIO_ISR_THREAD was needed.
> 
> Do you have any suggestions?

Tom,

The brcmfmac driver (in staging) doesn't yet support the BCM4325.  As you
found, there are a variety of older driver sources available in other repos.
You can contact Howard Harte <hharte@broadcom.com> to see about a combination
of those sources and firmware that will support your platform in the near term.

- Henry


