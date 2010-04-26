Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34776 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab0DZQIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 12:08:18 -0400
Subject: Re: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD}
 time out after 500ms
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <m2s2d0a357f1004260120z30d8b3a3i2792cfa4bc390dcc@mail.gmail.com>
References: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
	 <1271782442.14052.19698.camel@rchatre-DESK>
	 <s2j2d0a357f1004210006gc964e5edl672ec5406b892a9@mail.gmail.com>
	 <1271883056.4381.1743.camel@rchatre-DESK>
	 <m2s2d0a357f1004260120z30d8b3a3i2792cfa4bc390dcc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 09:08:17 -0700
Message-ID: <1272298097.4381.8765.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 01:20 -0700, Sedat Dilek wrote:
> I had only one issue with
> linux-image-2.6.34-rc4-115-gdc57da3_2.6.34-rc4-115-gdc57da3.20100424~iniza.1_i386.deb
> kernel:
> 
> ...
> /var/log/syslog.1-Apr 25 13:33:11 seduxbox wpa_supplicant[1732]: WPA:
> Group rekeying completed with 00:04:0e:e4:00:3d [GTK=CCMP]
> /var/log/syslog.1:Apr 25 13:59:56 seduxbox kernel: [59184.500070] No
> probe response from AP 00:04:0e:e4:00:3d after 500ms, disconnecting.
> /var/log/syslog.1-Apr 25 13:59:56 seduxbox kernel: [59184.505044]
> cfg80211: Calling CRDA to update world regulatory domain
> /var/log/syslog.1-Apr 25 13:59:56 seduxbox wpa_supplicant[1732]:
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> /var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717331]
> cfg80211: World regulatory domain updated:
> /var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717337]
> (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> /var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717343]
> (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> /var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717349]
> (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> /var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717355]
> (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> /var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717361]
> (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> /var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717367]
> (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]:
> Trying to associate with 00:04:0e:e4:00:3d
> (SSID='g00gle-street-knows-my-SSID-and-where-I-live' freq=2442 MHz)
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.753888]
> wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.755614]
> wlan0: authenticated
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.755649]
> wlan0: associate with 00:04:0e:e4:00:3d (try 1)
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.760216]
> wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0
> aid=1)
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.760221]
> wlan0: associated
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]:
> Associated with 00:04:0e:e4:00:3d
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]: WPA:
> Key negotiation completed with 00:04:0e:e4:00:3d [PTK=CCMP GTK=CCMP]
> /var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]:
> CTRL-EVENT-CONNECTED - Connection to 00:04:0e:e4:00:3d completed
> (reauth) [id=0 id_str=]
> ...

Sorry ... but could you please point out what the issue is above? I do
see that at one point the station's testing of AP communication
fails ... but that can happen for many reasons and does not indicate a
bug. Was there some other logs that pointed out an issue during this
time?

Reinette


