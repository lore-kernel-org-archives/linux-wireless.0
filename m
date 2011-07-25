Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:42394 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478Ab1GYUeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 16:34:18 -0400
Date: Mon, 25 Jul 2011 23:34:09 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: be more careful in suspend/resume
Message-ID: <20110725203409.GA11510@jm.kir.nu> (sfid-20110725_223421_422477_D90B93AB)
References: <1310653466.3874.23.camel@jlt3.sipsolutions.net>
 <1310654934.3874.25.camel@jlt3.sipsolutions.net>
 <20110725195747.GA24331@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110725195747.GA24331@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 25, 2011 at 10:57:47PM +0300, Jouni Malinen wrote:
> Hmm.. This patch seems to pretty much kill P2P at least with hwsim. Many
> of the EAPOL frames seem to be dropped at some point and the end result
> of this is in the WPS provisioning taking 10 seconds (two 5 second
> timeouts from the authenticator due to EAPOL frames dropped). This by
> itself may not be enough to hit the group formation timeout, but similar
> issue in 4-way handshake makes the authenticator miss msg 4/4 and hit
> the state mismatch with supplicant having configured the PTK and
> authenticator not..
> 
> I'm not yet sure what exactly is causing the issue, but this commit came
> up in git bisect and reverting it from the current wireless-testing.git
> made P2P work again in hwsim.

Actually, this does not make any sense.. Neither of the modified
functions are even called in my hwsim test. In addition, I can "fix" the
issue by adding a printk call into the beginning of (the not even
called) ieee80211_reconfig() function.

This sounds like some kind of build issue, but I've now reproduced this
issue multiple times and even after a full rebuild of the kernel to make
sure there are no build dependency issues etc. No idea what could be
causing this, but it looks very clear that some of the EAPOL frames get
dropped in some of the builds and just a single printk call seems to be
enough to move things enough to avoid this.. hwsim0 interface shows the
EAPOL frames, so they seem to be transmitted (or well, at least
mac80211_hwsim tries to transmit them), but the recipient does not
report them to wpa_supplicant (mac80211 dropping the frame?).

This is with x86_64 build and UML and on a new test host (i.e., new gcc
4.5.2-8ubuntu4 from Ubuntu 11.04), so my previous tests with hwsim may
have not had some odd issue that starts showing up now for whatever
reason.

-- 
Jouni Malinen                                            PGP id EFC895FA
