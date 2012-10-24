Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48270 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933474Ab2JXI7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 04:59:22 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v6 4/6] wireless: use OR operation to set wiphy features
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
	<1350542071-26498-5-git-send-email-bzhao@marvell.com>
Date: Wed, 24 Oct 2012 11:59:07 +0300
In-Reply-To: <1350542071-26498-5-git-send-email-bzhao@marvell.com> (Bing
	Zhao's message of "Wed, 17 Oct 2012 23:34:29 -0700")
Message-ID: <87d308z1no.fsf@purkki.adurom.net> (sfid-20121024_105927_500637_19EEB3D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing Zhao <bzhao@marvell.com> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> The next patch will introduce a flag that is set
> by default in cfg80211 so drivers and mac80211
> need to use |= to set features they have so that
> they don't clear the already-set feature.
>
> We could set the flag in wiphy_register() instead
> of wiphy_new() to avoid this patch, but then the
> drivers couldn't *unset* flags they don't want to
> use even though the implementation is generic.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Is there a way to check that drivers don't accidentally clear the flags
(ie. use '=' instead '|=')? For example by adding a dummy flag and
checking afterwards that it's not cleared?

I'm just worried that this detail might be too easy to miss, for example
somehow I had missed this patch and noticed only when rebasing ath6kl
patches.

-- 
Kalle Valo
