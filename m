Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51434 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728669AbeHOL4x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 07:56:53 -0400
Message-ID: <1534323867.3547.30.camel@sipsolutions.net> (sfid-20180815_110537_286861_231C564C)
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Aug 2018 11:04:27 +0200
In-Reply-To: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 17:30 -0700, Pradeep Kumar Chitrapu wrote:
> Currently ftm_responder parameter in hostapd.conf is only used for fine
> timing measurement (FTM) capability advertisement and actual control of
> the functionality is with low-level device/driver. This leads to confusion
> to the user when the capability advertisement is different from actual FTM
> responder functionality.
> 
> For example, FTM responder capability advertisement is set to 'disabled',
> which would imply that AP must not respond to FTM requests, but user sees
> AP still responding to FTM requests, as the functionality is enabled in
> the driver.

All you describe above is really a driver bug - it shouldn't have
enabled it to start with?

> The patch set allows userspace to configure FTM responder functionality
> with the addition of new Netlink attribute NL80211_ATTR_FTM_RESPONDER
> and also adds extended feature flag for the drivers to advertise the
> support. Sending '0' to disable FTM responder would imply AP does not
> respond to FTM requests and sending '1' to enable FTM responder would
> imply that AP responds to all FTM requests.

This makes sense anyway. Funny you should post this within hours of me
doing the same, basically.

I have no objection to your approach, though I guess it'd be nice if you
could take a look at the statistics I have exposed and see if those
makes sense or if additional ones are desirable for you, and then we can
combine the work that way, i.e. have your configuration and our stats?

johannes
