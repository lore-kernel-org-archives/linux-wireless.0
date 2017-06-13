Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52328 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751906AbdFMJCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 05:02:06 -0400
Message-ID: <1497344524.6068.5.camel@sipsolutions.net> (sfid-20170613_110226_444570_7390CB36)
Subject: Re: [PATCH V3 3/9] nl80211: add authorized flag to CONNECT event
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Jun 2017 11:02:04 +0200
In-Reply-To: <1497010130-16186-4-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
         <1497010130-16186-4-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-09 at 13:08 +0100, Arend van Spriel wrote:
> When the driver supports offloading of the PTK/GTK handshakes
> completion of that during connect changes the layer 2 control
> port state to authorized. This patch allows the driver to pass
> that state in cfg80211_connect_done() resulting in adding the
> new flag NL80211_ATTR_PORT_AUTHORIZED in the NL80211_CMD_CONNECT
> notification. For 802.1X the driver is expected to issue the
> NL80211_CMD_CONNECT notification twice. First without the new
> attribute to inform user-space that 802.1X authentication can
> start and a second one with the new attribute to indicate the
> completion of the handshakes.

So I was going to apply this, but now I'm no longer sure.

First of all, I'm concerned it could confuse older tools that don't
expect to see the notification twice. OTOH, they'd get the connected
notification now and not really know whether or not data can be passed,
so it seems unlikely they'd rely on it - but are we really sure about
that?

Additionally, I just discussed this with Avi, and it's not clear to us
what the second notification is actually useful for? If you were going
to say maybe it makes sense for when you can't send ROAMED, but still
connected again to the same network so you've already done the 4-way-HS 
at the time of the first notification - that I think makes sense.

But it seems that wpa_s moves all state machines to COMPLETE when it
sends the PMK to the device for offload, so it won't really care about
when that finished?

However, I think this might actually be a BAD thing, because it would
leave higher layers trying to do DHCP when the link isn't actually
ready yet.

(This, btw, is another problem we can solve with the EAPOL-over-nl80211 
since then we can set the carrier later when the port is authorized.)

So - I have no objections to this patch, but I think the double
notification needs to be revised, and if needed a separate notification
for "4-way-HS is done now" can be added.

johannes
