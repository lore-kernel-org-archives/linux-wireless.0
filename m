Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38105 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2IGPY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:24:59 -0400
Message-ID: <504A11C0.5030602@candelatech.com> (sfid-20120907_172502_919374_4D63A21C)
Date: Fri, 07 Sep 2012 08:24:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211: validate skb->dev in the tx status path
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2012 07:54 AM, Felix Fietkau wrote:
> skb->dev might contain a stale reference to a device that was already
> deleted, and using it unchecked can lead to invalid pointer accesses.
> Since this is only used for nl80211 tx, iterate over active interfaces
> to find a match for skb->dev, and discard the tx status if the device
> is gone.

Nasty performance hit if we have lots of virtual
interfaces, eh?  Maybe some sort of ref-counting
would be better?  Or a hashed lookup on the netdev
pointer/token?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

