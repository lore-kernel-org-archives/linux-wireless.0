Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282AbZHJQzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 12:55:08 -0400
Subject: Re: [PATCH] cfg80211: fix locking for SIWFREQ
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1249722238.31670.17.camel@johannes.local>
References: <1249722238.31670.17.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 09:55:09 -0700
Message-Id: <1249923309.30019.5611.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-08-08 at 02:03 -0700, Johannes Berg wrote:
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

Not sure if this is still needed, but for completeness:

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you very much

Reinette


