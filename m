Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58042 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbbANIdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:33:24 -0500
Message-ID: <1421224392.1950.12.camel@sipsolutions.net> (sfid-20150114_093330_291524_C2F5B648)
Subject: Re: [PATCH *** REVIEW ME ***] mac80211: let flush() drop packets
 when possible [BUGFIX]
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Jan 2015 09:33:12 +0100
In-Reply-To: <1420638159-16779-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1420638159-16779-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 15:42 +0200, Emmanuel Grumbach wrote:
> When roaming / suspending, it makes no sense to wait until
> the transmit queues of the device are empty. In extreme
> condition they can be starved (VO saturating the air), but
> even in regular cases, it is pointless to delay the roaming
> because the low level driver is trying to send packets to
> an AP which is far away. We'd rather drop these packets and
> let TCP retransmit if needed. This will allow to speed up
> the roaming.
> 
> For suspend, the explanation is even more trivial.

Applied.

johannes

