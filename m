Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46718 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbcHCGyR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 02:54:17 -0400
Message-ID: <1470207253.2638.10.camel@sipsolutions.net> (sfid-20160803_085423_133241_AB3D3A90)
Subject: Re: [PATCH] mac80211: fix purging multicast PS buffer queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Wed, 03 Aug 2016 08:54:13 +0200
In-Reply-To: <20160802091341.64330-1-nbd@nbd.name>
References: <20160802091341.64330-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-08-02 at 11:13 +0200, Felix Fietkau wrote:
> The code currently assumes that buffered multicast PS frames don't
> have
> a pending ACK frame for tx status reporting.
> However, hostapd sends a broadcast deauth frame on teardown for which
> tx
> status is requested. This can lead to the "Have pending ack frames"
> warning on module reload.
> Fix this by using ieee80211_free_txskb/ieee80211_purge_tx_queue.
> 
Applied, thanks.

johannes
