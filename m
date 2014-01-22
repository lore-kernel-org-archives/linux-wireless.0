Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaAVXL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 18:11:26 -0500
Message-ID: <1390432284.20070.1.camel@jlt4.sipsolutions.net> (sfid-20140123_001129_102542_A71FA8B3)
Subject: Re: [PATCH 1/2] mac80211:  Extra debug info for station cleanup
 case.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 00:11:24 +0100
In-Reply-To: <1390431296-20568-1-git-send-email-greearb@candelatech.com> (sfid-20140122_235532_670534_4FD6E588)
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>
	 (sfid-20140122_235532_670534_4FD6E588)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 14:54 -0800, greearb@candelatech.com wrote:
> -		WARN_ON_ONCE(ret != 0);
> +		if (WARN_ON_ONCE(ret != 0))
> +			sdata_info(sdata, "sta-info-destroy: drv-sta-state error: %i, sta: %pM\n",
> +				   ret, sta->sta.addr);

You should put the string into the warning

WARN_ONCE(ret, "sta-info-destroy: ...", ...)

johannes

