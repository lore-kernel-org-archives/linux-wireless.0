Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1HJNhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:37:08 -0400
Subject: Re: [PATCH 1/6] mac80211: fix mesh beacon format
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1312919418-32196-2-git-send-email-thomas@cozybit.com> (sfid-20110809_215155_359071_854103B9)
References: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
	 <1312919418-32196-2-git-send-email-thomas@cozybit.com>
	 (sfid-20110809_215155_359071_854103B9)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:37:04 +0200
Message-ID: <1312983424.4325.0.camel@jlt3.sipsolutions.net> (sfid-20110810_153712_181018_06A3A096)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:50 -0700, Thomas Pedersen wrote:

> -		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
> +		mgmt->u.beacon.capab_info |= sdata->u.mesh.security
> +					     ? WLAN_CAPABILITY_PRIVACY : 0;

This should, I believe, warn if you run with sparse (make C=1
M=net/mac80211 or your favourite invocation) -- there's an endian error
here.

johannes

