Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lerya.net ([213.251.186.118]:55376 "EHLO mx.lerya.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab3CMIAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 04:00:54 -0400
Date: Wed, 13 Mar 2013 09:00:48 +0100
From: Vincent Brillault <gentoo@lerya.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
Message-ID: <20130313080048.GB3484@Fea.lerya.net> (sfid-20130313_090058_681933_95C61781)
References: <20130307192920.GB8668@Fea.lerya.net>
 <20130308215833.GA2829@Fea.lerya.net>
 <513A960B.2020304@lwfinger.net>
 <20130309113222.GA3009@Fea.lerya.net>
 <513B7E58.9000505@lwfinger.net>
 <20130311183825.GG3009@Fea.lerya.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="E39vaYmALEf/7YXx"
In-Reply-To: <20130311183825.GG3009@Fea.lerya.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've achieved to capture more data. I've attached the result of a 'tail'
on both kernel logs and wpa_supplicant logs. The problem seems to be
related to those warnings on replay counters:
'wlan0: WPA: EAPOL-Key Replay Counter did not increase - dropping
packet'

Best,
Vincent

--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kernel-wpa.log"

==> /var/log/wpa_supplicant.log <==
wlan0: WPA: Group rekeying completed with 00:21:1e:4d:57:60 [GTK=TKIP]
wlan0: WPA: EAPOL-Key Replay Counter did not increase - dropping packet
wlan0: WPA: EAPOL-Key Replay Counter did not increase - dropping packet
wlan0: WPA: Group rekeying completed with 00:21:1e:4d:57:60 [GTK=TKIP]
wlan0: WPA: EAPOL-Key Replay Counter did not increase - dropping packet
wlan0: WPA: EAPOL-Key Replay Counter did not increase - dropping packet
wlan0: WPA: EAPOL-Key Replay Counter did not increase - dropping packet
wlan0: WPA: Group rekeying completed with 00:21:1e:4d:57:60 [GTK=TKIP]
wlan0: WPA: EAPOL-Key Replay Counter did not increase - dropping packet

==> /var/log/kern.log <==
Mar 13 08:23:18 localhost kernel: [331840.054781] wlan0: deauthenticated from 00:21:1e:4d:57:60 (Reason: 7)
Mar 13 08:23:18 localhost kernel: [331840.056808] wlan0: moving STA 00:21:1e:4d:57:60 to state 3
Mar 13 08:23:18 localhost kernel: [331840.056814] wlan0: moving STA 00:21:1e:4d:57:60 to state 2
Mar 13 08:23:18 localhost kernel: [331840.056817] wlan0: moving STA 00:21:1e:4d:57:60 to state 1
Mar 13 08:23:18 localhost kernel: [331840.056820] wlan0: Removed STA 00:21:1e:4d:57:60

==> /var/log/wpa_supplicant.log <==
wlan0: CTRL-EVENT-DISCONNECTED bssid=00:21:1e:4d:57:60 reason=0

==> /var/log/kern.log <==
Mar 13 08:23:18 localhost kernel: [331840.062797] wlan0: Destroyed STA 00:21:1e:4d:57:60
Mar 13 08:23:18 localhost kernel: [331840.062820] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar 13 08:23:18 localhost kernel: [331840.062824] cfg80211: Restoring regulatory settings
Mar 13 08:23:18 localhost kernel: [331840.062829] cfg80211: Kicking the queue
Mar 13 08:23:18 localhost kernel: [331840.062833] cfg80211: Calling CRDA to update world regulatory domain
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211: World regulatory domain updated:
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 13 08:23:18 localhost kernel: [331840.117741] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

==> /var/log/wpa_supplicant.log <==
wlan0: Trying to associate with 00:21:1e:4d:57:60 (SSID='***' freq=2437 MHz)

==> /var/log/kern.log <==
Mar 13 08:23:19 localhost kernel: [331841.075026] wlan0: authenticate with 00:21:1e:4d:57:60
Mar 13 08:23:19 localhost kernel: [331841.075034] wlan0: Allocated STA 00:21:1e:4d:57:60

==> /var/log/wpa_supplicant.log <==
wlan0: Association request to the driver failed

==> /var/log/kern.log <==
Mar 13 08:23:19 localhost kernel: [331841.084665] wlan0: Inserted STA 00:21:1e:4d:57:60
Mar 13 08:23:19 localhost kernel: [331841.084665] wlan0: send auth to 00:21:1e:4d:57:60 (try 1/3)
Mar 13 08:23:19 localhost kernel: [331841.089516] wlan0: authenticated
Mar 13 08:23:19 localhost kernel: [331841.089521] wlan0: moving STA 00:21:1e:4d:57:60 to state 2
Mar 13 08:23:19 localhost kernel: [331841.089543] rtl8192ce 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
Mar 13 08:23:19 localhost kernel: [331841.089547] rtl8192ce 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
Mar 13 08:23:19 localhost kernel: [331841.090484] wlan0: associate with 00:21:1e:4d:57:60 (try 1/3)

==> /var/log/wpa_supplicant.log <==
wlan0: Associated with 00:21:1e:4d:57:60

==> /var/log/kern.log <==
Mar 13 08:23:19 localhost kernel: [331841.096509] wlan0: RX AssocResp from 00:21:1e:4d:57:60 (capab=0x451 status=0 aid=1)
Mar 13 08:23:19 localhost kernel: [331841.096515] wlan0: moving STA 00:21:1e:4d:57:60 to state 3
Mar 13 08:23:19 localhost kernel: [331841.096535] wlan0: moving STA 00:21:1e:4d:57:60 to state 4
Mar 13 08:23:19 localhost kernel: [331841.096606] wlan0: associated

==> /var/log/wpa_supplicant.log <==
wlan0: WPA: Key negotiation completed with 00:21:1e:4d:57:60 [PTK=CCMP GTK=TKIP]
wlan0: CTRL-EVENT-CONNECTED - Connection to 00:21:1e:4d:57:60 completed [id=3 id_str=]

--E39vaYmALEf/7YXx--
