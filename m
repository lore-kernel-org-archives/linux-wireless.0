Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:38769 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYFZVYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:24:34 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product =?iso-8859-1?q?id=090x8197/0x8189?=
Date: Thu, 26 Jun 2008 18:24:39 -0300
Cc: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	andreamrl@tiscali.it, linville@redhat.com
References: <779389.39286.qm@web23108.mail.ird.yahoo.com> <4863F1DE.3080503@yahoo.co.uk> <200806261740.17878.herton@mandriva.com.br>
In-Reply-To: <200806261740.17878.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806261824.40610.herton@mandriva.com.br> (sfid-20080626_232447_743912_A6D76C41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small corrections to last message:

Em Thursday 26 June 2008 17:40:09 Herton Ronaldo Krzesinski escreveu:
> 
> There are main 6 changes on the diff above:
> 
> - len is probably plcp_len field like on r818{0,5}, on vendor driver it was
> specified as 'length'
> - To turn ANAPARAM off we need especial value like when turning on, for
> ANAPARAM*_OFF values I used the stock values from the hardware after
> a cold boot
> - The write to the address 0xFFF0 seems to need always a write to ACM_CONTROL

I mean 0xFFF0 to 0xFFFC

> after this with value '0', the vendor driver both on win/linux does this, was
> another mistake that I didn't see:
>  	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
> +	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
> 
> - Win driver writes to 0xFF4E and , so I added the same thing:

"- Win driver writes to 0xFF4E, so I added the same thing:"

> +	rtl818x_iowrite8_idx(priv, (u8 *)0xFF4E, 1, 2);
> and does things in another order, so I moved code:
> +	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0xa4, 0x86); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x85, 0xfb); msleep(1);
> 
> - I changed "static const u8 rtl8225z2_ofdm[]" because of when looking the usb
> traffic with usbmon and ndiswrapper it was different in that values, the win
> driver has the values.

"- I changed "static const u8 rtl8225z2_ofdm[]" because of when looking the usb
 traffic with usbmon and ndiswrapper it was different in that values" (drop last sentence)

> - I placed msleep(1) after write TX_ANTENNA, as all already in kernel realtek
> code need this why rtl8187b does not? Better to play safe.
> 
> As I don't have docs I have to appeal to this kind of things... sorry for the
> everything in one patch, I wasn't available to look more into this, but better
> post what I have found until now.
> 

-- 
[]'s
Herton
