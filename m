Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbYLCXz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 18:55:58 -0500
Subject: Re: Issue with ifconfig down and 4965 driver
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228347518.9181.15.camel@violet.holtmann.net>
References: <BCB72601-9DA2-4D89-BDF1-7B96254DA17C@linux.intel.com>
	 <1226555293.1115.939.camel@rc-desk>  <491BF73B.4080403@linux.intel.com>
	 <1228249643.10900.59.camel@rc-desk>
	 <1228347518.9181.15.camel@violet.holtmann.net>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 15:56:55 -0800
Message-Id: <1228348615.13338.83.camel@rc-desk> (sfid-20081204_005602_271135_BD4D7A47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-03 at 15:38 -0800, Marcel Holtmann wrote:
> Hi Reinette,
> 
> > > >> so I am running a 2.6.28-rc4 kernel and every time I stop
> > > >> wpa_supplicant or call ifconfig down on the 4965 card, I get a user
> > > >> noticeable delay (mouse freezes). Seems that some part inside the
> > > >> driver is actively sleeping with a busy-loop. This is really not an
> > > >> acceptable behavior since it is a day-to-day task to bring the device
> > > >> down. And for power concerns, we really wanna allow to bring down the
> > > >> interface.
> > > >>
> > > >
> > > > Please add your information to
> > > > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790
> > > 
> > > all information are already in the Bugzilla. It is nothing fancy and
> > > easy to reproduce. Do we have a patch for it?
> > > 
> > 
> > http://marc.info/?l=linux-wireless&m=122824886623698&w=2
> 
> so I finally got around testing the patch. It is great that it reduces
> the time drastically, but I think that it is still not good enough. So I
> don't care how long it takes to bring the device down. My concern is
> that we are busy-looping during this time. Meaning the kernel is not
> responding to anything. Simple symptom is that the mouse is stuck.
> 

We have found that this one patch is not the full solution. More work is
currently being done with activity tracked at
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790

Reinette

