Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42428 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab3DBPvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 11:51:09 -0400
Message-ID: <515AFE62.1080300@candelatech.com> (sfid-20130402_175119_582480_6F2F2253)
Date: Tue, 02 Apr 2013 08:50:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC V3] cfg80211: introduce critical protocol indication from
 user-space
References: <1364911454-3651-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1364911454-3651-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2013 07:04 AM, Arend van Spriel wrote:
> Some protocols need a more reliable connection to complete
> successful in reasonable time. This patch adds a user-space
> API to indicate the wireless driver that a critical protocol
> is about to commence and when it is done, using nl80211 primitives
> NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.
>
> The driver can support this by implementing the cfg80211 callbacks
> .crit_proto_start() and .crit_proto_stop(). Examples of protocols
> that can benefit from this are DHCP, EAPOL, APIPA. Exactly how the
> link can/should be made more reliable is up to the driver. Things
> to consider are avoid scanning, no multi-channel operations, and
> alter coexistence schemes.
>
> Cc: Ben Greear <greearb@candelatech.com>
> Cc: Dan Williams <dcbw@redhat.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Here is version 3. I tried to deal with all the review comments
> I received, except for the one below:
>
> Ben Greear said: "
> Also, you would probably need to enforce in the kernel that only
> x out of y time in any given period can be locked, otherwise lots
> of different dhclient processes (perhaps erroneously spawned..or
> running on lots of different VIFs) could basically disable scanning
> or channel changes..."
>
> Not sure how or even if we should deal with this. Any thoughts?

I think you could treat the start-critical-section as requests that may be
silently (or otherwise) ignored by the driver.

At a minimum, you could keep a timestamp of the last 'stop' time, and
ignore any requests that come in too soon after that stop.

Or to be more clever, keep last 5 or so start/stop times and
make sure the system is on average available for non-critical
stuff at least XX% of the time.

I can imagine wanting to support this in ath9k (or mac80211)
with lots of virtual interfaces, and in this case we would
definitely need some constraints to keep the system from constantly
being in critical section.  I guess this could be a driver
issue, however...NICs that support only a single interface may
not care about this...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

