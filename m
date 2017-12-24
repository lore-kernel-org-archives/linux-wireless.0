Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35710 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdLXMTP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Dec 2017 07:19:15 -0500
Received: by mail-wm0-f68.google.com with SMTP id f9so28846630wmh.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Dec 2017 04:19:14 -0800 (PST)
Date: Sun, 24 Dec 2017 13:19:06 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <20171221142558.GB4655@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain> (sfid-20171224_132031_810030_9E854E4B)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain> <20171213152017.GA3554@redhat.com> <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain> <20171218152142.GA15414@redhat.com> <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain> <20171219125431.GB2672@redhat.com> <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain> <20171221142558.GB4655@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
Unfortunately, the error di appear again. Still, I experienced no stalls.
But i am starting to think this doesn't happen necessarily when a device is going out of range. Now I think I don't know when this triggers.

Here is my log. I don't think it's useful, still:

Note: the two patches you so kidnly sent me / written, are applied; and the mmio workaround patch has been removed from queue.
This is an TP-Link Archer MR200, running OpenWRT.

Marry Christmas and happy new year to you Stanislaw, and to all of you reading this message.
thank you a lot for your help and support.
Enrico



Sun Dec 24 10:06:00 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disconnected due to excessive missing ACKs
Sun Dec 24 10:06:00 2017 daemon.notice hostapd: wlan0: AP-STA-DISCONNECTED xx:xx:xx:xx:xx:xx
Sun Dec 24 10:06:30 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)
Sun Dec 24 10:06:46 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
Sun Dec 24 10:06:46 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated (aid 1)
Sun Dec 24 10:06:46 2017 daemon.notice hostapd: wlan0: AP-STA-CONNECTED xx:xx:xx:xx:xx:xx
Sun Dec 24 10:06:46 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx WPA: pairwise key handshake completed (RSN)
Sun Dec 24 10:10:50 2017 authpriv.info dropbear[840]: Exit (root): Disconnect received
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.616638] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.626106] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.635562] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.645008] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.654452] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.663896] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.673340] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.682785] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.692230] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.701674] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.711118] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.720563] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.729984] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.739423] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.748862] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.758306] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.767737] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.777176] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.786616] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.796054] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.805497] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.814936] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.824376] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.833816] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.843264] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.852704] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.862143] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.871582] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.881029] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.890469] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.899894] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.909334] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.918773] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.928213] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.937642] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.947081] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.956520] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.965959] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.975402] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.984843] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.994282] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.003721] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.013160] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.022599] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.032038] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.041477] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.050920] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.060362] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.069780] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.079218] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.088656] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.098095] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.107524] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.116963] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.126406] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.135848] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.145287] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.154727] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.164165] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.173604] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.183043] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.192482] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.201926] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1511.211369] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.603490] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.612962] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.622416] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.631867] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.641313] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.650759] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.660204] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.669646] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.679090] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.688532] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.697976] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.707400] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.716851] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.726292] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.735731] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.745170] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.754609] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.764047] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.773487] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.782926] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.792364] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.801803] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.811242] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.820681] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.830120] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.839559] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.848998] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:25:20 2017 kern.err kernel: [ 1933.858436] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:31:23 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disconnected due to excessive missing ACKs
Sun Dec 24 11:31:23 2017 daemon.notice hostapd: wlan0: AP-STA-DISCONNECTED xx:xx:xx:xx:xx:xx
Sun Dec 24 11:31:24 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
Sun Dec 24 11:31:24 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated (aid 1)
Sun Dec 24 11:31:24 2017 daemon.notice hostapd: wlan0: AP-STA-CONNECTED xx:xx:xx:xx:xx:xx
Sun Dec 24 11:31:24 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx WPA: pairwise key handshake completed (RSN)
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.086116] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.095584] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.105040] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.114485] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.123932] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.133376] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.142819] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.152263] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.161705] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.171148] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.180600] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.190025] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.199467] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.208908] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.218346] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.227776] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.237215] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.246653] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.256092] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.265531] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.274969] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.284408] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.293847] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.303286] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.312724] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.322163] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.331610] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.341052] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.350491] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.359909] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.369348] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.378788] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.388226] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.397655] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.407098] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.416540] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.425979] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.435418] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.444857] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.454295] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.463734] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.473172] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.482615] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.492057] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.501504] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.510944] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.520382] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.529801] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.539238] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.548686] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.558120] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.567568] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.577009] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.586451] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.595892] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.605331] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.614770] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.624213] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.633658] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.643101] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.652539] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.661978] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.671417] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 11:48:34 2017 kern.err kernel: [ 2403.680861] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sun Dec 24 13:08:38 2017 authpriv.info dropbear[1297]: Child connection from 192.168.0.4:49276
Sun Dec 24 13:08:44 2017 authpriv.notice dropbear[1297]: Password auth succeeded for 'root' from 192.168.0.4:49276
