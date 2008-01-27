Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33510 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753119AbYA0NZz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 08:25:55 -0500
Date: Sun, 27 Jan 2008 14:22:48 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lars <Lars_Ericsson@telia.com>, linux-wireless@vger.kernel.org
Subject: mac80211 refcounting bug was: [PATCH 2/2] rc80211-pid: add sanity
 check
Message-ID: <20080127142248.3e76b237@morte> (sfid-20080127_132608_564019_CB502EE3)
In-Reply-To: <20080127134252.776cebd6@morte>
References: <20080126040534.005e6736@morte>
	<200801261219.34805.mb@bu3sch.de>
	<loom.20080126T193518-105@post.gmane.org>
	<20080127134252.776cebd6@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I tried to switch my AP to 802.11b only mode while associated:

Jan 27 14:00:43 morte [155681.801606] wlan0: RX deauthentication from 00:14:c1:35:8d:eb (reason=7)
Jan 27 14:00:43 morte [155681.801617] wlan0: deauthenticated
Jan 27 14:00:43 morte [155681.802802] wlan0: RX deauthentication from 00:14:c1:35:8d:eb (reason=7)
Jan 27 14:00:43 morte [155681.804121] wlan0: RX deauthentication from 00:14:c1:35:8d:eb (reason=7)
Jan 27 14:00:44 morte [155682.802888] wlan0: authenticate with AP 00:14:c1:35:8d:eb
Jan 27 14:00:44 morte [155682.805754] wlan0: RX authentication from 00:14:c1:35:8d:eb (alg=0 transaction=2 status=0)
Jan 27 14:00:44 morte [155682.805765] wlan0: authenticated
Jan 27 14:00:44 morte [155682.805773] wlan0: associate with AP 00:14:c1:35:8d:eb
Jan 27 14:00:44 morte [155682.807605] wlan0: RX ReassocResp from 00:14:c1:35:8d:eb (capab=0x1 status=0 aid=2)
Jan 27 14:00:44 morte [155682.807616] wlan0: associated
Jan 27 14:00:44 morte [155682.807629] wlan0: CTS protection enabled (BSSID=00:14:c1:35:8d:eb)
Jan 27 14:00:44 morte [155682.807638] wlan0: switched to long barker preamble (BSSID=00:14:c1:35:8d:eb)
Jan 27 14:00:44 morte [155682.836860] phy1: HW CONFIG: freq=2412
Jan 27 14:00:44 morte [155682.905834] phy1: HW CONFIG: freq=2417
Jan 27 14:00:45 morte [155682.974769] phy1: HW CONFIG: freq=2422
Jan 27 14:00:45 morte [155683.044555] phy1: HW CONFIG: freq=2427
Jan 27 14:00:45 morte [155683.112670] phy1: HW CONFIG: freq=2432
Jan 27 14:00:45 morte [155683.185615] phy1: HW CONFIG: freq=2437
Jan 27 14:00:45 morte [155683.254569] phy1: HW CONFIG: freq=2442
Jan 27 14:00:45 morte [155683.323524] phy1: HW CONFIG: freq=2447
Jan 27 14:00:45 morte [155683.393472] phy1: HW CONFIG: freq=2452
Jan 27 14:00:45 morte [155683.463473] phy1: HW CONFIG: freq=2457
Jan 27 14:00:45 morte [155683.532372] phy1: HW CONFIG: freq=2462
Jan 27 14:00:45 morte [155683.601635] phy1: HW CONFIG: freq=2462
Jan 27 14:01:42 morte [155740.006762] phy1: HW CONFIG: freq=2462
Jan 27 14:01:42 morte [155740.006803] wlan0: Initial auth_alg=0
Jan 27 14:01:42 morte [155740.006817] wlan0: authenticate with AP 00:14:c1:35:8d:eb
Jan 27 14:01:42 morte [155740.009325] wlan0: RX authentication from 00:14:c1:35:8d:eb (alg=0 transaction=2 status=0)
Jan 27 14:01:42 morte [155740.009336] wlan0: authenticated
Jan 27 14:01:42 morte [155740.009343] wlan0: associate with AP 00:14:c1:35:8d:eb
Jan 27 14:01:42 morte [155740.020796] wlan0: RX ReassocResp from 00:14:c1:35:8d:eb (capab=0x1 status=0 aid=2)
Jan 27 14:01:42 morte [155740.020806] wlan0: associated

Everything fine so far. Then, I wanted to unload mac80211, so I unloaded b43:
Jan 27 14:01:52 morte [155750.360286] b43-phy1 debug: Removing Interface type 2
Jan 27 14:01:52 morte [155750.412133] b43-phy1 debug: Wireless interface stopped
Jan 27 14:01:52 morte [155750.412331] b43-phy1 debug: DMA-32 0x0200 (RX) max used slots: 2/64
Jan 27 14:01:52 morte [155750.412462] b43-phy1 debug: DMA-32 0x02A0 (TX) max used slots: 0/128
Jan 27 14:01:52 morte [155750.414389] b43-phy1 debug: DMA-32 0x0280 (TX) max used slots: 0/128
Jan 27 14:01:52 morte [155750.416248] b43-phy1 debug: DMA-32 0x0260 (TX) max used slots: 0/128
Jan 27 14:01:52 morte [155750.418243] b43-phy1 debug: DMA-32 0x0240 (TX) max used slots: 0/128
Jan 27 14:01:52 morte [155750.420245] b43-phy1 debug: DMA-32 0x0220 (TX) max used slots: 128/128
Jan 27 14:01:52 morte [155750.422242] b43-phy1 debug: DMA-32 0x0200 (TX) max used slots: 0/128

Still fine. Then, I unloaded mac80211, but:
Jan 27 14:01:52 morte [155750.497798] phy1: Removed STA 00:14:c1:35:8d:eb
Jan 27 14:02:02 morte [155760.685067] unregister_netdevice: waiting for wlan0 to become free. Usage count = 1
Jan 27 14:02:12 morte [155770.782896] unregister_netdevice: waiting for wlan0 to become free. Usage count = 1
Jan 27 14:02:22 morte [155780.872092] unregister_netdevice: waiting for wlan0 to become free. Usage count = 1
Jan 27 14:02:33 morte [155790.960683] unregister_netdevice: waiting for wlan0 to become free. Usage count = 1

And even rmmod -f couldn't do that. Johannes, any clue?


--
Ciao
Stefano
