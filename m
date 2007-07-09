Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:55616 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXGIF5u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 01:57:50 -0400
In-Reply-To: <200707090055.55974.mb@bu3sch.de>
References: <468E5C33.2000102@warmcat.com> <46915B3C.6030609@warmcat.com> <20070708223829.GA18217@deine-taler.de> <200707090055.55974.mb@bu3sch.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7AA2BF00-371A-4DE5-B646-111117D41933@deine-taler.de>
Cc: Andy Green <andy@warmcat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
From: Uli Kunitz <kune@deine-taler.de>
Subject: Re: Arrested Development
Date: Mon, 9 Jul 2007 07:57:48 +0200
To: Michael Buesch <mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>>  echo -n mon0 >/sys/class/ieee80211/phy0/add_iface

> What do you mean by "additional interface"?
> Do you mean multiple STA interfaces? Does the zd hardware support
> this? I'd say this is unlikely.

>>>  echo -n mon0 >/sys/class/ieee80211/phy0/add_iface

mon0 is an additional interface for me. An additional
monitoring interface is not supported by the hardware, but can
be emulated. However zd1211rw has registers for a second MAC
address. Therefore STA+STA and AP+STA could be supported, if
the firmware handles it properly.

>> The problem with the STA + MNTR interface is, that mac80211 must
>> do the FCS checking for the STA interface or the driver has to
>> filter them before forwarding them to the upper layer.
>
> Well, it's not _that_ bad to forward frames with bad FCS in
> monitor mode. Hey, it's monitor mode. We want to see what's
> going on. ;) I'd say just push the corrupt frames upstream
> and implement the FCS checking later.

Right. I think the radiotap header has support for a bad fcs
flag and for the STA interface, if present, the FCS check has
to be done anyhow.

--
Uli Kunitz



