Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.35]:53512 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752106AbZGPGPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 02:15:03 -0400
Date: Wed, 15 Jul 2009 20:14:57 -1000
From: Joel Roth <joelz@pobox.com>
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k and Atheros AR242x - No scan results
Message-ID: <20090716061457.GA1576@sprite>
Reply-To: Joel Roth <joelz@pobox.com>
References: <20090630170916.GB5137@sprite> <20090712112340.GA3315@sprite>
 <40f31dec0907120808y45f575b6l6d83afd731e6d51@mail.gmail.com>
 <20090712203449.GA3058@sprite>
 <b6c5339f0907130708h3996b274qdcc7d7f6056a188c@mail.gmail.com>
 <20090714065414.GA16708@sprite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090714065414.GA16708@sprite>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 13, 2009 at 10:08:52AM -0400, Bob Copeland wrote:
> On Sun, Jul 12, 2009 at 4:34 PM, Joel Roth<joelz@pobox.com> wrote:
> > Vista advised me to:
> >
> > 1) turn on the hardware wifi switch <blush>
> >
> > 2) use the hotkey combination to enable wifi
> 
> It might be worth trying compat-wireless or 2.6.31-rcX.  Support
> for reading the card's internal rfkill state was added in the
> post-2.6.30 time-frame.
 
I installed compat-wireless against my 2.6.30.1 kernel,
and also the iw command.

I've read some docs, however I'm not sure what the next step should be. 

My general idea is that I should be able to see a list of
access points, however iwlist doesn't tell me anything new.

# iwlist wlan0 ap

wlan0     Interface doesn't have a list of Peers/Access-Points


I'm appending some diagnostics.

Here's what dmesg tells me after 'modprobe ath5k'

[256888.841092] cfg80211: Using static regulatory domain info
[256888.841098] cfg80211: Regulatory domain: US
[256888.841101] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[256888.841105] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[256888.841109] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[256888.841112] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[256888.841116] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[256888.841119] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[256888.841123] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[256888.841134] cfg80211: Calling CRDA for country: US
[256888.870476] ath5k 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[256888.870492] ath5k 0000:05:00.0: setting latency timer to 64
[256888.870563] ath5k 0000:05:00.0: registered as 'phy0'
[256888.943464] ath: EEPROM regdomain: 0x65
[256888.943466] ath: EEPROM indicates we should expect a direct regpair map
[256888.943471] ath: Country alpha2 being used: 00
[256888.943474] ath: Regpair used: 0x65
[256888.947007] phy0: Selected rate control algorithm 'minstrel'
[256888.947904] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)


# iw list


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
			* 2467 MHz [12] (20.0 dBm) (passive scanning)
			* 2472 MHz [13] (20.0 dBm) (passive scanning)
			* 2484 MHz [14] (disabled)
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
	max # scan SSIDs: 4
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
		 * mesh point

# iw wlan0 scan

BSS 00:40:05:c5:4f:19 (on wlan0)
        TSF: 5703065889 usec (0d, 01:35:03)
        freq: 2412
        beacon interval: 100
        capability: ESS PBCC (0x0041)
        signal: -92.00 dBm
        SSID: default
        Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0 
        DS Paramater set: channel 1
BSS 00:16:b6:db:fd:78 (on wlan0)
        TSF: 625899182784 usec (7d, 05:51:39)
        freq: 2437
        beacon interval: 100
        capability: ESS ShortSlotTime (0x0401)
        signal: -101.00 dBm
        SSID: linksys
        Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0
54.0 
        DS Paramater set: channel 6
        ERP: Barker_Preamble_Mode
        Extended supported rates: 6.0 9.0 12.0 48.0 

# iw wlan0 info
Interface wlan0
        ifindex 6
        type managed




-- 
Joel Roth
