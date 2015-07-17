Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52984 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715AbbGQNql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:46:41 -0400
Message-ID: <1437140799.1933.24.camel@sipsolutions.net> (sfid-20150717_154655_455668_4ED72A1F)
Subject: Re: [PATCH 10/10] mac80211: enable changing netdev features with
 ethtool
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Avri Altman <avri.altman@intel.com>
Date: Fri, 17 Jul 2015 15:46:39 +0200
In-Reply-To: <1436359312-26533-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144237_229138_0E3078CD)
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1436359312-26533-11-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150708_144237_229138_0E3078CD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-07-08 at 15:41 +0300, Emmanuel Grumbach wrote:
> From: Avri Altman <avri.altman@intel.com>
> 
> For drivers that have offloading features, these are currently
> forced and cannot be modified in any way. Enable that so users
> can change the features if needed, but of course this requires
> driver interaction.
> 
> For AP_VLAN don't allow direct changes but propagate them from
> the AP interface.
> 
> Additionally, add NETIF_F_RXCSUM to the whitelist, if a driver
> has this capability it doesn't have to advertise this but can
> just set the skb->checksum field accordingly, but advertising
> it will allow it to be changed with ethtool.
> 
This patch has an issue when ethtool is called while the interface is
still down, so I'll not apply it for now. I'll try to sort out that
issue after my vacation.

As a consequence, patch 9 is worthless so I'll also leave that for now.

johannes
