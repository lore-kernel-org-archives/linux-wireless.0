Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.alice.it ([85.37.17.100]:1661 "EHLO
	smtp-out04.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0DZMhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 08:37:05 -0400
Subject: Re: wl1251_sdio PSM
From: GNUtoo <GNUtoo@no-log.org>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1272235632.2349.28.camel@gnutoo-desktop>
References: <1272230300.2349.23.camel@gnutoo-desktop>
	 <1272232671.2349.25.camel@gnutoo-desktop>
	 <1272235632.2349.28.camel@gnutoo-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 14:36:56 +0200
Message-ID: <1272285416.2364.1.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 00:47 +0200, GNUtoo wrote:
> > I changed added | IEEE80211_HW_SUPPORTS_PS in:
> > wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
> >                 IEEE80211_HW_NOISE_DBM;
> > 
> > Denis.
> that was the wrong fix.
> The good fix(many thanks to chr_ in #linux-wireless) was to try
> compat-wireless,which bringed many more power saving features according
> to him.
> 
> Denis.
Unfortunately it didn't work as expected:
# ping router
PING router (192.168.1.1): 56 data bytes
64 bytes from 192.168.1.1: seq=0 ttl=64 time=7.995 ms
64 bytes from 192.168.1.1: seq=1 ttl=64 time=5.707 ms
64 bytes from 192.168.1.1: seq=2 ttl=64 time=5.005 ms
64 bytes from 192.168.1.1: seq=3 ttl=64 time=4.730 ms
64 bytes from 192.168.1.1: seq=4 ttl=64 time=13.703 ms
64 bytes from 192.168.1.1: seq=5 ttl=64 time=13.092 ms
64 bytes from 192.168.1.1: seq=6 ttl=64 time=12.513 ms
64 bytes from 192.168.1.1: seq=7 ttl=64 time=11.811 ms
64 bytes from 192.168.1.1: seq=8 ttl=64 time=11.200 ms
64 bytes from 192.168.1.1: seq=9 ttl=64 time=10.101 ms
64 bytes from 192.168.1.1: seq=10 ttl=64 time=9.400 ms
64 bytes from 192.168.1.1: seq=11 ttl=64 time=8.697 ms
64 bytes from 192.168.1.1: seq=12 ttl=64 time=8.088 ms
64 bytes from 192.168.1.1: seq=13 ttl=64 time=7.416 ms
64 bytes from 192.168.1.1: seq=14 ttl=64 time=6.775 ms
64 bytes from 192.168.1.1: seq=15 ttl=64 time=6.164 ms
64 bytes from 192.168.1.1: seq=16 ttl=64 time=5.494 ms
64 bytes from 192.168.1.1: seq=17 ttl=64 time=4.852 ms
64 bytes from 192.168.1.1: seq=18 ttl=64 time=4.364 ms
64 bytes from 192.168.1.1: seq=19 ttl=64 time=3.418 ms
64 bytes from 192.168.1.1: seq=20 ttl=64 time=2.777 ms
64 bytes from 192.168.1.1: seq=21 ttl=64 time=12.024 ms
64 bytes from 192.168.1.1: seq=22 ttl=64 time=11.414 ms
64 bytes from 192.168.1.1: seq=23 ttl=64 time=10.193 ms
64 bytes from 192.168.1.1: seq=24 ttl=64 time=9.552 ms
64 bytes from 192.168.1.1: seq=25 ttl=64 time=8.911 ms
64 bytes from 192.168.1.1: seq=26 ttl=64 time=8.240 ms
64 bytes from 192.168.1.1: seq=27 ttl=64 time=7.812 ms
64 bytes from 192.168.1.1: seq=28 ttl=64 time=6.958 ms
64 bytes from 192.168.1.1: seq=29 ttl=64 time=6.317 ms
64 bytes from 192.168.1.1: seq=30 ttl=64 time=5.707 ms
64 bytes from 192.168.1.1: seq=31 ttl=64 time=4.944 ms
64 bytes from 192.168.1.1: seq=32 ttl=64 time=4.303 ms
64 bytes from 192.168.1.1: seq=33 ttl=64 time=2194.366 ms 
64 bytes from 192.168.1.1: seq=34 ttl=64 time=1193.634 ms
64 bytes from 192.168.1.1: seq=35 ttl=64 time=193.421 ms
64 bytes from 192.168.1.1: seq=38 ttl=64 time=760.559 ms
64 bytes from 192.168.1.1: seq=39 ttl=64 time=784.851 ms

the power_save feature was activated with iw, just before the
64 bytes from 192.168.1.1: seq=33 ttl=64 time=2194.366 ms
line
then after 5 lines of ping it stopped displaying the pings.

Denis.

