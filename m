Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41554 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaBFQJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 11:09:55 -0500
Message-ID: <52F3B3D1.8050807@openwrt.org> (sfid-20140206_171000_437555_4D94073B)
Date: Thu, 06 Feb 2014 17:09:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] mac80211: add NAPI support back
References: <1391637437-5381-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1391637437-5381-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-05 22:57, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> NAPI was originally added to mac80211 a long time ago (by John in
> commit 4e6cbfd09c66 in July 2010), but then removed years later
> (by Stanislaw in commit 30c97120c6c7 in February 2013). No driver
> ever used it, so that was fine.
> 
> Now I'm adding support for NAPI to our driver, so add some code
> to mac80211 again  to support NAPI. John was originally wrapping
> some (but not nearly all NAPI-related functions), but that doesn't
> scale very well with the number of functions there there are, some
> of which are even only inlines. Thus, instead of doing that, let
> the drivers manage the NAPI struct, except for napi_add() which is
> needed so mac80211 knows how to call napi_gro_receive().
Why do you call napi_gro_receive at all?
Without device GRO support it seems to be just a fancy way of doing
netif_receive_skb with a bit more unnecessary indirection.

- Felix
