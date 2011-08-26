Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:53307 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1HZG4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:56:13 -0400
Message-Id: <201108260656.p7Q6u4F9002564@mail.maya.org> (sfid-20110826_085615_495246_691FB146)
Date: Fri, 26 Aug 2011 08:56:11 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [compat-wireless-3.1-rc1-1] rt2800usb crashes the machine
In-Reply-To: <20110825161103.GA8586@redhat.com>
References: <4E536DD8.6030308@01019freenet.de>
 <20110824090340.GA2277@redhat.com>
 <4E54ECDF.9030804@01019freenet.de>
 <20110825161103.GA8586@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Thu, 25 Aug 2011 18:11:04 +0200
schrieb Stanislaw Gruszka <sgruszka@redhat.com>:

> On Wed, Aug 24, 2011 at 02:21:51PM +0200, Andreas Hartmann wrote:
> > Stanislaw Gruszka schrieb:
> > > On Tue, Aug 23, 2011 at 11:07:36AM +0200, Andreas Hartmann wrote:
> > >> using rt2800usb with a Linksys WUSB600N v2 (rt3572) crashes the complete
> > >> machine (SMP, Core i5, linux 3.0) on unloading the module after using it
> > >> for a short period of time:
> > >> - 2 times netperf -t TCP_MAERTS -H host
> > >> - 2 times netperf -t TCP_STREAM -H host
> > >>
> > >> The error message in /var/log/messages is:
> > >>
> > >> phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting
> > >>
> > >> After the crash, you have to hard reset the machine.
> > 
> > [...]
> > 
> > > Otherwise perhaps you could photo crash logs on virtual terminal
> > > (switched by Alt+Ctrl+F2 from X-window) or by using netconsole or kdump.
> > 
> > There is no crash dump - the machine just hangs up itself and the fan is
> > getting loader and loader (until max), because the machine is getting
> > hot more and more.
> 
> Kernel should generate some information when it hangs, at least when 
> debug options are enabled like CONFIG_DEBUG_SPINLOCK,
> CONFIG_DEBUG_OBJECTS, CONFIG_LOCKUP_DETECTOR, ... 
> 
> I just realized that compat-wireless-3.1-rc1-1, does not contain some
> rt2x00 fixes:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=4b1bfb7d2d125af6653d6c2305356b2677f79dc6
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=df71c9cfceea801e7e26e2c74241758ef9c042e5
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=674db1344443204b6ce3293f2df8fd1b7665deea
> 
> Try to apply them first, or use compat-wireless-next. If they not help
> just try to reconfigure kernel to print messages on lockup.


I applied your patches (and the suspend patch) and got the following
throughput with a little luck (on a core i5):

TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to host (1.1.1.1) port 0 AF_INET 
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.17      33.48   
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to host (1.1.1.1) port 0 AF_INET 
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.07      73.48   
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to host (1.1.1.1) port 0 AF_INET 
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.35      32.08  


These values could be seen, after the wlan stack has been reloaded
after the first load. This is necessary, because the transfer stalled
after a few seconds after the first load of the module.

The system load on one core during the test was 100%. The latency (ping)
was about 5 ms.


I did the same test with a single core CPU (Celeron M). I could see the
same high CPU load during data transfer.

TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to host (1.1.1.1) port 0 AF_INET 
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.30      30.61   
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to host (1.1.1.6) port 0 AF_INET 
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.09      63.65   
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to host (1.1.1.6) port 0 AF_INET 
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.50      31.17


The latency on the single core machine was 0,5 ms (10 times less!!).

Oh, there are two more differences between the single and multi core
machine: the single core machine runs with linux 2.6.37.6-0.5-desktop
(32 bit), the multi core machine with 3.0.0-39-desktop (64 bit).


Anyway, I could see on both machines suddenly stalled transfers like
these:

TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to host (1.1.1.1)
port 0 AF_INET send_tcp_maerts: data recv error: Interrupted system call
len was -1

Sometimes, it took long time until the network stack was usable again or
I even had to reload the modules.

The 144/s status reports (see my other mail in this thread) are not
gone, if DEBUG option was set in config.mk.

The throughput during a netperf run is very unsteady. During TCP_MAERTS
e.g., it alternates heavily between 0 and 14 M/s (seen with xosview +n).

During the tests, I could see few errors like this in messages:
phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.


With the legacy driver, I'm getting _constant_ throughput until 16 M/s 
for TCP_MAERST and until 10 M/s for TCP_STREAM or
TCP_SENDFILE at the same place. The load during these transfers is 0 -
yes, it's really 0.0 - even with the Celeron M machine.

> Note, I'm not able to reproduce hangup using steps you provide.

I couldn't reproduce the mentioned hang with your patches. The hang came
up during my first tests without your patches if the DEBUG option
for rt2800usb in the config.mk was switched off! As long as it was
switched on, the machine didn't hang.

> However
> I have bad performance, between 6 and 16 Mbits/s measured by netperf
> on connection between two rt2800usb stations through WRT160NL AP.
> I'm going to look at this problem when I'll have a chance.

Well, that's the real problem (here)! It would be very great if this
could be fixed. There must be something really broken, if one CPU is
completely used for network data transfer.


After all these problems shown up here, I think that it is more or less
fortune, if the network does work at all (if it's getting stressed). I
can imagine, that on other machines and other terms, the machine could
even crash or hang.

As long as the network is mainly idle (just used for a slow internet
line or for ssh -X e.g.), I could see no problem. 
I didn't test suspend / resume.
If I want to copy big files or try to do something like backup /
restore, I can be pretty sure to run into problems, because the
connection isn't stable at all on load.
Therefore I really appreciate a fix for this problem! You can send it
to me, if you have one - I'll test it!



Thank you for your time and work!
Andreas
