Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35226 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0FRTPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 15:15:10 -0400
Date: Fri, 18 Jun 2010 15:12:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3] mac80211: Add interface for driver to temporarily
 disable dynamic ps
Message-ID: <20100618191225.GH6282@tuxdriver.com>
References: <1276753353-30310-1-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1276753353-30310-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 17, 2010 at 08:42:33AM +0300, Juuso Oikarinen wrote:
> This mechanism introduced in this patch applies (at least) for hardware
> designs using a single shared antenna for both WLAN and BT. In these designs,
> the antenna must be toggled between WLAN and BT.
> 
> In those hardware, managing WLAN co-existence with Bluetooth requires WLAN
> full power save whenever there is Bluetooth activity in order for WLAN to be
> able to periodically relinquish the antenna to be used for BT. This is because
> BT can only access the shared antenna when WLAN is idle or asleep.
> 
> Some hardware, for instance the wl1271, are able to indicate to the host
> whenever there is BT traffic. In essence, the hardware will send an indication
> to the host whenever there is, for example, SCO traffic or A2DP traffic, and
> will send another indication when the traffic is over.
> 
> The hardware gets information of Bluetooth traffic via hardware co-existence
> control lines - these lines are used to negotiate the shared antenna
> ownership. The hardware will give the antenna to BT whenever WLAN is sleeping.
> 
> This patch adds the interface to mac80211 to facilitate temporarily disabling
> of dynamic power save as per request of the WLAN driver. This interface will
> immediately force WLAN to full powersave, hence allowing BT coexistence as
> described above.
> 
> In these kind of shared antenna desings, when WLAN powersave is fully disabled,
> Bluetooth will not work simultaneously with WLAN at all. This patch does not
> address that problem. This interface will not change PSM state, so if PSM is
> disabled it will remain so. Solving this problem requires knowledge about BT
> state, and is best done in user-space.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
> v3: separate ieee80211_dyn_ps_enable/ieee80211_dyn_ps_enable functions

  CC [M]  net/mac80211/mlme.o
net/mac80211/mlme.c: In function ‘ieee80211_recalc_ps’:
net/mac80211/mlme.c:598: error: ‘struct ieee80211_conf’ has no member named ‘dynamic_ps_forced_timeout’
make[1]: *** [net/mac80211/mlme.o] Error 1

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
