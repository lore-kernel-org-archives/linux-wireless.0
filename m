Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52758 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537AbcHKMsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:48:36 -0400
Message-ID: <1470919713.12075.8.camel@sipsolutions.net> (sfid-20160811_144851_991549_2DA20FD1)
Subject: Re: [PATCH 1/4] cfg80211: rdev-ops: remove callback check from
 rdev_set_coalesce()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 11 Aug 2016 14:48:33 +0200
In-Reply-To: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-10 at 12:33 +0200, Arend van Spriel wrote:
> The wrapper rdev_set_coalesce() checks whether the driver provides
> the set_coalesce callback and returns -ENOTSUPP if not. However, this
> check is already performed in nl80211_set_coalesce() resulting in
> -EOPNOTSUPP. This patch removes check from rdev wrapper function.

What's the point though? Presumably the compiler will optimise it out,
and it seems safer to have it this way? Same for all patches in this
series.

johannes
