Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:53812 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZGJKaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 06:30:03 -0400
Message-ID: <4A571822.90308@fgan.de>
Date: Fri, 10 Jul 2009 12:29:54 +0200
From: Alexander Wenzel <wenzel@fgan.de>
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problem with p54 driver and ibss mode
References: <4A55DB91.2070305@fgan.de> <73aaf0dd0907090620i752b7f9cq60563f8e22c02d75@mail.gmail.com> <4A560E4B.6080209@fgan.de> <200907092157.21784.jcmvbkbc@gmail.com>
In-Reply-To: <200907092157.21784.jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there...

>> I just checked the other N810 devices and every device has
>> the same mac address. And here we go... [p54spi_eeprom.h:39]
>> 0x00, 0x02, 0xee, 0xc0, 0xff, 0xee,

>> So is there a way to let the kernel receive and set the
>> correct mac address of the wlan device?
>> I guess my problem is this line:
>> [ 3685.320800] cx3110x spi2.0: loading default eeprom...
> You're right. I guess that easiest way to deal with it is to save blob from p54spi_eeprom.h into a file
> 3826.eeprom in the same directory as 3826.arm and fix MAC address in it, according to comments in p54spi_eeprom.h

[ 2675.558532] cx3110x spi2.0: firmware: requesting 3826.eeprom
[ 2675.625579] cx3110x spi2.0: loading user eeprom...
[ 2675.625671] phy0: hwaddr 00:1d:6e:9c:**:**, MAC:isl3820 RF:Longbow

Ok, p54 with user eeprom and manually inserted mac address works fine.
So, a part of the problem is somehow "fixed"... Thanks.

Regards,
AleX
-- 
**********************************************
Dipl.-Inform. (FH) Alexander Wenzel
Forschungsgesellschaft fuer
Angewandte Naturwissenschaften e. V. (FGAN)
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.  : 0049 (0)228 9435-263
Fax   : 0049 (0)228 9435-685
E-Mail: wenzel@fgan.de
Web   : http://www.fgan.de/
**********************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Prof. Dr. Maurus Tacke (komm. Vors.)
          Prof. Dr. Joachim Ender (Stellv.)
