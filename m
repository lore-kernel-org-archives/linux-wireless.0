Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42670 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752623AbdJ3IsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 04:48:23 -0400
Message-ID: <1509353300.2637.2.camel@sipsolutions.net> (sfid-20171030_094826_579518_15395D53)
Subject: Re: [PATCH 1/5] mac80211: always update the PM state of a peer on
 MGMT / DATA frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 30 Oct 2017 09:48:20 +0100
In-Reply-To: <20171029095111.17078-2-luca@coelho.fi>
References: <20171029095111.17078-1-luca@coelho.fi>
         <20171029095111.17078-2-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-10-29 at 11:51 +0200, Luca Coelho wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> The 2016 version of the spec is more generic about when the
> AP should update the power management state of the peer:
> the AP shall update the state based on any management or
> data frames. This means that even non-bufferable management
> frames should be looked at to update to maintain the power
> management state of the peer.
> 
> This can avoid problematic cases for example if a station
> disappears while being asleep and then re-appears. The AP
> would remember it as in power save, but the Authentication
> frame couldn't be used to set the peer as awake again.
> Note that this issues wasn't really critical since at some
> point (after the association) we would have removed the
> station and created another one with all the states cleared.

IIRC this caused a hwsim test failure - is that addressed yet?

johannes
