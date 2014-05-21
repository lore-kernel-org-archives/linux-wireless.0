Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40306 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaEUKlp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 06:41:45 -0400
Message-ID: <1400668890.4136.1.camel@jlt4.sipsolutions.net> (sfid-20140521_124148_787986_8F8B89FB)
Subject: Re: [PATCHv2] nl80211: Provide TDLS link state
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org, Luca Coelho <luca@coelho.fi>
Date: Wed, 21 May 2014 12:41:30 +0200
In-Reply-To: <20140520223316.EFCF1E0007@pstew.mtv.corp.google.com> (sfid-20140521_003322_185995_CD232EF2)
References: <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
	 <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
	 <20140520223316.EFCF1E0007@pstew.mtv.corp.google.com>
	 (sfid-20140521_003322_185995_CD232EF2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-20 at 13:27 -0700, Paul Stewart wrote:
> Provide a method to query TDLS state in drivers that use the
> NL80211_CMD_TDLS_OPER method for link setup.

Apart from the fact that your patch isn't very clear on how this was
intended to be used (some return value?) I don't really see why even
such a driver couldn't implement station operations
(get_station/dump_station) and get the same API for this that mac80211
already implements.

iw wlan0 station dump gives me
Station 02:00:00:00:01:00 (on wlan0)
	inactive time:	450 ms
	rx bytes:	3068
	rx packets:	2
	tx bytes:	3036
	tx packets:	2
	tx retries:	0
	tx failed:	0
	signal:  	-30 dBm
	signal avg:	-30 dBm
	tx bitrate:	24.0 MBit/s
	rx bitrate:	12.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	no
	MFP:		no
	TDLS peer:	yes
[...]


johannes

