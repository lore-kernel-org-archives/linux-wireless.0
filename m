Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:60872 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZHCXqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 19:46:51 -0400
Date: Tue, 4 Aug 2009 01:46:51 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nico@cam.org
Subject: Re: [PATCH 4/5] mwl8k: prevent crash in ->configure_filter() if no interface was added
Message-ID: <20090803234651.GN18639@mail.wantstofly.org>
References: <20090803195857.GK18639@mail.wantstofly.org> <1249329790.4561.3.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249329790.4561.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 03, 2009 at 10:03:10PM +0200, Johannes Berg wrote:

> >  	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
> >  		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
> >  			rc = mwl8k_cmd_set_pre_scan(hw);
> >  		else {
> > -			mv_vif = MWL8K_VIF(priv->vif);
> > -			rc = mwl8k_cmd_set_post_scan(hw, mv_vif->bssid);
> 
> Btw, there are pre- and post-scan hooks now.

These hardware commands are slightly misnamed -- they are called
PRE_SCAN/POST_SCAN, but what they do is program the receive filter.
It seems appropriate to keep that in ->configure_filter() ?
