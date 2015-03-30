Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45719 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbbC3JGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 05:06:31 -0400
Message-ID: <1427706386.26117.21.camel@sipsolutions.net> (sfid-20150330_110634_690008_3021BBF0)
Subject: Re: [RFC] mac80211: check A-MSDU inner frame source address on AP
 interfaces.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Mon, 30 Mar 2015 11:06:26 +0200
In-Reply-To: <1427398823-30321-1-git-send-email-michael-dev@fami-braun.de> (sfid-20150326_204718_452345_B3C0C9FE)
References: <1427398823-30321-1-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20150326_204718_452345_B3C0C9FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-26 at 20:40 +0100, Michael Braun wrote:
> When using WPA security, the station and thus the required key is
> identified by its mac address when packets are received. So a
> station usually cannot spoof its source mac address.
> 
> But when a station sends an A-MSDU frame, port control and crypto
> is done using the outer mac address, while the packets delivered
> and forwarded use the inner mac address.
> 
> IEEE 802.11-2012 mandates that the outer source mac address should
> match the inner source address (section 8.3.2.2). For the
> destination mac address, matching is not required (section 10.23.15).
> 
> So I was wondering whether some checking would be useful?

Makes sense, but perhaps it should just be done in A-MSDU de-aggregation
in ieee80211_amsdu_to_8023s() so we can simply not even allocate the skb
for that frame if it's mismatched? It'd only be possible for those
callers who set has_80211_header=true, but mac80211 would still be
covered.

Alternatively, we could pass the TA into the function, and then check
against that.

johannes

