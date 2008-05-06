Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43770
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbYEFAIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 20:08:06 -0400
Date: Mon, 05 May 2008 17:08:05 -0700 (PDT)
Message-Id: <20080505.170805.127854312.davem@davemloft.net> (sfid-20080506_020723_205274_822CDDD7)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210032076.8012.49.camel@johannes.berg>
References: <1210029835.8012.30.camel@johannes.berg>
	<20080505.163916.239187195.davem@davemloft.net>
	<1210032076.8012.49.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 May 2008 02:01:16 +0200

> Right. I just checked, and realised I remembered wrongly, wpa_supplicant
> actually binds the socket to the ethertype it wants so
> dev_queue_xmit_nit() shouldn't be called. I'll have to check why I got
> so many cloned packets, best see if it still happens with the
> header_cloned() change.

skb_cloned() is fine, that's what every TCP packet is.

skb_header_cloned() is what we expect to be false

I look forward to the results of your investigation :-)
