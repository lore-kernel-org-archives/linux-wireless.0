Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59174 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbeICNxO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:53:14 -0400
Message-ID: <1535967225.3437.27.camel@sipsolutions.net> (sfid-20180903_113433_878460_E946C76F)
Subject: Re: [PATCH v2 2/3] mac80211: support FTM responder
 configuration/statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date: Mon, 03 Sep 2018 11:33:45 +0200
In-Reply-To: <1535745418-31336-3-git-send-email-pradeepc@codeaurora.org>
References: <1535745418-31336-1-git-send-email-pradeepc@codeaurora.org>
         <1535745418-31336-3-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-31 at 12:56 -0700, Pradeep Kumar Chitrapu wrote:
> 
> + * @ftm_responder: whether to enable fine timing measurement FTM functionality

missing "responder" somewhere there :)

> + * @ftmr_params: configurable lci/civic parameter when enabling FTM responder.

Perhaps the *existence* of ftmr_params could indicate that it's enabled?

> @@ -865,6 +899,20 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
>  	if (err == 0)
>  		changed |= BSS_CHANGED_AP_PROBE_RESP;
>  
> +	if (params->ftm_responder) {

Here you immediately have the problem I talked about in the earlier
patch ... yes, we don't have drivers that allow disabling it (so should
probably reject that now), but without it you can *enable* it on the
fly, but you cannot *disable*, in fact we assume saying "disable" means
"no change" which is rather confusing.

johannes
