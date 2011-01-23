Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:48042 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab1AWRZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 12:25:52 -0500
Date: Sun, 23 Jan 2011 18:26:25 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/3] nl80211: allow passing SSID in nl80211_set_bss
Message-ID: <20110123162625.GA1392@jm.kir.nu>
References: <1295555306-20005-1-git-send-email-arik@wizery.com>
 <1295556734.3693.53.camel@jlt3.sipsolutions.net>
 <AANLkTinZwZbnzbT2UvOg7PgUsCRAR-+Hx+Je0zgoRYHd@mail.gmail.com>
 <1295774590.3639.20.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295774590.3639.20.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 23, 2011 at 10:23:10AM +0100, Johannes Berg wrote:
> Not really, except that I think that by itself it's insufficient. I
> might add that depending on how the probe response thing works out in
> the supplicant, it might make sense to add a capability flag that makes
> the driver request this behaviour, since it would also disable
> multi-SSID operation on a single BSSID (if that gets ever implemented)
> for example since only a single probe request can be transmitted.

Yes, it would be useful to allow user space to figure out whether the
driver is generating Probe Response frames on it own (without having to
guess this based on never seeing Probe Request frames or something
similar).

> Also, P2P GO might be quite tricky with this, but I'm not exactly sure.

For the most basic functionality, it need a mechanism that allows the
Probe Response template to be updated during the lifetime of the BSS.
However, to fully comply with the P2P spec, whatever code is taking care
of processing Probe Request frames would need to be able to
conditionally include the P2P IE(s) from the template based on whether
the Probe Request frame included a P2P IE. In addition, it would need to
be able to check the Requested Device Type against the list of device
types (both local and remote) in the group to determine whether to reply
to the request.

-- 
Jouni Malinen                                            PGP id EFC895FA
