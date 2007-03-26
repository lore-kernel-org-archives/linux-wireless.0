Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53635 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964785AbXCZJyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 05:54:15 -0400
Date: Mon, 26 Mar 2007 11:54:12 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
Message-ID: <20070326115412.2786c8f4@griffin.suse.cz>
In-Reply-To: <20070325231817.9C5887B409F@zog.reactivated.net>
References: <20070325231817.9C5887B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[removing netdev]

On Mon, 26 Mar 2007 00:18:17 +0100 (BST), Daniel Drake wrote:
> The ZD1211 supports the delivery of packets with a wrong CRC value
> to the host. We switched that feature on in monitor mode, so that
> incomplete packets were delivered.
> 
> This problem has been reported to bugzilla.kernel.org as bug 8152.
> This patch fixes it for the mac80211 stack.

ACK.

But this feature of zd1211 looks interesting. Johannes, shouldn't we
add a parameter to cfg80211 allowing such packets to be received by
monitor iterfaces?

Daniel, does zd1211 send information about failed CRC check with the
packet? Or do we need to recheck CRC in the stack if the feature
mentioned above is implemented and there are both regular and monitor
interface operating?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
