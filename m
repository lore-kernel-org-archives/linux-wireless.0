Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3CGKBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:01:47 -0500
Message-ID: <1362650499.8694.15.camel@jlt4.sipsolutions.net> (sfid-20130307_110151_202606_5902B983)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 11:01:39 +0100
In-Reply-To: <1686131.738LDv7O6j@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir>
	 <1362412079.21028.34.camel@jlt4.sipsolutions.net>
	 <1686131.738LDv7O6j@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-07 at 09:10 +0200, Vladimir Kondratiev wrote:

> > We had something like this before. I think you need to specify not the
> > wiphy but a netdev though, to know what MAC address to use. In fact, not
> > a netdev but a wdev, so it can work on P2P_Device type wdevs.

> Why do we need wdev here? It should be similar to scan, as p2p scan composed
> of legacy scan and p2p find. Scan have only wiphy.
> It's no problem to add wdev as well, of course. I'll add it.

No, scan also has the device? It is needed for the MAC address, of
course.

> > Also, timings? Or is that left to the driver?

> Yes, timing is up to the driver. Point is, firmware may have its reasons
> when switch search/listen phases.

Some hints from userspace might be helpful though?

> > wpa_s will need to know whether or not it responded, unless you mandate
> > that it must respond by itself -- not sure if you should do that though?

> Same way as today wpa_s know whether driver/firmware answer probes - 
> WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD. Or, should I add one more flag, like
> WIPHY_FLAG_P2P_PROBE_RESP_OFFLOAD?

AP_PROBE_RESP_OFFLOAD doesn't seem appropriate? just read out the name
aloud, it starts with "AP" ;-)

johannes

