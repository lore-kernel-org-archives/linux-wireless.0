Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:53557 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaAXKYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 05:24:06 -0500
Message-ID: <1390559042.19968.74.camel@porter.coelho.fi> (sfid-20140124_112410_898832_F2B10790)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute
 confusion
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Raja Mani <rmani@qti.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Date: Fri, 24 Jan 2014 12:24:02 +0200
In-Reply-To: <1390557711-11596-1-git-send-email-johannes@sipsolutions.net>
References: <1390557711-11596-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 11:01 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The scheduled scan matchsets were intended to be a list of filters,
> with the found BSS having to pass at least one of them to be passed
> to the host. When the RSSI attribute was added, however, this was
> broken and currently wpa_supplicant adds that attribute in its own
> matchset; however, it doesn't intend that to mean that anything
> that passes the RSSI filter should be passed to the host, instead
> it wants it to mean that everything needs to also have higher RSSI.
> 
> This is semantically problematic because we have a list of filters
> like [ SSID1, SSID2, SSID3, RSSI ] with no real indication which
> one should be OR'ed and which one AND'ed.
> 
> To fix this, move the RSSI filter attribute into each matchset. As
> we need to stay backward compatible, treat a matchset with only the
> RSSI attribute as a "default RSSI filter" for all other matchsets.
> 
> To make driver implementation easier, keep a global min_rssi_thold
> for the entire request as well. The only affected driver is ath6kl.
> 
> I found this when I looked into the code after Raja Mani submitted
> a patch fixing the n_match_sets calculation to disregard the RSSI,
> but that patch didn't address the semantic issue.
> 
> Reported-by: Raja Mani <rmani@qti.qualcomm.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

This looks reasonable to me.

Acked-by: Luciano Coelho <luciano.coelho@intel.com>

--
Luca.

