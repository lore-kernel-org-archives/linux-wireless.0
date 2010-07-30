Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0G3Gdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 02:33:54 -0400
Subject: Re: [wt PATCH 0/5] libertas: make association work again
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1280470034.14523.4.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 08:35:06 +0200
Message-ID: <1280471706.3710.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-29 at 23:07 -0700, Dan Williams wrote:
> This series makes libertas actually associate with APs after the
> cfg80211 conversion.  There was a pretty big TODO where if cfg80211
> didn't pass in the BSSID of the AP to associate with, then libertas
> would fail because the firmware really, really, really wants a BSSID.
> So lets do a scan to find that BSSID.  The other notable change is
> a fix to make sure all supported rates are included in the firmware's
> association request, lack of which caused some APs to deny the attempt.

I'm a bit tempted to say we could use the connect logic in cfg80211 to
provide this? cfg80211 _already_ provides this if the hardware wants
auth()/assoc() rather than connect() calls, so it seems fairly simple to
also (optionally) do it here?

johannes

