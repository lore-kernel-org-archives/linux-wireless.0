Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47132 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbYCVLb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 07:31:26 -0400
Message-ID: <47E4EDB5.2080205@s5r6.in-berlin.de> (sfid-20080322_113136_991620_24BE0E74)
Date: Sat, 22 Mar 2008 12:29:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Brownell <david-b@pacbell.net>,
	Richard Purdie <rpurdie@rpsys.net>,
	Ingo Molnar <mingo@elte.hu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	netdev@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	video4linux-list@redhat.com, lm-sensors@lm-sensors.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
References: <20080316184349.GA28543@khazad-dum.debian.net> <200803161246.23909.david-b@pacbell.net> <20080318001429.896acf51.akpm@linux-foundation.org> <20080320225612.GB20788@khazad-dum.debian.net> <20080320164741.734e838c.akpm@linux-foundation.org> <20080321003604.GC20788@khazad-dum.debian.net> <20080320180802.426ad2d1.akpm@linux-foundation.org> <47E37E04.3080303@s5r6.in-berlin.de> <20080321123708.GE5586@khazad-dum.debian.net> <47E3B528.6010200@s5r6.in-berlin.de>
In-Reply-To: <47E3B528.6010200@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I wrote:
>>> and eth1394 to deal with temporary lack of of tlabels.  Alas I just  
>>> recently received a report that eth1394's workaround is unsuccessful 
>>> on  non-preemptible uniprocessor kernels.  
> (I haven't started working on a fix, or opened a bugzilla 
> ticket for it yet.  The reporter currently switched his kernel to 
> PREEMPT which is not affected.)

now logged as http://bugzilla.kernel.org/show_bug.cgi?id=10306

> The failure in the workaround is *not* about the in_atomic() being the 
> wrong question asked in hpsb_get_tlabel() --- no, ieee1394's in_atomic() 
> abuse works just fine even on UP PREEMPT_NONE.  Instead, the failure is 
> about kthreads not being scheduled in the way that I thought they would.
-- 
Stefan Richter
-=====-==--- --== =-==-
http://arcgraph.de/sr/
