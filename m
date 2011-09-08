Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62789 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab1IIA3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 20:29:07 -0400
Received: by yxp4 with SMTP id 4so975909yxp.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 17:29:06 -0700 (PDT)
Message-ID: <4E6911C2.2030309@lwfinger.net> (sfid-20110909_022912_050924_A4E9D071)
Date: Thu, 08 Sep 2011 14:04:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Semigod King <semigodking@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 driver for RT3070 wifi card does not work on big-endian
 platform
References: <CA+TXxM3EgGZmo1F9GS+-QNWfTTgWFD4XHvG31JH=kabrr=ES=A@mail.gmail.com>
In-Reply-To: <CA+TXxM3EgGZmo1F9GS+-QNWfTTgWFD4XHvG31JH=kabrr=ES=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2011 12:34 AM, Semigod King wrote:
> Greetings,
>
> I would like to report a bug to you. The same problem was reported to
> OpenWRT developers. But, they suggest me report it to linux wireless.

I do see a problem. Looking at one piece of your patch, we see

-    rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3,
-                    (u32 *)&rt2x00dev->eeprom[i]);
+    rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
+    *(u32 *)&rt2x00dev->eeprom[i] = le32_to_cpu(reg);

The last statement of rt2800_register_read_lock() does an le32_to_cpu() 
conversion of the output value (3rd argument), but rt2x00dev->eeprom is le16, 
which is why a double conversion le32 => be32 => le32 is needed. Your second 
line should be

*(u32 *)&rt2x00dev->eeprom[i] = cpu_to_le32(reg);

That does the same thing, but makes it clearer what is happening.

I am having to rebuild the Ubuntu system on my Mac, which will take a while. 
When that is done, I will be able to test.

Larry
