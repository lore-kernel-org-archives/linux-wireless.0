Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:33425 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab2EGKUv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:20:51 -0400
Message-ID: <4FA7A13D.6020405@01019freenet.de> (sfid-20120507_122054_866873_6FEB3702)
Date: Mon, 07 May 2012 12:17:33 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
CC: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken aggregation
 handling?
References: <4FA75983.9040003@01019freenet.de> <201205070702.q4772uem002960@mail.maya.org>
In-Reply-To: <201205070702.q4772uem002960@mail.maya.org>
Content-Type: multipart/mixed;
 boundary="------------060003060506030003040800"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060003060506030003040800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andreas Hartmann wrote:
> On Mon, May 07 2012 at 07:11:31 +0200 
> Andreas Hartmann <andihartmann@01019freenet.de> wrote:
> 
>> Hello!
>>
>> I switched on 802.11w on my AP (rt2860) in hostapd with ieee80211w=1 and
>> in wpa_supplicant with ieee80211w=2 (ath9k). key_mgmt is WPA-EAP (TLS) /
>> CCMP for both pairwise and group.
>>
>> On both machines, compat-wireless-2012-04-26 (or
>> compat-wireless-3.4-rc3) is running.
>>
>> Directly after authorization, dhcp is started and therefore the opening
>> of the BA session is started by the AP but times out because of no
>> answer of the supplicant:
> 
> [...]
> 
>>
>> The deauth request from wpa_supplicant -> AP isn't recognized on the AP,
>> too.
> 
> Meanwhile, I found the reason (I forgot to take care of hostapd's
> logfile - I would have expected an error message from the driver in
> messages, too :-)):
> 
> AP (hostapd.log):
> ...
> 1336372202.462946: WPA: 48:5d:60:3e:a3:18 WPA_PTK entering state INITIALIZE
> 1336372202.462965: wpa_driver_nl80211_set_key: ifindex=17 alg=0 addr=0x673d40 key_idx=0 set_tx=1 seq_len=0 key_len=0
> 1336372202.462977:    addr=48:5d:60:3e:a3:18
> 1336372202.462999: WPA: 48:5d:60:3e:a3:18 WPA_PTK_GROUP entering state IDLE
> 1336372202.463007: WPA: 48:5d:60:3e:a3:18 WPA_PTK entering state AUTHENTICATION
> 1336372202.463018: WPA: 48:5d:60:3e:a3:18 WPA_PTK entering state AUTHENTICATION2
> 1336372202.463025: WPA: Re-initialize GMK/Counter on first station
> 1336372202.463896: GMK - hexdump(len=32): [REMOVED]
> 1336372202.464771: Key Counter - hexdump(len=32): [REMOVED]
> 1336372202.465639: GTK - hexdump(len=16): [REMOVED]
> 1336372202.466502: IGTK - hexdump(len=16): [REMOVED]
> 1336372202.466524: wpa_driver_nl80211_set_key: ifindex=17 alg=3 addr=0x44fbbe key_idx=1 set_tx=1 seq_len=0 key_len=16
> 1336372202.466539:    broadcast key
> 1336372202.478318: wpa_driver_nl80211_set_key: ifindex=17 alg=4 addr=0x44fbbe key_idx=4 set_tx=1 seq_len=0 key_len=16
> 1336372202.478349:    broadcast key
> 1336372202.478389: nl80211: set_key failed; err=-22 Invalid argument)
> ....
> 1336372202.529973: wlan0: STA 48:5d:60:3e:a3:18 IEEE 802.1X: authenticated - EAP type: 13 (TLS)
> 
> 
> But there are some questions open anyway:
> 
> - Why is the authentication started here at all, regardless of an error?
> - Why does TLS succeed? (802.11g is "working"). 
> - Why does set_key fail?
> 
> 
> I'm getting the same error, regardless if nohwcrypt is enabled for
> rt2800pci or not.

The attached patch seems to enable 802.11w for rt2800pci (AP). It does
not work for rt2800usb (rt3572 SUPP), even if the set_key error
disappears (originally the flag IEEE80211_HW_MFP_CAPABLE was set
unconditionally).

I can't say, if it works with all rt2800pci devices and I can't say, if
it works with rt2800pci device used as supplicant.

Tested (incl. PTK rekeying) with ath9k supplicant. Deauthentication does
work fine, too. I couldn't test, if using more then one supplicant at
the same time, does work, too.

Legacy driver (rt5572sta) seems to not support 802.11w at all (with
ralink driver). Even if ieee80211w=2 in supplicant.conf is enabled, it
uses plain text management frames.


Regards,
Andreas Hartmann

--------------060003060506030003040800
Content-Type: text/x-patch;
 name="ieee802.11w-rt2x00.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ieee802.11w-rt2x00.patch"

diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c
--- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c	2012-04-26 22:10:30.000000000 +0200
+++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c	2012-05-07 11:04:17.894354807 +0200
@@ -4528,7 +4528,8 @@
 	 */
 	if (!rt2x00_is_usb(rt2x00dev))
 		rt2x00dev->hw->flags |=
-			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+			IEEE80211_HW_MFP_CAPABLE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,

--------------060003060506030003040800--
