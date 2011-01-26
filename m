Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1AZVyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:54:16 -0500
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta
 connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-3-git-send-email-arik@wizery.com>
	 <1296077594.3635.40.camel@jlt3.sipsolutions.net>
	 <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 22:54:17 +0100
Message-ID: <1296078857.3635.41.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 23:44 +0200, Arik Nemtsov wrote:

> Well no it doesn't do that. But the FW takes some time to know its
> authenticated.
> The flow is this:
> 
> 1. hostapd sends auth complete (the FW doesn't know anything about this)

you mean assoc, right?

> 2. The STA transmits something
> 3. The AP FW deauths the STA
> 4. hostapd adds the station, causing mac80211 to call add_sta(), which
> causes the FW to add the sta
> 
> Then we have an endless loop of sta add/remove..

I'd wondered about that race condition before -- maybe hostapd should
add the station before sending the assoc complete. The race also exists
in practice with just mac80211, except it only leads to a dropped frame.

johannes

