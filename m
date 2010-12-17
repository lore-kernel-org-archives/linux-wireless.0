Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:60763 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0LQKMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 05:12:41 -0500
Received: by gxk19 with SMTP id 19so294996gxk.11
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 02:12:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C4B3622F-ADC4-481E-9340-1819C815184A@mac.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com> <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
 <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com> <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
 <98BC4735-664C-491E-80CE-356BE32FA2ED@mac.com> <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
 <C4B3622F-ADC4-481E-9340-1819C815184A@mac.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 17 Dec 2010 12:12:23 +0200
Message-ID: <AANLkTikvk+AqKRr1VbKv9pSHicy7PAGu8GkdeZuvYwFh@mail.gmail.com>
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271 drivers
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: panduranga <x0125717@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Jara, Pedro" <pedrojara@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 11:44, Elvis Dowson <elvis.dowson@mac.com> wrote:
>
> On Dec 17, 2010, at 12:51 PM, Arik Nemtsov wrote:
>
>> Ethernet addresses with the LSB of the first octet turned on are considered multicast addresses. Please try:
>>
>> ifconfig wlan0 hw ether 00:22:33:44:55:66
>
> That worked, now the only thing is to put the firmware file in the appropriate place, I guess:
>
> # ifconfig wlan0 hw ether 00:22:33:44:55:66
>
> # ifconfig wlan0 up
>
> [  153.843597] wl1271: ERROR could not get firmware: -2
>
> Where should the firmware file be located? /etc/firmware ?
>
> Elvis Dowson
>

The firmware file should be called wl1271-fw.bin and the nvs file
should be called wl1271-nvs.bin. Both should reside in /etc/firmware
(if you're running a standard linux).

Regards,
Arik
