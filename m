Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaAMRXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 12:23:32 -0500
Message-ID: <1389633805.5008.13.camel@jlt4.sipsolutions.net> (sfid-20140113_182335_770821_FEA02C52)
Subject: Re: [PATCH v5] wl12xx: fix tx power setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Gal <a.gal@motsai.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 18:23:25 +0100
In-Reply-To: <CAN44aq1hrya4B4X4xTi4Aphb9QDBiQ9813kT6vhxtDCzBRoNhQ@mail.gmail.com> (sfid-20140113_181432_014011_0995EE3B)
References: <1389385273-1322-1-git-send-email-a.gal@motsai.com>
	 <1389620141.5008.8.camel@jlt4.sipsolutions.net>
	 <CAN44aq1hrya4B4X4xTi4Aphb9QDBiQ9813kT6vhxtDCzBRoNhQ@mail.gmail.com>
	 (sfid-20140113_181432_014011_0995EE3B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-13 at 12:14 -0500, Alex Gal wrote:

> > This doesn't really make sense since the driver handles
> > IEEE80211_CONF_CHANGE_POWER. If there's something wrong with that, maybe
> > that should be fixed?

> The IEEE80211_CONF_CHANGE_POWER never reaches the driver since in
> /net/mac80211/main.c:ieee80211_hw_config:
> 
>     if (!local->use_chanctx)
>         changed |= ieee80211_hw_conf_chan(local);
>     else
>         changed &= ~(IEEE80211_CONF_CHANGE_CHANNEL |
>                  IEEE80211_CONF_CHANGE_POWER);
> 
> only the else statement is executed.

Oh, really? Ok. I didn't think that driver supported channel contexts.
In that case your patch is right but incomplete - you should remove the
CONF_CHANGE_POWER handling.

johannes

