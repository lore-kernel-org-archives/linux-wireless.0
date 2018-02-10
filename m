Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34434 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbeBJVJP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 16:09:15 -0500
Message-ID: <1518296953.2029.6.camel@sipsolutions.net> (sfid-20180210_220918_447545_A931BEAB)
Subject: Re: mac80211 scan results, signal value not reliable
From: Johannes Berg <johannes@sipsolutions.net>
To: Jean Pierre TOSONI <jp.tosoni@acksys.fr>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 10 Feb 2018 22:09:13 +0100
In-Reply-To: <AM4PR0101MB23058FC2795B1FAF71CBF4F2E4F30@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180208_104936_856405_3756BBC7)
References: <AM4PR0101MB23058FC2795B1FAF71CBF4F2E4F30@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
         (sfid-20180208_104936_856405_3756BBC7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-02-08 at 09:49 +0000, Jean Pierre TOSONI wrote:

> In net/mac80211/scan.c, function ieee80211_bss_info_update() passes
> incoming scan results to the generic wireless layer, with indication of
> the received signal level, but no indication of signal validity.

Well, there is an indication of validity, if the value is 0 then it's
invalid.

> Before ieee80211_bss_info_update() is called, rx_status->flag can be set
> to RX_FLAG_NO_SIGNAL_VAL by the ath9k driver and it won't be taken into
> account in the wireless layer.
> Even later in ieee80211_bss_info_update(), rx_status->flag can also be set
> to RX_FLAG_NO_SIGNAL_VAL, and the wireless layer won't be aware of this.

However, it looks like you're right and ieee80211_bss_info_update()
doesn't take the flag into account. Bit strange that we even have the
flag I guess, since we treat 0 as an invalid value in various places,
being too high power to realistically receive anyway.

> I stumbled on this because, when using ath9k (WLE350NX) to do a passive scan
> off-channel, the beacons received in a 30ms window after channel change show
> a signal level +10dB above the real value. So I was looking for a way to
> tell the above layers that the signal is invalid. RX_FLAG_NO_SIGNAL_VAL seems
> to fit, but is not conveyed up to iw or wpa_supplicant.
> 
> In fact I did not find any such thing in net/wireless/nl80211.c, function
> nl80211_send_bss().
> 
> Any suggestion? Did I miss something?

Want to send a patch? There seem to be a few more places as well, e.g.
in rx.c for cfg80211_report_obss_beacon() and cfg80211_rx_mgmt().

johannes
