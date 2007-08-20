Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astro.systems.pipex.net ([62.241.163.6]:51269 "EHLO
	astro.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762960AbXHTUVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 16:21:42 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
Date: Mon, 20 Aug 2007 21:21:35 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
References: <200708082324.17186.linux@baker-net.org.uk> <200708162243.05809.linux@baker-net.org.uk> <1187345617.23489.143.camel@johannes.berg>
In-Reply-To: <1187345617.23489.143.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708202121.35543.linux@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 August 2007 11:13, Johannes Berg wrote:
>
> Hm. Maybe you could disable verbose debugging in the ralink drivers to
> get a lower printk rate; however, this is weird, I think I'll have to
> try to reproduce it.
>
I've instead obtained a faster terminal, taken out the printk on ieee80211_master_start_xmit
as that wasn't telling us much and added a couple more printk's

One is in ieee80211_if_set_type at the only point where I can see u.ap.ps_bc_buf could get
initialised and as I suspected that doesn't get called.
        case IEEE80211_IF_TYPE_AP:
                sdata->u.ap.dtim_period = 2;
                sdata->u.ap.force_unicast_rateidx = -1;
                sdata->u.ap.max_ratectrl_rateidx = -1;
                skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
                printk( KERN_DEBUG "Initiatilsing ps_bc_buf at %p\n",&sdata->u.ap.ps_bc_buf);
                sdata->bss = &sdata->u.ap;
                break;

The other is in ieee80211_tx_h_multicast_ps_buf just before tx->sdata->bss->ps_bc_buf gets
used. I haven't quite followed what ap structure bss should be pointing to at that time but I'm
presuming whatever it is doesn't contain an initialised ps_bc_buf hence the lock failure.

                printk( KERN_INFO "About to queue skb %p to buffer %p\n",tx->skb, &tx->sdata->bss->ps_bc_buf);
                skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);



[ 1358.490901] phy4 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt73.bin'.
[ 1358.509476] phy4 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 1.7.
[ 1358.565453] phy4 -> rt73usb_init_bbp: Debug - Start initialization from EEPROM...
[ 1358.573378] phy4 -> rt73usb_init_bbp: Debug - ...End initialization from EEPROM.
[ 1358.586965] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1358.619446] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1358.627387] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1358.634066] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1358.648203] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1358.682333] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1358.699790] phy4 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - CWmin: 4, CWmax: 10, Aifs: 2.
[ 1358.709530] phy4 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - CWmin: 4, CWmax: 10, Aifs: 2.
[ 1358.719248] phy4 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - CWmin: 4, CWmax: 10, Aifs: 2.
[ 1358.728958] phy4 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - CWmin: 4, CWmax: 10, Aifs: 2.
[ 1358.738673] phy4 -> rt2x00mac_conf_tx: Info - Configured TX ring 4 - CWmin: 4, CWmax: 10, Aifs: 2.
[ 1358.748367] phy4 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - CWmin: 5, CWmax: 10, Aifs: 2.
[ 1358.758042] wlan1: Trigger new scan to find an IBSS to join
[ 1358.784674] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1358.793919] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1358.855430] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1358.863375] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1358.870162] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1358.899358] HW CONFIG: channel=2 freq=2417 phymode=3
[ 1358.959295] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1358.967225] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1358.973893] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.003330] HW CONFIG: channel=3 freq=2422 phymode=3
[ 1359.063266] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.071184] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.077874] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.108220] HW CONFIG: channel=4 freq=2427 phymode=3
[ 1359.168078] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.175982] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.182725] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.211205] HW CONFIG: channel=5 freq=2432 phymode=3
[ 1359.271307] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.279236] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.285962] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.315170] HW CONFIG: channel=6 freq=2437 phymode=3
[ 1359.375181] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.383120] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.389943] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.419206] HW CONFIG: channel=7 freq=2442 phymode=3
[ 1359.479142] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.487076] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.493800] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.523180] HW CONFIG: channel=8 freq=2447 phymode=3
[ 1359.583111] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.591058] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.597781] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.628117] HW CONFIG: channel=9 freq=2452 phymode=3
[ 1359.688023] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.695949] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.702763] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.731052] HW CONFIG: channel=10 freq=2457 phymode=3
[ 1359.791063] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.798986] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.805742] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.835016] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1359.895016] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.902930] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.909723] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1359.916100] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1359.943001] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1359.963638] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1359.971435] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1359.978005] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1360.013076] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.115434] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.217788] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.320146] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.326786] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1360.334677] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1360.341392] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1360.422630] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.524985] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.627341] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.729697] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.832054] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1360.934408] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.036766] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.139125] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.211736] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.218304] wmaster0: Adding new IBSS station 00:19:4f:9e:b8:ba (dev=wlan1)
[ 1361.225846] wmaster0: Added STA 00:19:4f:9e:b8:ba
[ 1361.241481] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.343960] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.446316] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.548676] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.651027] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.753388] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.855746] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1361.958098] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1362.051290] wlan1: Trigger new scan to find an IBSS to join
[ 1362.060453] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1362.086345] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1362.146344] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.154277] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.161066] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.191366] HW CONFIG: channel=2 freq=2417 phymode=3
[ 1362.251197] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.259136] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.265923] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.294292] HW CONFIG: channel=3 freq=2422 phymode=3
[ 1362.354333] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.362276] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.369026] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.398294] HW CONFIG: channel=4 freq=2427 phymode=3
[ 1362.458345] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.466288] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.472913] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1362.479633] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.506218] HW CONFIG: channel=5 freq=2432 phymode=3
[ 1362.566263] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.574205] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1362.580754] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.587488] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.615234] HW CONFIG: channel=6 freq=2437 phymode=3
[ 1362.675134] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.683061] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.689847] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.718583] HW CONFIG: channel=7 freq=2442 phymode=3
[ 1362.778161] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.786115] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.792825] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.822124] HW CONFIG: channel=8 freq=2447 phymode=3
[ 1362.882126] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.890060] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1362.896811] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1362.926261] HW CONFIG: channel=9 freq=2452 phymode=3
[ 1362.986100] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1362.994041] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1363.000788] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1363.030137] HW CONFIG: channel=10 freq=2457 phymode=3
[ 1363.084146] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.094061] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1363.101980] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1363.108771] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1363.139114] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1363.186503] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.199095] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1363.207034] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1363.213755] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1363.242022] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1363.288983] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.391343] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.493699] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.596054] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.698411] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.800766] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1363.903128] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.005481] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.107839] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.210196] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.312675] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.415034] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.517387] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.525666] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1364.533607] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1364.540390] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1364.619749] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.722103] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.824461] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1364.926817] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1365.029173] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1365.131654] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1365.234011] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1365.319769] wlan1: Trigger new scan to find an IBSS to join
[ 1365.336363] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1365.358235] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1365.418412] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1365.426358] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1365.433100] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1365.461343] HW CONFIG: channel=2 freq=2417 phymode=3
[ 1365.521352] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1365.529292] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1365.536086] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1365.565303] HW CONFIG: channel=3 freq=2422 phymode=3
[ 1365.625307] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1365.633251] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1365.640067] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1365.669343] HW CONFIG: channel=4 freq=2427 phymode=3
[ 1365.729279] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1365.737197] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1365.743919] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1365.773309] HW CONFIG: channel=5 freq=2432 phymode=3
[ 1365.833244] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1365.841178] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1365.847900] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1365.854304] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1365.882301] HW CONFIG: channel=6 freq=2437 phymode=3
[ 1365.941254] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1365.949194] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1365.956009] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1365.986234] HW CONFIG: channel=7 freq=2442 phymode=3
[ 1366.046132] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1366.054054] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1366.060867] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1366.089151] HW CONFIG: channel=8 freq=2447 phymode=3
[ 1366.149157] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1366.157101] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1366.163843] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1366.193184] HW CONFIG: channel=9 freq=2452 phymode=3
[ 1366.253120] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1366.261036] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1366.267829] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1366.301950] HW CONFIG: channel=10 freq=2457 phymode=3
[ 1366.360060] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1366.373276] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1366.381212] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1366.387934] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1366.417060] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1366.462415] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1366.477056] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1366.484996] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1366.491792] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1366.521180] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1366.540954] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1366.548765] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1366.555400] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1366.564770] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1366.667126] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1366.769486] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1366.871842] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1366.974200] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.076679] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.179035] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.281396] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.383746] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.486103] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.588461] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.690815] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.793177] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.895530] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1367.997886] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1368.100371] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1368.202725] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1368.305081] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1368.407439] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1368.509794] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1368.604400] wlan1: Trigger new scan to find an IBSS to join
[ 1368.612152] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1368.640387] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1368.700481] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1368.708413] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1368.715140] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1368.745500] HW CONFIG: channel=2 freq=2417 phymode=3
[ 1368.805364] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1368.813309] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1368.820122] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1368.848329] HW CONFIG: channel=3 freq=2422 phymode=3
[ 1368.908331] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1368.916254] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1368.922974] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1368.952323] HW CONFIG: channel=4 freq=2427 phymode=3
[ 1369.012294] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.020236] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.026958] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.056328] HW CONFIG: channel=5 freq=2432 phymode=3
[ 1369.116367] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.124314] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.131064] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.160298] HW CONFIG: channel=6 freq=2437 phymode=3
[ 1369.220234] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.228155] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.234919] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.265141] HW CONFIG: channel=7 freq=2442 phymode=3
[ 1369.325188] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.333121] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.339904] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.368173] HW CONFIG: channel=8 freq=2447 phymode=3
[ 1369.428180] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.436091] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.442883] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.472233] HW CONFIG: channel=9 freq=2452 phymode=3
[ 1369.532145] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.540071] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.546863] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.576178] HW CONFIG: channel=10 freq=2457 phymode=3
[ 1369.636107] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.644030] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.650721] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.680149] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1369.738197] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1369.745442] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.753379] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.760197] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.789113] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1369.804027] wlan1: no IPv6 routers present
[ 1369.814985] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1369.822806] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1369.829372] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1369.840558] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1369.942913] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.045394] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.147752] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.250106] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.352461] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.358977] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 384
[ 1370.365430] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 384
[ 1370.371925] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 448
[ 1370.378426] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 384
[ 1370.384922] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 448
[ 1370.391428] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 384
[ 1370.397925] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 448
[ 1370.404421] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 448
[ 1370.410930] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 448
[ 1370.417422] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 448
[ 1370.454822] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.557181] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.659535] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.762014] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.864371] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1370.966726] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.069088] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.171442] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.273799] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.376152] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.478514] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.580869] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.683349] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.785710] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.888061] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1371.947429] wlan1: Trigger new scan to find an IBSS to join
[ 1371.979459] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1372.039397] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.047350] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.054038] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.083359] HW CONFIG: channel=2 freq=2417 phymode=3
[ 1372.151356] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.159291] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.166012] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.196260] HW CONFIG: channel=3 freq=2422 phymode=3
[ 1372.256213] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.264152] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.270875] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.299370] HW CONFIG: channel=4 freq=2427 phymode=3
[ 1372.359340] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.367288] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.374104] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.403305] HW CONFIG: channel=5 freq=2432 phymode=3
[ 1372.463332] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.471272] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.478087] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.502204] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1372.511359] HW CONFIG: channel=6 freq=2437 phymode=3
[ 1372.571230] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.579147] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.585941] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.616165] HW CONFIG: channel=7 freq=2442 phymode=3
[ 1372.650935] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1372.679206] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.687130] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.693921] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.723167] HW CONFIG: channel=8 freq=2447 phymode=3
[ 1372.783266] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.791197] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.797801] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1372.804525] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.831167] HW CONFIG: channel=9 freq=2452 phymode=3
[ 1372.891142] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1372.899065] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1372.905885] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1372.936081] HW CONFIG: channel=10 freq=2457 phymode=3
[ 1372.941601] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.003102] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1373.011049] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1373.017740] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1373.047140] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1373.107073] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1373.115005] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1373.121623] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.128342] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1373.155117] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1373.218825] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.232195] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.321183] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.423535] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.525893] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.628374] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.730728] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.833086] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1373.935442] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.037802] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.140157] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.242513] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.344870] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.447355] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.549706] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.652066] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.754419] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.856779] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1374.959133] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1375.061493] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1375.163849] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1375.200966] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1375.236983] wlan1: Trigger new scan to find an IBSS to join
[ 1375.266204] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1375.274417] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1375.335340] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1375.343287] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1375.350070] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1375.378378] HW CONFIG: channel=2 freq=2417 phymode=3
[ 1375.438424] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1375.446361] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1375.453176] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1375.482649] HW CONFIG: channel=3 freq=2422 phymode=3
[ 1375.542343] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1375.550278] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1375.557027] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1375.586376] HW CONFIG: channel=4 freq=2427 phymode=3
[ 1375.646323] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1375.654222] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1375.661014] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1375.690455] HW CONFIG: channel=5 freq=2432 phymode=3
[ 1375.750283] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1375.758204] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1375.764994] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1375.795285] HW CONFIG: channel=6 freq=2437 phymode=3
[ 1375.855104] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1375.863041] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1375.869854] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1375.898293] HW CONFIG: channel=7 freq=2442 phymode=3
[ 1375.958227] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1375.966166] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1375.972957] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1376.002187] HW CONFIG: channel=8 freq=2447 phymode=3
[ 1376.062252] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1376.070185] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1376.076934] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1376.106225] HW CONFIG: channel=9 freq=2452 phymode=3
[ 1376.166155] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1376.174107] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1376.180795] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1376.210222] HW CONFIG: channel=10 freq=2457 phymode=3
[ 1376.270128] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1376.278054] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1376.284771] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1376.315107] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1376.375077] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1376.383010] Leaving ieee80211_tx_h_multicast_ps_buf TXRX_CONTINUE
[ 1376.389752] phy4 -> rt2x00usb_interrupt_txdone: Debug - status 0
[ 1376.396133] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1376.426080] HW CONFIG: channel=11 freq=2462 phymode=3
[ 1376.494732] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1376.597092] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1376.699444] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1376.801806] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1376.904158] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.006520] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.108874] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.151117] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.157679] wlan1: STA 00:19:4f:9e:b8:ba aid 0 enters power save mode
[ 1377.211229] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.313714] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.416067] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.518421] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.620778] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.723134] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.825494] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1377.927852] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1378.030207] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1378.132564] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1378.234919] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1378.337401] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1378.439757] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1378.506770] wlan1: Trigger new scan to find an IBSS to join
[ 1378.537434] HW CONFIG: channel=1 freq=2412 phymode=3
[ 1378.542830] phy4 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[ 1378.605435] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[ 1378.613385] About to queue skb cd3cc3c0 to buffer c6eee910
[ 1378.619351] INFO: trying to register non-static key.
[ 1378.624717] the code is fine but needs lockdep annotation.
[ 1378.630651] turning off the locking correctness validator.
[ 1378.636560]  [<c01464f3>] __lock_acquire+0x573/0x1020
[ 1378.642062]  [<c01288b8>] vprintk+0x298/0x360
[ 1378.646815]  [<c0147000>] lock_acquire+0x60/0x80
[ 1378.651839]  [<c02c816c>] skb_queue_tail+0x1c/0x50
[ 1378.657055]  [<c0342e78>] _spin_lock_irqsave+0x38/0x50
[ 1378.662644]  [<c02c816c>] skb_queue_tail+0x1c/0x50
[ 1378.667805]  [<c02c816c>] skb_queue_tail+0x1c/0x50
[ 1378.672994]  [<e0ad9517>] ieee80211_tx_h_ps_buf+0xf7/0x3c0 [mac80211]
[ 1378.679991]  [<e0ae5b85>] sta_info_get+0x55/0x60 [mac80211]
[ 1378.686050]  [<e0adc5f5>] ieee80211_master_start_xmit+0x2b5/0x620 [mac80211]
[ 1378.693732]  [<c02ce64b>] dev_hard_start_xmit+0x1fb/0x2d0
[ 1378.699577]  [<c02df5c3>] __qdisc_run+0x53/0x1c0
[ 1378.704578]  [<c02df5ed>] __qdisc_run+0x7d/0x1c0
[ 1378.709609]  [<c02d09b2>] dev_queue_xmit+0x2e2/0x330
[ 1378.714984]  [<e0aec701>] ieee80211_sta_scan_work+0x201/0x240 [mac80211]
[ 1378.722229]  [<e0aec500>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 1378.729288]  [<c01459f7>] trace_hardirqs_on+0xb7/0x160
[ 1378.734850]  [<c0137f7e>] run_workqueue+0xe/0x150
[ 1378.739946]  [<e0aec500>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 1378.747036]  [<c013802f>] run_workqueue+0xbf/0x150
[ 1378.752229]  [<c0138a20>] worker_thread+0x0/0x100
[ 1378.757319]  [<c0138ac0>] worker_thread+0xa0/0x100
[ 1378.762502]  [<c013ba10>] autoremove_wake_function+0x0/0x50
[ 1378.768538]  [<c0138a20>] worker_thread+0x0/0x100
[ 1378.773623]  [<c013b762>] kthread+0x42/0x70
[ 1378.778125]  [<c013b720>] kthread+0x0/0x70
[ 1378.782539]  [<c0105537>] kernel_thread_helper+0x7/0x10
[ 1378.788220]  =======================
[ 1384.142553] BUG: NMI Watchdog detected LOCKUP on CPU0, eip c022d7fc, registers:
[ 1384.150444] Modules linked in: nls_cp437 isofs udf rfcomm l2cap bluetooth binfmt_misc cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_ondemand cpufreq_conservative freq_table video output battery container sbs fan thermal dock ac ipv6 nfs lockd sunrpc asb100 hwmon_vid lp rt2500usb arc4 ecb blkcipher rc80211_simple af_packet rt73usb rt2x00usb rt2x00lib input_polldev crc_itu_t mac80211 snd_ens1371 gameport snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss tsdev snd_pcm snd_timer 8139too serio_raw parport_pc evdev parport snd i2c_viapro i2c_core ehci_hcd psmouse floppy uhci_hcd via_ircc pcspkr soundcore snd_page_alloc 8139cp irda crc_ccitt mii shpchp usbcore pci_hotplug via_agp agpgart processor button
[ 1384.221432] CPU:    0
[ 1384.221433] EIP:    0060:[<c022d7fc>]    Not tainted VLI
[ 1384.221435] EFLAGS: 00000046   (2.6.23-rc3 #11)
[ 1384.234489] EIP is at _raw_spin_lock+0xac/0x150
[ 1384.239396] eax: 00000000   ebx: c6eee91c   ecx: fec8738b   edx: 6490a1cc
[ 1384.246734] esi: 0f1a13aa   edi: 00000000   ebp: 6b8ab266   esp: d8629d98
[ 1384.254036] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[ 1384.260333] Process rt73usb (pid: 4428, ti=d8628000 task=c7c1caa0 task.ti=d8628000)
[ 1384.268426] Stack: 00000041 00000046 c6eee92c c6eee91c ca60e028 00000001 6b8ab266 00000000 
[ 1384.277544]        c6eee91c 00000296 c6eee91c ca60e028 c0342e7f 00000000 00000002 c02c816c 
[ 1384.286797]        c6eee910 cd3cc3c0 c02c816c 00000000 d8629e5c 00000001 e0ad9517 e0afcf38 
[ 1384.295915] Call Trace:
[ 1384.298765]  [<c0342e7f>] _spin_lock_irqsave+0x3f/0x50
[ 1384.304319]  [<c02c816c>] skb_queue_tail+0x1c/0x50
[ 1384.309534]  [<c02c816c>] skb_queue_tail+0x1c/0x50
[ 1384.314753]  [<e0ad9517>] ieee80211_tx_h_ps_buf+0xf7/0x3c0 [mac80211]
[ 1384.321727]  [<e0ae5b85>] sta_info_get+0x55/0x60 [mac80211]
[ 1384.327788]  [<e0adc5f5>] ieee80211_master_start_xmit+0x2b5/0x620 [mac80211]
[ 1384.335471]  [<c02ce64b>] dev_hard_start_xmit+0x1fb/0x2d0
[ 1384.341315]  [<c02df5c3>] __qdisc_run+0x53/0x1c0
[ 1384.346317]  [<c02df5ed>] __qdisc_run+0x7d/0x1c0
[ 1384.351317]  [<c02d09b2>] dev_queue_xmit+0x2e2/0x330
[ 1384.356686]  [<e0aec701>] ieee80211_sta_scan_work+0x201/0x240 [mac80211]
[ 1384.363930]  [<e0aec500>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 1384.370993]  [<c01459f7>] trace_hardirqs_on+0xb7/0x160
[ 1384.376552]  [<c0137f7e>] run_workqueue+0xe/0x150
[ 1384.381625]  [<e0aec500>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 1384.388707]  [<c013802f>] run_workqueue+0xbf/0x150
[ 1384.393873]  [<c0138a20>] worker_thread+0x0/0x100
[ 1384.398962]  [<c0138ac0>] worker_thread+0xa0/0x100
[ 1384.404178]  [<c013ba10>] autoremove_wake_function+0x0/0x50
[ 1384.410208]  [<c0138a20>] worker_thread+0x0/0x100
[ 1384.415298]  [<c013b762>] kthread+0x42/0x70
[ 1384.419795]  [<c013b720>] kthread+0x0/0x70
[ 1384.424205]  [<c0105537>] kernel_thread_helper+0x7/0x10
[ 1384.429857]  =======================
[ 1384.433699] Code: 44 24 1c 00 00 00 00 c7 44 24 14 01 00 00 00 89 6c 24 18 85 ed 74 36 31 c0 86 03 84 c0 7f a4 31 f6 31 ff eb 08 31 c0 86 03 84 c0 <7f> 96 b8 01 00 00 00 e8 d8 d5 ff ff 83 c6 01 83 d7 00 8b 54 24 

