Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0IUTHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:07:30 -0400
Subject: Re: [mac80211/ath9k] mac80211/ath9k:  Support AMPDU with multiple
 VIFs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285095455-29081-1-git-send-email-greearb@candelatech.com>
References: <1285095455-29081-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 21:07:28 +0200
Message-ID: <1285096048.12764.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 11:57 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The old ieee80211_find_sta_by_hw method didn't properly
> find VIFS when there was more than on per AP.  This caused
> AMPDU logic in ath9k to get the wrong VIF when trying to
> account for transmitted SKBs.
> 
> This patch changes ieee80211_find_sta_by_hw to take a
> net_device pointer to distinguish among multiple VIFs.

Err, no, this certainly isn't the right thing to do, is skb->dev even
guaranteed to be right? I'm not convinced of that, and besides, if you
can have the dev you can have the vif too.

johannes

