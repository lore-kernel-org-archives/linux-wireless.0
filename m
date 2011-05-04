Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tdb.com ([216.99.214.4]:42874 "HELO mail.tdb.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754308Ab1EDOjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 10:39:24 -0400
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
References: <861v0igqhn.fsf@coulee.tdb.com>
From: Russell Senior <seniorr@aracnet.com>
Date: Wed, 04 May 2011 07:39:11 -0700
In-Reply-To: <861v0igqhn.fsf@coulee.tdb.com> (Russell Senior's message of "Sun\, 01 May 2011 12\:39\:16 -0700")
Message-ID: <86iptq8r8w.fsf@coulee.tdb.com> (sfid-20110504_163927_567369_B9E27011)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> "Russell" == Russell Senior <seniorr@aracnet.com> writes:

Russell> Recently trying to abandon madwifi for good on some embedded
Russell> devices with OpenWrt, encountered kernel panics.  Same radio
Russell> on an x86 platform (Soekris net4826), no kernel panic.
Russell> Different atheros radio, no kernel panic.  Tried two
Russell> different MIPS boards (Netgear WGT634U and Ubiquiti
Russell> RouterStation), both panic'd.

Russell> Netgear WGT634U: http://pastebin.ca/2051127 Ubiquiti
Russell> RouterStation: http://pastebin.ca/2052610

Here is another panic, this time not resulting from hostapd, but from
an adhoc vif:

  http://pastebin.ca/2053827

The initial panic appears to occur in a different function from the
hostapd initiated panics:

  PCI error 1 at PCI addr 0x10008020
  Data bus error, epc == 83006b24, ra == 83006b20
  Oops[#1]:
  Cpu 0
  $ 0   : 00000000 802f0000 deadc0de 00000002
  $ 4   : b0008020 00000002 018003e8 00000000
  $ 8   : 830a8228 00000015 83ad8df0 0000006c
  $12   : 00000001 0000000c 00000005 00000008
  $16   : 8387a000 01000000 00008020 00008024
  $20   : 0000802c 00008030 018003e8 000003e9
  $24   : 00000008 0000021c                 
  $28   : 83832000 83833b70 0000003b 83006b20
  Hi    : 00000000
  Lo    : 00000020
  epc   : 83006b24 ath5k_hw_reset_tsf+0x48/0x98 [ath5k]
      Not tainted
  ra    : 83006b20 ath5k_hw_reset_tsf+0x44/0x98 [ath5k]
  Status: 1000f403    KERNEL EXL IE
  Cause : 1080001c
  PrId  : 00019374 (MIPS 24Kc)
  Modules linked in: batman_adv ath5k ath mac80211 cfg80211 compat arc4 aes_generic crypto_algapi ipv6 leds_gpio gpio_keys_polled input_polldev input_core
  Process kworker/u:0 (pid: 5, threadinfo=83832000, task=83819100, tls=00000000)
  Stack : 00000000 00000001 00000000 00000000 000000d0 8387a000 00008034 00001f30
          00001ef0 83006d28 00000008 000200d0 0000ed54 800ade3c 83ad8da0 83ad8da0
          018003e8 00000000 00000000 000003e8 00000000 0000ed54 00000000 830113cc
          00000002 802c74fc 00000000 80099364 00000000 00000000 00000000 000252d0
          000000d0 00000001 802c74f8 003fffff 8387a000 00000000 0000021c 83845300
          ...
  Call Trace:
  [<83006b24>] ath5k_hw_reset_tsf+0x48/0x98 [ath5k]
  [<83006d28>] ath5k_hw_init_beacon+0x1b4/0x250 [ath5k]
  [<830113cc>] ath5k_beacon_update_timers+0x248/0xc8c [ath5k]
  [<83bc81f8>] ieee80211_process_addba_request+0x520/0xa44 [mac80211]
   
   
  Code: 0c058bb8  00442021  8e0500e4 <00518825> 02601021  0245100b  00402821  8e0200d4  02202021
  [...]


-- 
Russell Senior         ``I have nine fingers; you have ten.''
seniorr@aracnet.com
