Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48195 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbbCKQUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 12:20:25 -0400
Message-ID: <1426090817.1904.6.camel@sipsolutions.net> (sfid-20150311_172029_378469_1E4F30A0)
Subject: Re: Connection issues with BW Tracking in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 11 Mar 2015 17:20:17 +0100
In-Reply-To: <CABPxzYKa5eR+UrinkqY99jxOpVR4mTYcW_3xZ5f2kf9hXHCznA@mail.gmail.com> (sfid-20150311_171529_797404_ECB8E5E9)
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
	 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
	 <1424772587.2192.14.camel@sipsolutions.net>
	 <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
	 <1424774105.2192.29.camel@sipsolutions.net>
	 <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
	 <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com>
	 <1424810867.2192.60.camel@sipsolutions.net>
	 <CABPxzY+Z97Q4JSSaR2GfGnxbbR721qJ-v_AjG4Kc1TGetHF4ng@mail.gmail.com>
	 <1424851368.2050.8.camel@sipsolutions.net>
	 <CABPxzYKa5eR+UrinkqY99jxOpVR4mTYcW_3xZ5f2kf9hXHCznA@mail.gmail.com>
	 (sfid-20150311_171529_797404_ECB8E5E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 21:45 +0530, Krishna Chaitanya wrote:

> I did some experiments on this and found the root cause.
> 
> We are using 5GHz in WORLD Mode, so only passive scan is allowed.
> So when connecting the very first time, the mac80211 MLME sees that
> there are no probe_resp ies (only beacon_ies are present) and it sends
> a directed probe and updates the probe_resp ies. (and also the "ies").
> 
> But when config is changed and we get disconnected, beacon_ies are updated
> with the new config, but the probe_resp ies are not.
> cfg80211_bss_update assigns
> probe_resp ies to "ies' and mac80211 updates its bss info based on the
> probe_resp
> ies which have old config causing the issue.
> 
> Solution:
> 
> 1) Make the directed probe mandatory.
> 2) As you suggested maintain timestamps for probe_resp_ies and beacon_ies
> and use the latest.
> 
> Any takes?

What's the operational problem here? I don't really see it. Are you
afraid users will reconfigure their APs often enough for this to be an
issue?

johannes

