Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:29707 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbZLKMJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 07:09:08 -0500
Subject: Re: [PATCH 21/31] wl1271: prevent power save entry while not
 associated
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1260532418.2442.129.camel@johannes.local>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
	 <1260531682-4695-22-git-send-email-luciano.coelho@nokia.com>
	 <1260532418.2442.129.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 14:09:15 +0200
Message-ID: <1260533355.2689.45.camel@wimaxnb.ntc.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Unfortunately I haven't had the time to investigate this further, but
for me it did happen after getting de-authenticated from an AP and
attempting to re-authenticate. While re-authenticating, mac80211
appeared to request going into power save after transmitting the
corresponding control messages, preventing the re-authentication from
succeeding.

My assumption is, that the dynamic power save mechanism is somehow
getting triggered from the control message exchange - but, as I said, I
cannot be sure at this point.

-Juuso

On Fri, 2009-12-11 at 12:53 +0100, ext Johannes Berg wrote:
> On Fri, 2009-12-11 at 13:41 +0200, Luciano Coelho wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > The mac80211 sometimes requests power save entry while not associated - this
> > will cause problems, so prevent it if not associated. Go to powersave once
> > association is complete.
> 
> Does it? It's not supposed to, and I imagine that causing trouble with
> other drivers too. Do you know how that happens?
> 
> johannes


