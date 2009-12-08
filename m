Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46261 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755619AbZLHWjN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:39:13 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors in
 =?utf-8?q?=092=2E6=2E32?=
Date: Tue, 8 Dec 2009 23:39:15 +0100
Cc: Andi Kleen <andi@firstfloor.org>, linux-wireless@vger.kernel.org,
	Tim Blechmann <tim@klingt.org>, rjw@sisk.pl, IvDoorn@gmail.com,
	linville@tuxdriver.com
References: <20091204233202.GA13658@basil.fritz.box> <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com> <4B1EC842.7040407@gmail.com>
In-Reply-To: <4B1EC842.7040407@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912082339.16893.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tuesday 08 December 2009, Gertjan van Wingerde wrote:
> On 12/08/09 11:19, Gertjan van Wingerde wrote:
> > On Tue, Dec 8, 2009 at 10:57 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >>> This patch doesn't seem to change this particular issue, disabling
> >>> powersaving however makes rt62pci work again.
> >>
> >> Yes confirmed here. Haven't seen it in a day or so with disabled power
> >> saving.
> >>
> >> However I haven't tried the patch with power saving enabled.
> > 
> > OK.
> > I think Stefan said that the patch didn't help for this issue.
> > 
> > However, I've got an other hunch (based on the Ralink driver). Maybe
> > we shouldn't go to sleep when still TX entries are present. I'll cook
> > up a patch tonight.
> > 
> 
> OK. Please try again with the attached patch. Basically it disables going
> to sleep when there are still unacknowledged frames in the TX queues.
> This mirrors the behavior of the Ralink provided drivers.

Unfortunately this fails to compile for me:

drivers/net/wireless/rt2x00/rt61pci.c: In function 'rt61pci_config_ps':
drivers/net/wireless/rt2x00/rt61pci.c:999: error: invalid storage class for function 'rt61pci_config'
drivers/net/wireless/rt2x00/rt61pci.c:996: warning: ISO C90 forbids mixed declarations and code
drivers/net/wireless/rt2x00/rt61pci.c:1020: error: invalid storage class for function 'rt61pci_link_stats'
drivers/net/wireless/rt2x00/rt61pci.c:1038: error: invalid storage class for function 'rt61pci_set_vgc'
drivers/net/wireless/rt2x00/rt61pci.c:1048: error: invalid storage class for function 'rt61pci_reset_tuner'
drivers/net/wireless/rt2x00/rt61pci.c:1054: error: invalid storage class for function 'rt61pci_link_tuner'
drivers/net/wireless/rt2x00/rt61pci.c:1145: error: invalid storage class for function 'rt61pci_get_firmware_name'
drivers/net/wireless/rt2x00/rt61pci.c:1168: error: invalid storage class for function 'rt61pci_check_firmware'
drivers/net/wireless/rt2x00/rt61pci.c:1197: error: invalid storage class for function 'rt61pci_load_firmware'
drivers/net/wireless/rt2x00/rt61pci.c:1284: error: invalid storage class for function 'rt61pci_get_entry_state'
drivers/net/wireless/rt2x00/rt61pci.c:1301: error: invalid storage class for function 'rt61pci_clear_entry'
drivers/net/wireless/rt2x00/rt61pci.c:1324: error: invalid storage class for function 'rt61pci_init_queues'
drivers/net/wireless/rt2x00/rt61pci.c:1406: error: invalid storage class for function 'rt61pci_init_registers'
drivers/net/wireless/rt2x00/rt61pci.c:1550: error: invalid storage class for function 'rt61pci_wait_bbp_ready'
drivers/net/wireless/rt2x00/rt61pci.c:1566: error: invalid storage class for function 'rt61pci_init_bbp'
drivers/net/wireless/rt2x00/rt61pci.c:1618: error: invalid storage class for function 'rt61pci_toggle_rx'                                                                                         
drivers/net/wireless/rt2x00/rt61pci.c:1630: error: invalid storage class for function 'rt61pci_toggle_irq'
drivers/net/wireless/rt2x00/rt61pci.c:1670: error: invalid storage class for function 'rt61pci_enable_radio'
drivers/net/wireless/rt2x00/rt61pci.c:1692: error: invalid storage class for function 'rt61pci_disable_radio'                                                                                     
drivers/net/wireless/rt2x00/rt61pci.c:1700: error: invalid storage class for function 'rt61pci_set_state'
drivers/net/wireless/rt2x00/rt61pci.c:1730: error: invalid storage class for function 'rt61pci_set_device_state'
drivers/net/wireless/rt2x00/rt61pci.c:1774: error: invalid storage class for function 'rt61pci_write_tx_desc'
drivers/net/wireless/rt2x00/rt61pci.c:1855: error: invalid storage class for function 'rt61pci_write_beacon'
drivers/net/wireless/rt2x00/rt61pci.c:1889: error: invalid storage class for function 'rt61pci_kick_tx_queue'
drivers/net/wireless/rt2x00/rt61pci.c:1919: error: invalid storage class for function 'rt61pci_kill_tx_queue'
drivers/net/wireless/rt2x00/rt61pci.c:1939: error: invalid storage class for function 'rt61pci_agc_to_rssi'
drivers/net/wireless/rt2x00/rt61pci.c:1968: error: invalid storage class for function 'rt61pci_fill_rxdone'
drivers/net/wireless/rt2x00/rt61pci.c:2037: error: invalid storage class for function 'rt61pci_txdone'
drivers/net/wireless/rt2x00/rt61pci.c:2131: error: invalid storage class for function 'rt61pci_interrupt'
drivers/net/wireless/rt2x00/rt61pci.c:2184: error: invalid storage class for function 'rt61pci_validate_eeprom'
drivers/net/wireless/rt2x00/rt61pci.c:2295: error: invalid storage class for function 'rt61pci_init_eeprom'
drivers/net/wireless/rt2x00/rt61pci.c:2542: error: invalid storage class for function 'rt61pci_probe_hw_mode'
drivers/net/wireless/rt2x00/rt61pci.c:2606: error: invalid storage class for function 'rt61pci_probe_hw'
drivers/net/wireless/rt2x00/rt61pci.c:2659: error: invalid storage class for function 'rt61pci_conf_tx'
drivers/net/wireless/rt2x00/rt61pci.c:2715: error: invalid storage class for function 'rt61pci_get_tsf'
drivers/net/wireless/rt2x00/rt61pci.c:2740: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2740: error: (near initialization for 'rt61pci_mac80211_ops.conf_tx')
drivers/net/wireless/rt2x00/rt61pci.c:2742: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2742: error: (near initialization for 'rt61pci_mac80211_ops.get_tsf')
drivers/net/wireless/rt2x00/rt61pci.c:2747: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2747: error: (near initialization for 'rt61pci_rt2x00_ops.irq_handler')
drivers/net/wireless/rt2x00/rt61pci.c:2748: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2748: error: (near initialization for 'rt61pci_rt2x00_ops.probe_hw')
drivers/net/wireless/rt2x00/rt61pci.c:2749: error: initializer element is not constant           
drivers/net/wireless/rt2x00/rt61pci.c:2749: error: (near initialization for 'rt61pci_rt2x00_ops.get_firmware_name')
drivers/net/wireless/rt2x00/rt61pci.c:2750: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2750: error: (near initialization for 'rt61pci_rt2x00_ops.check_firmware')
drivers/net/wireless/rt2x00/rt61pci.c:2751: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2751: error: (near initialization for 'rt61pci_rt2x00_ops.load_firmware')
drivers/net/wireless/rt2x00/rt61pci.c:2754: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2754: error: (near initialization for 'rt61pci_rt2x00_ops.get_entry_state')
drivers/net/wireless/rt2x00/rt61pci.c:2755: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2755: error: (near initialization for 'rt61pci_rt2x00_ops.clear_entry')
drivers/net/wireless/rt2x00/rt61pci.c:2756: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2756: error: (near initialization for 'rt61pci_rt2x00_ops.set_device_state')
drivers/net/wireless/rt2x00/rt61pci.c:2758: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2758: error: (near initialization for 'rt61pci_rt2x00_ops.link_stats')
drivers/net/wireless/rt2x00/rt61pci.c:2759: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2759: error: (near initialization for 'rt61pci_rt2x00_ops.reset_tuner')
drivers/net/wireless/rt2x00/rt61pci.c:2760: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2760: error: (near initialization for 'rt61pci_rt2x00_ops.link_tuner')
drivers/net/wireless/rt2x00/rt61pci.c:2761: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2761: error: (near initialization for 'rt61pci_rt2x00_ops.write_tx_desc')
drivers/net/wireless/rt2x00/rt61pci.c:2763: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2763: error: (near initialization for 'rt61pci_rt2x00_ops.write_beacon')
drivers/net/wireless/rt2x00/rt61pci.c:2764: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2764: error: (near initialization for 'rt61pci_rt2x00_ops.kick_tx_queue')
drivers/net/wireless/rt2x00/rt61pci.c:2765: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2765: error: (near initialization for 'rt61pci_rt2x00_ops.kill_tx_queue')
drivers/net/wireless/rt2x00/rt61pci.c:2766: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2766: error: (near initialization for 'rt61pci_rt2x00_ops.fill_rxdone')
drivers/net/wireless/rt2x00/rt61pci.c:2773: error: initializer element is not constant
drivers/net/wireless/rt2x00/rt61pci.c:2773: error: (near initialization for 'rt61pci_rt2x00_ops.config')
drivers/net/wireless/rt2x00/rt61pci.c:2832: warning: 'alias' attribute ignored
drivers/net/wireless/rt2x00/rt61pci.c:2832: warning: ISO C90 forbids mixed declarations and code
drivers/net/wireless/rt2x00/rt61pci.c:2848: error: invalid storage class for function 'rt61pci_init'
drivers/net/wireless/rt2x00/rt61pci.c:2853: error: invalid storage class for function 'rt61pci_exit'
drivers/net/wireless/rt2x00/rt61pci.c:2857: error: invalid storage class for function '__inittest'
drivers/net/wireless/rt2x00/rt61pci.c:2857: warning: 'alias' attribute ignored
drivers/net/wireless/rt2x00/rt61pci.c:2858: error: invalid storage class for function '__exittest'
drivers/net/wireless/rt2x00/rt61pci.c:2858: warning: ISO C90 forbids mixed declarations and code
drivers/net/wireless/rt2x00/rt61pci.c:2858: warning: 'alias' attribute ignored 
drivers/net/wireless/rt2x00/rt61pci.c:2858: error: expected declaration or statement at end of input
make[7]: *** [drivers/net/wireless/rt2x00/rt61pci.o] Error 1
make[7]: *** Waiting for unfinished jobs....

$ gcc --version
gcc (Debian 4.4.2-3) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Thanks
	Stefan Lippers-Hollmann
