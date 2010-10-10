Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46209 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab0JJWyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 18:54:53 -0400
Message-ID: <4CB24435.2070201@openwrt.org>
Date: Mon, 11 Oct 2010 00:54:45 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mac80211: minstrel_ht A-MPDU fix
References: <alpine.DEB.2.00.1010102206580.31264@bigbill>
In-Reply-To: <alpine.DEB.2.00.1010102206580.31264@bigbill>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-10 10:14 PM, Björn Smedman wrote:
> This patch fixes two problems with the minstrel_ht rate control
> algorithms handling of A-MPDU frames:
> 
> 1. The ampdu_len field of the tx status is not always initialized for 
> non-HT frames (and it would probably be unreasonable to require all 
> drivers to do so). This could cause rate control statistics to be 
> corrupted. We now trust the ampdu_len and ampdu_ack_len fields only when 
> the frame is marked with the IEEE80211_TX_STAT_AMPDU flag.
> 
> 2. Successful transmission attempts where only recognized when the A-MPDU
> subframe carrying the rate control status information was marked with the
> IEEE80211_TX_STAT_ACK flag. If this information happed to be carried on a
> frame that failed to be ACKed then the other subframes (which may have
> succeeded) where not correctly registered. We now update rate control
> statistics regardless of whether the subframe carrying the information was
> ACKed or not.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
For all 3 patches:
Acked-by: Felix Fietkau <nbd@openwrt.org>
