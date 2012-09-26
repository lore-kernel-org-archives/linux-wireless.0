Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60083 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab2IZRQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 13:16:05 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Alper Yilmaz <alperyilmaz@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 802.1X can associate but can not connect
References: <CAFDG9nuce-T0paZavi3D1wnNLHsJkxH4NOPmayFAM9TPOkQ13Q@mail.gmail.com>
	<87obkt2hdw.fsf@purkki.adurom.net>
Date: Wed, 26 Sep 2012 20:16:03 +0300
In-Reply-To: <87obkt2hdw.fsf@purkki.adurom.net> (Kalle Valo's message of "Wed,
	26 Sep 2012 13:44:11 +0300")
Message-ID: <87fw643dt8.fsf@purkki.adurom.net> (sfid-20120926_191609_996005_3B2431D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@adurom.com> writes:

>> The forum post contains all necessary information (system info, logs, etc.).
>
> Is this the post:
>
> http://ubuntuforums.org/showthread.php?t=2060708

(Alper confirmed privately that the URL is correct.)

>From the logs it seems that wifi authentication was succesful:

Aug 22 22:18:44 dv7 wpa_supplicant[4528]: CTRL-EVENT-EAP-SUCCESS EAP
authentication completed successfully
Aug 22 22:18:44 dv7 wpa_supplicant[4528]: CTRL-EVENT-CONNECTED -
Connection to 00:25:46:83:

But dhcp failed:

Aug 22 22:19:23 dv7 dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255
port 67 interval 12
Aug 22 22:19:29 dv7 NetworkManager[4519]: <warn> (wlan0): DHCPv4 request
timed out.

>From this I can't yet conclude where the problem is. It might a problem
with dhcp client/server or it might be a lower level problem in wifi
(driver/wpasupplicant).

Few things I recommend to try:

o manual IPs (for example, use same settings as windows gets from the dhcp
server)
o disable network-manager and run wpasupplicant manually
o try different dhcp client, like udhcpc

-- 
Kalle Valo
