Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab1CBIZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 03:25:27 -0500
Subject: Re: [PATCH 2/9] [{mac|nl}80211] Add 2 new radar channel flags
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Bernhard Schmidt <bernhard.schmidt@saxnet.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"dubowoj@neratec.com" <dubowoj@neratec.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"simon.wunderlich@saxnet.de" <simon.wunderlich@saxnet.de>
In-Reply-To: <20110301215412.GD6835@tux>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
	 <201102281747.06564.bernhard.schmidt@saxnet.de> <20110301215412.GD6835@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 09:25:17 +0100
Message-ID: <1299054317.4076.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 13:54 -0800, Luis R. Rodriguez wrote:

> > + * @NL80211_FREQUENCY_ATTR_RADAR_CLEAR: during a full CAC no interference has
> > + *	been detected.
> 
> Why do you need a flag for clear, can you simply count on the
> lack of the flag as the "clear" state?

This really means CAC_DONE_AND_FOUND_CLEAR.

Though now that has me wondering, maybe it should be CAC_DONE and BUSY
as separate flags? But then the checks have to be (CAC_DONE && !BUSY),
which is more expressive but also more complex and error prone.

johannes

