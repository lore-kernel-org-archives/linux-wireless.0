Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:41405 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZHIC4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 22:56:54 -0400
Received: by wa-out-1112.google.com with SMTP id j5so502935wah.21
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 19:56:55 -0700 (PDT)
Message-ID: <4A7E3AB2.5070103@lwfinger.net>
Date: Sat, 08 Aug 2009 21:55:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: fix locking for SIWFREQ
References: <1249722238.31670.17.camel@johannes.local>
In-Reply-To: <1249722238.31670.17.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> "cfg80211: validate channel settings across interfaces"
> contained a locking bug -- in the managed-mode SIWFREQ
> call it would end up running into a lock recursion.
> 
> This fixes it by not checking that particular interface
> for a channel that it needs to stay on, which is as it
> should be as that's the interface we're setting the
> channel for.
> 
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Reported-by: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---

This patch also fixes the problem that I had.

Larry
