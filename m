Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56388 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbaHKPBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 11:01:06 -0400
Message-ID: <1407769263.9844.3.camel@jlt4.sipsolutions.net> (sfid-20140811_170110_598515_F366110E)
Subject: Re: [PATCH] mac80211: don't resize skbs needlessly
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ido Yariv <idox.yariv@intel.com>
Date: Mon, 11 Aug 2014 17:01:03 +0200
In-Reply-To: <1406637554-19475-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1406637554-19475-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-07-29 at 15:39 +0300, Emmanuel Grumbach wrote:
> From: Ido Yariv <ido@wizery.com>
> 
> Header-less cloned skbs with sufficient headroom need not be cloned
> unless the tailroom is going to be modified.
> 
> Fix ieee80211_skb_resize so it would only resize cloned skbs if either
> the header isn't released or the tailroom is going to be modified.
> 
> Some drivers might have assumed that skbs are never cloned, so add a HW
> flag that explicitly permits cloned TX skbs. Drivers which do not modify
> TX skbs should set this flag to avoid copying skbs.

Applied.

johannes

