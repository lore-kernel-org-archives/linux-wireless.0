Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3825 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab2KPPCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 10:02:46 -0500
Message-ID: <50A65586.9080102@broadcom.com> (sfid-20121116_160249_818220_8F1EEDA0)
Date: Fri, 16 Nov 2012 16:02:30 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com, "Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 01/22] brcmsmac: Introduce AMPDU sessions for
 assembling AMPDUs
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-2-git-send-email-seth.forshee@canonical.com>
 <50A5FB05.4040500@broadcom.com> <20121116141255.GA19078@thinkpad-t410>
In-Reply-To: <20121116141255.GA19078@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 03:12 PM, Seth Forshee wrote:
> What does strike me as problematic is the locking in brcms_ops_flush().
> It holds wl->lock, and the interrupt handling tries to acquire the same
> lock. Doesn't this prevent both the txpktpend counts from getting
> updated and any more packets being transmitted from the packet queue?
>
> Seth
>

Actually, in the brcms_c_wait_for_tx_completion() the while loop does a 
brcms_msleep() which releases the wl->lock, does an msleep() and 
acquires the lock. At least that is what is currently in 
wireless-testing. I changed it internally to wait_for_event() mechanism, 
but it was not accepted as people still were seeing issues.

Gr. AvS

