Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2KLLmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 06:42:02 -0500
Message-ID: <1352720554.9525.19.camel@jlt4.sipsolutions.net> (sfid-20121112_124206_481839_A4EDCDCA)
Subject: Re: [PATCH v2] nl/cfg80211: advertise OBSS scan offload capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 12 Nov 2012 12:42:34 +0100
In-Reply-To: <20121112111719.GA6079@w1.fi>
References: <1352512290-7316-1-git-send-email-bzhao@marvell.com>
	 <1352712697.9525.4.camel@jlt4.sipsolutions.net>
	 <20121112111719.GA6079@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-12 at 13:17 +0200, Jouni Malinen wrote:

> Sorry for being a bit late with my comments, but does this single flag
> really cover expected use cases? I would assume that number of more full
> MAC -like designs will have to move to separate auth/assoc commands
> instead of using connect API in the future (e.g., for FT and SAE).
> However, those drivers do not necessarily expect user space to take care
> of OBSS scans. I understand that this is not currently supported since
> wpa_supplicant assuming auth/assoc to mean user space SME, but it should
> be kept in mind that that may need to change in the future..
> 
> I guess we can handle the auth/assoc without user space OBSS scan
> separately (a new feature flag for stopping OBSS scan?), so I'm fine
> with this patch moving ahead as-is.

Right, I don't see any other choice anyway given that we need to be
backward compatible. I kinda scratched the surface of this previously
when I said mac80211 could set the new flag, but then I don't see how to
detect that it's explicitly not set vs. being an older kernel.

johannes


