Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45938 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1FASqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 14:46:14 -0400
Date: Wed, 1 Jun 2011 14:40:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] bluetooth: fix error cases
Message-ID: <20110601184036.GD2509@tuxdriver.com> (sfid-20110601_204620_311173_028E373B)
References: <1306910377.3867.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1306910377.3867.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 01, 2011 at 08:39:37AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The error cases in a few functions can use a
> socket variable that was never initialised,
> gcc correctly warns about this:
> net/bluetooth/l2cap_core.c: In function ‘l2cap_recv_frame’:
> include/linux/spinlock.h:325:19: warning: ‘sk’ may be used uninitialized in this function [-Wuninitialized]
> net/bluetooth/l2cap_core.c:3789:15: note: ‘sk’ was declared here
> include/linux/spinlock.h:325:19: warning: ‘sk’ may be used uninitialized in this function [-Wuninitialized]
> net/bluetooth/l2cap_core.c:3756:15: note: ‘sk’ was declared here
> 
> Initialise the socket to NULL as clearly intended
> by the error handling code.
> 
> Also fix a "set but not used" warning.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Dave fixed part of these a couple of weeks ago:

commit 6dcae1eaee2b437536b2fe928a609f9589691ebf
Author: David S. Miller <davem@davemloft.net>
Date:   Mon May 16 23:09:26 2011 -0400

    bluetooth: Fix warnings in l2cap_core.c
    
    net/bluetooth/l2cap_core.c: In function ‘l2cap_recv_frame’:
    net/bluetooth/l2cap_core.c:3758:15: warning: ‘sk’ may be used uninitialized 
    net/bluetooth/l2cap_core.c:3758:15: note: ‘sk’ was declared here
    net/bluetooth/l2cap_core.c:3791:15: warning: ‘sk’ may be used uninitialized 
    net/bluetooth/l2cap_core.c:3791:15: note: ‘sk’ was declared here
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

The "set but not used" bit still applies...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
