Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36123 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZCXNzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 09:55:49 -0400
Subject: Re: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
  dereference
From: Martin Capitanio <martin@capitanio.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Larry.Finger@lwfinger.net, herton@mandriva.com.br,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903232248m1f6fc27fw92086d391c86d3eb@mail.gmail.com>
References: <1237849455.16745.41.camel@marvin>
	 <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com>
	 <1237859527.5714.60.camel@marvin>
	 <43e72e890903232248m1f6fc27fw92086d391c86d3eb@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 14:55:35 +0100
Message-Id: <1237902935.6674.62.camel@marvin> (sfid-20090324_145552_951387_913564E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-23 at 22:48 -0700, Luis R. Rodriguez wrote:
> On Mon, Mar 23, 2009 at 6:52 PM, Martin Capitanio <martin@capitanio.org> wrote:
> > Am Montag, den 23.03.2009, 16:10 -0700 schrieb Luis R. Rodriguez:
> >> On Mon, Mar 23, 2009 at 4:04 PM, Martin Capitanio <martin@capitanio.org> wrote:
> >> > Setting the EU or DE regulatory domain (cfg80211 ieee80211_regdom=EU)
> >> > seems to be working, but afterwards inserting the rtl8187 driver causes crash:
> >>
> >> Please try with today's wireless-testing a set of fixes went in to
> >
> > Sure, I tried "DE" with the same result as well.
> >
> > Fortunately, wireless-testing doesn't crash during the rtl8187 driver load
> > anymore, but changing the regulatory domain seems to be no-op (see below).
> >
> > Furthermore the current wireless-testing breaks the rtl8187 driver completely.
> > If I try to connect to an AP (with or without changing the domain),
> > it hard-freezes the kernel without any log entry.
> >
> >> address a bug with "EU". Mind you, "EU" is an invalid ISO3166-alpha2
> >> so you may want to consider start using your own valid country alpha2
> >> code. If you use "EU" now you'll world roam.
> >
> > I wonder why is there than the EU (confusing) code at all?
> 
> Its complete crap, in fact stop using the module parameter. "EU" is
> part of the 3 static regulatory domains left from the old regulatory
> implementation. It should have been removed eons ago but old habits
> are hard to kill. Fortunately distributions are now shipping and with
> OLD_REG disabled on 2.6.28 (both FC11 and Ubuntu Jaunty). The "EU"
> option and even the ieee80211_regdom module parameter are simply not
> an option in 2.6.28 and 2.6.29 if OLD_REG is disabled, we have a
> suitable replacement -- a userspace call.
> 
> Unfortunately I just added the module parameter when OLD_REG is
> disabled to try to remove OLD_REG completely but that didn't seem to
> work yet.
> 
> > Actually I would expect a "smallest common intersection" of the 27 European
> > Union member states.
> 
> Heh, well its easier than that you get a ISO / IEC 3166 alpha2 for
> each country. So you just pick your country. "EU" is an ancient
> regulatory concoction, it should be ignored and forgotten.
> 

Full ACK from the user POW. If the hid maintainers had a fraction
of your enthusiasm and pulled the "funny keys" quirk monstrosity to the
userspace ...  

> > 2.6.29-rc8-wl at commit 8fe80c672051978895d0c3ef7be1dc7bcaa8621e
> >
> > [   14.724111] cfg80211: Using static regulatory domain info
> > [   14.724154] cfg80211: Regulatory domain: US
> 
> So, not all of my patches were applied... Specifically the one that
> removed OLD_REG was not applied. This is why you are getting "US"
> still as your default. You probably have OLD_REG enabled in your
> kernel.

Yes, fgrep OLD_REG /boot/config-2.6.29-rc8-wl 
CONFIG_WIRELESS_OLD_REGULATORY=y

The make oldconfig did it ;-)

... 
> > modprobe -r rtl8187
> > modprobe -r cfg80211
> > modprobe cfg80211 ieee80211_regdom=DE
> > [  570.676064] usbcore: deregistering interface driver rtl8187
> > [  570.944071] usb 2-6: reset high speed USB device using ehci_hcd and address 4
> > [  687.552176] cfg80211: Using static regulatory domain info
> > [  687.552182] cfg80211: Regulatory domain: US
> > [  687.552186]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> > [  687.552191]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> > [  687.552196]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> > [  687.552201]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> > [  687.552206]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> > [  687.552210]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> > [  687.552215]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> 
> So.. this still happens because within OLD_REG "DE" is not a valid
> static regulatory domain, so first you get by default the "US" static
> regulatory domain. That is -- if you want to use OLD_REG and get a
> static regulatory domain applied by default first you only have 3
> options:
> 
> "US"
> "EU"
> "JP"
> 
> Now this is pure garbage and which is why people should stop using
> OLD_REG and forget about it.

Hmm, there is a lot bogus information or howtos on the web. 
Somebody probably should incorporate exactly this information
on the web-page  http://linuxwireless.org/en/developers/Regulatory
E.g. I didn't know what "static regulatory domain" really means.

> 
> > [  687.552501] cfg80211: Calling CRDA for country: DE
> 
> Strange well I just tested with OLD_REG and I get the same "US" crap
> as above but then immediately after that I got "DE" as follows:
> 
> [15895.175144] cfg80211: Regulatory domain changed to country: DE
> [15895.175189] 	(start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [15895.175241] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [15895.175274] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
> [15895.175312] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
> 
> You probably don't have the wireless-regdb and crda installed. We have
> offloaded all this regulatory information to userspace, you know get a
> decent world roaming regulatory domain by default instead of assuming
> everyone lives the United States. Then you can set the regulatory
> domain.
> 
> http://wireless.kernel.org/download/wireless-regdb/
> sudo make install
> 
> http://wireless.kernel.org/download/crda/
> make
> sudo make install

Thanks! The udev rule was not activated. (Maybe
the install target could check if the /etc/udev/rules.d/
directory eixst before installing it somewhere else)

As it is, wireless-testing works now (OLD_REGULATORY disabled):

[   14.582317] cfg80211: World regulatory domain updated:
[   14.582362] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.583219] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.583264] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.583299] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.583352] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.583394] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
...
iw list
Wiphy phy0
	Band 1:
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
			* 2467 MHz [12] (20.0 dBm) (passive scanning, no IBSS)
			* 2472 MHz [13] (20.0 dBm)
			* 2484 MHz [14] (20.0 dBm) (passive scanning, no IBSS)
...
iw reg get
country 00:
	(2402 - 2472 @ 40), (3, 20)
	(2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
	(2474 - 2494 @ 20), (3, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS

iw reg set DE
iw reg get
country DE:
	(2400 - 2483 @ 40), (N/A, 20)
	(5150 - 5255 @ 40), (N/A, 23), NO-OUTDOOR, DFS
	(5470 - 5650 @ 40), (N/A, 30), DFS

iw list
Wiphy phy0
	Band 1:
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
			* 2467 MHz [12] (20.0 dBm)
			* 2472 MHz [13] (20.0 dBm)
			* 2484 MHz [14] (disabled)
...
[  502.786782] cfg80211: Calling CRDA for country: DE
[  502.793085] cfg80211: Regulatory domain changed to country: DE
[  502.793095] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  502.793100] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  502.793105] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[  502.793109] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[  752.221876] cfg80211: Calling CRDA to update world regulatory domain
[  752.227562] cfg80211: Enabling active scanning on frequency: 2472 MHz (Ch 13) on phy0
[  752.227570] cfg80211: Enabling beaconing on frequency: 2472 MHz (Ch 13) on phy0
[  752.227574] cfg80211: World regulatory domain updated:
[  752.227578] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  752.227584] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  752.227589] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  752.227594] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  752.227598] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  752.227603] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  787.947893] cfg80211: Calling CRDA for country: DE
[  787.953490] cfg80211: Regulatory domain changed to country: DE
[  787.953498] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  787.953503] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  787.953508] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[  787.953512] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
... 
> I don't see any panics, everything is as expected --except my removal
> of OLD_REG patch was not applied.

As Johannes wrote, the problem is blindingly obvious ;-)
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index eff59f3..64ebe66 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1884,7 +1884,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
        if (ieee80211_vif_is_mesh(&sdata->vif))
                return ieee80211_mesh_rx_mgmt(sdata, rx->skb, rx->status);
 
-       if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+       if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
                return ieee80211_ibss_rx_mgmt(sdata, rx->skb, rx->status);
 
        if (sdata->vif.type == NL80211_IFTYPE_STATION)

I did some unscientific throughput measurements (WPA2/AES connection,
the AP says 54 MBit/s). Although this probably doesn't yet stop Balmers
monkey dancing, I see an _huge jump forwards_ compared to
the 2.6.27 / 2.6.28 code:

NETIO - Network Throughput Benchmark, Version 1.26
2.6.27 / 2.6.28:
TCP connection established.
Packet size  1k bytes:  377 KByte/s Tx,  795 KByte/s Rx.
Packet size  2k bytes:  392 KByte/s Tx,  739 KByte/s Rx.
Packet size  4k bytes:  371 KByte/s Tx,  782 KByte/s Rx.
Packet size  8k bytes:  381 KByte/s Tx,  759 KByte/s Rx.
Packet size 16k bytes:  383 KByte/s Tx,  765 KByte/s Rx.
Packet size 32k bytes:  384 KByte/s Tx,  810 KByte/s Rx.

wireless-testing / 2.6.29:
TCP connection established.
Packet size  1k bytes:  889 KByte/s Tx,  1109 KByte/s Rx.
Packet size  2k bytes:  1207 KByte/s Tx,  1032 KByte/s Rx.
Packet size  4k bytes:  1174 KByte/s Tx,  1106 KByte/s Rx.
Packet size  8k bytes:  1149 KByte/s Tx,  1138 KByte/s Rx.
Packet size 16k bytes:  1149 KByte/s Tx,  980 KByte/s Rx.
Packet size 32k bytes:  1119 KByte/s Tx,  1217 KByte/s Rx.

$vista$:
TCP connection established.
Packet size  1k bytes:  2746 KByte/s Tx,  3278 KByte/s Rx.
Packet size  2k bytes:  2786 KByte/s Tx,  3229 KByte/s Rx.
Packet size  4k bytes:  2554 KByte/s Tx,  3248 KByte/s Rx.
Packet size  8k bytes:  2850 KByte/s Tx,  3281 KByte/s Rx.
Packet size 16k bytes:  2865 KByte/s Tx,  3271 KByte/s Rx.
Packet size 32k bytes:  2673 KByte/s Tx,  3248 KByte/s Rx.

However iwconfig doesn't show the connection rate now:
wlan0     IEEE 802.11bg  ESSID:"xx"  
          Mode:Managed  Frequency:2.447 GHz  Access Point: xx   
          Bit Rate=1 Mb/s   Tx-Power=20 dBm
                   ??????   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:xx [3]   Security mode:open
          Power Management:off
          Link Quality=70/70  Signal level=-37 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

iwconfig -v
iwconfig  Wireless-Tools version 29
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

wlan0     Recommend Wireless Extension v21 or later,
          Currently compiled with Wireless Extension v22.

iw dev wlan0 scan dump
BSS xx (on wlan0)
	TSF: 4126925365 usec (0d, 01:08:46)
	freq: 2447
	beacon interval: 100
	capability: 0x0411
	signal: -38.00 dBm
	SSID: xx
	Supported rates: 1.0* 2.0* 5.5* 11.0* 
	DS Parameter set: channel 8
	Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0 

2.6.27/2.6.28:
wlan0     IEEE 802.11bg  ESSID:"xx"  
          Mode:Managed  Frequency:2.447 GHz  Access Point: xx   
          Bit Rate=54 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:xx [2]   Security mode:open
          Power Management:off
          Link Quality=60/100  Signal level:-41 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Martin

