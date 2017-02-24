Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42406 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdBXGiA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 01:38:00 -0500
Message-ID: <1487918278.2540.3.camel@sipsolutions.net> (sfid-20170224_073811_907659_4A27C74F)
Subject: Re: [PATCH 101/306] mac80211-hwsim: Pass rate-ctrl flags and
 tx-power to user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 07:37:58 +0100
In-Reply-To: <1487896109-23851-3-git-send-email-greearb@candelatech.com> (sfid-20170224_012922_365111_F1EE0FCA)
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487896109-23851-3-git-send-email-greearb@candelatech.com>
         (sfid-20170224_012922_365111_F1EE0FCA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +/* Auxilary info to allow user-space to better understand the rate
> */
> +struct hwsim_tx_rate2 {
> +	u16 rc_flags; /* rate-ctrl flags (see
> mac80211_rate_control_flags) */
> +	s16 power_level;
> +} __packed;

Nope, not going to happen - I'm not tying the user-space visible API to
the mac80211 internals that directly.

johannes
