Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35462 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbAWJvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:51:25 -0500
Message-ID: <1422006682.2728.14.camel@sipsolutions.net> (sfid-20150123_105129_466106_44A9D01C)
Subject: Re: [PATCH] mac80211: only roll back station states for WDS when
 suspending
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 10:51:22 +0100
In-Reply-To: <1421871574-18789-1-git-send-email-luca@coelho.fi>
References: <1421699291-16279-1-git-send-email-luca@coelho.fi>
	 <1421871574-18789-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-21 at 22:19 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> In normal cases (i.e. when we are fully associated), cfg80211 takes
> care of removing all the stations before calling suspend in mac80211.
> 
> But in the corner case when we suspend during authentication or
> association, mac80211 needs to roll back the station states.  But we
> shouldn't roll back the station states in the suspend function,
> because this is taken care of in other parts of the code, except for
> WDS interfaces.  For AP types of interfaces, cfg80211 takes care of
> disconnecting all stations before calling the driver's suspend code.
> For station interfaces, this is done in the quiesce code.
> 
> For WDS interfaces we still need to do it here, so move the code into
> a new switch case for WDS.

Applied.

johannes

