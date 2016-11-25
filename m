Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60620 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750787AbcKYI0M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 03:26:12 -0500
Message-ID: <1480062330.4317.2.camel@sipsolutions.net> (sfid-20161125_092617_738163_E9593B0D)
Subject: Re: [PATCH] nl80211: provide minimum scheduled scan (plan) interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 25 Nov 2016 09:25:30 +0100
In-Reply-To: <5c249c34-5e8c-093a-c5df-3507cabc8872@broadcom.com> (sfid-20161122_210634_601031_8D67F631)
References: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
         <1479821915.9021.4.camel@sipsolutions.net>
         <5c249c34-5e8c-093a-c5df-3507cabc8872@broadcom.com>
         (sfid-20161122_210634_601031_8D67F631)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, forgot to reply to this until Luca's email bumped it up...

On Tue, 2016-11-22 at 21:06 +0100, Arend Van Spriel wrote:

> Are we? Currently, the minimum is not checked in nl80211, but that
> does not say anything about the driver which might validate the
> interval as well and return an error.

Well, since drivers currently don't return an error (even if they
ignore the value!) that *does* change the API.

> What made me start looking at this is that in brcmfmac the interval
> in the request was ignored and a fixed interval was provisioned in
> the device. I wanted to fix that but was not sure if I needed to
> check it against our firmware min..max range and what the appropriate
> error handling should be. If silently changing what user-space is
> requesting is fine for this, I am happy to make it so. Preferably in
> nl80211.

I think (agreeing with Luca) bumping it up is fine.

johannes
