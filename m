Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev2day.de ([83.169.2.241]:51122 "EHLO dev2day.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0HBUfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:35:40 -0400
Message-ID: <4C572C18.6070003@dev2day.de>
Date: Mon, 02 Aug 2010 22:35:36 +0200
From: Jan Friedrich <jft@dev2day.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [Patch] ath9k: fix erased ieee80211_rx_status.mactime
References: <4C57278E.1030601@dev2day.de> <20100802202137.GC8920@tux>
In-Reply-To: <20100802202137.GC8920@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What effect does this have? What issue does this fix? Is this a
> fix which also needs to be propagated to the stable kernels, if so
> why? etc.

The mactime is always set to 0. I encountered the problem in IBSS mode.
In ieee80211_rx_bss_info (net/mac80211/ibss.c) the mactime is used to
trigger an IBSS merge. At the moment the merge is always triggered.

I got the "beacon TSF higher than local TSF - IBSS merge with BSSID" log
message with every beacon and so recognized this odd behaviour.

I think this has to be fixed and at least influences IBSS mode negatively.

Greetings,
Jan


