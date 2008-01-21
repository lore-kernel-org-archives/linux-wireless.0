Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:23409 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbYAUQFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 11:05:33 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1402357fkz.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2008 08:05:30 -0800 (PST)
To: bruno randolf <bruno@thinktube.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Mon, 21 Jan 2008 17:05:23 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>
References: <20080118125252.6455.41047.stgit@one> <200801201143.09488.IvDoorn@gmail.com> <200801211052.41016.bruno@thinktube.com>
In-Reply-To: <200801211052.41016.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801211705.24221.IvDoorn@gmail.com> (sfid-20080121_160537_681180_D26F58BC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Then there is a problem for rt2x00. Since the mactime isn't known.
> > rt2400pci is the _only_ device which has a RX_END_TIME field in the
> > RX descriptor.
> 
> one workaround could be to simply use the current TSF at the time in the 
> tasklet or interrupt handler (to be more close to the actual rx time). this 
> should be sufficient to catch most cases where an IBSS merge is necessary - 
> usually the beacon's TSF will be much higher than the local TSF.

Should the driver to this, or should mac80211 handle that?
Personally I think it is something for the mac80211 layer since the driver will
give what it can, and can be sure that it is what mac80211 expects instead of
drivers interpreting what mac80211 might want as replacement.
If mac80211 needs the TSF value when no mac time is given, it could just
use the get_tsf() callback function to the driver to get the substitute. When the
get_tsf() callback is not provided, then mac80211 can complain about missing
information.

Ivo
