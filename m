Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46852 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbbFQI7A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:59:00 -0400
Message-ID: <1434531537.1884.17.camel@sipsolutions.net> (sfid-20150617_105909_922195_0C0DA1B1)
Subject: Re: [PATCH] mac80211: don't invalidate SN on discovery failure
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com
Cc: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Date: Wed, 17 Jun 2015 10:58:57 +0200
In-Reply-To: <557B4B65.60001@cococorp.com> (sfid-20150612_231319_185504_F3077021)
References: <557B4B65.60001@cococorp.com>
	 (sfid-20150612_231319_185504_F3077021)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-12 at 14:13 -0700, Alexis Green wrote:
> From: Jesse Jones <jjones@cococorp.com>
> 
> The 2012 spec mentions that path SNs can be invalid when created (see
> section 13.10.8.4 table 13-9) but AFAICT never talks about invalidating
> SNs. Which makes sense: if we have figured out the path to a target at a
> certain SN then we want to remember that fact. Failing to do so can lead
> to routing loops because if we don't have a valid SN then we have no way
> of knowing whether an incoming path message leads to or away from the
> target.
> 
> However currently when discovery fails we zero out mpath->flags which
> clears MESH_PATH_SN_VALID. This patch fixes that so that only the
> discovery relevant flags are cleared.

Applied; I fixed the indentation a bit.

Also, please mention "mesh" in the future in the subject of your
patches, it makes it easier to pick out.

johannes


