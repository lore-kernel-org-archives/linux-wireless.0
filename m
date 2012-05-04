Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:63133 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab2EDUau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 16:30:50 -0400
Message-ID: <4FA43C79.6020202@lenbrook.com> (sfid-20120504_223055_079033_085A39B8)
Date: Fri, 04 May 2012 16:30:49 -0400
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Anthony Ginger <mapfly@gmail.com>, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com> <4F4B25F5.4090204@qca.qualcomm.com> <4F8546C7.40703@qca.qualcomm.com> <4FA036B6.7040002@lenbrook.com> <4FA03939.4080307@qca.qualcomm.com> <4FA0535D.2060907@lenbrook.com> <4FA21468.6060909@qca.qualcomm.com>
In-Reply-To: <4FA21468.6060909@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-05-03 01:15 AM, Kalle Valo wrote:
>
> That might be challenging. I think it's easier if you add debug messages
> and try to pinpoint where it is failing. For example
> ath6kl_cfg80211_change_iface() is a good place to start debugging.
>
> Kalle
Kalle,

I tried again and it appears that sometimes (< 10 %) I can make 
connections to the ath6kl in AP mode.  Just to rule out any issues with 
my configs & tools, I setup a cw1200 sdio using the same software 
stack.  The cw1200 is working fine for me in AP mode and the output of 
hostapd is richer.  Any clues from the ath6kl hostapd output?


--------hostapd output using ath6kl-------

nl80211: Event message available
nl80211: New station d8:a2:5e:08:89:56
nl80211: Assoc Req IEs - hexdump(len=55): 00 09 4e 31 35 30 2d 66 30 30 
32 01 08 82 84 8b 96 24 30 48 6c 21 02 08 10 24 02 01 0e 32 04 0c 12 18 
60 dd 09 00 10 18 02 00 00 01 00 00 dd 07 00 50 f2 02 00 01 00
wlan0: Event ASSOC (0) received
wlan0: STA d8:a2:5e:08:89:56 IEEE 802.11: associated
STA did not include WPS/RSN/WPA IE in (Re)AssocReq
   New STA
ap_sta_add: register ap_handle_timer timeout for d8:a2:5e:08:89:56 (300 
seconds - ap_max_inactivity)
wlan0: STA d8:a2:5e:08:89:56 RADIUS: starting accounting session 
00000B62-00000000
IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for 
d8:a2:5e:08:89:56 (300 seconds - ap_max_inactivity)
Sending OFFER of 192.168.5.80
Sending OFFER of 192.168.5.80
Sending ACK to 192.168.5.80
Sending ACK to 192.168.5.80
Sending ACK to 192.168.5.80
random: Got 8/20 bytes from /dev/random
nl80211: Event message available


--------Same software stack, but with cw1200-------

wlan0: Event RX_MGMT (20) received
mgmt::auth
authentication: STA=d8:a2:5e:08:89:56 auth_alg=0 auth_transaction=1 
status_code=0 wep=0
   New STA
ap_sta_add: register ap_handle_timer timeout for d8:a2:5e:08:89:56 (300 
seconds - ap_max_inactivity)
wlan0: STA d8:a2:5e:08:89:56 IEEE 802.11: authentication OK (open system)
wlan0: STA d8:a2:5e:08:89:56 MLME: 
MLME-AUTHENTICATE.indication(d8:a2:5e:08:89:56, OPEN_SYSTEM)
wlan0: STA d8:a2:5e:08:89:56 MLME: 
MLME-DELETEKEYS.request(d8:a2:5e:08:89:56)
authentication reply: STA=d8:a2:5e:08:89:56 auth_alg=0 
auth_transaction=2 resp=0 (IE len=0)
wlan0: Event TX_STATUS (18) received
mgmt::auth cb
wlan0: STA d8:a2:5e:08:89:56 IEEE 802.11: authenticated
wlan0: Event RX_MGMT (20) received
mgmt::assoc_req
association request: STA=d8:a2:5e:08:89:56 capab_info=0x21 
listen_interval=10
   new AID 1
wlan0: STA d8:a2:5e:08:89:56 IEEE 802.11: association OK (aid 1)
wlan0: Event TX_STATUS (18) received
mgmt::assoc_resp cb
wlan0: STA d8:a2:5e:08:89:56 IEEE 802.11: associated (aid 1)
wlan0: AP-STA-CONNECTED d8:a2:5e:08:89:56
wlan0: STA d8:a2:5e:08:89:56 MLME: 
MLME-ASSOCIATE.indication(d8:a2:5e:08:89:56)
wlan0: STA d8:a2:5e:08:89:56 MLME: 
MLME-DELETEKEYS.request(d8:a2:5e:08:89:56)
wlan0: STA d8:a2:5e:08:89:56 RADIUS: starting accounting session 
0000167A-00000000
IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for 
d8:a2:5e:08:89:56 (300 seconds - ap_max_inactivity)
nl80211: Event message available
nl80211: New station d8:a2:5e:08:89:56
Sending OFFER of 192.168.5.80
Sending OFFER of 192.168.5.80
Sending ACK to 192.168.5.80

Jon
