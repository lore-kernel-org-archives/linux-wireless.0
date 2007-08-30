Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:55190 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760942AbXH3ORz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:17:55 -0400
Message-ID: <46D6D18F.2080108@warmcat.com>
Date: Thu, 30 Aug 2007 15:17:51 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: ian <ischram@telenet.be>,
	=?ISO-8859-1?Q?Robert_F=FChricht?= <the_master_of_disaster@gmx.at>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211, iwlwifi and packet injection
References: <20070829161655.7f68542c@doppelhertz>	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com> <1188481073.27590.11.camel@xo-3E-67-34.localdomain>
In-Reply-To: <1188481073.27590.11.camel@xo-3E-67-34.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

Let me say first I started using NM to control my wireless device for
the first time because it does a nice job aside from this issue.

>> BTW NetworkManager-0.6.5-7.fc7 also still tries to do its thing with
>> thinking the virtual interface is a second physical device, pushes it
>> into Managed, presents it as a second device on the UI, etc.  NM should
>> check and see if the network interface resolves to the same wiphy down
>> /sys and not do those things to virtual interfaces not in Managed already.
> 
> No, NM shouldn't be touching /sys at all.  That's HAL's job.  If there's
> a device out there that's an 802.11 device, NM will attempt to control
> it.  I don't really see why that's wrong.  What's more wrong is

There is *a* device.  There are multiple logical network interfaces that
are bound to that device.  I can spawn five logical network interfaces
and still only have one device.  NM thinks I spawned five devices: that
behaviour can be improved (by de-aliasing them via /sys or whatever I
don't mind).

You can spawn logical network interfaces like this:

# echo -n mon0 > /sys/class/ieee80211/phy0/add_iface

 > I assume what you'd like to do is have NM ignore the fact that you just
> turned on some sort of "raw" mode on the device.  Unfortunately, WEXT
> doesn't give us the flexibility to OR the modes.  Ideally
> "raw"/"monitor" would just be attributes of the device that wouldn't
> really affect it's normal operation.

Well I just sent the logical network interface I created to normal
iwconfig-type "Monitor Mode".  The original logical interface wlan0
remained where it was, in Managed (and associated).

> WRT the disconnection, please run 'iwevent' during your packet injection
> runs and see if the driver sends you an SIOCGIWAP event filled with
> zeros, meaning that the driver disconnected you.  Also please run a few
> 'iwlist ethX scan' commands about 30 seconds or more apart during that
> run, and see what the 'iwevent' says.  My suspicion is that doing scans
> during the injection while associated makes the card hiccup, causing NM
> to notice the disconnection event and kill the connection (rightly so).

15:09:44.953794   wlan0    Set Encryption key:off
15:09:44.957503   wlan0    Set ESSID:off/any
15:09:45.495921   wlan0    New Access Point/Cell address:Not-Associated
15:09:50.085765   wlan0    Scan request completed
15:09:50.086194   wlan0    Set Mode:Managed
15:09:50.086496   wlan0    Set Frequency:2.437 GHz (Channel 6)
15:09:50.086890   wlan0    Set ESSID:"froh"
15:09:50.091016   wlan0    Custom driver event:ASSOCINFO(ReqIEs=...
RespIEs=...)
15:09:50.091053   wlan0    New Access Point/Cell address:00:11:50:AD:CE:38
15:09:53.698725   mon0     Set Mode:Managed
15:09:53.754515   mon0     Set ESSID:""
15:09:53.754580   mon0     Set Encryption key:off
15:09:53.754686   mon0     Set Mode:Managed

Remember mon0 and wlan0 are the same physical device... mac80211 cannot
deliver on having two logical network interfaces in Managed on the same
radio.

wlan0     IEEE 802.11g  ESSID:"froh"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:11:50:AD:CE:38
          Bit Rate=54 Mb/s   Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:... [2]
          Link Quality=96/100  Signal level=-31 dBm  Noise level=-70 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

mon0      IEEE 802.11g  ESSID:""
          Mode:Managed  Frequency:2.437 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I can't get it to deassociate on injection any more, despite I did it
several times last night and didn't reboot since... sorry.  Injection is
working fine even with NM up at the moment.  The other difference from
last night is that then NM listed the scanned APs twice in the UI, now
it lists them once with an empty section header for what is presumably
the mon0 interface of the same title as the first interface.

-Andy
