Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726208AbeIDPIY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 11:08:24 -0400
Message-ID: <7fe496c005939f8b649311fbff07931568521fe7.camel@coelho.fi> (sfid-20180904_124355_711638_51ADF3EE)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>
Date: Tue, 04 Sep 2018 13:43:44 +0300
In-Reply-To: <1535964968.3437.20.camel@sipsolutions.net>
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-13-luca@coelho.fi>
         (sfid-20180831_105558_739876_7BB84AB1) <1535964968.3437.20.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 12/28] cfg80211: add he_capabilities (ext) IE to AP
 settings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-03 at 10:56 +0200, Johannes Berg wrote:
> On Fri, 2018-08-31 at 11:31 +0300, Luca Coelho wrote:
> > 
> > +	cap = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ies,
> > ies_len);
> > +	if (cap && cap[1] >= sizeof(*params->he_cap) + 1)
> > +		params->he_cap = (void *)(cap + 3);
> 
> I think this should validate that the element is actually well-formed
> before passing it to the driver. To do this, need to refactor the
> size
> checks from ieee80211_he_cap_ie_to_sta_he_cap().

We don't currently check any of the other IEs we use in this function. 
Do you mean that this is relevant only for HE?

I can spin the size checks off from mac80211 so it can be reused here,
but maybe that should be in a separate patch?

--
Cheers,
Luca.
