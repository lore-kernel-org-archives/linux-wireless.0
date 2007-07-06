Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:45803 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760111AbXGFMzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 08:55:48 -0400
Received: by wa-out-1112.google.com with SMTP id v27so251838wah
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 05:55:46 -0700 (PDT)
Message-ID: <9e4733910707060555s224b485ege5ed6024c7ca6b30@mail.gmail.com>
Date: Fri, 6 Jul 2007 08:55:46 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Multiple interfaces in mac80211
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1183725861.3779.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
	 <9e4733910707050632m794944b5nb9ac9393b05dfa75@mail.gmail.com>
	 <200707052154.24976.flamingice@sourmilk.net>
	 <9e4733910707060533y3bd3b4a5v5f0441f0d6e76377@mail.gmail.com>
	 <1183725861.3779.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-07-06 at 08:33 -0400, Jon Smirl wrote:
>
> > Packets to other mac addresses are arriving at the receiver and I can
> > trace them up to ieee80211_rx_monitor and onto netif_rx. Something in
> > the higher level networking code is filtering out these promiscuous
> > packets; but I don't know what was is doing it. It's not iptables
> > which it isn't loaded.
>
> That's odd because it works for everybody else. Have you tried with
> *only* a monitor interface?

Yes, only interface is monitor.

Here is something else that is odd.

Beacons are reporting channel 1...
08:52:41.922526 1.0 Mb/s 2457 MHz (0x0480) 36dB signal 0us Beacon
(Smirl) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 1, PRIVACY
08:52:42.024888 1.0 Mb/s 2457 MHz (0x0480) 35dB signal 0us Beacon
(Smirl) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 1, PRIVACY
08:52:42.127247 1.0 Mb/s 2457 MHz (0x0480) 36dB signal 0us Beacon
(Smirl) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 1, PRIVACY
08:52:42.229737 1.0 Mb/s 2457 MHz (0x0480) 36dB signal 0us Beacon
(Smirl) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 1, PRIVACY

But I am tuned to channel 10.

wlan0     IEEE 802.11g  Mode:Monitor  Frequency:2.457 GHz
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


>
> johannes
>
>


-- 
Jon Smirl
jonsmirl@gmail.com
