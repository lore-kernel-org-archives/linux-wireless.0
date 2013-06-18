Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3FRP05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:26:57 -0400
Message-ID: <1371569205.8318.47.camel@jlt4.sipsolutions.net> (sfid-20130618_172700_083727_B0E6F6D0)
Subject: Re: [RFC 2/2] mac80211:  Fix bss ref leak.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Jun 2013 17:26:45 +0200
In-Reply-To: <1371504746-8476-2-git-send-email-greearb@candelatech.com> (sfid-20130617_233256_432869_08F1495E)
References: <1371504746-8476-1-git-send-email-greearb@candelatech.com>
	 <1371504746-8476-2-git-send-email-greearb@candelatech.com>
	 (sfid-20130617_233256_432869_08F1495E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-17 at 14:32 -0700, greearb@candelatech.com wrote:

>  static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
> -					 bool assoc)
> +					 bool assoc, bool put_bss)

Do we _really_ need another argument? Shouldn't it always be put in the
non-assoc case anyway, at least if non-NULL?

> @@ -2415,6 +2415,10 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
>  		ieee80211_vif_release_channel(sdata);
>  	}
>  
> +	if (put_bss)
> +		cfg80211_put_bss(sdata->local->hw.wiphy, assoc_data->bss);
> +
> +

just one blank line

> +	/** bss will be passed back to calling code, and that code must
> +	 * deal with properly putting the reference.
> +	 */

/** is for kernel-doc only

>  	return RX_MGMT_CFG80211_RX_ASSOC;

You're working on some pretty old code here ... If you want this to be
in stable the patch really needs to be smaller, I think. And for
mac80211-next this can't apply.

johannes

