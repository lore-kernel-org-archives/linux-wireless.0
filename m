Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49741 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932335AbcJQKjh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 06:39:37 -0400
Message-ID: <1476700771.19992.20.camel@sipsolutions.net> (sfid-20161017_123940_278970_3E5D08AB)
Subject: Re: [Projekt-wlan] [PATCHv5 2/2] mac80211: fix A-MSDU outer SA/DA
From: Johannes Berg <johannes@sipsolutions.net>
To: michael-dev <michael-dev@fami-braun.de>
Cc: projekt-wlan@fem.tu-ilmenau.de, Fietkau <nbd@openwrt.org>,
        Felix@mail.fem.tu-ilmenau.de, linux-wireless@vger.kernel.org
Date: Mon, 17 Oct 2016 12:39:31 +0200
In-Reply-To: <d793195b149aebb974dd596632d2ba83@fami-braun.de>
References: <1476530899-24241-1-git-send-email-michael-dev@fami-braun.de>
         <1476530899-24241-2-git-send-email-michael-dev@fami-braun.de>
         <1476697463.19992.18.camel@sipsolutions.net>
         <d793195b149aebb974dd596632d2ba83@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-17 at 12:29 +0200, michael-dev wrote:
> 
> ether_addr_copy requires both arguments to be __aligned(2) according
> to 
> include/linux/etherdevice.h.
> bssid might be sdata->u.mgd.bssid, which is bssid in struct 
> ieee80211_if_managed, but neither sdata->u, sdata->u.mgd nor 
> sdata->u.mgd.bssid seem to be declared as __aligned(2).So
> ether_addr_copy should not be used.

They are in fact aligned today, given that they occur after a pointer.
However, I did add the __aligned(2) annotation to make that plenty
clear for the future.

johannes
