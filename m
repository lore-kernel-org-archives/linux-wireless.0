Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26811 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbcLTRTk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 12:19:40 -0500
Message-ID: <1482254378.30160.16.camel@redhat.com> (sfid-20161220_181950_065432_B97C689B)
Subject: Re: iwl3945 randomly crashes
From: Dan Williams <dcbw@redhat.com>
To: =?UTF-8?Q?=C5=81ukasz?= Walewski <ljw@icm.edu.pl>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com,
        sgruszka@redhat.com
Date: Tue, 20 Dec 2016 11:19:38 -0600
In-Reply-To: <20161220181145.f92ef40322426f7911300885@icm.edu.pl>
References: <20161220172429.300dc743cad7b840857142a1@icm.edu.pl>
         <1482252592.30160.8.camel@redhat.com>
         <20161220181145.f92ef40322426f7911300885@icm.edu.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-12-20 at 18:11 +0100, Łukasz Walewski wrote:
> On Tue, 20 Dec 2016 10:49:52 -0600
> Dan Williams <dcbw@redhat.com> wrote:
> 
> > 
> > On Tue, 2016-12-20 at 17:24 +0100, Łukasz Walewski wrote:
> > > 
> > > Hi,
> > > 
> > > I am using the latest Lubuntu 16.10 with fairly recent kernel
> > > 
> > > ljw@hideo:~$ uname -a
> > > Linux hideo 4.8.0-30-generic #32-Ubuntu SMP Fri Dec 2 03:43:33
> > > UTC
> > > 2016 i686 i686 i686 GNU/Linux
> > > 
> > > on an old Toshiba laptop (Satellite Pro U200) equipped with an
> > > Intel
> > > PRO/Wireless 3945ABG adapter
> > > 
> > > ljw@hideo:~$ lspci | grep ireless
> > > 02:00.0 Network controller: Intel Corporation PRO/Wireless
> > > 3945ABG
> > > [Golan] Network Connection (rev 02)
> > > 
> > > The wireless network crashes once in a while with no apparent
> > > reason
> > > with the following log entries:
> > > 
> > > Dec 18 17:23:42 hideo kernel: [94900.863133] iwl3945
> > > 0000:02:00.0:
> > > loaded firmware version 15.32.2.9
> > > Dec 18 17:23:42 hideo kernel: [94900.913626] iwl3945
> > > 0000:02:00.0:
> > > BSM uCode verification failed at addr 0x00003800+0 (of 900), is
> > > 0xa5a5a5a2, s/b 0xf802020
> > > Dec 18 17:23:42 hideo kernel: [94900.913633] iwl3945
> > > 0000:02:00.0:
> > > Unable to set up bootstrap uCode: -5
> > > 
> > > This problem has been reported several times on different mailing
> > > lists and community portals all over the Internet, nevertheless I
> > > was
> > > not able to locate the right fix for it.
> > > 
> > > The workaround suggested elswhere (restarting the network-manager
> > > when the problem occurs) works with my setup.
> > 
> > Instead of restarting NM, you can "pkill -TERM wpa_supplicant" or
> > something, which will do the same thing but just bounce the wifi
> > rather
> > than everything.  Or 'rmmod iwl3945; modprobe iwl3945'.
> 
> Thanks, but that is just another workaround. I am interested in
> fixing the problem, i.e. getting the driver not to crash at all,
> rather than playing around with it crashing every now and then.

Yeah, I know.  Just pointing out that people often use a huge hammer,
when a much smaller hammer will do.

Dan
