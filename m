Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0JNHMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 03:12:43 -0400
Subject: Re: [PATCH 2/6] Ad cfg80211 call for threshold notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101013224851.9C46820418@glenhelen.mtv.corp.google.com>
References: <20101013224851.9C46820418@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 09:13:24 +0200
Message-ID: <1287040404.4641.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 15:10 -0700, Paul Stewart wrote:
> Similar to its rssi counterpart, provide a cfg80211 call for sending
> bitrate change updates.
> 

> +	int	(*set_cqm_bitrate_config)(struct wiphy *wiphy,
> +					  struct net_device *dev,
> +					  u32 bitrate_thold);
> +

Need to document units here ... Also, when you start looking at that,
things get really awkward HT -- you don't really want to have to
determine the bitrate for HT packets for every single one, I think.

johannes

