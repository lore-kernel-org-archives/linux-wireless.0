Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031672Ab2COQdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 12:33:45 -0400
Subject: Re: [PATCH] cfg80211: allow CFG80211_SIGNAL_TYPE_UNSPEC in
 station_info
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331827087-21339-1-git-send-email-linville@tuxdriver.com>
References: <1331825203.3432.25.camel@jlt3.sipsolutions.net>
	 <1331827087-21339-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 17:33:42 +0100
Message-ID: <1331829222.3432.27.camel@jlt3.sipsolutions.net> (sfid-20120315_173400_676334_91CCF0B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 11:58 -0400, John W. Linville wrote:
> The station_info struct had demanded dBm signal values, but the
> cfg80211 wireless extensions implementation was also accepting
> "unspecified" (i.e. RSSI) unit values while the nl80211 code was
> completely unaware of them.  Resolve this by formalling allowing the
> "unspecified" units while making nl80211 ignore them.

Looks fine, just a minor comment below.

> + * @signal: the signal strength, type depends on the wiphy's signal_type
> + * @signal_avg: avg signal strength, type depends on the wiphy's signal_type

This should be more specific since the BSS signal is "unspec" or "mBm"
where this now demands "unspec" or "dBm"... I suppose it could be made
more consistent at some point.

johannes

