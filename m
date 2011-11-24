Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1KXS3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:29:07 -0500
Subject: Re: [RFC v2 5/8] mac80211: setting link-specific mesh power modes
 when plink opens
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
In-Reply-To: <1321886416-12597-6-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154155_732897_648C5C05)
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	 <1321886416-12597-6-git-send-email-ivan.bezyazychnyy@gmail.com>
	 (sfid-20111121_154155_732897_648C5C05)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:29:04 +0100
Message-ID: <1322159344.5366.34.camel@jlt3.sipsolutions.net> (sfid-20111124_192911_934984_B5C6EE54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 18:40 +0400, Ivan Bezyazychnyy wrote:

> +static inline bool ieee80211s_has_capab_pm(__le16 capab_info)
> +{
> +	return (capab_info & MESHCONF_CAPAB_POWER_SAVE_LEVEL) != 0;
> +}

To me it look like sparse will warn here.

> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -248,6 +248,8 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
>  {
>  	struct ieee80211_local *local = sdata->local;
>  	struct sta_info *sta;
> +	struct ieee80211_mgmt *mgmt = container_of(hw_addr,
> +					struct ieee80211_mgmt, sa[0]);

You've got to be kidding! Change the prototypes accordingly if you need
more stuff.
 
johannes

