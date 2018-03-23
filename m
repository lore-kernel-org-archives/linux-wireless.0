Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44192 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbeCWIE4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 04:04:56 -0400
Message-ID: <1521792294.4175.10.camel@sipsolutions.net> (sfid-20180323_090501_462768_325133A8)
Subject: Re: [RFC v5 0/9] EAPoL over NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2018 09:04:54 +0100
In-Reply-To: <0603f0fc-8a89-6ef4-5e9a-1d59569efa44@gmail.com> (sfid-20180322_145452_867502_BC5BE8BD)
References: <20180313215942.29176-1-denkenz@gmail.com>
         <1521645199.2645.34.camel@sipsolutions.net>
         <6c4a389a-55e1-5af2-cac2-1754fce7fabf@gmail.com>
         <1521714493.19621.5.camel@sipsolutions.net>
         <0603f0fc-8a89-6ef4-5e9a-1d59569efa44@gmail.com>
         (sfid-20180322_145452_867502_BC5BE8BD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Okay, that makes things easier.  However, it does bring up a
> question. Should we be symmetric and remove AP_VLAN as a valid target
> of control  port frames?  E.g. drop NL80211_IFTYPE_AP_VLAN case in
> patch 2 of the  series.  In effect we'd require all control port
> frame traffic to go  over the master interface.

Yeah, I think that'd make sense.

> I'm the one confused now.  You wanted me to add IFTYPE_IBSS in 
> nl80211_tx_control_port in your earlier feedback :)

Hah. My memory is like a sieve...

> Let me try to restate what I said earlier in a different way and see
> if it makes things a bit clearer:
> 
> So in patch 9, we set sdata->control_port_over_nl80211 based on 
> parameters passed into start_ap or mgd_assoc.  The 
> control_port_over_nl80211 flag is passed in cfg80211_crypto_settings 
> structure that is part of the relevant parameters structure.  If 
> sdata->control_port_over_nl80211 is true, then we actually redirect
> the control port frames to nl80211.

Right.

> So my question is, if we want to support IBSS/MESH, should we:
> 1. add the whole cfg80211_crypto_settings to the IBSS/MESH
> parameters,
> 2. add the control_port_over_nl80211 flag directly to IBSS/MESH
> parameters
> 3. Pass the flag some other way?
> 4. Or drop IBSS/MESH from patch 2 (nl80211_tx_control_port)
> completely?

I'd say 2 or 4. Having all the crypto settings would be confusing,
since they aren't (and possibly cannot) be used.

4 is a bit annoying - not that I remember - because it eventually means
that when we do want to support it in IBSS/MESH, we'd have to add
another flag indicating that now it's supported, etc. But I think we
can live with that too, if it's too complex to add this for real.

johannes
