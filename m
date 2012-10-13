Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:41665 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab2JMGtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 02:49:43 -0400
Date: Sat, 13 Oct 2012 08:47:20 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/7] rt2800: use BBP_R1 for setting tx
 power
Message-ID: <20121013084720.45682744@dualc.maya.org> (sfid-20121013_084947_277461_1991EBD4)
In-Reply-To: <20121008091523.GB2478@redhat.com>
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com> <506F0A56.70900@01019freenet.de> <20121008091523.GB2478@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Hi
> 
> On Fri, Oct 05, 2012 at 06:27:02PM +0200, Andreas Hartmann wrote:
> > I would like to test this patchset. Whereon should I pay (most)
> > attention? What do you expect to be changed (or not) behaviour with
> > 2.4 GHz / 40 MHz?
> 
> Yes, all band 2.4GHz/5GHz and bandwitch 20MHz/40MHz combinations are 
> touched by those patches. 
> 
> You can check if patches make anything better on long distance
> performance if you want to.

Just saw that I've been using this patchset since Aug 27, 2012 with my
AP (http://www.wikidevi.com/wiki/Linksys_WMP600N) and
compat-wireless-3.5-rc5-1 and linux 3.1.10

iw list and iwconfig are showing always 0 dBm for each channel (2.4 and
5 GHz).



2.4 GHz / 40 MHz

Well, I couldn't find any problems (means: it isn't worse, but I'm not
sure if it is better as before). 

One thing I can see frequently, is the fact, that I'm getting
surprisingly high throughput rates using netperf and 2.4 GHz/40 MHz at
16 MB/s. 
Why can I see them just sometimes and not always (at the same
position)? This behaviour is not patch related!



5.22 GHz / 40 MHz

The behaviour didn't change. It's unusable as before. See this thread:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-March/004738.html


Some values with WAP610N (external AP)
======================================

Sa 13. Okt 07:03:05 CEST 2012
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to AP (x.x.x.x) port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.11      27.18   
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to AP (x.x.x.x) port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.34      47.21   
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to AP (x.x.x.x) port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.22      26.47

ra0       Ralink STA  ESSID:"5091eb221bcdc9326"  Nickname:"RT3572STA"
          Mode:Managed  Frequency=5.2 GHz  Access Point: 00:25:9C:8E:FA:3F   
          Bit Rate=162 Mb/s   
          RTS thr:off   Fragment thr:off
          Encryption key:BACB-8E8A-E647-88E9-7D92-C27E-CA1C-579D [3]   Security mode:restricted   Security mode:open
          Link Quality=95/100  Signal level:-71 dBm  Noise level:-96 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0




Some actual values (with own AP):
=================================

Sa 13. Okt 07:12:20 CEST 2012
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to AP (x.x.x.x) port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    12.31       0.53   
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to AP (x.x.x.x) port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    11.89       0.83   
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to AP (x.x.x.x) port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.97       1.02


ra0       Ralink STA  ESSID:"5091eb221bcdc9326"  Nickname:"RT3572STA"
          Mode:Managed  Frequency=5.22 GHz  Access Point: 84:50:61:D8:38:67   
          Bit Rate=13.5 Mb/s   
          RTS thr:off   Fragment thr:off
          Encryption key:45A0-77D8-58A4-3CF7-600F-6CF5-A923-CF85 [2]   Security mode:restricted   Security mode:open
          Link Quality=78/100  Signal level:-82 dBm  Noise level:-88 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0





STREAM, SENDFILE: 	Direction from supplicant -> AP
MAERTS:			Direction from AP -> supplicant





Kind regards,
Andreas
