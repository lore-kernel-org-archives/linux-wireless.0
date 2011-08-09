Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout7.freenet.de ([195.4.92.97]:50794 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1HIKIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 06:08:24 -0400
Message-ID: <4E410718.8090205@01019freenet.de> (sfid-20110809_120828_064918_CA0A2963)
Date: Tue, 09 Aug 2011 12:08:24 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Dane Shih <daneshih1981@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8
 and compat-wireless-2.6.38.2-2
References: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com> <4E40D58A.4000901@01019freenet.de> <CAH-LUqojjVCqbg_rQYNCU6Ge2D2ekNWoq03MDKKidqwrNqod0g@mail.gmail.com>
In-Reply-To: <CAH-LUqojjVCqbg_rQYNCU6Ge2D2ekNWoq03MDKKidqwrNqod0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dane Shih schrieb:
> thanks
> kernel upgrade to 3.0
> and install compat-wireless_3.0_stable_releases ath9k  driver

Well, I'm using the original drivers from 3.0.

> [  4] local 192.168.100.254 port 5001 connected with 192.168.100.47 port 49230
> [ ID] Interval       Transfer     Bandwidth
> [  4]  0.0- 2.1 sec  10.0 MBytes  40.5 Mbits/sec
> [  5] local 192.168.100.254 port 5001 connected with 192.168.100.47 port 49231
> [  5]  0.0- 6.4 sec  30.0 MBytes  39.2 Mbits/sec

Where does this output come from? I don't know it. You could use netperf
for testing the bandwith.

#!/bin/sh

dest="your_srv" # set the servername

while true ; do
netperf -t TCP_MAERTS -H $dest
netperf -t TCP_STREAM -H $dest
netperf -t TCP_SENDFILE -H $dest
done

Start netserver on the server side before you start this script (script
can be stopped with CTRL-C).

I'm using hostapd from hostapd git from 21.04.2011.

> 
> 80211n  maxinum throughput 40Mbit
> 
> what i should be check
> 
> another question
> wireless client also get  100 MBit/s
> 
> thanks

Sorry - I don't understand you :-(.


Andreas
