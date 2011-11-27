Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab1K0Ouv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 09:50:51 -0500
Subject: Re: [PATCH v2] mac80211: fix race between the AGG SM and the Tx
 data path
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
In-Reply-To: <1322400584-10964-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20111127_142959_845534_A4ABDBBA)
References: <1322400584-10964-1-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20111127_142959_845534_A4ABDBBA)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Nov 2011 15:50:46 +0100
Message-ID: <1322405446.4044.34.camel@jlt3.sipsolutions.net> (sfid-20111127_155054_374742_E904FE36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-11-27 at 15:29 +0200, Emmanuel Grumbach wrote:
> When a packet is supposed to sent be as an a-MPDU, mac80211 sets
> IEEE80211_TX_CTL_AMPDU to let the driver know. On the other
> hand, mac80211 configures the driver for aggregration with the
> ampdu_action callback.
> There is race between these two mechanisms since the following
> scenario can occur when the BA agreement is torn down:
> 
> Tx softIRQ	 			drv configuration
> ==========				=================
> 
> check OPERATIONAL bit
> Set the TX_CTL_AMPDU bit in the packet
> 
> 					clear OPERATIONAL bit
> 					stop Tx AGG
> Pass Tx packet to the driver.
> 
> In that case the driver would get a packet with TX_CTL_AMPDU set
> although it has already been notified that the BA session has been
> torn down.
> 
> To fix this, we need to synchronize all the Qdisc activity after we
> cleared the OPERATIONAL bit. After that step, all the following
> packets will be buffered until the driver reports it is ready to get
> new packets for this RA / TID. This buffering allows not to run into
> another race that would send packets with TX_CTL_AMPDU unset while
> the driver hasn't been requested to tear down the BA session yet.
> 
> This race occurs in practice and iwlwifi complains with a WARN_ON
> when it happens.
> 
> Cc: stable@kernel.org
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

