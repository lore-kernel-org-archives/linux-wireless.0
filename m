Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63745 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab1FASs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 14:48:27 -0400
Date: Wed, 1 Jun 2011 15:48:33 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] bluetooth: fix error cases
Message-ID: <20110601184833.GA2564@joana> (sfid-20110601_204833_039589_5A2C869D)
References: <1306910377.3867.5.camel@jlt3.sipsolutions.net>
 <20110601184036.GD2509@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20110601184036.GD2509@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [2011-06-01 14:40:37 -0400]:

> On Wed, Jun 01, 2011 at 08:39:37AM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The error cases in a few functions can use a
> > socket variable that was never initialised,
> > gcc correctly warns about this:
> > net/bluetooth/l2cap_core.c: In function ‘l2cap_recv_frame’:
> > include/linux/spinlock.h:325:19: warning: ‘sk’ may be used uninitialized in this function [-Wuninitialized]
> > net/bluetooth/l2cap_core.c:3789:15: note: ‘sk’ was declared here
> > include/linux/spinlock.h:325:19: warning: ‘sk’ may be used uninitialized in this function [-Wuninitialized]
> > net/bluetooth/l2cap_core.c:3756:15: note: ‘sk’ was declared here
> > 
> > Initialise the socket to NULL as clearly intended
> > by the error handling code.
> > 
> > Also fix a "set but not used" warning.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Dave fixed part of these a couple of weeks ago:
> 
> commit 6dcae1eaee2b437536b2fe928a609f9589691ebf
> Author: David S. Miller <davem@davemloft.net>
> Date:   Mon May 16 23:09:26 2011 -0400
> 
>     bluetooth: Fix warnings in l2cap_core.c
>     
>     net/bluetooth/l2cap_core.c: In function ‘l2cap_recv_frame’:
>     net/bluetooth/l2cap_core.c:3758:15: warning: ‘sk’ may be used uninitialized 
>     net/bluetooth/l2cap_core.c:3758:15: note: ‘sk’ was declared here
>     net/bluetooth/l2cap_core.c:3791:15: warning: ‘sk’ may be used uninitialized 
>     net/bluetooth/l2cap_core.c:3791:15: note: ‘sk’ was declared here
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> The "set but not used" bit still applies...

Those are fixed in my -next tree now.

-- 
Gustavo F. Padovan
http://profusion.mobi
