Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39914 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbbFZHIC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 03:08:02 -0400
Message-ID: <1435302478.2106.2.camel@sipsolutions.net> (sfid-20150626_090806_391094_B1E2E098)
Subject: Re: [PATCH v3] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Fri, 26 Jun 2015 09:07:58 +0200
In-Reply-To: <9228e2c85d5d4bab9ad2cc859fa6c946@SC-EXCH02.marvell.com>
References: <909c66d61ee943f5a5ca202040944f2d@SC-EXCH02.marvell.com>
	 <1435225107.2096.12.camel@sipsolutions.net>
	 <9228e2c85d5d4bab9ad2cc859fa6c946@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-26 at 01:25 +0000, David Lin wrote:

> Both the drivers are operable for the same chip part number 8897 and 
> its modules (boards) manufactured out there. The PCI Device ID is a 
> fixed value (by chip/manufacturer) on those modules. As said earlier, 
> the two drivers are for mac80211 host mac, and firmware mac 
> respectively. They serve different purposes. Users need to choose 
> which driver they want to use for the same wifi hardware, and they 
> cannot use both of them at the same time. The mwifiex is more widely 
> used now and sta centric. We do not want to break it.
> 
> I am not sure but I believe they are also multiple flavors of driver 
> for some other chips. Any advice how they are handled, considering 
> that changing the hardware/board is not an option? I guess we want 
> the community to be better served using the same hardware. Opinion 
> from others are welcomed.

Hmm, interesting, I didn't realize it was the same device.

Perhaps it simply shouldn't conflict at build time, and you can
recommend to blacklist one or the other? Or, in fact, return an error
from probe if you can't find the correct firmware file, so the other
driver would be attempted?

> Although "-D__CHECK_ENDIAN__" does not put into Makefile, I had used 
> "C=2 CF="-D__CHECK_ENDIAN__" to check warnings for endian and remove 
> these warnings.

Ok. Then I guess my issues were mostly due to 64-bit system.

> If you think we need to add this to Makefile and make sure zero 
> warning messages, we will do that (only for sparser).

Well it just helps not forget adding CF=-D... to the command line, it's
equivalent. I just prefer it in a sense since then if people run with
C=1 or C=2 they get that part for free, and since the driver is clean
to start with then that's a good thing to do I think.

I'll try to take a closer look later.

johannes
