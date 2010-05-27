Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0E0LrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 07:47:06 -0400
Subject: Re: [RFC PATCHv6] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1274960533-395-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1274960533-395-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 13:47:05 +0200
Message-ID: <1274960825.3669.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 14:42 +0300, Juuso Oikarinen wrote:
> Some hardware allow extended filtering of ARP frames not intended for
> the host. To perform such filtering, the hardware needs to know the current
> IP address(es) of the host, bound to its interface.
> 
> Add support for ARP filtering to mac80211 by adding a new op to the driver
> interface, allowing to configure the current IP addresses. This op is called
> upon association with the currently configured address(es), and when
> associated whenever the IP address(es) change.
> 
> This patch adds configuration of IPv4 addresses only, as IPv6 addresses don't
> need ARP filtering.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Yay.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>


Hmm. Actually, something I just thought of during our IRC discussion,
should we turn it off when we disassociate or something? Do we even
care? I guess not since it'll be reconfigured after the next
association?

johannes

