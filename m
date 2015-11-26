Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38146 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbKZRIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:08:48 -0500
Message-ID: <1448557724.2167.28.camel@sipsolutions.net> (sfid-20151126_180852_421423_742DE952)
Subject: Re: [PATCH] mac80211: add new IEEE80211_VIF_GET_NOA_UPDATE flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Date: Thu, 26 Nov 2015 18:08:44 +0100
In-Reply-To: <1445931520-14509-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151027_083846_037088_3C5DC175)
References: <1445931520-14509-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20151027_083846_037088_3C5DC175)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-10-27 at 08:38 +0100, Janusz Dziedzic wrote:
> Add new VIF flag, that will allow get NOA update
> notification when driver will request this, even
> this is not pure P2P vif (eg. STA vif).

Applied.

I'll note that people here seem to want to do a similar thing, so
thanks :)

Also, perhaps we should have a common way to advertise this kind of
capability in the association request of this station, so that the
(mobile?) APs implementing it can know? I think we'd discussed using an
Intel-specific vendor IE for this, but making the specification thereof
public so others could do it as well, but I'm sure we're open for other
suggestions. Any interest?

We're also going to be working on nl80211 extensions to actually let
the driver know if the client is P2P (or NoA capable) or not.

johannes
