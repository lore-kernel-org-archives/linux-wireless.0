Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:64987 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1DUHgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 03:36:06 -0400
Date: Thu, 21 Apr 2011 09:38:59 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH V2 1/4] mwl8k: Do not stop tx queues
Message-ID: <20110421073859.GW1897@wantstofly.org>
References: <1303231582-17333-1-git-send-email-nishants@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303231582-17333-1-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 10:16:19PM +0530, Nishant Sarmukadam wrote:

> From: Pradeep Nemavat <pnemavat@marvell.com>
> 
> This is in preparation to support life time expiry of packets in the
> hardware to avoid head-of-line blocking where a slow client can
> hog a tx queue and affect the traffic to a faster client from the same
> queue. Time stamp the packets in driver to allow dropping them in the
> hardware if they are queued for more than 500ms.
> 
> If queues are stopped, packets will be queued up outside the driver.
> Since we will be able to timestamp the packets only after they hit the
> driver, the timestamp will be less accurate since we cannot consider
> the time the packets spent in queues outside the driver. With this commit,
> to achieve accurate timestamping, the tx queues will never be stopped.
> Now, we need to be prepared for a situation where packets hit the driver
> even after the tx queues are full. Drop all such packets in the driver itself.

It might be worth adding that after this patch, the mac80211 queues are
only stopped when firmware commands are executing (and when the interface
is down'ed).

Also, it's somewhat doubtful that this should really be called HOL
blocking.

Apart from those, OK with the explanation.
