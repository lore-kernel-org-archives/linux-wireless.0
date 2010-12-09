Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0LIVVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 16:21:35 -0500
Subject: Re: [PATCH RFC] mac80211 default tx_last_beacon false (congestion)
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Harvey <harvey.tim@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291929345-8066-1-git-send-email-harvey.tim@gmail.com>
References: <1291929345-8066-1-git-send-email-harvey.tim@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 22:21:34 +0100
Message-ID: <1291929694.3540.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 13:15 -0800, Tim Harvey wrote:
> The 802.11 spec states that the STA that generated the last Beacon frame shall
> be the STA that response to a probe request.  This is important for congestion
> reduction when a probe request is received - only 1 node in an adhoc BSS
> will transmit a response.  While mac80211 drivers should provide the
> tx_last_beacon function to report if they transmitted the last beacon many
> do not.  As an attempt to reduce probe response congestion default this
> to 0 such that a node not implementing this capability does not contribute
> to unnecessary congestion.
> 
> In a modern medium sized office environment I see upwards of 100 probe
> requests per second received at a given node from various hardware/OS/drivers
> doing zeroconf 'active probing' as opposed to passively listening for beacons.
> With a modest 10-node adhoc network consisting of drivers that do not implement
> this tx_last_beacon feature, I have seen this result in the simultaneous xmit
> of probe responses accumulating to 500 probe responses per second because of
> collisions which brings the adhoc network to its knees as well as causes
> needless congestion.

FWIW, I'm OK with this. It shouldn't really have much adverse effect.

johannes

