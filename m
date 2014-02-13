Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBMKDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 05:03:34 -0500
Message-ID: <1392285810.4150.5.camel@jlt4.sipsolutions.net> (sfid-20140213_110342_948131_9D64997D)
Subject: Re: [PATCH] mac80211: add NAPI support back
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 13 Feb 2014 11:03:30 +0100
In-Reply-To: <CA+XVXfc+chWOPuJ5A61+yrJDbUTqb+8-kWZG6ZG4SOONMJJi8g@mail.gmail.com> (sfid-20140213_110050_019195_B8A2B593)
References: <1392237482-18172-1-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXffxt5A_EOMJqMA6hHzZBaCy46ctdXL6R4k+QY_oVTAC7g@mail.gmail.com>
	 <1392282362.4150.4.camel@jlt4.sipsolutions.net>
	 <CA+XVXfc+chWOPuJ5A61+yrJDbUTqb+8-kWZG6ZG4SOONMJJi8g@mail.gmail.com>
	 (sfid-20140213_110050_019195_B8A2B593)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-13 at 12:00 +0200, Arik Nemtsov wrote:

> It's fine. But I guess it's nicer to add a small ieee80211 wrapper for
> it that also clears local->napi? not sure.

Well if the whole thing is going down there's little point in that.

> In general can we even add/remove napi when an interface is up or is
> it a bad idea? if it is, maybe it should be warned/blocked? I guess
> the scoping wasn't really clear for me, but maybe it is for anyone
> familiar with napi.

It seems that isn't allowed, the locking would seem rather missing for
that? *Maybe* if the driver locks everything, but even then I'd be wary.

johannes

