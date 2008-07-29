Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44599 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758435AbYG2OrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 10:47:09 -0400
Message-ID: <488F2D64.902@lwfinger.net> (sfid-20080729_164714_214443_6385C747)
Date: Tue, 29 Jul 2008 09:47:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
References: <1217323927.10489.9.camel@johannes.berg>
In-Reply-To: <1217323927.10489.9.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This patch fixes mac80211 to not use the skb->cb over the queue step
> from virtual interfaces to the master. The patch also, for now,
> disables aggregation because that would still require requeuing,
> will fix that in a separate patch. There are two other places (software
> requeue and powersaving stations) where requeue can happen, but that is
> not currently used by any drivers/not possible to use respectively.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This fixes wireless. At least it works on my WPA network, I haven't
> actually tested a broken kernel.

This patch fixes my broken 2.6.27-rc1 kernel using b43, which had not worked 
since the new networking stuff was merged.

I'm pretty discouraged that a change that has such an impact on wireless never 
made it to wireless-testing, where this kind of defect should have been found 
and fixed long before it ever got into mainline.

Larry
