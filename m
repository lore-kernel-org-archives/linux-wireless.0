Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33342 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbeAOIPr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 03:15:47 -0500
Message-ID: <1516004144.410.0.camel@sipsolutions.net> (sfid-20180115_091601_164667_FA5F15D1)
Subject: Re: [PATCH v3] nl80211: take RCU read lock when calling
 ieee80211_bss_get_ie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: regressions@leemhuis.info, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Jan 2018 09:15:44 +0100
In-Reply-To: <20180115071215.GA2639@light.dominikbrodowski.net>
References: <20171222072012.GA3110@light.dominikbrodowski.net>
         <20171230131132.GA2624@light.dominikbrodowski.net>
         <20180108100403.GA4715@light.dominikbrodowski.net>
         <20180114180338.GA1569@light.dominikbrodowski.net>
         <1515967102.26804.31.camel@sipsolutions.net>
         <20180114222255.GA9036@light.dominikbrodowski.net>
         <1515969647.26804.33.camel@sipsolutions.net>
         <20180115071215.GA2639@light.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-15 at 08:12 +0100, Dominik Brodowski wrote:
> As ieee80211_bss_get_ie() derefences an RCU to return ssid_ie, both
> the call to this function and any operation on this variable need
> protection by the RCU read lock.
> 
> Fixes: 44905265bc15 ("nl80211: don't expose wdev->ssid for most interfaces")
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
> 
> > but after, perhaps it's easier to just do
> > 
> > 		if (ssid_ie &&
> > 		    nla_put(...)
> > 			goto nla_put_failure_rcu_locked;
> > 
> > and avoid the extra label (but yeah, it's getting late)
> 
> OK, done that (and updated the commit message), and testet it.
> 

Applied, thanks!

johannes
