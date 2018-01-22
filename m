Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:46383 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbeAVGjT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 01:39:19 -0500
Received: by mail-wm0-f44.google.com with SMTP id 143so14100650wma.5
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jan 2018 22:39:19 -0800 (PST)
Date: Mon, 22 Jan 2018 06:45:57 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Tom Psyborg <pozega.tomislav@gmail.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
Message-ID: <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain> (sfid-20180122_073930_485011_33266B42)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain> <20171213152017.GA3554@redhat.com> <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain> <20171218152142.GA15414@redhat.com> <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain> <20171219125431.GB2672@redhat.com> <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain> <20171221142558.GB4655@redhat.com> <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
 <20180103113540.GA10306@redhat.com> <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain> <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-663074487-1516599959=:32225"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-663074487-1516599959=:32225
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Crash happening here also in the WL-330n3G device; unfortunately, no messages to report.
Regarding your hypothesis regardingthe firmware not being able to communicate a problem regarding it's inability to send frames: around when OpenWRT had 3.9.9 kernel, this device worked for weeks no stop with no issues I think.
And I don't think this is only a coicnidence. So I suspect, but it's only an impression, also because I know ... very very little about this, that at some point things worked.

thank you very very much for your patience and help. Sorry for the slowness. I triggered this problem this morning after something like 1 h of use.
thank you again,
Enrico



On Thu, 11 Jan 2018, Tom Psyborg wrote:

> Date: Thu, 11 Jan 2018 17:00:14
> From: Tom Psyborg <pozega.tomislav@gmail.com>
> To: Enrico Mioso <mrkiko.rs@gmail.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
>     linux-wireless <linux-wireless@vger.kernel.org>,
>     Johannes Berg <johannes.berg@intel.com>,
>     Daniel Golle <daniel@makrotopia.org>, Arnd Bergmann <arnd@arndb.de>,
>     John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
>     frame due to full tx queue...?
> 
> does not help as expected. there was even a crash:
> [   92.559018] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [   92.563751] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [   92.937179] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [   92.942395] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [  104.195138] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [  104.199798] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [  107.175301] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [  107.179910] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [  131.973838] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [  131.978753] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [  134.551378] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [  134.556511] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [  143.642447] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [  143.647579] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [  176.019555] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010f, type=4
> [  176.025456] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010f, type=4
> [  177.724843] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010e, type=4
> [  179.044594] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010f, type=4
> [  179.313118] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010f, type=4
> [  179.668916] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010f, type=4
> [  180.496958] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010f, type=4
> [  180.675051] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010e, type=4
> [  187.155300] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010e, type=4
> [  191.620272] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4 spurious TX_FIFO_STATUS interrupt(s)
> [  191.624983] ieee80211 phy1: rt2800mmio_txdone: Warning - Got TX status for an empty queue 2, dropping
> [  200.584720] ------------[ cut here ]------------
> [  200.586933] WARNING: CPU: 0 PID: 0 at backports-2017-11-01/net/mac80211/rx.c:629 ieee80211_rx_napi+0x254/0x924 [mac80211]
> [  200.591898] Modules linked in: ath9k_htc ath9k_common rt2800usb rt2800soc rt2800pci rt2800mmio rt2800lib pppoe ppp_async ath9k_hw ath rt2x00usb rt2x00soc rt2x00pci rt2x00mmio rt2x00lib pppox ppp_generic mt76x2e mt7603e mt76 mac80211
> iptable_nat iptable_mangle iptable_filter ipt_REJECT ipt_MASQUERADE ip_tables cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT xt_LOG x_tables slhc
> nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4 nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_log_common nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack crc_itu_t crc_ccitt compat eeprom_93cx6 leds_gpio ohci_platform
> ohci_hcd ehci_platform ehci_hcd gpio_button_hotplug usbcore nls_base usb_common
> [  200.622366] CPU: 0 PID: 0 Comm: swapper Not tainted 4.9.73 #0
> [  200.624960] Stack : 803e751a 00000031 00000000 00000001 80392f34 80392ba7 80349710 00000000
> [  200.628749]         803e3660 00000275 00000004 870e2730 00000000 8004d250 8034eef0 80390000
> [  200.632536]         00000003 00000275 8034d0b8 87c0ddd4 00000000 8007cb3c 803e751a 0000006d
> [  200.636325]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  200.640112]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  200.643901]         ...
> [  200.645007] Call Trace:
> [  200.646120] [<8000e478>] show_stack+0x54/0x88
> [  200.648101] [<800239f0>] __warn+0xe4/0x118
> [  200.649954] [<80023ab8>] warn_slowpath_null+0x1c/0x34
> [  200.652292] [<877255e0>] ieee80211_rx_napi+0x254/0x924 [mac80211]
> [  200.655081] [<87054ccc>] ath9k_rx_tasklet+0x144/0x194 [ath9k_htc]
> [  200.657846] [<80026bac>] tasklet_action+0x80/0xc8
> [  200.659979] [<8002655c>] __do_softirq+0x250/0x298
> [  200.662112] [<800096f8>] handle_int+0x138/0x144
> [  200.664160] [<8000b1e4>] r4k_wait_irqoff+0x18/0x20
> [  200.666330] [<80047d24>] cpu_startup_entry+0x84/0xd0
> [  200.668580] [<803b2bb4>] start_kernel+0x44c/0x46c
> [  200.670710] ---[ end trace 56da331f0ae836de ]---
> 
> On 3 January 2018 at 15:04, Enrico Mioso <mrkiko.rs@gmail.com> wrote:
>       I'll apply your patch and let you know. Thank you very very much for your help, patience, and re-posting the patch.
>       Your work is very valuable, sorry for the slowness and not testing this before.
>       Enrico
> 
>
>       On Wed, 3 Jan 2018, Stanislaw Gruszka wrote:
>
>             Date: Wed, 3 Jan 2018 12:35:41
>             From: Stanislaw Gruszka <sgruszka@redhat.com>
>             To: Enrico Mioso <mrkiko.rs@gmail.com>
>             Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
>                 Daniel Golle <daniel@makrotopia.org>, Arnd Bergmann <arnd@arndb.de>,
>                 John Crispin <john@phrozen.org>, nbd@nbd.name
>             Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
>                 frame due to full tx queue...?
>
>             Hi
>
>             On Sun, Dec 24, 2017 at 01:19:06PM +0100, Enrico Mioso wrote:
>                   Unfortunately, the error di appear again. Still, I experienced no stalls.
>                   But i am starting to think this doesn't happen necessarily when a device is going out of range. Now I think I don't know when this triggers.
> 
>
>             <sni>
>                   Sun Dec 24 10:10:50 2017 authpriv.info dropbear[840]: Exit (root): Disconnect received
>                   Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.616638] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
>                   Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.626106] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
>                   Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.635562] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> 
>
>             I would also try bigger threshold for waking queue like
>             in below patch for those errors:
>
>             diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
>             index 357c0941aaad..b8bdf57ed7ea 100644
>             --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
>             +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
>             @@ -416,7 +416,7 @@ static void rt2x00lib_clear_entry(struct rt2x00_dev *rt2x00dev,
>                      * before it was stopped.
>                      */
>                     spin_lock_bh(&entry->queue->tx_lock);
>             -       if (!rt2x00queue_threshold(entry->queue))
>             +       if (rt2x00queue_available(queue) > 2*queue->threshold)
>                             rt2x00queue_unpause_queue(entry->queue);
>                     spin_unlock_bh(&entry->queue->tx_lock);
>             }
> 
> 
> 
>
--8323329-663074487-1516599959=:32225--
