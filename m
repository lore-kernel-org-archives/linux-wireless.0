Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35377 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3CHVXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 16:23:09 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so1527609wey.33
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 13:23:08 -0800 (PST)
Message-ID: <513A56B8.7050900@gmail.com> (sfid-20130308_222313_541851_392DD5AB)
Date: Fri, 08 Mar 2013 22:23:04 +0100
From: Jenya Y <jy.gerstmaier@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: PROBLEM: linux kernel 3.9 rc1 and rtl8187 wireless, unable to
 connect to any available hotspots.
References: <51380336.6030007@live.com> <BLU0-SMTP15357D4D2469B872AE4355CF1E50@phx.gbl> <5138109D.1040605@lwfinger.net> <BLU0-SMTP18556F96AB7DC8FE9D76DA3F1E50@phx.gbl> <513936C8.5060908@lwfinger.net> <513A04BD.3020002@gmail.com> <513A0D9D.8020600@lwfinger.net> <513A1F5F.3080209@gmail.com> <513A2824.30603@lwfinger.net> <513A4154.3040000@gmail.com> <513A51E6.9090704@lwfinger.net>
In-Reply-To: <513A51E6.9090704@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2013 10:02 PM, Larry Finger wrote:
> No, it was not. At the end were the lines
>
> [   19.322729] rtl8187: wireless switch is on
> [   19.322763] usbcore: registered new interface driver rtl8187
> [   19.423269] systemd-udevd[272]: renamed network interface wlan0 to 
> wlp0s29f7u7u3
> [   21.321746] IPv6: ADDRCONF(NETDEV_UP): wlp0s29f7u7u3: link is not 
> ready
>
> Why are your udev rules renaming wlan0 to that crazy string?
>
> Your ESSID for the AP of "1.618029" is also strange, but that works OK 
> here.
>
> Note that I added the ML to this reply.
>
> Larry
>

The ID didn't cause any issues before, neither did the strange names 
(courtesy of systemd 197) and they are indeed very strange but as you 
have already seen the same setup is working in 3.8.2

Here are relevant dmesg output in 3.8.2 //

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.2-1-jy (jy@Y8) (gcc version 4.7.2 (GCC) 
) #1 SMP PREEMPT Thu Mar 7 23:37:49 CET 2013
....
[   17.868726] cfg80211: Calling CRDA to update world regulatory domain
[   17.991571] cfg80211: World regulatory domain updated:
[   17.991574] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   17.991576] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   17.991578] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   17.991580] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[   17.991582] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   17.991583] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   18.393371] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   18.393650] ieee80211 phy0: hwaddr 00:15:af:03:b1:88, RTL8187vB 
(default) V1 + rtl8225z2, rfkill mask 2
[   18.404459] rtl8187: Customer ID is 0x00
[   18.404944] rtl8187: wireless switch is on
[   18.404970] usbcore: registered new interface driver rtl8187
[   18.518265] systemd-udevd[326]: renamed network interface wlan0 to 
wlp0s29f7u7u3
[   20.419743] IPv6: ADDRCONF(NETDEV_UP): wlp0s29f7u7u3: link is not ready
[   30.480518] wlp0s29f7u7u3: authenticate with 00:13:49:df:22:72
[   30.515723] wlp0s29f7u7u3: capabilities/regulatory prevented using AP 
HT/VHT configuration, downgraded
[   30.552709] wlp0s29f7u7u3: send auth to 00:13:49:df:22:72 (try 1/3)
[   30.554577] wlp0s29f7u7u3: authenticated
[   30.554666] rtl8187 5-7.3:1.0 wlp0s29f7u7u3: disabling HT as WMM/QoS 
is not supported by the AP
[   30.554669] rtl8187 5-7.3:1.0 wlp0s29f7u7u3: disabling VHT as WMM/QoS 
is not supported by the AP
[   30.555028] wlp0s29f7u7u3: associate with 00:13:49:df:22:72 (try 1/3)
[   30.557461] wlp0s29f7u7u3: RX AssocResp from 00:13:49:df:22:72 
(capab=0x411 status=0 aid=1)
[   30.558206] wlp0s29f7u7u3: associated
[   30.558237] IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s29f7u7u3: link 
becomes ready


so is there maybe a quick fix?

I have another idea, I should try out. Maybe I should try to disable 
IPv6 in my network settings.

