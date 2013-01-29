Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3A2TWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 14:22:45 -0500
Message-ID: <1359487383.8108.20.camel@jlt4.sipsolutions.net> (sfid-20130129_202248_737437_88EFFD01)
Subject: Re: [RFC 0/3] WPA_NONE support in mac80211/ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Antonio Quartulli <ordex@autistici.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Ray Gibson <rgibson@futurec.net>
Date: Tue, 29 Jan 2013 20:23:03 +0100
In-Reply-To: <30210911.93HAZKKtRJ@bentobox>
References: <30210911.93HAZKKtRJ@bentobox>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-28 at 17:11 +0100, Sven Eckelmann wrote:
> Hi,
> 
> I've tried to use WPA_NONE together with ath9k (other people reported
> problems, but said it would be batman-adv related [1]). I ran into three
> smaller problems and worked around them. I am not sure what kind of support
> mac80211 should have for WPA_NONE, but maybe also someone else is trying
> it and could use this as a reference. Nevertheless, IBSS/RSN should be
> preferred.

All of this seems really hacky. For example, instead of installing the
keys earlier, you should manage the authorized flag like in RSN IBSS.
Similarly, why not just install the same key for all stations? That way,
you probably don't even need the replay detection.

johannes

