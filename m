Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41152 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbYFZVwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:52:18 -0400
Message-ID: <48640FDB.70602@lwfinger.net> (sfid-20080626_235220_754736_77A9C74E)
Date: Thu, 26 Jun 2008 16:53:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	Pavel Roskin <proski@gnu.org>,
	Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id 0x8197/0x8189
References: <779389.39286.qm@web23108.mail.ird.yahoo.com> <4863F1DE.3080503@yahoo.co.uk> <200806261740.17878.herton@mandriva.com.br> <200806261824.40610.herton@mandriva.com.br>
In-Reply-To: <200806261824.40610.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Small corrections to last message:
> 
> Em Thursday 26 June 2008 17:40:09 Herton Ronaldo Krzesinski escreveu:
>> There are main 6 changes on the diff above:
>>
>> - len is probably plcp_len field like on r818{0,5}, on vendor driver it was
>> specified as 'length'
>> - To turn ANAPARAM off we need especial value like when turning on, for
>> ANAPARAM*_OFF values I used the stock values from the hardware after
>> a cold boot
>> - The write to the address 0xFFF0 seems to need always a write to ACM_CONTROL
> 
> I mean 0xFFF0 to 0xFFFC
> 
>> after this with value '0', the vendor driver both on win/linux does this, was
>> another mistake that I didn't see:
>>  	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
>> +	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
>>
>> - Win driver writes to 0xFF4E and , so I added the same thing:
> 
> "- Win driver writes to 0xFF4E, so I added the same thing:"
> 
>> +	rtl818x_iowrite8_idx(priv, (u8 *)0xFF4E, 1, 2);
>> and does things in another order, so I moved code:
>> +	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
>> +	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
>> +	rtl8225_write_phy_ofdm(dev, 0xa4, 0x86); msleep(1);
>> +	rtl8225_write_phy_ofdm(dev, 0x85, 0xfb); msleep(1);
>>
>> - I changed "static const u8 rtl8225z2_ofdm[]" because of when looking the usb
>> traffic with usbmon and ndiswrapper it was different in that values, the win
>> driver has the values.
> 
> "- I changed "static const u8 rtl8225z2_ofdm[]" because of when looking the usb
>  traffic with usbmon and ndiswrapper it was different in that values" (drop last sentence)
> 
>> - I placed msleep(1) after write TX_ANTENNA, as all already in kernel realtek
>> code need this why rtl8187b does not? Better to play safe.
>>
>> As I don't have docs I have to appeal to this kind of things... sorry for the
>> everything in one patch, I wasn't available to look more into this, but better
>> post what I have found until now.

I have put your patch into the wireless-testing code. So far, I have 
not seen any particular improvement in the performance, etc. of the 
device, but I'll continue to play with it.

Larry
