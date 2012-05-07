Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:38026 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab2EGHFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 03:05:11 -0400
Message-Id: <201205070702.q4772uem002960@mail.maya.org> (sfid-20120507_090516_132109_B2DD8555)
Date: Mon, 7 May 2012 09:02:58 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: hostap@lists.shmoo.com,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken
 aggregation handling?
In-Reply-To: <4FA75983.9040003@01019freenet.de>
References: <4FA75983.9040003@01019freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07 2012 at 07:11:31 +0200 
Andreas Hartmann <andihartmann@01019freenet.de> wrote:

> Hello!
> 
> I switched on 802.11w on my AP (rt2860) in hostapd with ieee80211w=1 and
> in wpa_supplicant with ieee80211w=2 (ath9k). key_mgmt is WPA-EAP (TLS) /
> CCMP for both pairwise and group.
> 
> On both machines, compat-wireless-2012-04-26 (or
> compat-wireless-3.4-rc3) is running.
> 
> Directly after authorization, dhcp is started and therefore the opening
> of the BA session is started by the AP but times out because of no
> answer of the supplicant:

[...]

> 
> The deauth request from wpa_supplicant -> AP isn't recognized on the AP,
> too.

Meanwhile, I found the reason (I forgot to take care of hostapd's
logfile - I would have expected an error message from the driver in
messages, too :-)):

AP (hostapd.log):
...
1336372202.462946: WPA: 48:5d:60:3e:a3:18 WPA_PTK entering state INITIALIZE
1336372202.462965: wpa_driver_nl80211_set_key: ifindex=17 alg=0 addr=0x673d40 key_idx=0 set_tx=1 seq_len=0 key_len=0
1336372202.462977:    addr=48:5d:60:3e:a3:18
1336372202.462999: WPA: 48:5d:60:3e:a3:18 WPA_PTK_GROUP entering state IDLE
1336372202.463007: WPA: 48:5d:60:3e:a3:18 WPA_PTK entering state AUTHENTICATION
1336372202.463018: WPA: 48:5d:60:3e:a3:18 WPA_PTK entering state AUTHENTICATION2
1336372202.463025: WPA: Re-initialize GMK/Counter on first station
1336372202.463896: GMK - hexdump(len=32): [REMOVED]
1336372202.464771: Key Counter - hexdump(len=32): [REMOVED]
1336372202.465639: GTK - hexdump(len=16): [REMOVED]
1336372202.466502: IGTK - hexdump(len=16): [REMOVED]
1336372202.466524: wpa_driver_nl80211_set_key: ifindex=17 alg=3 addr=0x44fbbe key_idx=1 set_tx=1 seq_len=0 key_len=16
1336372202.466539:    broadcast key
1336372202.478318: wpa_driver_nl80211_set_key: ifindex=17 alg=4 addr=0x44fbbe key_idx=4 set_tx=1 seq_len=0 key_len=16
1336372202.478349:    broadcast key
1336372202.478389: nl80211: set_key failed; err=-22 Invalid argument)
....
1336372202.529973: wlan0: STA 48:5d:60:3e:a3:18 IEEE 802.1X: authenticated - EAP type: 13 (TLS)


But there are some questions open anyway:

- Why is the authentication started here at all, regardless of an error?
- Why does TLS succeed? (802.11g is "working"). 
- Why does set_key fail?


I'm getting the same error, regardless if nohwcrypt is enabled for
rt2800pci or not.


Thanks for your advice,
kind regards,
Andreas Hartmann
