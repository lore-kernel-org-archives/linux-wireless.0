Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.siteground211.com ([209.62.36.12]:54717 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYHBXMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:12:15 -0400
Date: Sun, 3 Aug 2008 02:12:06 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: me@felipebalbi.com, Eugeniy Meshcheryakov <eugen@debian.org>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080802231201.GB23361@frodo> (sfid-20080803_011222_613482_1A87C75F)
Reply-To: me@felipebalbi.com
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc> <20080731224357.GA9741@localhost.localdomain> <48939C97.5030608@imap.cc> <20080802082851.GB8213@frodo> <4894D86A.6030108@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4894D86A.6030108@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 02, 2008 at 11:58:02PM +0200, Tilman Schmidt wrote:
> Aug  2 19:06:16 compaq kernel: read firmware upload result
> Aug  2 19:06:16 compaq kernel: TNETW1450 firmware upload successful!
> Aug  2 19:06:16 compaq kernel: initializing max packet templates
> Aug  2 19:06:16 compaq kernel: acx: issue_cmd(): USB read error -75

hmm... an overflow here.

It's probably timing issue as well.

> Aug  2 19:06:16 compaq kernel: acx: issue_cmd(cmd:ACX1xx_CMD_INTERROGATE) FAILED
> Aug  2 19:06:16 compaq kernel: wlan%d: interrogate(type:ACX1xx_IE_MEMORY_CONFIG_OPTIONS) FAILED
> Aug  2 19:06:16 compaq kernel: dump queue head (from card):
> Aug  2 19:06:16 compaq kernel: len: 20
> Aug  2 19:06:16 compaq kernel: tx_memory_block_address: 80000B80
> Aug  2 19:06:16 compaq kernel: rx_memory_block_address: DF313D34
> Aug  2 19:06:16 compaq kernel: tx1_queue address: 10
> Aug  2 19:06:16 compaq kernel: rx1_queue address: E080FBBD
> Aug  2 19:06:16 compaq kernel: get_mask 0x00004182, set_mask 0x00000000
> Aug  2 19:06:16 compaq kernel: don't know how to get sensitivity for radio type 0x1B
> Aug  2 19:06:16 compaq kernel: got sensitivity value 0
> Aug  2 19:06:16 compaq kernel: got antenna value 0x4A
> Aug  2 19:06:16 compaq kernel: got regulatory domain 0x30
> Aug  2 19:06:16 compaq kernel: get_mask 0x00000000, set_mask 0x00000000 - after update
> Aug  2 19:06:16 compaq kernel: new ratevector: 82 84 0B 0C 12 16 18 24 2C 30 48 60 6C
> Aug  2 19:06:16 compaq kernel: setting RXconfig to 2010:0FDD
> Aug  2 19:06:16 compaq kernel: acx: === chipset TNETW1450, radio type 0x1B (An unknown radio used by TNETW1450 USB adapters), form factor 0x00 (unspecified), EEPROM version 0x05: uploaded firmware 'Rev 2.4.0.72' ===
> Aug  2 19:06:16 compaq kernel: registering network device
> Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0
> Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0_diag
> Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0_eeprom
> Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0_phy
> Aug  2 19:06:16 compaq kernel: acx: USB module v0.3.37 loaded successfully
> Aug  2 19:06:16 compaq kernel: usb 2-2: New USB device found, idVendor=057c, idProduct=6201
> Aug  2 19:06:16 compaq kernel: usb 2-2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Aug  2 19:06:16 compaq kernel: usb 2-2: Product: WLAN USB Device
> Aug  2 19:06:16 compaq kernel: usb 2-2: Manufacturer: AVM GmbH
> Aug  2 19:06:16 compaq kernel: usb 2-2: SerialNumber: 001C4AF1E469
> Aug  2 19:06:16 compaq ifup:     wlan0     
> Aug  2 19:06:16 compaq ifup:               No configuration found for wlan0

hmm... what does lsusb -v -d 057c:6201 reports to you ?

> The device was reported in iwconfig as:
> 
> wlan0     IEEE 802.11b+/g+  ESSID:"STAF1E469"  Nickname:"acx v0.3.37"
>           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated   
>           Bit Rate:54 Mb/s   Tx-Power=15 dBm   
>           Retry min limit:7   RTS thr:off   
>           Encryption key:off
>           Power Management:off
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> but didn't work. In particular "iwlist wlan0 scan" failed with the message:
> 
> wlan0     Interface doesn't support scanning : Resource temporarily unavailable

Did you try setting the parameters by hand ?

# iwconfig wlan0 essid <ESSID> key <KEY>

and then

# dhclient wlan0

> Aug  2 20:14:05 compaq kernel: usb 2-2: reset high speed USB device using ehci_hcd and address 12
> Aug  2 20:14:20 compaq kernel: usb 2-2: device descriptor read/64, error -110

It's probably affected by timing as well. That driver sure needs some
rework. Btw, are you using the mac80211 version or the other one ?

-- 
balbi
