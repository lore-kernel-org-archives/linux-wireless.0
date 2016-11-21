Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34684 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754494AbcKUMuz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 07:50:55 -0500
Message-ID: <1479732652.8662.21.camel@sipsolutions.net> (sfid-20161121_135101_038818_641757AB)
Subject: Re: [PATCH v7 1/2] nl80211: multicast_to_unicast can be changed
 while IFF_UP
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Date: Mon, 21 Nov 2016 13:50:52 +0100
In-Reply-To: <1477921260-24556-1-git-send-email-michael-dev@fami-braun.de>
References: <1477921260-24556-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-31 at 14:40 +0100, Michael Braun wrote:
> There is no need to prevent toggling multicast_to_unicast while
> interface is already up. This change simplifies reconfiguration
> from hostapd.

Applied. This check never should've been there anyway, if desired,
NEED_NETDEV_UP should've been used.

johannes
