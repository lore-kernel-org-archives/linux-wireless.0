Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18330 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0FQEuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 00:50:04 -0400
Subject: Re: [PATCHv2] mac80211: Add interface for driver to temporarily
 disable dynamic ps
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100616185706.GC3138@tuxdriver.com>
References: <1276668092-28872-1-git-send-email-juuso.oikarinen@nokia.com>
	 <20100616185706.GC3138@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 07:49:49 +0300
Message-ID: <1276750189.5277.43139.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-16 at 20:57 +0200, ext John W. Linville wrote:
> On Wed, Jun 16, 2010 at 09:01:32AM +0300, Juuso Oikarinen wrote:
> > This mechanism introduced in this patch applies (at least) for hardware
> > designs using a single shared antenna for both WLAN and BT. In these designs,
> > the antenna must be toggled between WLAN and BT.
> > 
> > In those hardware, managing WLAN co-existence with Bluetooth requires WLAN
> > full power save whenever there is Bluetooth activity in order for WLAN to be
> > able to periodically relinquish the antenna to be used for BT. This is because
> > BT can only access the shared antenna when WLAN is idle or asleep.
> 
> Maybe it is just me, but
> 
> void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif)
> void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif)
> 
> would make more sense than
> 
> void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable)

Well.. can't argue with that ;)

I'll submit v3 shortly.

-Juuso

> John


