Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49935 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427Ab0FPTAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 15:00:08 -0400
Date: Wed, 16 Jun 2010 14:57:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] mac80211: Add interface for driver to temporarily
 disable dynamic ps
Message-ID: <20100616185706.GC3138@tuxdriver.com>
References: <1276668092-28872-1-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1276668092-28872-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 09:01:32AM +0300, Juuso Oikarinen wrote:
> This mechanism introduced in this patch applies (at least) for hardware
> designs using a single shared antenna for both WLAN and BT. In these designs,
> the antenna must be toggled between WLAN and BT.
> 
> In those hardware, managing WLAN co-existence with Bluetooth requires WLAN
> full power save whenever there is Bluetooth activity in order for WLAN to be
> able to periodically relinquish the antenna to be used for BT. This is because
> BT can only access the shared antenna when WLAN is idle or asleep.

Maybe it is just me, but

void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif)
void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif)

would make more sense than

void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
