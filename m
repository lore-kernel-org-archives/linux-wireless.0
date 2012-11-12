Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:54106 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab2KLLRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 06:17:37 -0500
Date: Mon, 12 Nov 2012 13:17:19 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH v2] nl/cfg80211: advertise OBSS scan offload capability
Message-ID: <20121112111719.GA6079@w1.fi> (sfid-20121112_121741_526447_DFDB16FD)
References: <1352512290-7316-1-git-send-email-bzhao@marvell.com>
 <1352712697.9525.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352712697.9525.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 10:31:37AM +0100, Johannes Berg wrote:
> On Fri, 2012-11-09 at 17:51 -0800, Bing Zhao wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> > 
> > wpa_supplicant will do OBSS scan for drivers that implement
> > auth/assoc API. Drivers that implement nl80211 connect API
> > (rather than auth/assoc) may need wpa_supplicant to do this
> > as well.

> Applied, but I changed a lot ;-)
> 
> Notably, I reworded the constant name to be
> NL80211_FEATURE_NEED_OBSS_SCAN, since we typically use the term
> "offload" to mean that the *device* does something, not to mean that
> *userspace* does something.

Sorry for being a bit late with my comments, but does this single flag
really cover expected use cases? I would assume that number of more full
MAC -like designs will have to move to separate auth/assoc commands
instead of using connect API in the future (e.g., for FT and SAE).
However, those drivers do not necessarily expect user space to take care
of OBSS scans. I understand that this is not currently supported since
wpa_supplicant assuming auth/assoc to mean user space SME, but it should
be kept in mind that that may need to change in the future..

I guess we can handle the auth/assoc without user space OBSS scan
separately (a new feature flag for stopping OBSS scan?), so I'm fine
with this patch moving ahead as-is.

-- 
Jouni Malinen                                            PGP id EFC895FA
