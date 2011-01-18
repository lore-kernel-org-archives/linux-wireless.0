Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1ARMLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:11:35 -0500
Subject: Re: [PATCH 4/5] mac80211: add primarily CAC support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <201101181301.45021.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.8150D2084@mx.techwires.net>
	 <1295347515.3563.10.camel@jlt3.sipsolutions.net>
	 <201101181301.45021.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 13:12:20 +0100
Message-ID: <1295352740.3563.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 13:01 +0100, Bernhard Schmidt wrote:

> > > +	mutex_lock(&radar->mtx);
> > 
> > Clearly, you haven't even tested this code. I'm not sure why I'm even
> > reviewing it.
> 
> Granted, I did only some basic tests with only a few predefined 
> scenarios, not at all is just wrong. Anyways, I should have mentioned in 
> 0/13 that preventing channel changes while in CAC should be considered 
> and chan should be assigned to local variable then.

I was more referring to the fact that you're trying to lock a mutex in a
timer -- so you can't have executed this code path ever?!

johannes


