Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56579 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1ARL7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 06:59:50 -0500
Received: by fxm20 with SMTP id 20so7109155fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 03:59:48 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/5] mac80211: add DFS related channel flags
Date: Tue, 18 Jan 2011 12:59:46 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201101171621.29863.bernhard.schmidt@saxnet.de> <20110117161133.66B54207E@mx.techwires.net> <1295347236.3563.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295347236.3563.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101181259.46719.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 18, 2011 11:40:36 Johannes Berg wrote:
> On Mon, 2011-01-17 at 09:31 +0100, Bernhard Schmidt wrote:
> > Before a radar channel can be used, a full CAC has be done, the
> > IEEE80211_CHAN_RADAR_CLEAR flags indicates that this has been done.
> > If either during CAC or in-service monitoring interference is
> > detected, the channel is added to NOL and marked with
> > IEEE80211_CHAN_RADAR_INTERFERENCE.
> 
> I'm not sure about this -- shouldn't that be global information? If
> one device in the system records a radar on the channel, it surely
> applies to other devices as well, even if they are hot-plugged after
> the radar was found?

True, I've based this on our IRC discussions, the consensus there was to 
do it per-wiphy only at first.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
