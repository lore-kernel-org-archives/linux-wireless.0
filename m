Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2KPONC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 09:13:02 -0500
Date: Fri, 16 Nov 2012 08:12:55 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com, Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH v2 01/22] brcmsmac: Introduce AMPDU sessions for
 assembling AMPDUs
Message-ID: <20121116141255.GA19078@thinkpad-t410> (sfid-20121116_151305_869936_00E0FEB1)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-2-git-send-email-seth.forshee@canonical.com>
 <50A5FB05.4040500@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50A5FB05.4040500@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2012 at 09:36:21AM +0100, Arend van Spriel wrote:
> On 11/15/2012 03:07 PM, Seth Forshee wrote:
> >AMPDU session allows MPDUs to be temporarily queued until either a full
> >AMPDU has been collected or circumstances dictate that transmission
> >should start with a partial AMPDU. Packets are added to the session by
> 
> I started reviewing this and reading this commit message got me
> wondering about the .flush() problems. I realized the flush would be
> a "circumstance" to start transmission of a partial AMPDU, but I am
> pretty sure it currently is not treated as such.

I hope my terminology here isn't confusing; I wasn't sure how else to
express this. By "full" I mean an AMPDU that is transmitted because it
can accommodate no more packets. A "partial" AMPDU is any that is
transmitted without being full.

One of the things I added when removing the tx queue was a DMA flush
operation to force any queued AMPDU packets into the DMA ring. But in
the current code brcms_c_sendampdu() will transmit the AMPDU with
whatever it's got when it runs out of packets in the pktq, so I don't
see a partial AMPDU problem.

What does strike me as problematic is the locking in brcms_ops_flush().
It holds wl->lock, and the interrupt handling tries to acquire the same
lock. Doesn't this prevent both the txpktpend counts from getting
updated and any more packets being transmitted from the packet queue?

Seth
