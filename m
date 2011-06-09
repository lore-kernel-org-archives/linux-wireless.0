Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36610 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1FINC3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 09:02:29 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] ath6kl: testmode support
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
	<20110608115430.32208.81891.stgit@localhost6.localdomain6>
	<20110608194618.GB4069@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 09 Jun 2011 16:02:25 +0300
In-Reply-To: <20110608194618.GB4069@shale.localdomain> (Dan Carpenter's message of "Wed\, 8 Jun 2011 22\:46\:18 +0300")
Message-ID: <8762of88f2.fsf@purkki.adurom.net> (sfid-20110609_150232_619204_640035A7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> On Wed, Jun 08, 2011 at 02:54:30PM +0300, Kalle Valo wrote:
>> Add testmode support for running low level hardware tests. The testmode
>> is enabled by setting testmode module parameter to 1.
>> 
>> For now only a simple command passing is supported. More advanced
>> support will be implemented later.
>> 
>
> It's Greg's call, but probably it's late in the release cycle to add
> this feature.

Do you mean for 3.0? I was thinking of getting this into 3.1, didn't
even consider 3.0.

> Also are we even still developing this driver? I thought the real
> driver was moved to a different tree?

We are maintaining still maintaining the staging driver and fixing the
critical issues until the cleaned up driver is merged.

The testmode support got broke when the private ioctl interfaces were
removed from the driver. I had people asking me how to use testmode
and when I started implementing it through nl80211 testmode interface.
So this was a feature regression.

The cleanup of the driver is happening here:

http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary

-- 
Kalle Valo
