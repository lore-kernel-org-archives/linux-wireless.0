Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43933 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1A0Kd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 05:33:26 -0500
Subject: Re: [PATCH 05/10] wl12xx: report invalid TX rate when returning
 non-TX-ed skbs
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296121901.5263.116.camel@pimenta>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-6-git-send-email-arik@wizery.com>
	 <1296121901.5263.116.camel@pimenta>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 11:33:23 +0100
Message-ID: <1296124403.3622.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-27 at 11:51 +0200, Luciano Coelho wrote:
> On Sun, 2011-01-16 at 06:42 +0100, Arik Nemtsov wrote:
> > Report a TX rate idx of -1 when returning untransmitted skbs to mac80211
> > using ieee80211_tx_status(). Otherwise mac80211 tries to use the
> > returned (essentially garbage) status.
> > 
> > Signed-off-by: Arik Nemtsov <arik@wizery.com>
> > ---
> 
> Is this a documented way of doing it or it just happens to work?

I think the more expected way would be to set the TX counts to 0?

johannes

