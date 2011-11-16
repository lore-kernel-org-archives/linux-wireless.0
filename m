Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1KPHwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 02:52:18 -0500
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 08:52:15 +0100
Message-ID: <1321429935.4773.10.camel@jlt3.sipsolutions.net> (sfid-20111116_085220_289304_F251FE68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 00:21 +0100, Simon Wunderlich wrote:
> This patch adds support for NoAck per WMM Queue. The Unicast QoS
> Header is adapted accordingly for each outgoing frame.
> The support is turned on and off through nl80211 by extending
> the WMM TX Queue Parameters, but can be triggered separately.

Can you explain what for? :-)

I'm not sure this API is really the best way to handle it either, like I
just said it might be nicer per connection or so to get reset properly.

> I have tested this feature on ath9k as well as ath5k devices. There is
> an iw patch as well to make use of this feature.

Since you're adding 'real API' (unlike the debugfs file which you should
probably remove now!) you also should think about drivers like mwifiex
that don't support this and don't use mac80211.

Also, given real API, this impacts the duration calculation etc.

johannes

