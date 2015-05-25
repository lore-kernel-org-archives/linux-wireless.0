Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35369 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbEYEnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 00:43:02 -0400
Date: Mon, 25 May 2015 10:12:50 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: haggai.eran@gmail.com
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Stable <stable@vger.kernel.org>,
	Arek Rusniak <arek.rusi@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call of
 del_timer_sync()
Message-ID: <20150525044250.GA3385@sudip-PC> (sfid-20150525_064312_722326_5EFA1AED)
Reply-To: 1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>I haven't been using kernel v4.1 so I haven't seen this warning, but looking
>at the code it seems to originate from the two recent patches to remove
>_cancel_timer and _cancel_timer_ex. I see that there's another patch in lkml [1]
>that changes del_timer_sync back to del_timer in more places. Perhaps it
>could prevent other warnings like this in the future.

_cancel_timer and _cancel_timer_ex both were internally using del_timer,
and the issue was reported in bugzilla. I have given the reference of the
bugzilla in my patch in lkml.
I have changed the reference of del_timer_sync to del_timer in all places
which were in interrupt context, in some places it was not removed as
those were not in interrupt context.

regards
sudip
