Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:46602 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab1GYT6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 15:58:02 -0400
Date: Mon, 25 Jul 2011 22:57:47 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: be more careful in suspend/resume
Message-ID: <20110725195747.GA24331@jm.kir.nu> (sfid-20110725_215805_633081_B516E08C)
References: <1310653466.3874.23.camel@jlt3.sipsolutions.net>
 <1310654934.3874.25.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310654934.3874.25.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 04:48:54PM +0200, Johannes Berg wrote:
> When suspending with all netdevs down, the device
> is stopped but we still call a number of driver
> callbacks that the driver might not expect. The
> same happens during resume, we might call a few
> callbacks without starting the driver. Fix this
> by checking open_count around more things and
> exiting quickly if it is 0.
> 
> Also, while at this I noticed that the coverage
> class isn't reprogrammed after resume, so add
> that.

Hmm.. This patch seems to pretty much kill P2P at least with hwsim. Many
of the EAPOL frames seem to be dropped at some point and the end result
of this is in the WPS provisioning taking 10 seconds (two 5 second
timeouts from the authenticator due to EAPOL frames dropped). This by
itself may not be enough to hit the group formation timeout, but similar
issue in 4-way handshake makes the authenticator miss msg 4/4 and hit
the state mismatch with supplicant having configured the PTK and
authenticator not..

I'm not yet sure what exactly is causing the issue, but this commit came
up in git bisect and reverting it from the current wireless-testing.git
made P2P work again in hwsim.

-- 
Jouni Malinen                                            PGP id EFC895FA
