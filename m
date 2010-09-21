Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0IUMYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 08:24:44 -0400
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C98A2C4.8060108@openwrt.org>
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>
	 <4C98A022.7020106@candelatech.com>  <4C98A2C4.8060108@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 14:24:40 +0200
Message-ID: <1285071880.12764.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 14:19 +0200, Felix Fietkau wrote:

> To keep track of the Block ACK window, it needs to look up the TID, for
> which it needs a STA pointer. At that level, the driver typically
> doesn't have access to the vif.
> 
> It might be possible to fix this by adding another sta lookup helper
> function in mac80211 that takes another address argument for the BSSID,
> so that it can get the sta entry for the correct vif. I don't know if
> Johannes wants something like that though.

Seems simple enough, and if it fixes things ... for iwlwifi I fixed the
driver to keep track of the vif properly, though more work it does make
a lot more things better than just this.

johannes

