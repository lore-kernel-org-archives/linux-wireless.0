Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57697 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1D2Gyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 02:54:35 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QFhaz-0006D1-9K
	for linux-wireless@vger.kernel.org; Fri, 29 Apr 2011 08:54:33 +0200
Received: from dslb-088-068-193-215.pools.arcor-ip.net ([88.68.193.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 08:54:33 +0200
Received: from alexander.simon by dslb-088-068-193-215.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 08:54:33 +0200
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
Date: Fri, 29 Apr 2011 06:54:21 +0000 (UTC)
Message-ID: <loom.20110429T084118-365@post.gmane.org> (sfid-20110429_085443_970145_470B3272)
References: <1302604964.2139.5.camel@alex-2>  <loom.20110412T130620-109@post.gmane.org>  <1302607159.3639.8.camel@jlt3.sipsolutions.net>  <loom.20110428T135917-421@post.gmane.org>  (sfid-20110428_141415_832084_99A2E356) <1303995368.3558.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Well. You need to consider more than just this. I have a feeling you're
> only considering fixed channel use cases. But if we configure HT40+, and
> then find a peer on a channel that may only use HT40-, then what?

Good point. But still i think this is the same case. Right now, the card would
still be set into HT40+, regardless of the frequency. Then, minstrel_ht would
just use HT20, i suppose.

My proposal would be making the HT iw argument non-advisory: Use it when
creating a network, discard it when joining one.

I also will do some refactoring in nl80211.c in order to check main and
extension channel.

