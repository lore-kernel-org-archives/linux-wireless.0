Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:36311 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424Ab1A0AUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 19:20:43 -0500
Date: Thu, 27 Jan 2011 02:20:34 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta
 connection
Message-ID: <20110127002034.GA18234@jm.kir.nu>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-3-git-send-email-arik@wizery.com>
 <1296077594.3635.40.camel@jlt3.sipsolutions.net>
 <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com>
 <1296078857.3635.41.camel@jlt3.sipsolutions.net>
 <AANLkTikno8Aa3wKy1js62D3FLOZJUxPyuwYsQd+g8JBM@mail.gmail.com>
 <1296079719.3635.47.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296079719.3635.47.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 11:08:39PM +0100, Johannes Berg wrote:
> If we add the station before the response frame's ACK is received, we
> still have the race, and we need to delete if we don't get the ACK. If
> we add the station before we send the assoc response we get rid of this
> race, but also have to delete if we don't get the ACK. I guess that case
> is actually nicer in some way since we would have allowed the station to
> connect, so if spurious data frames go up because we don't get an ACK
> from the station that's no big deal?

>From the correctness view point, the STA entry would need to be enabled
(added/marked associated) at the moment the ACK frame is received. Since
we do some internal processing between kernel and user space, there is
obviously some latency involved. The most correct mechanism would be to
make hostapd add a not-associated-STA entry before sending association
response with status code 0 and request mac80211 to mark it associated
automatically on TX status report (showing success) from the driver.
However, for practical purposes, that may be too complex and doing what
you describe above is likely good enough.

-- 
Jouni Malinen                                            PGP id EFC895FA
