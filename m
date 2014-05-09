Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51715 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaEILdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:33:49 -0400
Message-ID: <1399635226.4136.3.camel@jlt4.sipsolutions.net> (sfid-20140509_133353_012244_2CB98FE3)
Subject: Re: [PATCH] cfg80211: fix compilation error in cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 09 May 2014 13:33:46 +0200
In-Reply-To: <1399634516-13089-1-git-send-email-luca@coelho.fi>
References: <1399634516-13089-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-09 at 14:21 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Commit 0be035a2 (mac80211: handle failed restart/resume better) broke
> compilation:
> 
> net/wireless/core.c: In function 'cfg80211_shutdown_all_interfaces':
> net/wireless/core.c:215:9: error: implicit declaration of function 'wiphy_to_dev' [-Werror=implicit-function-declaration]
>   struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
>          ^
> 
> This is due to the function name change from wiphy_to_dev() to
> wiphy_to_rdev().

Yeah, my mistake, but I already had Fengguang's build bot flag it and
fixed it already. Thanks though.

johannes

