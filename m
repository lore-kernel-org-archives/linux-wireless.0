Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:28627 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0EXIuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:50:44 -0400
Subject: Re: [PATCH 3/6] wl1271: Flush TX buffers to air before going to
 idle
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274689723.3743.16.camel@jlt3.sipsolutions.net>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
	 <1274689100-14785-4-git-send-email-luciano.coelho@nokia.com>
	 <1274689723.3743.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 11:51:27 +0300
Message-ID: <1274691087.5277.54.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-24 at 10:28 +0200, ext Johannes Berg wrote:
> On Mon, 2010-05-24 at 11:18 +0300, Luciano Coelho wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > The mac80211 changes to idle almost immediately after transmitting some
> > frames, such as deauth etc. When going to idle, the wl1271 is disconnected,
> > which causes TX frames already on buffers, but not yet transmitted, to be
> > deleted.
> > 
> > To make sure deauth frames reach the air, allow the TX buffers to flush
> > before proceeding to idle.
> 
> Actually, mac80211 executes a flush() request before idle, so you could
> just implement the flush callback and also benefit in some other
> scenarios (though the software scan one you don't care about)

Yeah. I noticed that later while working with other stuff.

I already have planned to move the flush to flush() ;)

-Juuso

> johannes
> 


