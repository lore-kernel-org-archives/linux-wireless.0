Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12777 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab0A1RSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 12:18:31 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2010 09:18:31 -0800
Subject: Re: mac80211: Open bug in current wireless-testing
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <470500.11306.qm@web51403.mail.re2.yahoo.com>
References: <470500.11306.qm@web51403.mail.re2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 09:18:30 -0800
Message-ID: <1264699110.9434.2.camel@jm-laptop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-01-28 at 00:21 -0800, Joerg Pommnitz wrote:
> I found and read the patch in question. If I understand things correctly,
> this provides a way to set a mask that marks the data rates that are
> available for the RC algorithm to choose from. This could be translated
> into an iw command like this:
> 
> iw dev wlan0 rates 54M,11M
> 
> and then the current RC algorithm would be limited to choose either 54M or
> 11M as TX data rate. Is this correct?

Yes.

> Selecting a single fixed data rate would mean to only mark one data rate
> as available. I think this meats my requirements in this area. However,
> I still have another problem: We use Madwifi to multicast video streams.
> 
> With Madwifi we have an iwpriv call that allows the selection of the multicast/broadcast data rate. We need something equivalent for mac80211
> before we can make the switch.

You can control the multicast/broadcast rates with basic rate set
configuration (in hostapd.conf). I think the current rate control
algorithms do not support dynamic rate selection for
multicast/broadcast, so they will end up picking the lowest rate from
the basic rate set. Anyway, if you include only a single rate in the
basic rate set, that rate will be used for multicast/broadcast frames.

- Jouni


