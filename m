Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab1LIEOE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 23:14:04 -0500
Subject: Re: [PATCH] iwlwifi regression in 20111205 merge
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Nikolay Martynov <mar.kolya@gmail.com>, linville@tuxdriver.com
Cc: "mar.kolya@gmail.com linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <1323399833.13074.80.camel@wwguy-huron>
References: <1323398619-19774-1-git-send-email-mar.kolya@gmail.com>
	 <1323399833.13074.80.camel@wwguy-huron>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 19:15:28 -0800
Message-ID: <1323400528.13074.87.camel@wwguy-huron> (sfid-20111209_051412_762507_53647091)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

what is the correct method to handle this case?
the patch need to add a piece of code in iwl-mac80211.c, and also need
to backport to stable
Since the function was recently move from iwl-agn.c to iwl-mac80211.c,
so separated patch need for "wireless-next" and "wireless". But look
like portion of patch just lost because the function was move.

Thanks
Wey

On Thu, 2011-12-08 at 19:03 -0800, Guy, Wey-Yi wrote:
> Hi Nikolay,
> 
> I believe I know what happen,
> 
> this change happen after the function being move from iwl-agn.c to
> iwl-mac80211.c
> 
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Dec 2 08:19:17 2011 -0800
> 
>     iwlagn: fix HW crypto for TX-only keys
>     
>     Group keys in IBSS or AP mode are not programmed
>     into the device since we give the key to it with
>     every TX packet. However, we do need mac80211 to
>     create the MMIC & PN in all cases. Move the code
>     around to set the key flags all the time. We set
>     them even when the key is removed again but that
>     is obviously harmless.
>     
>     Cc: stable@vger.kernel.org
>     Reported-by: Reinette Chatre <reinette.chatre@intel.com>
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> and the changes was made in iwl-mac80211.c
> 
> but since this patch need to be backport to stable kernel.
> so there is a separated patch sent for the changes in iwl-agn.c against
> stable
> 
> because all these, for some reason the changes just got lost.
> Thank you for catch this
> 
> Wey
> 
> 
> On Thu, 2011-12-08 at 18:43 -0800, Nikolay Martynov wrote:
> > It looks like the regression was introduced between 20111202 and
> > 20111205 (linux-next tree). Symptoms: connection to AP seem to be
> > established, but no data goes though it in any way. Tested on intel
> > 5300.
> >   Peek at the changes have shown that it looks like at least part of
> > the code wasn't merged properly. It was originally committed into
> > iwl_agn.c but code in question was moved to iwl-mac80211.c.
> >   This patch puts code in place and my card works again.
> >   I hope this patch will be reviewed by people developing iwl
> > driver. Also, it is possible that some other iwl code didn't make it
> > though 20111205 merge as well, so this probably should be checked too.
> >   Please let me know if I can provide any more info.
> >   Thanks!
> > 
> > Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-mac80211.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > index 794b735..55308b8 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > @@ -517,6 +517,17 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> >  		return -EOPNOTSUPP;
> >  	}
> >  
> > +	switch (key->cipher) {
> > +	case WLAN_CIPHER_SUITE_TKIP:
> > +		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
> > +		/* fall through */
> > +	case WLAN_CIPHER_SUITE_CCMP:
> > +		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> >  	/*
> >  	 * We could program these keys into the hardware as well, but we
> >  	 * don't expect much multicast traffic in IBSS and having keys
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


