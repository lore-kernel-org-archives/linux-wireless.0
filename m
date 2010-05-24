Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0EXI2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:28:47 -0400
Subject: Re: [PATCH 3/6] wl1271: Flush TX buffers to air before going to
 idle
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1274689100-14785-4-git-send-email-luciano.coelho@nokia.com>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
	 <1274689100-14785-4-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 10:28:43 +0200
Message-ID: <1274689723.3743.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-24 at 11:18 +0300, Luciano Coelho wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The mac80211 changes to idle almost immediately after transmitting some
> frames, such as deauth etc. When going to idle, the wl1271 is disconnected,
> which causes TX frames already on buffers, but not yet transmitted, to be
> deleted.
> 
> To make sure deauth frames reach the air, allow the TX buffers to flush
> before proceeding to idle.

Actually, mac80211 executes a flush() request before idle, so you could
just implement the flush callback and also benefit in some other
scenarios (though the software scan one you don't care about)

johannes

