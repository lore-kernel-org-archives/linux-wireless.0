Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56579 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1ARMAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:00:11 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7109155fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 04:00:10 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/5] mac80211: initialize radar params + add driver API
Date: Tue, 18 Jan 2011 13:00:08 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201101171621.29863.bernhard.schmidt@saxnet.de> <20110117161133.6EEA42080@mx.techwires.net> <1295347402.3563.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295347402.3563.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101181300.08636.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 18, 2011 11:43:22 Johannes Berg wrote:
> On Mon, 2011-01-17 at 10:16 +0100, Bernhard Schmidt wrote:
> > @@ -1241,6 +1244,8 @@ static int ieee80211_set_channel(struct wiphy
> > *wiphy,
> > 
> >  	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR)
> >  	
> >  		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
> > 
> > +	ieee80211_radar_detection_enable(local, chan);
> > +
> 
> So you're ignoring the return value -- that doesn't seem right at
> all. Also, if the driver doesn't implement detection, you should
> probably reject using the channel.

Yeah right, I've missed that. I wasn't sure about how to proper handle 
opmode and then forgot about it.. Point is, this should only fail on an 
opmode which does involve sending beacons (or in other words, opmodes 
which act as a master device) but not for sta. Will think about 
something.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
