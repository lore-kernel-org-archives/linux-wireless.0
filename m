Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:32981 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932124AbdC2K2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 06:28:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glkwg-linux-wireless@m.gmane.org>)
        id 1ctApt-0006uZ-A7
        for linux-wireless@vger.kernel.org; Wed, 29 Mar 2017 12:28:17 +0200
To: linux-wireless@vger.kernel.org
From: Dennis New <dennisn@dennisn.mooo.com>
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
Date: Wed, 29 Mar 2017 06:28:08 -0400
Message-ID: <20170329062808.032e71a5327f3405f82df4b2@dennisn.mooo.com> (sfid-20170329_122846_570548_1B99027C)
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
        <1490772890.18052.8.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
In-Reply-To: <1490772890.18052.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 29 Mar 2017 09:34:50 +0200, Johannes Berg wrote:
> On Fri, 2017-03-24 at 21:32 -0400, Dennis New wrote:
> > Ever since I upgraded to the 4.10 kernels (I don't think this
> > behavior existed in the 4.8 series), after I startup my laptop
> > (either from cold boot, or from standby), my wlan0 interface keeps
> > deauthenticating
> 
> > ...
> > 19:23:29 kernel: wlan0: authenticate with 00:11:22:33:44:55
> > 19:23:29 kernel: ------------[ cut here ]------------
> > 19:23:29 kernel: WARNING: CPU: 0 PID: 18925 at
> > net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380
> 
> This is already indicating a severe problem. I don't know how you end
> up in this situation with b43, since that doesn't have any regulatory
> magic afaict.
> 
> > 19:23:29 kernel: wlan0: associated
> > 
> > 19:24:29 kernel: wlan0: deauthenticating from 00:11:22:33:44:55 by
> > local choice (Reason: 3=DEAUTH_LEAVING)
> 
> I'm convinced that this comes from reg_check_channels().
> 
> The above WARN_ON() already told you that the channel was considered
> invalid.
> 
> Do you know what channel your AP is on?

6

> Perhaps show the output of "iw wlan0 scan dump" while it's
connected (you have 60 seconds :P)

I have been having stable connections for the past few days,
simply by putting a 60 second sleep before starting my wlan0. Although
if I /etc/init.d/net.wlan0 restart it (without the delay), it will
still do this deauth'ing.


> Can you please show the output of "iw list" and "iw phy0 channels"?

"iw phy7 channels":
Band 1:
	* 2412 MHz [1] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2417 MHz [2] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2422 MHz [3] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2427 MHz [4] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2432 MHz [5] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2437 MHz [6] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2442 MHz [7] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2447 MHz [8] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2452 MHz [9] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2457 MHz [10] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2462 MHz [11] 
	  Maximum TX power: 20.0 dBm
	  Channel widths:
	* 2467 MHz [12] 
	  Maximum TX power: 20.0 dBm
	  No IR
	  Channel widths:
	* 2472 MHz [13] 
	  Maximum TX power: 20.0 dBm
	  No IR
	  Channel widths:
	* 2484 MHz [14] 
	  Maximum TX power: 20.0 dBm
	  No IR
	  Channel widths: 20MHz


"iw list":
Wiphy phy7
	max # scan SSIDs: 4
	max scan IEs length: 2285 bytes
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
		* CCMP-128 (00-0f-ac:4)
		* CCMP-256 (00-0f-ac:10)
		* GCMP-128 (00-0f-ac:8)
		* GCMP-256 (00-0f-ac:9)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
	Band 1:
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
			* 2412 MHz [1] (20.0 dBm)
			* 2417 MHz [2] (20.0 dBm)
			* 2422 MHz [3] (20.0 dBm)
			* 2427 MHz [4] (20.0 dBm)
			* 2432 MHz [5] (20.0 dBm)
			* 2437 MHz [6] (20.0 dBm)
			* 2442 MHz [7] (20.0 dBm)
			* 2447 MHz [8] (20.0 dBm)
			* 2452 MHz [9] (20.0 dBm)
			* 2457 MHz [10] (20.0 dBm)
			* 2462 MHz [11] (20.0 dBm)
			* 2467 MHz [12] (20.0 dBm) (no IR)
			* 2472 MHz [13] (20.0 dBm) (no IR)
			* 2484 MHz [14] (20.0 dBm) (no IR)
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * start_ap
		 * new_station
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
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
		 * connect
		 * disconnect
		 * set_qos_map
	Supported TX frame types:
		 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
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
	Driver supports full state transitions for AP/GO clients
	Driver supports a userspace MPM
	Device supports configuring vdev MAC-addr on create.
