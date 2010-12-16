Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:59735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0LPQCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 11:02:30 -0500
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id oBGG2SHR001838
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 08:02:29 -0800
Received: from iwn38 (iwn38.prod.google.com [10.241.68.102])
	by wpaz33.hot.corp.google.com with ESMTP id oBGG2R3g025746
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 08:02:27 -0800
Received: by iwn38 with SMTP id 38so3900669iwn.36
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 08:02:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292504020.3612.17.camel@jlt3.sipsolutions.net>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	<1292482775.3542.8.camel@jlt3.sipsolutions.net>
	<AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	<1292499024.3612.3.camel@jlt3.sipsolutions.net>
	<AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
	<1292501047.3612.9.camel@jlt3.sipsolutions.net>
	<AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
	<1292502934.3612.15.camel@jlt3.sipsolutions.net>
	<AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
	<1292504020.3612.17.camel@jlt3.sipsolutions.net>
Date: Thu, 16 Dec 2010 08:02:27 -0800
Message-ID: <AANLkTinWkYK2Zu1LsKw9YQ4dAXJ2b_quEvZLc59-c_5q@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 4:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 04:46 -0800, Paul Stewart wrote:
> Not really -- the driver may throw away all internal state, mac80211
> will (attempt to) restore it all through drv_config() with changed = ~0.
> Evidently ath9k has some magic that makes this fail?

The magic in question is as follows (ath9k_config()):

    if (changed & IEEE80211_CONF_CHANGE_IDLE) {
        bool enable_radio;
        bool all_wiphys_idle;
        bool idle = !!(conf->flags & IEEE80211_CONF_IDLE);

        spin_lock_bh(&sc->wiphy_lock);
        all_wiphys_idle =  ath9k_all_wiphys_idle(sc);
       ath9k_set_wiphy_idle(aphy, idle);

        enable_radio = (!idle && all_wiphys_idle);

        /*
         * After we unlock here its possible another wiphy
         * can be re-renabled so to account for that we will
         * only disable the radio toward the end of this routine
         * if by then all wiphys are still idle.
         */
        spin_unlock_bh(&sc->wiphy_lock);

        if (enable_radio) {
            sc->ps_idle = false;
            ath_radio_enable(sc, hw);
            ath_dbg(common, ATH_DBG_CONFIG,
                    "not-idle: enabling radio\n");
        }
    }

So, ath9k enables and disables the radio based on ps_idle (the
internal state), but that's not re-evaluated unless the wiphys
actually change.  In this case they do not change because ath9k was
never informed that the wiphy went idle (all_wiphys_idle evaluates to
false).  One solution would be to do an ah9k_set_wiphy_idle(aphy,
true) in ath9k_stop() instead of Luis' previous suggestion of setting
sc->ps_idle directly.  Perhaps in January when I return from vacation
I'll test this to make sure that performs as intended in the
suspend-resume-while-associated case.  It's a little bit of a lie to
do it in this case since in fact as far as mac80211 is concerned, the
wiphy is not idle in this case.

--
Paul
