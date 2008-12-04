Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55512 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYLDLT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 06:19:56 -0500
Subject: Re: Issue with ifconfig down and 4965 driver
From: Marcel Holtmann <holtmann@linux.intel.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228348615.13338.83.camel@rc-desk>
References: <BCB72601-9DA2-4D89-BDF1-7B96254DA17C@linux.intel.com>
	 <1226555293.1115.939.camel@rc-desk>  <491BF73B.4080403@linux.intel.com>
	 <1228249643.10900.59.camel@rc-desk>
	 <1228347518.9181.15.camel@violet.holtmann.net>
	 <1228348615.13338.83.camel@rc-desk>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 12:19:51 +0100
Message-Id: <1228389591.28839.1.camel@violet.holtmann.net> (sfid-20081204_122001_109608_C5C87416)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> > > > >> so I am running a 2.6.28-rc4 kernel and every time I stop
> > > > >> wpa_supplicant or call ifconfig down on the 4965 card, I get a user
> > > > >> noticeable delay (mouse freezes). Seems that some part inside the
> > > > >> driver is actively sleeping with a busy-loop. This is really not an
> > > > >> acceptable behavior since it is a day-to-day task to bring the device
> > > > >> down. And for power concerns, we really wanna allow to bring down the
> > > > >> interface.
> > > > >>
> > > > >
> > > > > Please add your information to
> > > > > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790
> > > > 
> > > > all information are already in the Bugzilla. It is nothing fancy and
> > > > easy to reproduce. Do we have a patch for it?
> > > > 
> > > 
> > > http://marc.info/?l=linux-wireless&m=122824886623698&w=2
> > 
> > so I finally got around testing the patch. It is great that it reduces
> > the time drastically, but I think that it is still not good enough. So I
> > don't care how long it takes to bring the device down. My concern is
> > that we are busy-looping during this time. Meaning the kernel is not
> > responding to anything. Simple symptom is that the mouse is stuck.
> > 
> 
> We have found that this one patch is not the full solution. More work is
> currently being done with activity tracked at
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790

I quickly checked Mohamed's last patch. It actually makes it worse on my
system.

Regards

Marcel


