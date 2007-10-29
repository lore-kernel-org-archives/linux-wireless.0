Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19]:31426 "HELO
	web52909.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752444AbXJ2Lpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 07:45:47 -0400
Date: Mon, 29 Oct 2007 11:39:05 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.1] PCI device locking up the computer when its module loads
To: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1193657365.19938.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <343473.92638.qm@web52909.mail.re2.yahoo.com> (sfid-20071029_114613_415795_3187AA56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Dan Williams <dcbw@redhat.com> wrote:
> This same sort of problem was just fixed for iwl4965.  The fix for that
> was to disable device interrupts until everything the driver needed
> (including interrupt handler) was set up and ready before re-enabling
> them, I think.  See the thread "iwl4965 detection problem" and the mail
> from Jes Sorensen on 2007-10-26.

The problem with this case is that pci_enable_device() is the very first thing that the driver
calls, but (as I understand it) I have no hope of sending commands to the device until this
function returns. This is a "catch 22" situation from my perspective, because how am I supposed to
know which device interrupt to disable if I can't call pci_enable_device()?

Does the 2.4 kernel survive because IRQs are disabled globally during module_init() or something?

Cheers,
Chris



      ___________________________________________________________ 
Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html
