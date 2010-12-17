Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:42252 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0LQI7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 03:59:54 -0500
Received: by gxk19 with SMTP id 19so268699gxk.11
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 00:59:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com> <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
 <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com> <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
 <98BC4735-664C-491E-80CE-356BE32FA2ED@mac.com> <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 17 Dec 2010 10:59:38 +0200
Message-ID: <AANLkTimJCg1_6cZY1JE11hpmow772cP2KspM6diuDoAE@mail.gmail.com>
Subject: Problem bringing up wlan0 interface up with mainline wl1271 drivers
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: panduranga <x0125717@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Jara, Pedro" <pedrojara@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ resending to list since it rejects html subparts ]

Hey Elvis,

>
> On Fri, Dec 17, 2010 at 10:36, Elvis Dowson <elvis.dowson@mac.com> wrote:
>>
>> Hi,
>>
>> On Dec 17, 2010, at 9:11 AM, panduranga wrote:
>>
>> # ifconfig wlan0 hw ether 11:22:33:44:55:66
>> SIOCSIFHWADDR: Cannot assign requested address
>>
>> Even trying to assign an IP address doesn't work.
>>
>> # ifconfig wlan0 inet 192.168.1.105 netmask 255.255.255.0
>> SIOCSIFFLAGS: Cannot assign requested address
>>
>

Ethernet addresses with the LSB of the first octet turned on are
considered multicast addresses. Please try:

ifconfig wlan0 hw ether 00:22:33:44:55:66

Regards,
Arik
