Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3KMV3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 16:29:40 -0500
Message-ID: <1384378173.28806.22.camel@jlt4.sipsolutions.net> (sfid-20131113_222942_988726_50AF2AF0)
Subject: Re: [RFC 5/5] cfg80211: DFS check dfs_region before usage
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 22:29:33 +0100
In-Reply-To: <1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191316_346113_52F94214)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131113_191316_346113_52F94214)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> Check the DFS region before channel availability check
> or declaring a channel as DFS usable.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---
>  net/wireless/chan.c    | 8 ++++++++
>  net/wireless/nl80211.c | 5 +++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 78559b5..4e6eaa0 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -517,10 +517,18 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>  	struct ieee80211_sta_ht_cap *ht_cap;
>  	struct ieee80211_sta_vht_cap *vht_cap;
>  	u32 width, control_freq;
> +	enum nl80211_dfs_regions dfs_region;
>  
>  	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
>  		return false;
>  
> +	rtnl_lock();
> +	dfs_region = reg_get_dfs_region(wiphy);
> +	rtnl_unlock();

This I'm fairly sure will just deadlock.

Anyway, this and patch 4 together can be done MUCH simpler by just
having the driver advertise the bitmap of what it supports before
registration, and then not using it if CERTIFICATION_ONUS isn't enabled
or something.

johannes

