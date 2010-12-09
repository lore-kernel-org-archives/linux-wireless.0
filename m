Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:58789 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab0LIPUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 10:20:17 -0500
Received: by fxm18 with SMTP id 18so2511520fxm.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 07:20:16 -0800 (PST)
Message-ID: <4D00F3C3.6040801@lwfinger.net>
Date: Thu, 09 Dec 2010 09:20:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/4] Make N-PHY support experimental
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>	<AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>	<4CFEFD8D.1080808@lwfinger.net> <AANLkTi=mDh9wkp+u3ebuXqF8Q-rTW_YCtee3CmCBdWTh@mail.gmail.com>
In-Reply-To: <AANLkTi=mDh9wkp+u3ebuXqF8Q-rTW_YCtee3CmCBdWTh@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2010 08:11 AM, Rafał Miłecki wrote:
> 2010/12/8 Larry Finger <Larry.Finger@lwfinger.net>:
>> I have a bit more info regarding the problem with WPA2 encryption on an N PHY.
>> As shown in the NetworkManager log attached, Authentication is successful, but
>> DHCP fails. Either the transmit data is improperly encrypted, or the decryption
>> fails. I will use wireshark to sort that out. Note: Using software encryption
>> makes no difference.
> 
> Hm, I expected software encryption to work, that's weird. I don't
> really have nice access to my development machine, so some tests would
> be great.

Actually, when I got wireshark all setup on my netbook and tried again, WPA2
worked with hardware encryption. I'm not sure what the problem was the first time.

I still have no idea why OFDM rates are failing. Any thoughts?

My device lists the following:

Network controller [0280]: Broadcom Corporation BCM4321 802.11a/b/g/n
[14e4:4328] (rev 03)
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
ssb: Core 2 found: PCI-E (cc 0x820, rev 0x04, vendor 0x4243)
ssb: Core 3 found: PCI (cc 0x804, rev 0x0D, vendor 0x4243)
ssb: Core 4 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)

It has a rev 2 PHY, and a rev 4 0x2055 radio.

I am willing to buy a higher PHY rev device for testing. Any idea what is in a
4324A-BRCM1036? See
http://cgi.ebay.com/Broadcom-Mini-PCI-e-802-11-a-b-g-n-Wireless-Card-/190477425068?pt=LH_DefaultDomain_0&hash=item2c5956d9ac.

Larry
