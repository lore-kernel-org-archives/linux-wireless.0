Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2E2Oft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 10:35:49 -0400
Message-ID: <1338302148.4342.33.camel@jlt3.sipsolutions.net> (sfid-20120529_163552_927332_74F3F885)
Subject: Re: [PATCH 2/2] mac80211: handle channel times in scan command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 16:35:48 +0200
In-Reply-To: <CAK80WHbtfhNdd5E7QNYno3L3gG00nTxWEPaQtGH7b5Ee2BhTFg@mail.gmail.com>
References: <1337885569-32711-1-git-send-email-victorg@ti.com>
	 <1337885569-32711-2-git-send-email-victorg@ti.com>
	 <1338275419.4342.19.camel@jlt3.sipsolutions.net>
	 <CAK80WHbtfhNdd5E7QNYno3L3gG00nTxWEPaQtGH7b5Ee2BhTFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-29 at 17:28 +0300, Goldenshtein, Victor wrote:
> On Tue, May 29, 2012 at 10:10 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > I'd prefer the default values to be defined in cfg80211, not mac80211,
> > so that other drivers can also benefit once they add support for these
> > settings.
> >
> 
> you mean, to move (and rename) the:
> 
> #define IEEE80211_CHANNEL_TIME (HZ / 33)
> #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
> 
> from scan.c to nl80211.h (or other?), and to set the default values in
> nl80211_trigger_scan() ?

Probably not nl80211.h, but more like net/wireless/scan.c or something?

Keep in mind that the defaults need to be set for both nl80211 and wext.

johannes

