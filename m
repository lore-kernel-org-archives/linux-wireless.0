Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2K1RJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 12:09:03 -0500
Message-ID: <1354122565.9345.41.camel@jlt4.sipsolutions.net> (sfid-20121128_180907_596870_C565F5D8)
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
Date: Wed, 28 Nov 2012 18:09:25 +0100
In-Reply-To: <8887AA04B7EC49479420AE48C5F94A930172CE02@NASANEXD02D.na.qualcomm.com>
References: <8887AA04B7EC49479420AE48C5F94A930172CE02@NASANEXD02D.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 17:06 +0000, Malinen, Jouni wrote:

> >FWIW, right now our plan for iwlwifi is to only really support it with
> >the P2P Device wdev, but I'm not sure what implications that has in
> >terms of support for GAS/ANQP etc. We might have to revisit that.
> 
> GAS/ANQP is pre-association if that makes any difference. Anyway, quite a
> few new things will start depending on off channel Action frames and
> everything I'm working on this area will most likely be using r-o-c..

Yes, pre-association might make a difference. I think it's entirely
reasonable to implement it all using ROC, I just don't know whether or
not we can support it right now out of the box.

> >Maybe we should start advertising where it's supported so wpa_s/hostapd
> >can disable/enable features appropriately?
> 
> Yeah, sounds reasonable. I guess you could also reject the r-o-c command,
> but it is cleaner if this can be determined beforehand.

We do that today. Actually, in the current driver we do allow it but
it's rather messy so I might remove the ability once we have P2P Device
support, not sure. In the future we'll have it only on P2P Device,
though making it work on unassociated interfaces should not be a big
issue.

johannes

