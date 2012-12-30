Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:44264 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L3OIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2012 09:08:40 -0500
Received: by mail-oa0-f42.google.com with SMTP id j1so11219667oag.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2012 06:08:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50D18E01.7080502@gmx.net>
References: <50D18E01.7080502@gmx.net>
Date: Sun, 30 Dec 2012 19:38:39 +0530
Message-ID: <CAD2nsn29oWNapj-zHEejPra9RC=CCexbiTPbxi1z8cq814MLcQ@mail.gmail.com> (sfid-20121230_151010_246984_F44248F3)
Subject: Re: Change adhoc network speed not working
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: George News <george.news@gmx.net>
Cc: Linux Wireless mailing list <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 19, 2012 at 3:20 PM, George News <george.news@gmx.net> wrote:
> Hi all,
>
> I'm using Ubuntu 12.04.1 64bit with a TPLink TL-WN821 v3. The driver used is
> ath9k_htc. I'm creating an adhoc/ibss network and want to change the bitrate
> of the network.
>
> First of all I disable wireless from the network manager in order to be able
> to execute my commands.
>
> These are the commands I execute on both ends:
>
>         master$ sudo ifconfig wlan0 down
>         master$ sudo rfkill unblock wifi
>         master$ sudo iw dev wlan0 set type ibss
>         master$ sudo iw dev wlan0 set bitrates legacy-2.4 1
>         master$ sudo ifconfig wlan0 up
>         master$ sudo iw dev wlan0 ibss join adhoc_linux 2462
>         master$ sudo ifconfig wlan0 1.2.3.4 up
>         master$ iperf -s -u -l 1472
>
>         slave$ sudo ifconfig wlan0 down
>         slave$ sudo rfkill unblock wifi
>         slave$ sudo iw dev wlan0 set type ibss
>         slave$ sudo iw dev wlan0 set bitrates legacy-2.4 1
>         slave$ sudo ifconfig wlan0 up
>         slave$ sudo iw dev wlan0 scan | less
>         slave$ sudo iw dev wlan0 ibss join adhoc_linux 2462
>         slave$ sudo ifconfig wlan0 1.2.3.5 up
>         slave$ iperf -c 1.2.3.4 -u -b 100M -l 1472 -t 25 -i 1
>
> As you can see I want to set the speed to 1 Mbps. However I don't know why I
> get 25Mbps from iperf which is more or less the maximun speed for 802.11g
> (theoretically 54Mbps but in reality is something like 30Mbps).
>
> The output of `iw dev wlan0 station dump` reports that both nodes are
> attached to the same network at 54Mbps.
>
> After testing that I have also tried with another command:
>
> $ sudo iw dev wlan0 ibss join adhoc_linux 2462 basic-rates 1
>
> But I got the same result.
make sure you get this issue with the updated firmware and
driver(compat wireless)
would be best to see the packet rate by observing the ping packets in
a standalone sniffer.

>
> I have tried many many things, putting the iface up, down, leaving the ibss
> net, setting the speed while iface up, etc. I'm just stuck.
>
> Any help is more than welcome.
>
> Jorge
>
>
> P.S.: Please include my email address in the reply as I'm not subscribed to
> the list and otherwise I won't be receiving the answer.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
