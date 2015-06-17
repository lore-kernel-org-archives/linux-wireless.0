Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58658 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbFQIUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:20:31 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21889.11726.101648.552280@gargle.gargle.HOWL> (sfid-20150617_102036_119518_7679B082)
Date: Wed, 17 Jun 2015 13:50:30 +0530
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
In-Reply-To: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic wrote:
> mac80211 configure rxfilter per HW,
> so we don't need this per channel.
> 
> This fix problem when chanctx used and
> ath9k allocate new ath_chanctx. Then we loose
> rxfilter configuration.
> 
> Eg. during p2p_find (when use_chanctx=1) during
> remain on channel, driver create new ath_chanctx
> with incorrect rxfilter. Then we didn't receive
> probe requests and fail p2p_find.

The RX filter is calculated based on the operating mode
of the HW. If we have a concurrent P2P-GO/station
setup, for example, then the RX filter needs to be different for each
context, (MYBEACON vs. BEACON etc.). I don't see how
having a global filter will allow this ?

Sujith



