Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48424
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbXFTVBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 17:01:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] bcm43xx: honour promisc bit even in monitor mode
Date: Wed, 20 Jun 2007 23:01:25 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1182295838.3714.14.camel@johannes.berg>
In-Reply-To: <1182295838.3714.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706202301.25890.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 June 2007 01:30:38 Johannes Berg wrote:
> When bcm43xx goes into monitor mode, it always is a promisc monitor
> mode. For the hostapd using monitor interfaces, we'll want to only go
> into monitor mode if it's really required. I previously thought that
> this requires changes to mac80211, but mac80211 does in fact already
> seem to handle IFF_PROMISC appropriately. Hence, this change is the
> only required to get proper semantics for a monitor interface that
> isn't in promiscuous mode on bcm43xx.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> ---
> Since wireshark/tcpdump by default still set IFF_PROMISC everything will
> work just fine, but if somebody really wants a monitor interface that
> isn't promisc this makes it work too. However, you'll of course get all
> packets still if any other interface is set promisc. We don't do any
> promisc/non-promisc filtering in the stack when multiple monitor
> interfaces are open.

Applied, thanks.

-- 
Greetings Michael.
