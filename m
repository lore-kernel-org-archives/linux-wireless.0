Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:36199 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYFPGq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 02:46:28 -0400
Received: by yw-out-2324.google.com with SMTP id 9so3029118ywe.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jun 2008 23:46:27 -0700 (PDT)
Message-ID: <48560C38.3030901@gmail.com> (sfid-20080616_093323_559434_8E6F3A2F)
Date: Mon, 16 Jun 2008 09:46:16 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: =?ISO-8859-1?Q?Tor_H=E5kon_Haugen?= <tor.hakon.haugen@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
References: <484FEA26.1040305@gmail.com> <48528B63.5030403@gmail.com>	 <48528CF0.8050204@gmail.com>	 <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>	 <48551C62.80904@gmail.com>	 <1ba2fa240806150647mdc97d98oad0b1b02de1fcf87@mail.gmail.com>	 <48552344.5090801@gmail.com>	 <1ba2fa240806150809h13c28937nd064230baca8a15d@mail.gmail.com>	 <1ba2fa240806150947s1ed9391ao4b1d1a91c871ef8f@mail.gmail.com>	 <4855FF14.9080506@gmail.com> <1ba2fa240806152252v5fdb4f7dn1028a2a02e8d9cd1@mail.gmail.com> <48560359.4090909@gmail.com>
In-Reply-To: <48560359.4090909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.....
> 
> I just want to note that hardware scanning doesn't work well here 
> (something unrelated)
> 
> First of all I noticed large delays in communications occurring 
> sometimes, I for example tried pinging Google, and every 20 replies
> I get about 10 lost packets. (this is exactly what hardware scanning 
> should prevent, but it seems that the opposite happens)
> 
> I tried that again now, and see no delays, but I reproduced this twice.

Rebooted, and here it is:

maxim@MOBILE:~$ ping www.google.com
PING www.google.com (209.85.135.147) 56(84) bytes of data.
64 bytes from www.google.com (209.85.135.147): icmp_seq=1 ttl=245 time=89.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=2 ttl=245 time=89.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=3 ttl=245 time=87.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=4 ttl=245 time=87.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=5 ttl=245 time=85.7 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=6 ttl=245 time=88.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=7 ttl=245 time=88.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=8 ttl=245 time=86.7 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=9 ttl=245 time=85.8 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=10 ttl=245 time=89.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=11 ttl=245 time=88.5 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=12 ttl=245 time=89.5 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=13 ttl=245 time=87.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=14 ttl=245 time=87.1 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=15 ttl=245 time=89.1 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=16 ttl=245 time=89.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=17 ttl=245 time=87.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=25 ttl=245 time=87.8 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=26 ttl=245 time=89.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=27 ttl=245 time=87.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=28 ttl=245 time=89.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=29 ttl=245 time=85.9 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=30 ttl=245 time=86.9 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=31 ttl=245 time=87.8 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=32 ttl=245 time=87.3 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=33 ttl=245 time=86.8 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=34 ttl=245 time=87.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=35 ttl=245 time=89.1 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=36 ttl=245 time=88.2 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=37 ttl=245 time=87.6 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=38 ttl=245 time=87.1 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=39 ttl=245 time=88.6 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=40 ttl=245 time=87.6 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=41 ttl=245 time=86.6 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=42 ttl=245 time=87.7 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=43 ttl=245 time=87.7 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=44 ttl=245 time=87.8 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=45 ttl=245 time=86.3 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=46 ttl=245 time=86.4 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=47 ttl=245 time=88.4 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=55 ttl=245 time=87.7 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=56 ttl=245 time=88.4 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=57 ttl=245 time=87.5 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=58 ttl=245 time=87.0 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=59 ttl=245 time=87.6 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=60 ttl=245 time=87.1 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=61 ttl=245 time=88.1 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=62 ttl=245 time=89.7 ms
64 bytes from www.google.com (209.85.135.147): icmp_seq=63 ttl=245 time=87.1 ms
^C
--- www.google.com ping statistics ---
63 packets transmitted, 49 received, 22% packet loss, time 62140ms
rtt min/avg/max/mdev = 85.770/87.752/89.720/1.068 ms
maxim@MOBILE:~$

and here:

ping www.google.com
PING www.l.google.com (209.85.129.99) 56(84) bytes of data.
64 bytes from www.google.com (209.85.129.99): icmp_seq=1 ttl=246 time=82.5 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=9 ttl=246 time=79.6 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=10 ttl=246 time=83.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=11 ttl=246 time=82.6 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=12 ttl=246 time=82.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=13 ttl=246 time=82.1 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=14 ttl=246 time=81.9 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=15 ttl=246 time=81.4 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=16 ttl=246 time=82.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=17 ttl=246 time=80.9 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=18 ttl=246 time=80.9 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=19 ttl=246 time=80.5 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=20 ttl=246 time=81.5 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=21 ttl=246 time=80.5 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=22 ttl=246 time=80.1 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=23 ttl=246 time=82.5 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=24 ttl=246 time=82.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=25 ttl=246 time=82.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=26 ttl=246 time=81.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=27 ttl=246 time=81.5 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=28 ttl=246 time=81.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=29 ttl=246 time=80.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=30 ttl=246 time=80.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=31 ttl=246 time=80.0 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=39 ttl=246 time=82.8 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=40 ttl=246 time=82.3 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=41 ttl=246 time=81.3 ms
64 bytes from www.google.com (209.85.129.99): icmp_seq=42 ttl=246 time=81.8 ms
^C
--- www.l.google.com ping statistics ---
42 packets transmitted, 28 received, 33% packet loss, time 41109ms
rtt min/avg/max/mdev = 79.627/81.461/83.079/0.961 ms
maxim@MOBILE:~$


> 
> Then power levels go crazy, the nm-applet shows that my access point 
> have 23% quality, then 100%, then something low again, and looking list 
> of networks withing same applet, it shows for example now that all 3 
> networks (mine, and two neighbors) have 100% quality, which is just wrong.
> 
Don't see that now, but sudo iwlist wlan0 scan shows only my access point,
although there are two another strong access points.

Best regards,
	Maxim levitsky

> 
> Best regards,
>     Maxim Levitsky
> 

