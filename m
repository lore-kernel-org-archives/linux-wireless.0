Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43996 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932467AbcK1OwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:52:25 -0500
Message-ID: <1480344742.8107.63.camel@sipsolutions.net> (sfid-20161128_155230_215996_5C772D67)
Subject: Re: cfg80211: add set/get link loss profile
From: Johannes Berg <johannes@sipsolutions.net>
To: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 28 Nov 2016 15:52:22 +0100
In-Reply-To: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Introduce NL80211_CMD_SET_LINK_LOSS_PROFILE and
> NL80211_CMD_GET_LINK_LOSS_PROFILE as it required by the user space
> to configure the link loss profile.

I'm not convinced.

> The link loss profile represents the priority of maintaining link up
> in different link quality environments.
> Three types of behavior for link loss defined:
> LINK_LOSS_PROFILE_RELAXED: prefer maintaining link up even in poor
> link quality environment.
> LINK_LOSS_PROFILE_DEFAULT: The default behavior for maintaining link
> up vs link quality.
> LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link up in poor link
> quality environment.

What you're doing here is *extremely* vague. No definitions of what
this means, no description of how it's intended to be implemented, no
note even on whether or not this is for full-MAC chips or not, etc.

At least for mac80211, we can define signals to userspace regarding
"link quality" and make decisions in wpa_s then?


> --- a/drivers/net/wireless/ath/wil6210/cfg80211.c

Those changes obviously don't belong into this patch anyway.

johannes
