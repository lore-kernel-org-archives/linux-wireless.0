Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from straum.hexapodia.org ([66.109.99.53]:44430 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747Ab3GaPJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 11:09:44 -0400
Date: Wed, 31 Jul 2013 08:09:44 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3.11] mac80211: ignore HT primary channel while
 connected
Message-ID: <20130731150944.GA31411@hexapodia.org> (sfid-20130731_170955_012397_54FD5EBD)
References: <1375264234-31077-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375264234-31077-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 31, 2013 at 11:50:34AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> While we're connected, the AP shouldn't change the primary channel
> in the HT information. We checked this, and dropped the connection
> if it did change it.
> 
> Unfortunately, this is causing problems on some APs, e.g. on the
> Netgear WRT610NL: the beacons seem to always contain a bad channel
> and if we made a connection using a probe response (correct data)
> we drop the connection immediately and can basically not connect
> properly at all.
> 
> Work around this by ignoring the HT primary channel information in
> beacons if we're already connected.
> 
> Also print out more verbose messages in the other situations to
> help diagnose similar bugs quicker in the future.
> 
> Cc: stable@vger.kernel.org [3.10]

Acked-by: Andy Isaacson <adi@hexapodia.org>

LGTM.  Wasn't able to test though.  Recommend this for -stable,
regressing wifi connectivity makes it hard to report bugs.

-andy
