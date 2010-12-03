Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:45345 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab0LCJM6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 04:12:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 01:12:43 -0800
Date: Fri, 3 Dec 2010 14:42:33 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: fix beacon resource related race condition
Message-ID: <20101203091233.GA17284@vmraj-lnx.users.atheros.com>
References: <1291115197-10883-1-git-send-email-rmanoharan@atheros.com>
 <20101202185444.GA2358@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101202185444.GA2358@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 12:24:44AM +0530, John W. Linville wrote:
> On Tue, Nov 30, 2010 at 04:36:37PM +0530, Rajkumar Manoharan wrote:
> > While releasing beacon slot, it can be accessed by beacon tasklet.
> > To avoid concurrency, beacon alert is disabled before
> > freeing beacon resource and it will be enabled again in the
> > persence of other beaconing mode interfaces.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> 
> Is this intended for 2.6.37?  It looks like it could apply there.

yes. I missed to mention. Thanks for pointing out.

> Could you be more specific about the effect of the bug you are fixing?

The beacon tasklet is accesssing the bslot info for beacon generation.
Meanwhile the same slot can be freed on interface deletion.
Actually the remove_interface disables the beacon alert after freeing the slot.
This may lead to null pointer access.

This patch disables SWBA and kills the beacon tasklet to prevent access
to the slot to be freed. After releasing the slot, swba will be enabled again
upon the availablity of beaconing interfaces.

--
Rajkumar
