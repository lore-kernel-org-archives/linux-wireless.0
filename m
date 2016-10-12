Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:34835 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932307AbcJLTdy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 15:33:54 -0400
Message-ID: <1476300656.1492.20.camel@embedded.rocks> (sfid-20161012_213358_301412_1CEE6D7A)
Subject: Re: TCP data throughput for BCM43362
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Date: Wed, 12 Oct 2016 21:30:56 +0200
In-Reply-To: <c571ac91-ccd1-5e98-317f-eb3e56ad6b58@broadcom.com>
References: <1470429980.29489.10.camel@embedded.rocks>
         <CAF7Mx6o+WuQqtzuApMWQ8YAkLSX7xQ_H06xmO--RxFdwHwzLdQ@mail.gmail.com>
         <1BCE83A1-AA47-438D-BC47-05AE53D40121@embedded.rocks>
         <CA+8PC_f7VQMwBfQmZZ_vUtYtNJKVYzmFmxziAwoG8-iRUeW9Jw@mail.gmail.com>
         <1470492734.2120.0.camel@embedded.rocks>
         <6cdbbae7-8a56-6778-e886-68eeea7add15@broadcom.com>
         <1471873052.1683.27.camel@embedded.rocks>
         <40d15186-6ddf-a210-03de-2bbe21957f1d@broadcom.com>
         <1472505309.21429.3.camel@embedded.rocks>
         <1473860503.19492.19.camel@embedded.rocks>
         <27e007ed-57f6-4082-2f65-a11ba3b7f548@broadcom.com>
         <1474266984.7448.1.camel@embedded.rocks>
         <64180601-8d99-09fe-2db5-06c4ed7dd5d6@broadcom.com>
         <1474548738.11992.2.camel@embedded.rocks>
         <CAF7Mx6q+B4RoURNF5XxewjF9aVGCXg==XU0aDD6w+354yXZ70Q@mail.gmail.com>
         <F306F99A-DCEC-4C28-8805-AE0BA50D485F@embedded.rocks>
         <01642203-65dc-3b44-bbd4-2585bfdab15e@broadcom.com>
         <1476282457.1492.8.camel@embedded.rocks>
         <c571ac91-ccd1-5e98-317f-eb3e56ad6b58@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mi, 2016-10-12 at 21:08 +0200, Arend van Spriel wrote:

[snip]

> On 12-10-16 16:27, Jörg Krause wrote:
> > 
> > It is running the iperf server. It is running in station mode as
> > well
> > as in AP mode, depending on the use case. The wireshark dump was
> > taken
> > when the bcm43362 is operating in AP mode.
> > 
> > > 
> > > What specs does the ARM on your custom board have?
> > 
> > Which specs do you mean?
> > 
> > > 
> > > The trace shows that it does not do
> > > aggregation. What it does not show is whether A-MPDU was setup,
> > > ie.
> > > ADDBA message exchange. So could you create a similar capture
> > > including
> > > connection setup, ie. AUTH/ASSOC, etc.
> > 
> > Yes, I can do that. Note, that I am using wpa_supplicant 2.5 for AP
> > mode operation (not hostapd).
> 
> ok. unchartered territory for me. In the beacon frame I see
> 
> .... ..01 = Maximum Rx A-MPDU Length: 0x1 (16383[Bytes])
> ...1 10.. = MPDU Density: 8 [usec] (0x6)
> 
> In the trace it is only ~1500 bytes so no A-MPDU.

The issue is not only valid for operating the BCM43362 in AP mode, but
also in station mode. The TCP throughput is the same for both modes.

> What device is in the notebook?

It is a Broadcom 43225. However, the low TCP throughput is not specific
to this device but with all kind of devices including Smartphones,
Notebooks, PCs running the iperf client.

> Can you use 'iw list' there to obtain info.

    $ iw list
    Wiphy phy0
    	    max # scan SSIDs: 4
    	    max scan IEs length: 2257 bytes
    	    max # sched scan SSIDs: 0
    	    max # match sets: 0
    	    max # scan plans: 1
    	    max scan plan interval: -1
    	    max scan plan iterations: 0
    	    Retry short limit: 7
    	    Retry long limit: 4
    	    Coverage class: 0 (up to 0m)
    	    Device supports RSN-IBSS.
    	    Supported Ciphers:
    	    	    * WEP40 (00-0f-ac:1)
    	    	    * WEP104 (00-0f-ac:5)
    	    	    * TKIP (00-0f-ac:2)
    	    	    * CCMP (00-0f-ac:4)
    	    	    * 00-0f-ac:10
    	    	    * GCMP (00-0f-ac:8)
    	    	    * 00-0f-ac:9
    	    Available Antennas: TX 0 RX 0
    	    Supported interface modes:
    	    	     * IBSS
    	    	     * managed
    	    	     * AP
    	    	     * AP/VLAN
    	    	     * monitor
    	    Band 1:
    	    	    Capabilities: 0x70
    	    	    	    HT20
    	    	    	    Static SM Power Save
    	    	    	    RX Greenfield
    	    	    	    RX HT20 SGI
    	    	    	    RX HT40 SGI
    	    	    	    No RX STBC
    	    	    	    Max AMSDU length: 3839 bytes
    	    	    	    No DSSS/CCK HT40
    	    	    Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
    	    	    Minimum RX AMPDU time spacing: 8 usec (0x06)
    	    	    HT Max RX data rate: 500 Mbps
    	    	    HT TX/RX MCS rate indexes supported: 0-15
    	    	    Bitrates (non-HT):
    	    	    	    * 1.0 Mbps
    	    	    	    * 2.0 Mbps (short preamble supported)
    	    	    	    * 5.5 Mbps (short preamble supported)
    	    	    	    * 11.0 Mbps (short preamble supported)
    	    	    	    * 6.0 Mbps
    	    	    	    * 9.0 Mbps
    	    	    	    * 12.0 Mbps
    	    	    	    * 18.0 Mbps
    	    	    	    * 24.0 Mbps
    	    	    	    * 36.0 Mbps
    	    	    	    * 48.0 Mbps
    	    	    	    * 54.0 Mbps
    	    	    Frequencies:
    	    	    	    * 2412 MHz [1] (19.0 dBm)
    	    	    	    * 2417 MHz [2] (19.0 dBm)
    	    	    	    * 2422 MHz [3] (19.0 dBm)
    	    	    	    * 2427 MHz [4] (19.0 dBm)
    	    	    	    * 2432 MHz [5] (19.0 dBm)
    	    	    	    * 2437 MHz [6] (19.0 dBm)
    	    	    	    * 2442 MHz [7] (19.0 dBm)
    	    	    	    * 2447 MHz [8] (19.0 dBm)
    	    	    	    * 2452 MHz [9] (19.0 dBm)
    	    	    	    * 2457 MHz [10] (19.0 dBm)
    	    	    	    * 2462 MHz [11] (19.0 dBm)
    	    	    	    * 2467 MHz [12] (19.0 dBm) (no IR)
    	    	    	    * 2472 MHz [13] (19.0 dBm) (no IR)
    	    	    	    * 2484 MHz [14] (disabled)
    	    Supported commands:
    	    	     * new_interface
    	    	     * set_interface
    	    	     * new_key
    	    	     * start_ap
    	    	     * new_station
    	    	     * new_mpath
    	    	     * set_mesh_config
    	    	     * set_bss
    	    	     * authenticate
    	    	     * associate
    	    	     * deauthenticate
    	    	     * disassociate
    	    	     * join_ibss
    	    	     * join_mesh
    	    	     * set_tx_bitrate_mask
    	    	     * frame
    	    	     * frame_wait_cancel
    	    	     * set_wiphy_netns
    	    	     * set_channel
    	    	     * set_wds_peer
    	    	     * probe_client
    	    	     * set_noack_map
    	    	     * register_beacons
    	    	     * start_p2p_device
    	    	     * set_mcast_rate
    	    	     * set_qos_map
    	    	     * connect
    	    	     * disconnect
    	    Supported TX frame types:
    	    	     * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
    0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    	     * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
    0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    	     * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
    0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    	     * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
    0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    	     * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
    0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    	     * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
    0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    	     * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
    0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    	     * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
    0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
    	    Supported RX frame types:
    	    	     * IBSS: 0x40 0xb0 0xc0 0xd0
    	    	     * managed: 0x40 0xd0
    	    	     * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
    	    	     * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
    	    	     * mesh point: 0xb0 0xc0 0xd0
    	    	     * P2P-client: 0x40 0xd0
    	    	     * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
    	    	     * P2P-device: 0x40 0xd0
    	    software interface modes (can always be added):
    	    	     * AP/VLAN
    	    	     * monitor
    	    interface combinations are not supported
    	    HT Capability overrides:
    	    	     * MCS: ff ff ff ff ff ff ff ff ff ff
    	    	     * maximum A-MSDU length
    	    	     * supported channel width
    	    	     * short GI for 40 MHz
    	    	     * max A-MPDU length exponent
    	    	     * min MPDU start spacing
    	    Device supports TX status socket option.
    	    Device supports HT-IBSS.
    	    Device supports SAE with AUTHENTICATE command
    	    Device supports low priority scan.
    	    Device supports scan flush.
    	    Device supports AP scan.
    	    Device supports per-vif TX power setting
    	    Driver supports a userspace MPM
    	    Device supports configuring vdev MAC-addr on create.

> > 
> > > 
> > > Just to confirm. You are using the firmware from linux-firmware,
> > > right?
> > 
> > Right.
> > 
> > > 
> > > Or are you using firmware from the wiced dev kit?
> > 
> > No. I guess you mean bcmdhd?
> 
> You referred to 20 Mbps claim on wiced dev kit page at mouser so I
> assumed you were using that and it includes firmware. As you
> confirmed
> using firmware from linux-firmware repo this question does not
> matter.

I see! Note, that I measured >20MB throughput on the Cubietruck, which
is using the AP6210, but also the brcmfmac driver.

Best regards
Jörg Krause
