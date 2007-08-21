Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:11526 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXHUVGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 17:06:46 -0400
Received: by nf-out-0910.google.com with SMTP id g13so975625nfb
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2007 14:06:44 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
Date: Tue, 21 Aug 2007 23:14:14 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070821161845.165557000@sipsolutions.net> <20070821161942.938977000@sipsolutions.net>
In-Reply-To: <20070821161942.938977000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708212314.15010.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 21 August 2007, Johannes Berg wrote:
> Drivers are currently supposed to keep track of monitor
> interfaces if they allow so-called "hard" monitor, and
> they are also supposed to keep track of multicast etc.
> 
> This patch changes that, replaces the set_multicast_list()
> callback with a new configure_filter() callback that takes
> filter flags (FIF_*) instead of interface flags (IFF_*).
> For a driver, this means it should open the filter as much
> as necessary to get all frames according to the filter flags.
> 
> Multicast filtering is a bit special, which is why drivers
> that do not require FIF_ALLMULTI for multicast address filters
> (i.e. they actually have filters for multicast addresses)
> need to set the new IEEE80211_HW_MULTICAST_FILTER flag and
> call the ieee80211_get_mc_list_item() function.
> 
> At the same time, drivers are no longer notified about
> monitor interfaces at all, this means they now need to
> implement the start() and stop() callbacks and the new
> change_filter_flags() callback. Also, the start()/stop()
> ordering changed, start() is now called *before* any
> add_interface() as it really should be, and stop() after
> any remove_interface().
> 
> The patch also changes the behaviour of setting the bssid
> to multicast for scanning when IEEE80211_HW_NO_PROBE_FILTERING
> is set; the IEEE80211_HW_NO_PROBE_FILTERING flag is removed
> and the filter flag FIF_BCN_PRBRESP_PROMISC introduced.
> This is a lot more efficient for hardware like b43 that
> supports it and other hardware can still set the BSSID
> to multicast.

Personally I like the idea of this packet filtering, implementation
and driver interface looks allright to me.

> WARNING: This patch makes the ralink drivers BUG_ON().

If you can give me a warning when you are going to submit this
for inclusion, I'll cook up a patch to make it work for rt2x00. :)

Ivo
