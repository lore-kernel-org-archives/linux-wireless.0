Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from woodchuck.wormnet.eu ([77.75.105.223]:38731 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbZEKT2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 15:28:11 -0400
Date: Mon, 11 May 2009 20:28:08 +0100 (BST)
From: Jamie Lentin <jm@lentin.co.uk>
To: Kalle Valo <kalle.valo@iki.fi>
cc: linux-wireless@vger.kernel.org
Subject: Re: Chances of WPA with at76c505a-rfmd2958
In-Reply-To: <87r5z99y1n.fsf@litku.valot.fi>
Message-ID: <alpine.DEB.1.10.0905052225290.24512@woodchuck.wormnet.eu>
References: <alpine.DEB.1.10.0904301926090.24512@woodchuck.wormnet.eu> <87r5z99y1n.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I've got this chip within my OQO 01+, generally the driver seems very
>> stable (thankyou for your work!),
>
> Which driver? There is at76c50x-usb (using mac80211) and at76_usb in
> staging (which is going away sometime in the future). Because
> at76c50x-usb is the path forward, I will omit at76_usb here.

Yes at76c50x-usb, sorry.  I'd tried at76_usb also, but not the 
WPA-enabled version you suggest below.

> The answer is (b). At least some chipsets seem to support WPA. I'm busy
> with other projects right now and I don't have time to implement WPA
> support, but I can give you hints. I see two ways forward:

Thanks---this has certainly got me further than I would have done on my 
own.  I've been playing with it when I've had the time and this is as far 
as I've got so far.

> 1) use mac80211 to encrypt the frames
>
> Currently encryption happens in hardware, but also mac80211 can do it.
> And mac80211 sw encryption supports TKIP and AES, so with luck you will
> get WPA working with that method. Remove .set_key from at76_ops and see
> what happens.

Comparing other drivers' no_hwcrypt options, I think removing set_key is 
unnecessary (mac80211 will fallback when it gets -EOPNOTSUPP from 
set_key), but I have removed it anyway to see what happens.

The 4-way handshake works, however hostapd doesn't receive a response to 
the group handshake.  hostapd says "EAPOL-Key timeout" once it gets to 
this point.  wpa_supplicant on the device:-

State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:0f:b5:97:37:54 (ver=2)
WPA: IE KeyData - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 
00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 4/4
WPA: Installing PTK to the driver.
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_nl80211_set_key: alg=3 addr=0x80c5f04 key_idx=0 set_tx=1 
seq_len=6 key_len=16
    addr=00:0f:b5:97:37:54
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b15 len=20
Wireless event: new AP: 00:00:00:00:00:00
Setting scan request: 0 sec 100000 usec
Added BSSID 00:0f:b5:97:37:54 into blacklist
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_nl80211_set_key: alg=0 addr=0x80b89b0 key_idx=0 set_tx=0 
seq_len=0 key_len=0
nl80211: set_key failed; err=-2
wpa_driver_nl80211_set_key: alg=0 addr=0x80b89b0 key_idx=1 set_tx=0 
seq_len=0 key_len=0
nl80211: set_key failed; err=-2
wpa_driver_nl80211_set_key: alg=0 addr=0x80b89b0 key_idx=2 set_tx=0 
seq_len=0 key_len=0
nl80211: set_key failed; err=-2
wpa_driver_nl80211_set_key: alg=0 addr=0x80b89b0 key_idx=3 set_tx=0 
seq_len=0 key_len=0
nl80211: set_key failed; err=-2
wpa_driver_nl80211_set_key: alg=0 addr=0x80c4640 key_idx=0 set_tx=0 
seq_len=0 key_len=0
    addr=00:0f:b5:97:37:54
nl80211: set_key failed; err=-2
State: GROUP_HANDSHAKE -> DISCONNECTED

Comparing output to a working card, wpa_supplicant doesn't seem to be 
receiving the group handshake frames from hostapd.  Comparing DBG_RX_DATA 
to what wireshark finds (from a third computer), none of the group key 
handshake frames get as far as DBG_RX_DATA, although when using TKIP 
there is a 802.11 ACK frame going back (CCMP is ignored entirely).  Is the 
firmware trying to decrypt and ditching them, since it doesn't have the 
relevant keys?  Any ideas on what I can poke to stop this?

> 2) enable firmware support for WPA
>
> Milan Plzik had some patches for at76_usb which added WPA firmware
> support. The patches are here:
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-legacy.git;a=shortlog;h=at76
>
> You can port them for at76c50x-usb and get WPA working. First check that
> the WPA firmware supports your device, though.

This looks do-able, unfortunately the firmware version I have is older 
than the version insisted by FIRMWARE_IS_WPA:-

usb 3-1: using firmware atmel_at76c505a-rfmd2958.bin (version 1.102.0-113)

The "standard" set of firmwares[1] doesn't seem to include any firmwares 
newer than this.  Does anyone know where the 1.103 firmwares come from? 
The original Atmel driver seems to compile images into the source code, 
I'll try splicing this in and see what version I end up with, but if 
anyone knows better please let me know---considering the age of the 
include in CVS I'm not that hopeful it'll work.

Many thanks,

  [1] http://www.thekelleys.org.uk/atmel

