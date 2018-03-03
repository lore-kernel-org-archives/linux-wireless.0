Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skyhawk.myhost.co.nz ([120.138.17.237]:60804 "EHLO
        skyhawk.myhost.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbeCCECC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 23:02:02 -0500
Subject: Re: [PATCH] Revert "mac80211: use QoS NDP for AP probing"
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180225211541.29931-1-ben@transient.nz>
 <1519725888.4086.3.camel@sipsolutions.net>
From: Ben Caradoc-Davies <ben@transient.nz>
Message-ID: <6110331d-bf2b-8aa5-29b9-ef29074f43ed@transient.nz> (sfid-20180303_050208_976416_F3B28CDE)
Date: Sat, 3 Mar 2018 17:01:54 +1300
MIME-Version: 1.0
In-Reply-To: <1519725888.4086.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/02/18 23:04, Johannes Berg wrote:
> Perhaps we can set some sort of flag in the driver that says "don't use
> QoS" frames. In fact, ath9k already says it doesn't like QoS frames:
> -		skb = ieee80211_nullfunc_get(sc->hw, vif, false);
> so which place creates them?

Thy only place I see QoS frames created is net/mac80211/mlme.c:899 on 
master, in ieee80211_send_nullfunc, where the "true" flag was added by 
commit 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing"):

skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif, true);

This enables QoS for any driver, including those that do not like QoS 
frames. I guess this gets called in response to a beacon, which would 
explain the intermittent nature of the failure.

Kind regards,


-- 
Ben Caradoc-Davies <ben@transient.nz>
Director
Transient Software Limited <https://transient.nz/>
New Zealand
