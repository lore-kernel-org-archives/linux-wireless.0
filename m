Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40799 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAQBvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 20:51:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21689.49345.803049.938915@gargle.gargle.HOWL> (sfid-20150117_025143_179879_AD06FD81)
Date: Sat, 17 Jan 2015 07:24:09 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC 2/2] mac80211: support RX rate statistics
In-Reply-To: <1421401708-8123-2-git-send-email-johannes@sipsolutions.net>
References: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
	<1421401708-8123-2-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add support for RX rate statistics to mac80211. This tracks the number
> of MSDUs received per rate, if rate statistics are enabled.
> 
> As the number of rates is very high (as explained in the commit log of
> the cfg80211 patch) mac80211 tracks at most 36 different rates at once.
> This is done with a very simple hash table format (3 * index) array to
> track three different NSS/SGI/bw combinations, plus a few more entries
> acting as "escape" when all three different combinations are filled.
> 
> Counters are limited to 16-bit to reduce memory consumption and when a
> limit of 64000 is reached the process to send them out to userspace is
> scheduled. The same happens when the escape entries need to be used.
> 
> The data structure itself is stored for each station, accessible under
> RCU, and sending them to userspace is combined with freeing so that no
> RCU-accessor (really only the synchronized RX path anyway though) can
> still see them when they're transmitted out. This ensures a consistent
> view is transmitted right before being discarded; it also ensures that
> the RX path isn't blocked by any configuration paths for this.
> 
> Note that TX statistics (tx, retries, failures) aren't covered. Those
> need tighter integration with the driver or rate scaling as not all
> drivers are able to fully encode the necessary information in the TX
> status data due to the size limit there.

Nice. :)

We were doing simple RX statistics collection inside ath9k
(CONFIG_ATH9K_STATION_STATISTICS), which can be removed once this goes
in. Is there any way a driver can pass custom data, like per-frame
antenna details ?

Sujith
