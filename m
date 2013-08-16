Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3HPK6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 06:58:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VAHjo-00054H-TC
	for linux-wireless@vger.kernel.org; Fri, 16 Aug 2013 12:58:37 +0200
Message-ID: <1376650714.15299.17.camel@jlt4.sipsolutions.net> (sfid-20130816_125841_740266_288F2B69)
Subject: Re: [PATCH] mac80211: add APIs to allow keeping connections after
 WoWLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 12:58:34 +0200
In-Reply-To: <1376309240-2485-1-git-send-email-johannes@sipsolutions.net> (sfid-20130812_140728_802101_934A3D7D)
References: <1376309240-2485-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130812_140728_802101_934A3D7D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-12 at 14:07 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In order to be able to (securely) keep connections alive after
> the system was suspended for WoWLAN, we need some additional
> APIs. We already have API (ieee80211_gtk_rekey_notify) to tell
> wpa_supplicant about the new replay counter if GTK rekeying
> was done by the device while the host was asleep, but that's
> not sufficient.
> 
> If GTK rekeying wasn't done, we need to tell the host about
> sequence counters for the GTK (and PTK regardless of rekeying)
> that was used while asleep, add ieee80211_set_key_rx_seq() for
> that.
> 
> If GTK rekeying was done, then we need to be able to disable
> the old keys (with ieee80211_remove_key()) and allocate the
> new GTK key(s) in mac80211 (with ieee80211_gtk_rekey_add()).
> 
> If protocol offload (e.g. ARP) is implemented, then also the
> TX sequence counter for the PTK must be updated, using the new
> ieee80211_set_key_tx_seq() function.

Applied.

johannes

