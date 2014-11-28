Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41640 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaK1PLJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 10:11:09 -0500
Message-ID: <1417187462.27562.17.camel@sipsolutions.net> (sfid-20141128_161113_634829_251B97B3)
Subject: Re: [PATCH] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Date: Fri, 28 Nov 2014 16:11:02 +0100
In-Reply-To: <CAA2SeNJy4UmLujROiKwj0aScRfQkPpNLNTeb_8e68FDgxKKwqg@mail.gmail.com> (sfid-20141128_160247_073454_F48DFAB4)
References: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1417099707.19919.0.camel@sipsolutions.net>
	 <CAA2SeNJuMYXRAU3NFABsKk27_ojZARBByRx4oU3xApaDnBJYug@mail.gmail.com>
	 <1417181014.27562.4.camel@sipsolutions.net>
	 <CAA2SeNJy4UmLujROiKwj0aScRfQkPpNLNTeb_8e68FDgxKKwqg@mail.gmail.com>
	 (sfid-20141128_160247_073454_F48DFAB4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-28 at 16:02 +0100, Lorenzo Bianconi wrote:

> I just need to notify lower driver (ath9k in my case) to setup TPC
> registers in order to take into account TX power configured in frame
> descriptors. For that purpose I added tpc_enabled flags in
> ieee80211_bss_conf and in ieee80211_conf. Is there any other variables
> I can use to notify that configuration?

Well, arguably, you can just do that unconditionally. If you want to do
it "right" according to the nl80211 API that we introduced due to wext
compatibility (IIRC), you'd have to look at the value passed in enum
nl80211_tx_power_setting. This can take

NL80211_TX_POWER_AUTOMATIC - no limit from userspace
NL80211_TX_POWER_LIMITED - limit, but allow using less than specified
NL80211_TX_POWER_FIXED - use exactly what userspace wanted

I don't think any driver really implements this today, but you could
take this as a hint and only enable TPC (with or without the user's
specified limit) in the first two cases.

johannes

