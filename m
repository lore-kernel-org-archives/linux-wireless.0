Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34944 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbeC2IfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:35:07 -0400
Message-ID: <1522312501.5932.0.camel@sipsolutions.net> (sfid-20180329_103510_784805_22456CFF)
Subject: Re: [PATCH v3 2/3] mac80211: limit wmm params to comply with ETSI
 requirements
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <peter.oh@bowerswilkins.com>, Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Mar 2018 10:35:01 +0200
In-Reply-To: <fc2a88ae-b908-028a-9e3b-1457404d2c06@bowerswilkins.com>
References: <20180328102411.25677-1-luca@coelho.fi>
         <20180328102411.25677-3-luca@coelho.fi>
         <fc2a88ae-b908-028a-9e3b-1457404d2c06@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 10:29 -0700, Peter Oh wrote:
> > +	if (sdata->vif.type == NL80211_IFTYPE_AP)
> > +		wmm_ac = &rrule->wmm_rule->ap[ac];
> > +	else
> > +		wmm_ac = &rrule->wmm_rule->client[ac];
> > +	qparam->cw_min = max_t(u16, qparam->cw_min, wmm_ac->cw_min);
> > +	qparam->cw_max = max_t(u16, qparam->cw_max, wmm_ac->cw_max);
> 
> not min_t() for cw_max?

No, the regulations say you have to use a long content window, hence
limiting both min and max at the lower end (hence max_t).

johannes
