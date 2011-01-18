Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:53079 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1ARM2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:28:11 -0500
Received: by mail-fx0-f66.google.com with SMTP id 14so2807840fxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 04:28:11 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/5] mac80211: add primarily CAC support
Date: Tue, 18 Jan 2011 13:28:08 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201101171621.29863.bernhard.schmidt@saxnet.de> <201101181301.45021.bernhard.schmidt@saxnet.de> <1295352740.3563.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295352740.3563.14.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101181328.09624.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 18, 2011 13:12:20 Johannes Berg wrote:
> On Tue, 2011-01-18 at 13:01 +0100, Bernhard Schmidt wrote:
> > > > +	mutex_lock(&radar->mtx);
> > > 
> > > Clearly, you haven't even tested this code. I'm not sure why I'm
> > > even reviewing it.
> > 
> > Granted, I did only some basic tests with only a few predefined
> > scenarios, not at all is just wrong. Anyways, I should have
> > mentioned in 0/13 that preventing channel changes while in CAC
> > should be considered and chan should be assigned to local variable
> > then.
> 
> I was more referring to the fact that you're trying to lock a mutex
> in a timer -- so you can't have executed this code path ever?!

I'm running it right now, the code path *is* executed, what am I missing 
here?

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
