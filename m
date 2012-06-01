Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab2FAIVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 04:21:54 -0400
Message-ID: <1338538911.4884.10.camel@jlt3.sipsolutions.net> (sfid-20120601_102240_732074_43371C49)
Subject: Re: [PATCH] mac80211: clear ifmgd->bssid only after building DELBA
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 01 Jun 2012 10:21:51 +0200
In-Reply-To: <1338538443-23172-1-git-send-email-eliad@wizery.com> (sfid-20120601_101428_305649_924D8D82)
References: <1338538443-23172-1-git-send-email-eliad@wizery.com>
	 (sfid-20120601_101428_305649_924D8D82)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-01 at 11:14 +0300, Eliad Peller wrote:
> ieee80211_set_disassoc() clears ifmgd->bssid before
> building DELBA frames, resulting in frames with invalid
> bssid ("00:00:00:00:00:00").
> 
> Fix it by clearing ifmgd->bssid only after building
> all the needed frames.
> 
> After this change, we no longer need to save the
> bssid (before clearing it), so remove the local array.

I'm not convinced clearing the BSSID this late is correct, there's a lot
of code using it, for example comparing it on RX, that we may not want
to have it at this point any more.

It may well be that this is no longer a concern, but I wouldn't dismiss
it right away.

johannes

