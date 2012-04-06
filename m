Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60508 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2DFPvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 11:51:19 -0400
Received: by wejx9 with SMTP id x9so1526965wej.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 08:51:18 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: carl9170: not able to add P2P_GO - add_interface fail with -EBUSY
Date: Fri, 6 Apr 2012 17:51:13 +0200
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CAFED-jno-531+5TPOjDJ598jAO1zMmFpe6UJOsRt4SfbCU9zDQ@mail.gmail.com> <201204061322.26832.chunkeey@googlemail.com> <1333725089.5577.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333725089.5577.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201204061751.13708.chunkeey@googlemail.com> (sfid-20120406_175132_142920_68484ACD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 April 2012 17:11:29 Johannes Berg wrote:
> On Fri, 2012-04-06 at 13:22 +0200, Christian Lamparter wrote:
> 
> > > Is that chipset limitation we could add only new STA interface when
> > > main_vif is also STA?
> > <http://wireless.kernel.org/en/users/Drivers/carl9170#Multiple_Interfaces>
> > no, it's not. But you'll have to go through several hoops to extend
> > the driver to switch the "main" interface while the device is up and
> > running.
> 
> So the driver has a concept of the order in which interfaces are added?
> That's something I never considered when writing the interface type
> combinations support.
Actually, it's more of a master/slave situation. 

The MAC only has one security engine "mode" which can be either AP/IBSS/WDS.
[So, this setting will be shared with all virtual interfaces]
Next, the MAC only has one TSF counter, [beacon/tbtt timer, etc...] which
is also shared between the virtual interfaces [note: the TSF sync depends
on the mode as well, you see if the main interface is a station/ibss then
the TSF is automatically updated [by the hardware in fact] and there is
nothing a slave interface [e.g.: AP] can do!]. And then there is of
course the shared ERP, basic rates, slot time, multicast, QOS/WME, ... stuff.

Regards,
	Christian
