Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2LTLap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:30:45 -0500
Message-ID: <1356003035.10029.6.camel@jlt4.sipsolutions.net> (sfid-20121220_123047_691855_E9BBE167)
Subject: Re: [PATCH] mac80211: fix dtim_period in hidden SSID AP association
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 20 Dec 2012 12:30:35 +0100
In-Reply-To: <1355253502-23159-1-git-send-email-johannes@sipsolutions.net> (sfid-20121211_201803_393036_58A29981)
References: <1355253502-23159-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121211_201803_393036_58A29981)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 20:18 +0100, Johannes Berg wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> When AP's SSID is hidden the BSS can appear several times in
> cfg80211's BSS list: once with a zero-length SSID that comes
> from the beacon, and once for each SSID from probe reponses.
> 
> Since the mac80211 stores its data in ieee80211_bss which
> is embedded into cfg80211_bss, mac80211's data will be
> duplicated too.
> 
> This becomes a problem when a driver needs the dtim_period
> since this data exists only in the beacon's instance in
> cfg80211 bss table which isn't the instance that is used
> when associating.
> 
> Remove the DTIM period from the BSS table and track it
> explicitly to avoid this problem.

Applied.

johannes

