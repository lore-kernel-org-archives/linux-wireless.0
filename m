Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:24424 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0E0MFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 08:05:12 -0400
Subject: Re: [RFC PATCHv6] mac80211: Add support for hardware ARP query
 filtering
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274960825.3669.37.camel@jlt3.sipsolutions.net>
References: <1274960533-395-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274960825.3669.37.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 15:07:01 +0300
Message-ID: <1274962021.5277.3575.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 13:47 +0200, ext Johannes Berg wrote:
> On Thu, 2010-05-27 at 14:42 +0300, Juuso Oikarinen wrote:
> > Some hardware allow extended filtering of ARP frames not intended for
> > the host. To perform such filtering, the hardware needs to know the current
> > IP address(es) of the host, bound to its interface.
> > 
> > Add support for ARP filtering to mac80211 by adding a new op to the driver
> > interface, allowing to configure the current IP addresses. This op is called
> > upon association with the currently configured address(es), and when
> > associated whenever the IP address(es) change.
> > 
> > This patch adds configuration of IPv4 addresses only, as IPv6 addresses don't
> > need ARP filtering.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Yay.
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 

YAY! :D

> 
> Hmm. Actually, something I just thought of during our IRC discussion,
> should we turn it off when we disassociate or something? Do we even
> care? I guess not since it'll be reconfigured after the next
> association?
> 

This is how I was thinking. After disassociation we shouldn't be seeing
data frames anyway, and on next assoc, we set the addresses again.

-Juuso

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


