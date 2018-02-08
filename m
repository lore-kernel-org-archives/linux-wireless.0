Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0092.outbound.protection.outlook.com ([104.47.0.92]:17040
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750806AbeBHJtb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 04:49:31 -0500
From: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211 scan results, signal value not reliable
Date: Thu, 8 Feb 2018 09:49:28 +0000
Message-ID: <AM4PR0101MB23058FC2795B1FAF71CBF4F2E4F30@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180208_104936_856405_3756BBC7)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D----------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D-----=
-----=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D----------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Hello list,

In net/mac80211/scan.c, function ieee80211_bss_info_update() passes
incoming scan results to the generic wireless layer, with indication of
the received signal level, but no indication of signal validity.

Before ieee80211_bss_info_update() is called, rx_status->flag can be set
to RX_FLAG_NO_SIGNAL_VAL by the ath9k driver and it won't be taken into
account in the wireless layer.
Even later in ieee80211_bss_info_update(), rx_status->flag can also be set
to RX_FLAG_NO_SIGNAL_VAL, and the wireless layer won't be aware of this.

I stumbled on this because, when using ath9k (WLE350NX) to do a passive sca=
n
off-channel, the beacons received in a 30ms window after channel change sho=
w
a signal level +10dB above the real value. So I was looking for a way to
tell the above layers that the signal is invalid. RX_FLAG_NO_SIGNAL_VAL see=
ms
to fit, but is not conveyed up to iw or wpa_supplicant.

In fact I did not find any such thing in net/wireless/nl80211.c, function
nl80211_send_bss().

Any suggestion? Did I miss something?

Regards,
Jean-Pierre
