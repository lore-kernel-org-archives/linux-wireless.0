Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55044 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1EJUaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 16:30:11 -0400
Received: by vxi39 with SMTP id 39so6999752vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 13:30:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=DGhnDWiVBwR=uU1VtOivqsdWx_g@mail.gmail.com>
References: <BANLkTikmQkj9p5VhSfD6FrwcqBNYjg3Rfg@mail.gmail.com>
	<BANLkTimrOzzZ2OeoqL5xbiQki804rbR7Bg@mail.gmail.com>
	<BANLkTinOHVXf6fESZExraYN4SuErK68viw@mail.gmail.com>
	<BANLkTinze2ozSwqJkx-ur9j=mXVZzANWdg@mail.gmail.com>
	<BANLkTi=DGhnDWiVBwR=uU1VtOivqsdWx_g@mail.gmail.com>
Date: Tue, 10 May 2011 22:30:10 +0200
Message-ID: <BANLkTik9SwFOQFoq4gwj1aodso3UWwNj5Q@mail.gmail.com> (sfid-20110510_223016_676606_C4CCA859)
Subject: Re: [rt2x00-users] rt2800usb broken for rt3070
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: =?ISO-8859-1?Q?Rub=E9n_P=E9rez?= <lqb@yomolo.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Once again, please reply to all the recipients (including the mailing lists)
else I won't answer again.

2011/5/10 Rubén Pérez <lqb@yomolo.com>:
> Hi....
> The problem was the firmware, effectively it was not the latest.... Ive
> updated the firmware as you told me and it was working... I've also updated
> to the latest daily build from compat-wireless....
> But now, Im having another problem.... Pings are very slow....
> 64 bytes from 192.168.10.4: icmp_req=1 ttl=64 time=267 ms
> 64 bytes from 192.168.10.4: icmp_req=2 ttl=64 time=188 ms
> 64 bytes from 192.168.10.4: icmp_req=3 ttl=64 time=109 ms
> 64 bytes from 192.168.10.4: icmp_req=4 ttl=64 time=30.2 ms
> 64 bytes from 192.168.10.4: icmp_req=5 ttl=64 time=154 ms
> 64 bytes from 192.168.10.4: icmp_req=6 ttl=64 time=75.4 ms
> 64 bytes from 192.168.10.4: icmp_req=7 ttl=64 time=97.8 ms
> 64 bytes from 192.168.10.4: icmp_req=8 ttl=64 time=19.0 ms
> 64 bytes from 192.168.10.4: icmp_req=9 ttl=64 time=145 ms
> 64 bytes from 192.168.10.4: icmp_req=10 ttl=64 time=168 ms
> 64 bytes from 192.168.10.4: icmp_req=11 ttl=64 time=89.2 ms

It is a known issue, that hasn't got yet to the compat-wireless tree,
it should eventually.

Apply this patch, and that should solve it...

http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=29c217871d172f092a238997c50bc44110150004


>
> With the official Ralink driver is about 2-3ms.... Im completely sure the
> chip is cool, and ive tried in two equal devices....
> Thanks!
>
>
>
> 2011/5/10 Juan Carlos Garza <juancarlosgarza@gmail.com>
>>
>> Hi,
>>
>> please reply to all when replying, the thread discussed here might
>> help someone else in the future.
>>
>> 2011/5/10 Rubén Pérez <lqb@yomolo.com>:
>> > according with the ralink support page:
>> > http://www.ralinktech.com/support.php?s=2
>> > The latest version for rt28XX/rt30XX is the 22. maybe Im wrong because i
>> > can
>> > see the release date is quite old....
>>
>> I am attaching the firmware file for revision 29. Ralink does not have
>> an updated version in their support page.
>> md5sum: 36c944c3138125605d28c0a3a1338be9
>>
>> > By the way, I'll try later the daily version as well as another older
>> > version, but the version I'm currently using is suppose to be stable and
>> > the
>> > development of this driver is no so new....
>>
>> Sometimes the newer the better.
>>
>> > Thanks for your attention!
>> > Regards
>> > Rubén
>> >
>> > 2011/5/10 Juan Carlos Garza <juancarlosgarza@gmail.com>
>> >>
>> >> Hi, below my comments.
>> >>
>> >> 2011/5/9 Rubén Pérez <lqb@yomolo.com>
>> >> >
>> >> > Hi....
>> >> >
>> >> > Ive tried the latest version from wireless-compat 2.6.39 on a 2.6.29
>> >> > rt-kernel and it's not working.... everytime I get no scan
>> >> > results.... I
>> >> > paste the debug output from the modprobe, ifconfig up, and iwlist
>> >> > scan:
>> >> >
>> >> >
>> >> > ocinante compat-wireless-2.6.39-rc6-1 # dmesg
>> >> > [ 3301.701830] phy2 -> rt2x00_set_chip: Info - Chipset detected - rt:
>> >> > 3070, rf: 0005, rev: 0201.
>> >> > [ 3301.703827] ieee80211 phy2: Selected rate control algorithm
>> >> > 'minstrel_ht'
>> >> > [ 3301.731823] Registered led device: rt2800usb-phy2::radio
>> >> > [ 3301.731958] Registered led device: rt2800usb-phy2::assoc
>> >> > [ 3301.733136] Registered led device: rt2800usb-phy2::quality
>> >> > [ 3301.733574] usbcore: registered new interface driver rt2800usb
>> >> > [ 3306.369314] phy2 -> rt2x00lib_request_firmware: Info - Loading
>> >> > firmware file 'rt2870.bin'.
>> >> > [ 3306.386143] phy2 -> rt2x00lib_request_firmware: Info - Firmware
>> >> > detected - version: 0.22.
>> >>
>> >> I think that the latest version of the firmware is 0.29 (someone
>> >> correct me if i'm wrong),
>> >> so upgrading it might help.
>> >>
>> >> > [ 3306.618110] phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue
>> >> > 0 -
>> >> > CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
>> >> > [ 3306.619472] phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue
>> >> > 1 -
>> >> > CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
>> >> > [ 3306.620846] phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue
>> >> > 2 -
>> >> > CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
>> >> > [ 3306.622220] phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue
>> >> > 3 -
>> >> > CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
>> >> > [ 3334.829055] phy2 -> rt2x00queue_flush_queue: Warning - Queue 0
>> >> > failed
>> >> > to flush
>> >> > [ 3334.842583] phy2 -> rt2x00usb_watchdog_tx_status: Warning - TX
>> >> > queue
>> >> > 0 status timed out, invoke forced tx handler
>> >> > [ 3337.087058] phy2 -> rt2x00queue_flush_queue: Warning - Queue 0
>> >> > failed
>> >> > to flush
>> >> > rocinante compat-wireless-2.6.39-rc6-1 #
>> >> >
>> >> >
>> >> > Im running it on a Geode (i586) plattform.....
>> >>
>> >> Have you tried the daily compat-wireless builds? They contain some
>> >> good patches that will not appear until 2.6.40.
>> >>
>> >>
>> >> >
>> >> >
>> >> >
>> >> > thanks
>> >> > _______________________________________________
>> >> > users mailing list
>> >> > users@rt2x00.serialmonkey.com
>> >> >
>> >> >
>> >> > http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>> >> >
>> >>
>> >> Regards,
>> >> --
>> >> Juan Carlos Garza
>> >
>> >
>>
>> --
>> Juan Carlos Garza
>
>

-- 
Juan Carlos Garza
