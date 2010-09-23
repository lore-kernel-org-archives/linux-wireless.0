Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0IWOI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 10:08:27 -0400
Subject: Re: [PATCH] mac80211/ath9k:  Support AMPDU with multiple VIFs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1285250054-32035-1-git-send-email-greearb@candelatech.com>
References: <1285250054-32035-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 16:08:26 +0200
Message-ID: <1285250906.3770.114.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 06:54 -0700, greearb@gmail.com wrote:

>   *
> - * NOTE: This function should not be used! When mac80211 is converted
> - *	 internally to properly keep track of stations on multiple
> - *	 virtual interfaces, it will not always know which station to
> - *	 return here since a single address might be used by multiple
> - *	 logical stations (e.g. consider a station connecting to another
> - *	 BSSID on the same AP hardware without disconnecting first).
> - *
> - * DO NOT USE THIS FUNCTION.

Also, I'm not sure you really should remove this comment, since it still
applies when you pass NULL, and I'm still not convinced that ath9k
couldn't keep track of the virtual interface accurately?

johannes

