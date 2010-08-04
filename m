Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55180 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0HDSeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 14:34:03 -0400
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wl1251 issues
References: <1280682326.3868.37.camel@gnutoo-laptop>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 04 Aug 2010 21:33:59 +0300
In-Reply-To: <1280682326.3868.37.camel@gnutoo-laptop> (Denis Carikli's message of "Sun\, 01 Aug 2010 19\:05\:26 +0200")
Message-ID: <87y6cmcjmw.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Denis 'GNUtoo' Carikli <GNUtoo@no-log.org> writes:

> Hi,

Hi Denis,

> Here's the issue(this first issue doesn't involve PSM yet):
> I connect trough wpa to the local access point at the wifi cafee(wrt54
> somrthing,running an old openwrt with a 2.4 kernel and the proprietary
> broadcom module)
>
> I use dhcp to get an ip
> The connection last for a while and then I've that:
> wlan0     IEEE 802.11bg  ESSID:"essid_has_been_hidden_in_that_mail"  
>           Mode:Managed  Frequency:2.432 GHz  Access Point:
> 00:23:69:XX:XX:XX  
>           Bit Rate=1 Mb/s   Tx-Power=20 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=43/70  Signal level=-67 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> That seem connected.
>
> root@htcdream ~ # ping 192.168.2.1
> PING 192.168.2.1 (192.168.2.1): 56 data bytes
> ^C
> --- 192.168.2.1 ping statistics ---
> 22 packets transmitted, 0 packets received, 100% packet loss

So basically what happens is that you associate but no data is
transfered? Did you confirm that the dhcp client really gets the ip
address?

> here's the wpa connection script output:
> ot@htcdream ~ # sh wpa.sh
> CTRL-EVENT-SCAN-RESULTS 
> Trying to associate with 00:23:69:xx:xx:xx
> (SSID='essid_has_been_hidden_in_that_mail' freq=2432 MHz)
> Associated with 00:23:69:xx:xx:xx
> WPA: Key negotiation completed with 00:23:69:xx:xx:xx [PTK=CCMP
> GTK=CCMP]
> CTRL-EVENT-CONNECTED - Connection to 00:23:69:xx:xx:xx completed (auth)
> [id=0 id_str=]
>
> the essid and mac address have been changed.
>
> a while true;do dmesg -c;done gave a still flowing flow of messages:
> here's a part of it:

I didn't immeadiately notice anything wrong from the logs. I would
like to know if the problem is related to power save mode or
encryption. Can you first test without encryption, ie. connect to an
open network and see if you still see the problem. If you still see
the problem, disable power save and connect to the same open AP again.

-- 
Kalle Valo
