Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39679 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbcAZNXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:23:38 -0500
Message-ID: <1453814615.2759.48.camel@sipsolutions.net> (sfid-20160126_142341_680502_9EBEBE76)
Subject: Re: [PATCH] mac80211: Parse legacy and HT rate in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 26 Jan 2016 14:23:35 +0100
In-Reply-To: <1844534.ZYplpSov4f@bentobox>
References: <1444746990-17526-1-git-send-email-sven@narfation.org>
	 <1448558726.2167.34.camel@sipsolutions.net> <1844534.ZYplpSov4f@bentobox>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-25 at 13:59 +0100, Sven Eckelmann wrote:
> 
> The flag itself has to be set when the radiotap information is
> available+parsed and when the actual rate information calculation
> should
> happen. 
> 
> Afaik the ieee80211_tx_data is always a local variable on the stack.
> Either
> from ieee80211_tx_prepare_skb, ieee80211_tx, ieee80211_xmit_fast or
> ieee80211_get_buffered_bc. But the parsing of the radiotap header
> happens
> before that in ieee80211_monitor_start_xmit. And after that it calls
> ieee80211_xmit -> ieee80211_tx. So tx_data is definitely not
> available when
> the radiotap header is parsed.

Fair enough. We could put that data elsewhere, but it's probably not
worth it for a simple flag.

johannes
