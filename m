Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41276 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752607AbcJLHMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 03:12:55 -0400
Message-ID: <1476256370.5271.2.camel@sipsolutions.net> (sfid-20161012_091258_793242_641F9EDC)
Subject: Re: [PATCHv2 1/3] mac80211: fix CMD_FRAME for AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 12 Oct 2016 09:12:50 +0200
In-Reply-To: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161003_131427_265805_ADB81E75)
References: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de>
         (sfid-20161003_131427_265805_ADB81E75)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-03 at 13:14 +0200, Michael Braun wrote:
> When using IEEE 802.11r FT OVER-DS roaming with AP_VLAN, hostapd
> needs to
> send out a frame using CMD_FRAME for a station assigned to an AP_VLAN
> interface.
> 
> Right now, the userspace needs to give the exact AP_VLAN interface
> index
> for CMD_FRAME; hostapd does not do this. Additionally, userspace
> cannot
> use GET_STATION to query the AP_VLAN ifidx, as while GET_STATION
> finds
> stations assigned to AP_VLAN even if the AP iface is queried, it does
> not
> return AP_VLAN ifidx (it returns the queried one).
> 
> This breaks IEEE 802.11r over_ds with vlans, as the reply frame does
> not
> get out. This patch fixes this by using get_sta_bss for CMD_FRAME.
> 
Applied, thanks.

johannes
