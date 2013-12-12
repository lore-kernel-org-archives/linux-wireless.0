Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49110 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3LLBpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 20:45:23 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so11144372pbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 17:45:23 -0800 (PST)
Date: Wed, 11 Dec 2013 17:45:19 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Fw: [Cerowrt-devel] Wireless failures 3.10.17-3
Message-ID: <20131211174519.34966001@nehalam.linuxnetplumber.net> (sfid-20131212_024526_926607_8D10305A)
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I originally reported this problem to the CeroWrt list.
Thought I should include the driver developers as well.

The Cerowrt release uses 3.10.17 kernel but problem continues with 3.10.21.

The ath9k driver goes catatonic under load. This message has the most log
info.

Begin forwarded message:

Date: Wed, 11 Dec 2013 21:41:30 +0100
From: Sebastian Moeller <moeller0@gmx.de>
To: Dave Taht <dave.taht@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, "cerowrt-devel@lists.bufferbloat.net" <cerowrt-devel@lists.bufferbloat.net>
Subject: Re: [Cerowrt-devel] Wireless failures 3.10.17-3


Hi List, hi Dave,


On Dec 11, 2013, at 19:41 , Dave Taht <dave.taht@gmail.com> wrote:

> I have the regrettable problem of mostly testing the 5ghz channel due
> to interference issues on the 2ghz band.
> 
> What I am seeing in the last several releases of the 3.8.x and 3.10
> series is after tons of traffic and multiple days of uptime a DMA tx
> error which you can see via the logread or dmesg tool, and once it
> happens, at least sometimes, that radio can "go away" and not be
> resettable. "cannot stop tx dma" is the error.

	I think I can make tho error appear "at will" by running netperf-wrapper against my wndr3700v2, just tested under 3.10.21-1:
/netperf-wrapper -l 300 -H gw.home.lan rrul -p all -t hms-beagle_cerowrt3.10.21-1_2_nacktmulle

dmesg on the router:
[   53.007812] IPv6: ADDRCONF(NETDEV_CHANGE): gw11: link becomes ready
[28792.039062] ath: phy1: Failed to stop TX DMA, queues=0x00e!
[28794.078125] ath: phy1: Failed to stop TX DMA, queues=0x00e!
[28807.164062] ath: phy1: Failed to stop TX DMA, queues=0x00e!
[28809.191406] ath: phy1: Failed to stop TX DMA, queues=0x002!
[28823.269531] ath: phy1: Failed to stop TX DMA, queues=0x00e!

dmesg was clean before so these 5 failures are from the rrul test over the 5GHz radio

running the same over the 2.4GHz radio adds the following:

[29200.921875] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29206.980468] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29209.019531] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29211.066406] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29215.109375] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29227.195312] ath: phy0: Failed to stop TX DMA, queues=0x006!
[29233.257812] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29238.308593] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29240.351562] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29247.417968] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29251.480468] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29253.515625] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29256.558593] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29262.617187] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29264.652343] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29269.699218] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29273.750000] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29278.804687] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29281.859375] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29291.933593] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29294.972656] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29304.050781] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29312.117187] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29315.167968] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29322.246093] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29325.292968] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29330.355468] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29332.390625] ath: phy0: Failed to stop TX DMA, queues=0x00a!
[29334.445312] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29336.484375] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29337.527343] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29343.617187] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29349.679687] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29358.757812] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29361.816406] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29363.851562] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29364.882812] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29370.937500] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29371.976562] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29376.031250] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29378.062500] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29381.105468] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29388.175781] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29393.230468] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29401.292968] ath: phy0: Failed to stop TX DMA, queues=0x003!
[29403.332031] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29413.429687] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29417.480468] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29422.542968] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29424.582031] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29427.636718] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29429.671875] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29431.718750] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29433.765625] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29445.835937] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29449.898437] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29454.960937] ath: phy0: Failed to stop TX DMA, queues=0x00f!
[29461.023437] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29463.062500] ath: phy0: Failed to stop TX DMA, queues=0x00e!
[29466.117187] ath: phy0: Failed to stop TX DMA, queues=0x00f!

I have to admit before today I never tested with 2.4GHz and only say the 4 to 5 messages in the 5GHz band.

Running the same over the wired interface does not cause these messages…

And running from a 5GHz client through the router to a wired client (both on the internal side) just adds:
[30643.500000] ath: phy1: Failed to stop TX DMA, queues=0x00c!
[30736.898437] ath: phy1: Failed to stop TX DMA, queues=0x00e!

It does not immediately lead to a drop of the radio though...

Maybe this can be helpful in the hands of a real expert?


> I have seen this error
> many, many times in cerowrt releases for the last 2 years, but this
> time it seems more severe than usual.
> 
> There was also a bug in dnsmasq or somewhere in the lower level of the
> stack where it stops responding to multicast dhcp packets.
> 
> The upcoming 3.10.23-1 development release has a refresh of mac80211,
> and a bug fix related to multicast, so I have some hope for it.
> 
> It has also the latest dnsmasq 2.68 (which fixes a bug in cname
> handling in particular), and also pie v3 but I am (as usual) not in a
> position to test it right now.
> 
> It is my hope that now that the bug happens a lot we can track it
> down. Or, that it's fixed. :)
> 
> I just put that release up at:
> 
> http://snapon.lab.bufferbloat.net/~cero2/cerowrt/wndr/3.10.23-1/
> 
> It does not have the updated aqm-scripts code and gui (sorry
> sebastian),

	Ah, even better, I finished the discussed cosmetic changes and tested them, I will try to send them before Sunday, so they might end up in the next cero release. That means you will have to integrate with your changes to avoid HTB for high bandwidths… (or you just put your version in and I will do the integration after the next release :) )
	Also, I still need to figure out how to make mutually exclusive with the default QOS system...


> nor the pie v4 drop that just got rejected for kernel
> mainline. I'll try to do a respin this weekend with those, and poke
> harder at the dma tx issue after I get back in the lab. Thoughts
> towards being able to isolate the cause and minimize the effect are
> welcomed - it's one of the biggest barriers to declaring a stable
> release at this point!
> 
> 
> On Wed, Dec 11, 2013 at 8:58 AM, Stephen Hemminger
> <stephen@networkplumber.org> wrote:
>> Has anyone seen wireless failing after several days with 3.10.17-3?
>> 
>> The symptoms are devices fall off the net several days (or a week) after
>> router has been running. I saw the bg AP go away, but the 5 Ghz AP still
>> working. Wired attachment works.
>> _______________________________________________
>> Cerowrt-devel mailing list
>> Cerowrt-devel@lists.bufferbloat.net
>> https://lists.bufferbloat.net/listinfo/cerowrt-devel
> 
> 
> 
> -- 
> Dave Täht
> 
> Fixing bufferbloat with cerowrt: http://www.teklibre.com/cerowrt/subscribe.html
> _______________________________________________
> Cerowrt-devel mailing list
> Cerowrt-devel@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/cerowrt-devel

