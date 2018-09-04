Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53366 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbeIDP2M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 11:28:12 -0400
Message-ID: <1536059005.3940.8.camel@sipsolutions.net> (sfid-20180904_130337_667610_5259DD42)
Subject: Re: [PATCH 12/28] cfg80211: add he_capabilities (ext) IE to AP
 settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>
Date: Tue, 04 Sep 2018 13:03:25 +0200
In-Reply-To: <7fe496c005939f8b649311fbff07931568521fe7.camel@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-13-luca@coelho.fi>
         (sfid-20180831_105558_739876_7BB84AB1) <1535964968.3437.20.camel@sipsolutions.net>
         <7fe496c005939f8b649311fbff07931568521fe7.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-04 at 13:43 +0300, Luca Coelho wrote:
> On Mon, 2018-09-03 at 10:56 +0200, Johannes Berg wrote:
> > On Fri, 2018-08-31 at 11:31 +0300, Luca Coelho wrote:
> > > 
> > > +	cap = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ies,
> > > ies_len);
> > > +	if (cap && cap[1] >= sizeof(*params->he_cap) + 1)
> > > +		params->he_cap = (void *)(cap + 3);
> > 
> > I think this should validate that the element is actually well-formed
> > before passing it to the driver. To do this, need to refactor the
> > size
> > checks from ieee80211_he_cap_ie_to_sta_he_cap().
> 
> We don't currently check any of the other IEs we use in this function. 
> Do you mean that this is relevant only for HE?

We do check all the other IEs, e.g.

        cap = cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY, ies, ies_len);
        if (cap && cap[1] >= sizeof(*params->vht_cap))
                params->vht_cap = (void *)(cap + 2);

Only HE has the variable-size thing where this isn't sufficient for a
proper size check.

> I can spin the size checks off from mac80211 so it can be reused here,
> but maybe that should be in a separate patch?

Sure, make it a separate patch and let it be before this one? :)

johannes
