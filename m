Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:38894 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754220Ab0IRNn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 09:43:27 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: Realtek rtl8188 support?
Date: Sat, 18 Sep 2010 15:43:15 +0200
Cc: Claus Ried <claus.ried@gmail.com>, linux-wireless@vger.kernel.org
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com> <loom.20100910T132509-455@post.gmane.org> <AANLkTim4F8t2g8YGH8TKaudzAg42vzFgijcURUubVdkc@mail.gmail.com>
In-Reply-To: <AANLkTim4F8t2g8YGH8TKaudzAg42vzFgijcURUubVdkc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009181543.18159.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Saturday 18 September 2010, Hin-Tak Leung wrote:
> On Fri, Sep 10, 2010 at 12:29 PM, Claus Ried <claus.ried@gmail.com> wrote:
[...]
> The Realtek vendor driver has always bundled its own wpa_supplicant
> and I have wondered what mod they have made. Are you using your distro
> wpa_supplicant or the Realtek vendor bundled one?

Talking about the staging driver in kernel 2.6.35/ 2.6.36 (rtl8192su/ 
r8192s_usb, I didn't test rtl8712 from {linux,staging}-next yet), 
RTL8188S [1] and RTL8191S [2] hardware works quite well for me with 
stock wpasupplicant 0.6.10/ 0.7.3 (Debian/ unstable, no hardware 
specific patches and using the plain wext backend and no special 
configuration). While it takes a little to authenticate succesfully 
(20-30 seconds), I have not experienced any problems yet.

Looking at the bundled wpa_supplicant-0.5.10.tar.gz (from
rtl8192su_linux_2.6.0003.0810.2009.tar.gz shipped on the vendor's 
driver CD) confirms that its MD5 matches the upstream wpa_supplicant 
tarball:
	9e7b99da67c47d81121368c6d580d069 *wpa_supplicant-0.5.10.tar.gz

Regards
	Stefan Lippers-Hollmann

[1]	Longshine LCS-8131N2, 150 MBit/s
	0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter
	.
	usb 1-3: new high speed USB device using ehci_hcd and address 6
	usb 1-3: New USB device found, idVendor=0bda, idProduct=8171
	usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
	usb 1-3: Product: RTL8188S WLAN Adapter 
	usb 1-3: Manufacturer: Manufacturer Realtek 
	usb 1-3: SerialNumber: 00e04c000001

[2]	DeLock 88530, 300 MBit/s
	0bda:8172 Realtek Semiconductor Corp. RTL8191S WLAN Adapter
	.
	usb 2-6: new high speed USB device using ehci_hcd and address 2
	usb 2-6: New USB device found, idVendor=0bda, idProduct=8172
	usb 2-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
	usb 2-6: Product: RTL8191S WLAN Adapter
	usb 2-6: Manufacturer: Manufacturer Realtek
	usb 2-6: SerialNumber: 00e04c000001
