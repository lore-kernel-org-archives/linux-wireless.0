Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52171 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3KMVj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 16:39:56 -0500
Message-ID: <1384378761.16343.11.camel@porter.coelho.fi> (sfid-20131113_224000_656900_F17CC7BD)
Subject: Re: [PATCH v4 3/5] mac80211: refactor
 ieee80211_mesh_process_chanswitch()
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: sw@simonwunderlich.de, johannes@sipsolutions.net,
	yeohchunyeow@gmail.com, yeohchunyeow@cozybit.com
Date: Wed, 13 Nov 2013 23:39:21 +0200
In-Reply-To: <1384364851-31805-3-git-send-email-luciano.coelho@intel.com>
References: <1384364851-31805-1-git-send-email-luciano.coelho@intel.com>
	 <1384364851-31805-3-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 19:47 +0200, Luciano Coelho wrote:
> Refactor ieee80211_mesh_process_chanswitch() to use
> ieee80211_channel_switch() and avoid code duplication.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---

[...]

> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index f4af05d..bba7897 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -612,6 +612,7 @@ struct ieee80211_if_mesh {
>  	/* Channel Switching Support */
>  	struct mesh_csa_settings __rcu *csa;
>  	bool chsw_init;
> +	bool csa_repeater;

These two booleans are mutually exclusive, so they should probably be
combined in an enumeration to avoid confusion.

I'll send v5 with this change.

--
Cheers,
Luca.

