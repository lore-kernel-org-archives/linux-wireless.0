Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perathoner.de ([213.133.103.166]:60354 "EHLO
	yvonne.perathoner.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYHQVkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 17:40:47 -0400
Received: from p5b0033ee.dip.t-dialin.net ([91.0.51.238] helo=fool.perathoner.loc)
	by yvonne.perathoner.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <marcello@perathoner.de>)
	id 1KUpVD-0003Zb-5d
	for linux-wireless@vger.kernel.org; Sun, 17 Aug 2008 23:09:33 +0200
Message-ID: <48A89363.5080505@perathoner.de> (sfid-20080817_234055_866216_9B6A732D)
Date: Sun, 17 Aug 2008 23:08:51 +0200
From: Marcello Perathoner <marcello@perathoner.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Subject: [BUG] periodic iwl4965 connectivity drops on thinkpad t61
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I experience periodic drops of connectivity on my thinkpad t61.

This happens exactly every 10 minutes. The connectivity is always back 
after 1 minute.

Also, connectivity drops almost immediately after dhcp handshake. 
ifconfig shows the interface is fully configured, so dhcp worked. 
Connectivity comes back after ca. 80 seconds.


Problem started when I upgraded from kernel 2.6.24 to 2.6.25 and still 
happens with kernel 2.6.26 standard driver and with new driver compiled 
from compat-wireless-2008-08-06.

Last working iwl4965 version: 1.1.17ks


Conjecture: bug triggers when access point tries to install new group 
key. Ran wpa_supplicant in terminal:

> # wpa_supplicant -c/etc/wpa_supplicant.conf -iwlan0 -d

Output of dmesg on start of wpa_supplicant:

> [  339.983966] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> [  339.983966] PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100102, writing 100106)
> [  340.181492] Registered led device: iwl-phy0:radio
> [  340.181492] Registered led device: iwl-phy0:assoc
> [  340.181492] Registered led device: iwl-phy0:RX
> [  340.181492] Registered led device: iwl-phy0:TX
> [  340.220702] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  341.990325] wlan0: authenticate with AP 00:1c:4a:01:ba:9c
> [  341.992033] wlan0: authenticated
> [  341.992044] wlan0: associate with AP 00:1c:4a:01:ba:9c
> [  341.996536] wlan0: RX AssocResp from 00:1c:4a:01:ba:9c (capab=0x431 status=0 aid=2)
> [  341.996536] wlan0: associated
> [  341.996536] wlan0 (WE) : Wireless Event too big (366)
> [  342.009290] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  352.130226] wlan0: no IPv6 routers present
> [  459.398344] iwl4965: iwl_tx_agg_start on ra = 00:1c:4a:01:ba:9c tid = 0
> [  459.398344] HW queue is empty

Nothing happens in dmesg when connectivity drops.

But:

Debug log from wpa_supplicant every 10 minutes immediately before (or 
after?) connectivity drops:

> RX EAPOL from 00:1c:4a:01:ba:9c
> IEEE 802.1X RX: version=2 type=3 length=127
>   EAPOL-Key type=2
>   key_info 0x1382 (ver=2 keyidx=0 rsvd=0 Group Ack MIC Secure Encr)
>   key_length=16 key_data_length=32
>   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 06
>   key_nonce - hexdump(len=32): 09 1b fe 12 31 74 f0 69 a1 46 e8 13 bf 88 9a 16 74 99 02 4f ae 1e 76 30 24 50 5a 03 fb f6 a1 0f
>   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
>   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
>   key_mic - hexdump(len=16): 45 34 fa 0d f6 1e b1 64 20 c5 e2 b0 b0 29 bf f4
> RSN: encrypted key data - hexdump(len=32): fe 9f da bd 37 30 21 b6 a2 13 19 e3 62 e4 71 d6 72 dc e1 7b d2 b1 b5 11 10 88 46 fd 53 01 41 1e
> WPA: decrypted EAPOL-Key key data - hexdump(len=24): [REMOVED]
> WPA: RX message 1 of Group Key Handshake from 00:1c:4a:01:ba:9c (ver=2)
> RSN: msg 1/2 key data - hexdump(len=24): dd 16 00 0f ac 01 02 00 53 23 2e 42 85 a4 ea bd 01 8f e9 bc 8b 49 3c 0e
> RSN: received GTK in group key handshake - hexdump(len=18): 02 00 53 23 2e 42 85 a4 ea bd 01 8f e9 bc 8b 49 3c 0e
> State: COMPLETED -> GROUP_HANDSHAKE
> WPA: Group Key - hexdump(len=16): [REMOVED]
> WPA: Installing GTK to the driver (keyidx=2 tx=0 len=16).
> WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
> wpa_driver_wext_set_key: alg=3 key_idx=2 set_tx=0 seq_len=6 key_len=16
> WPA: Sending EAPOL-Key 2/2
> WPA: Group rekeying completed with 00:1c:4a:01:ba:9c [GTK=CCMP]
> Cancelling authentication timeout
> State: GROUP_HANDSHAKE -> COMPLETED

ping output:

 > 64 bytes from 192.168.178.1: icmp_seq=202 ttl=64 time=1.39 ms
 > 64 bytes from 192.168.178.1: icmp_seq=203 ttl=64 time=1.24 ms
 > 64 bytes from 192.168.178.1: icmp_seq=204 ttl=64 time=1.63 ms
 > [ wpa_supplicant output happens at this moment ]
 > From 192.168.178.21 icmp_seq=233 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=234 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=235 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=237 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=238 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=239 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=241 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=242 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=243 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=245 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=246 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=247 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=249 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=250 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=251 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=253 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=254 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=255 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=257 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=258 Destination Host Unreachable
 > From 192.168.178.21 icmp_seq=259 Destination Host Unreachable
 > 64 bytes from 192.168.178.1: icmp_seq=205 ttl=64 time=57049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=206 ttl=64 time=56049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=207 ttl=64 time=55049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=208 ttl=64 time=54049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=209 ttl=64 time=53049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=210 ttl=64 time=52049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=211 ttl=64 time=51049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=212 ttl=64 time=50049 ms
 > 64 bytes from 192.168.178.1: icmp_seq=213 ttl=64 time=49045 ms
 > 64 bytes from 192.168.178.1: icmp_seq=214 ttl=64 time=48032 ms
 > 64 bytes from 192.168.178.1: icmp_seq=215 ttl=64 time=47032 ms
 > 64 bytes from 192.168.178.1: icmp_seq=216 ttl=64 time=46033 ms
 > 64 bytes from 192.168.178.1: icmp_seq=217 ttl=64 time=45033 ms
 > 64 bytes from 192.168.178.1: icmp_seq=218 ttl=64 time=44033 ms
 > 64 bytes from 192.168.178.1: icmp_seq=219 ttl=64 time=43033 ms
 > 64 bytes from 192.168.178.1: icmp_seq=263 ttl=64 time=0.956 ms
 > 64 bytes from 192.168.178.1: icmp_seq=264 ttl=64 time=1.46 ms
 > 64 bytes from 192.168.178.1: icmp_seq=265 ttl=64 time=0.947 ms
 > 64 bytes from 192.168.178.1: icmp_seq=266 ttl=64 time=0.962 ms
 > 64 bytes from 192.168.178.1: icmp_seq=267 ttl=64 time=0.957 ms


These are my parameters:

> # cat /etc/modprobe.d/options
> options iwl4965 debug=0x43fff disable_hw_scan=1
> # 


Any ideas?

What can I do / where can I look for more details?



