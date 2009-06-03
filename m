Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:34971 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZFCCyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 22:54:50 -0400
Received: by qw-out-2122.google.com with SMTP id 5so5945840qwd.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 19:54:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ee8eb53d0906021923k3dc3578er755c4b3676d6495@mail.gmail.com>
References: <ee8eb53d0905312008rbd346d8h171fedb96d2a3d96@mail.gmail.com>
	 <1243858809.5299.15.camel@johannes.local>
	 <20090601131742.GA3386@tuxdriver.com>
	 <ee8eb53d0906021917q787c160ja3b3a453f09da1d0@mail.gmail.com>
	 <ee8eb53d0906021923k3dc3578er755c4b3676d6495@mail.gmail.com>
Date: Tue, 2 Jun 2009 23:54:52 -0300
Message-ID: <ee8eb53d0906021954q256083dax5ef2b37c53925f06@mail.gmail.com>
Subject: Re: [GSoC 2009] Automation of testing using mac80211_hwsim and Orbit
	- status report 01
From: Georgy Berdyshev <codingmaster@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I got it worked out.

/opt/wifi/bin/hostapd hostapd.conf -dd
Configuration file: hostapd.conf
nl80211: Add own interface ifindex 6
nl80211: Add own interface ifindex 12
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
.......
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x6
..........
RATE[11] rate=540 flags=0x0
Completing interface initialization
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
Flushing old station entries
Deauthenticate all stations
nl_set_encr: ifindex=6 alg=0 addr=(nil) key_idx=0 set_tx=1 seq_len=0 key_len=0
nl_set_encr: ifindex=6 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
nl_set_encr: ifindex=6 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
nl_set_encr: ifindex=6 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
Using interface wlan0 with hwaddr 02:00:00:00:00:00 and ssid 'mac80211 test'
nl80211: Set beacon (beacon_set=0)
wlan0: Setup of interface done.
MGMT (TX callback) ACK

Blacklisting some modules and disabling NetworkManager fixed the problem.

Georgy

-- 
Georgy Berdyshev

GPG key: 830F68C5
Fingerprint: 0379 ED5A BEE5 65A8 7BD5  31E7 F5B4 1EC7 830F 68C5
