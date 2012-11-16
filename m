Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab2KPPTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 10:19:03 -0500
Date: Fri, 16 Nov 2012 09:18:57 -0600
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
Message-ID: <20121116151857.GB19078@thinkpad-t410> (sfid-20121116_161908_882903_10AB1205)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-2-git-send-email-seth.forshee@canonical.com>
 <50A5FB05.4040500@broadcom.com>
 <20121116141255.GA19078@thinkpad-t410>
 <50A65586.9080102@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50A65586.9080102@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2012 at 04:02:30PM +0100, Arend van Spriel wrote:
> On 11/16/2012 03:12 PM, Seth Forshee wrote:
> >What does strike me as problematic is the locking in brcms_ops_flush().
> >It holds wl->lock, and the interrupt handling tries to acquire the same
> >lock. Doesn't this prevent both the txpktpend counts from getting
> >updated and any more packets being transmitted from the packet queue?
> >
> >Seth
> >
> 
> Actually, in the brcms_c_wait_for_tx_completion() the while loop
> does a brcms_msleep() which releases the wl->lock, does an msleep()
> and acquires the lock. At least that is what is currently in
> wireless-testing. I changed it internally to wait_for_event()
> mechanism, but it was not accepted as people still were seeing
> issues.

Ah, I failed to look at what brcms_msleep() is doing so I didn't notice
that. Nevermind then.

Seth
