Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49160 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab1AKL2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 06:28:21 -0500
Subject: Re: wl12xx compat wireless rcu_read_lock issue
From: Luciano Coelho <coelho@ti.com>
To: "DE CESCO, Jonathan" <jonathanc@ti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>
In-Reply-To: <13872098A06B02418CF379A158C0F146015BEB592B@dnce02.ent.ti.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	 <1294062164-3459-2-git-send-email-shahar_levi@ti.com>
	 <1294671655.1992.103.camel@pimenta>
	 <AANLkTi=KnSjVVCN=9=PaL9_GYpDOpJFvD-LGxFXEevhw@mail.gmail.com>
	 <AANLkTimpDo=0AcL5OdEjnpB8-_o7XBJ5QT-mE-FmfZo6@mail.gmail.com>
	 <13872098A06B02418CF379A158C0F146015BEB592B@dnce02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 13:28:20 +0200
Message-ID: <1294745300.12992.90.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 11:22 +0100, DE CESCO, Jonathan wrote:
> Hi,
> 
> When trying to test wl12xx driver from compat-wireless-2010-12-13 (with a wl1273 device), I notice a crash when initializing the wlan interface.
> 
> Find below the patch that seems to solve the issue:
> 
> diff --git a/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c b/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c
> index 1fc5a36..480f44b 100644
> --- a/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c
> +++ b/compat-wireless-2010-12-13/drivers/net/wireless/wl12xx/main.c
> @@ -1858,11 +1858,17 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>  {
>             enum wl1271_cmd_ps_mode mode;
>             struct wl1271 *wl = hw->priv;
> -           struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
> +          rcu_read_lock();
> +          struct ieee80211_sta *sta;
>             bool do_join = false;
>             bool set_assoc = false;
>             int ret;
> 
> +          sta = ieee80211_find_sta(vif, bss_conf->bssid);
> +          if (!sta) {
> +                      rcu_read_unlock();
> +                      return;
> +          }
> 
>             wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
> +     	rcu_read_unlock();
>             mutex_lock(&wl->mutex);
> 
> --
> 
> Is this a known bug that has already been encountered? I am using the compat wireless flavor of the mac80211 framework and driver so I don't really know if you can come across this issue with standard kernel.

I hadn't seen it before, but then again, I just integrated the AP
patches which added this code.  The code has been tested quite well
before, but indeed this is broken.

We need to lock the RCU before calling ieee80211_find_sta() and also
whenever we access the resulting pointer.

In your patch, the if (!sta) part is wrong, because we still do lots of
things in this function even if sta is NULL.  So that if can be removed.

Also, because the RCU lock needs to be held when the returned pointer is
accessed, we should hold it until the end of the function.

>From mac80211 documentation:

/**
 * ieee80211_find_sta - find a station
 *
 * @vif: virtual interface to look for station on
 * @addr: station's address
 *
 * This function must be called under RCU lock and the
 * resulting pointer is only valid under RCU lock as well.
 */

Thanks for reporting this!

-- 
Cheers,
Luca.

