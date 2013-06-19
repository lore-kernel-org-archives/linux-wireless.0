Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3FSNFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 09:05:24 -0400
Message-ID: <1371647214.10785.11.camel@dcbw.foobar.com> (sfid-20130619_150528_167723_5F242C4F)
Subject: Re: mac80211: impact of netif_carrier_off during roaming
From: Dan Williams <dcbw@redhat.com>
To: m.fitzjohn@samsung.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 08:06:54 -0500
In-Reply-To: <004401ce6ccf$5b69e620$123db260$%fitzjohn@samsung.com>
References: <004401ce6ccf$5b69e620$123db260$%fitzjohn@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 10:28 +0100, Mark Fitzjohn wrote:
> Hi
> 
> I've noticed that during roaming triggered by detection of a significantly
> better AP in wpa_supplicant that mac80211 calls netif_carrier_off and then
> netif_carrier_on when associated with the new AP.
> 
> Does this have any detrimental impact on applications using the wifi
> connection or is the assumption that as long as the roam happens in a
> reasonable time then applications should tolerate it?
> 
> Just wondering if signalling the netif_carrier_off only when the current AP
> is lost and there is no immediate alternative AP for the network available
> was considered?

Carrier is more "can I send data the other side is expected to receive",
and that's what it's doing in mac80211.  If you're roaming but not yet
associated to the new AP, you can't send any data, thus carrier is down.

Carrier for Wi-Fi is simply more complicated than ethernet because Wi-Fi
is more complicated.  The current approach provides a good notification
of L2 connectivity, which maps well to the existing Ethernet semantics
and how stuff like DHCP works if it wants to renew addresses.  Something
needs to provide this and carrier does that in a consistent way.

What you're probably looking for is indications of
connection/disconnection from an SSID, which is provided by
mac80211/cfg80211 and wpa_supplicant.

Dan

