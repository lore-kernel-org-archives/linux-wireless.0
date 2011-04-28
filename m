Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56055 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab1D1MOM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 08:14:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QFQ6l-0003vk-2g
	for linux-wireless@vger.kernel.org; Thu, 28 Apr 2011 14:14:11 +0200
Received: from dslb-084-059-209-058.pools.arcor-ip.net ([84.59.209.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 14:14:11 +0200
Received: from alexander.simon by dslb-084-059-209-058.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 14:14:11 +0200
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
Date: Thu, 28 Apr 2011 12:13:55 +0000 (UTC)
Message-ID: <loom.20110428T135917-421@post.gmane.org> (sfid-20110428_141415_832084_99A2E356)
References: <1302604964.2139.5.camel@alex-2>  <loom.20110412T130620-109@post.gmane.org> <1302607159.3639.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Also what if the IBSS is created with HT40+ and then joins, can it join
> HT40-? Is the channel type "advisory" like the frequency? Can it join
> HT20 IBSS as well?
HT type can`t be advisory, as there may be stations without n.

Our card is set to HT40+/- if set by iw.
Some other station is added into our internal station list by its HT beacons.
E.g. if we have configured HT40- and there is someone with HT40+, minstrel_ht
should use HT20 only. But i admit it seems cleaner to AND both caps.

