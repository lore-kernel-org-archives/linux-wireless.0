Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47985 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753085AbcJEKBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 06:01:21 -0400
Message-ID: <1475661677.4994.27.camel@sipsolutions.net> (sfid-20161005_120124_711448_0B8D4E82)
Subject: Re: [PATCH 2/3] mac80211: filter multicast data packets on AP /
 AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 05 Oct 2016 12:01:17 +0200
In-Reply-To: <1475643324-2845-2-git-send-email-michael-dev@fami-braun.de>
References: <1475643324-2845-1-git-send-email-michael-dev@fami-braun.de>
         <1475643324-2845-2-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please also add "v3" to the subject line, e.g. using --subject-prefix
'PATCH v3' when using git send-email.

> +static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
> +{
> +	// add num_mcast_sta_vlan using name num_mcast_sta

Please don't use // style comments.

> +static inline void
> +ieee80211_vif_inc_num_mcast(struct ieee80211_sub_if_data *sdata)
> +{
> +	if (sdata->vif.type != NL80211_IFTYPE_AP &&
> +	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
> +		return;

That's pointless, given this:

> +	if (sdata->vif.type == NL80211_IFTYPE_AP)
> +		atomic_inc(&sdata->u.ap.num_mcast_sta);
> +	else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
> +		atomic_inc(&sdata->u.vlan.num_mcast_sta);
> +}
> +
> +static inline void
> +ieee80211_vif_dec_num_mcast(struct ieee80211_sub_if_data *sdata)
> +{
> +	if (sdata->vif.type != NL80211_IFTYPE_AP &&
> +	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
> +		return;
> +
> +	if (sdata->vif.type == NL80211_IFTYPE_AP)
> +		atomic_dec(&sdata->u.ap.num_mcast_sta);
> +	else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
> +		atomic_dec(&sdata->u.vlan.num_mcast_sta);

Same here.

> +}
> +
> +/* This function returns the number of multicast stations connected
> to this
> + * interface. It returns -1 if that number is not tracked, that is
> for netdevs
> + * not in AP or AP_VLAN mode or when using 4addr. */
> +static inline int
> +ieee80211_vif_get_num_mcast_if(struct ieee80211_sub_if_data *sdata)
> +{
> +	if (sdata->vif.type == NL80211_IFTYPE_AP)
> +		return atomic_read(&sdata->u.ap.num_mcast_sta);
> +	else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> +		 !sdata->u.vlan.sta)
> +		return atomic_read(&sdata->u.vlan.num_mcast_sta);
> +	else
> +		return -1;

All the "else" branches are useless since you return immediately inside
each if.

> -       } else if (unlikely(tx->sdata->vif.type == NL80211_IFTYPE_AP &&
> -                           ieee80211_is_data(hdr->frame_control) &&
> -                           !atomic_read(&tx->sdata->u.ap.num_mcast_sta))) {
> +       } else if (unlikely(ieee80211_vif_get_num_mcast_if(tx->sdata) == 0 &&
> +                           ieee80211_is_data(hdr->frame_control))) {

any particular reason to invert the order of the checks? seems checking
for data first should be faster/cheaper from the cache, than accessing
the counters?

johannes
