Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2K1Q5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 11:57:09 -0500
Message-ID: <1354121848.9345.39.camel@jlt4.sipsolutions.net> (sfid-20121128_175714_008044_BD900CB9)
Subject: Re: [ath9k-devel] [RFC 1/3] nl80211: add spec scan flag
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"mathias.kretschmer@fokus.fraunhofer.de"
	<mathias.kretschmer@fokus.fraunhofer.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>
Date: Wed, 28 Nov 2012 17:57:28 +0100
In-Reply-To: <8887AA04B7EC49479420AE48C5F94A930172CDA2@NASANEXD02D.na.qualcomm.com>
References: <8887AA04B7EC49479420AE48C5F94A930172CDA2@NASANEXD02D.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >Anyway, you'd suggest to use the NL80211 remain on channel command for
> >that?
> 
> Yes.
> 
> >Or add a new "spectral scan" nl80211 command to do a spectral scan on this
> >(or multiple) channels, and use the various functions from
> >mac80211/offchannel.c?
> 
> I would rather add a flag to the existing r-o-c command to indicate that
> spectral scan functionality is to be enabled (well, assuming Johannes is
> fine with this).

Ultimately I don't really care all that much whether it's ROC-like or
SCAN-like, though it didn't seem like the timing mattered because all
the data was just collected inside the callback while it was running,
i.e. synchronously, and thus extended the scan timing?

For ROC I guess an argument could be made that it could just be a flag,
for SCAN I don't think so since none of the other scan functionality
applies. As far as the implementation is concerned, I don't really care,
but I do want to keep the userspace API clean.

scan could be more efficient since it doesn't always go back to the same
channel and can do multiple in a row, unlike ROC.


> >BTW, is there any limitation to remain on channel commands, like will they
> >work on AP ifaces, Ad-Hoc ifaces, MultiSSID in general, etc?
> 
> I hope not. There may be some practical issues with not all drivers
> supporting this, but remain-on-channel is the mechanism we use for
> supporting concurrent operations (e.g., P2P negotiations or GAS/ANQP) and
> making this work in all combinations would be important regardless.

FWIW, right now our plan for iwlwifi is to only really support it with
the P2P Device wdev, but I'm not sure what implications that has in
terms of support for GAS/ANQP etc. We might have to revisit that.

Maybe we should start advertising where it's supported so wpa_s/hostapd
can disable/enable features appropriately?

johannes

