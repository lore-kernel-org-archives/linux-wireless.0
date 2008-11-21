Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:62651 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYKUFVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 00:21:09 -0500
Received: by gxk4 with SMTP id 4so708709gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 21:21:07 -0800 (PST)
Message-ID: <40f31dec0811202121i7d0b5931g9b416a9122f9e0e5@mail.gmail.com> (sfid-20081121_062115_335925_3FC58E63)
Date: Fri, 21 Nov 2008 07:21:07 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: Clean up eeprom parsing and add missing calibration data
Cc: "Felix Fietkau" <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20081121030022.GA25726@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <49257136.2050902@openwrt.org>
	 <20081121030022.GA25726@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/21 Bob Copeland <me@bobcopeland.com>:
> On Thu, Nov 20, 2008 at 03:16:22PM +0100, Felix Fietkau wrote:
>> +
>> +     if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
>> +             AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
>> +             AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);
>
> Can we add the rest here?
>
> +               AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC2, ee_misc2);
> +               AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC3, ee_misc3);
> +               AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC4, ee_misc4);
> +               AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC5, ee_misc5);
>
> I'm adding CCMP support and it wants to use AR5K_EEPROM_AES_DIS(ee_misc5).
>

Problem is that legacy-hal doesn't make use of these infos (along with
many other infos stored in eeprom !), so i don't know what eeprom
versions have them. Go on and use them but for now assume that they
are only available for eeprom versions 5 and above and i'll check out
my eeprom dumps etc to find out.

Right now i'm working on a debugfs entry for eeprom stuff to make
debuging of this code easier.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
