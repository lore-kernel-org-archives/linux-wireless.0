Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbYH0BUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 21:20:34 -0400
Subject: Re: Are these Ralink chips supported?
From: Dan Williams <dcbw@redhat.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080826191654.GB26037@storm.local.network>
References: <20080805163234.GA22429@storm.local.network>
	 <200808061014.10483.IvDoorn@gmail.com>
	 <20080826191654.GB26037@storm.local.network>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 21:21:46 -0400
Message-Id: <1219800106.3112.4.camel@localhost.localdomain> (sfid-20080827_032053_760901_D4123C4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-26 at 15:16 -0400, Forest Bond wrote:
> Hi,
> 
> On Wed, Aug 06, 2008 at 10:14:10AM +0200, Ivo van Doorn wrote:
> > On Tuesday 05 August 2008, Forest Bond wrote:
> > > I'm having a hard time figuring out if the following wireless chips are
> > > supported:
> > > 
> > >  * RT2770 + RT2720
> > 
> > I *think* this is the rt2870 driver. The in-kernel driver is under development
> 
> Okay, the RT2870 driver from Ralink works with this device, but it seems to be a
> bit quirky:
> 
>  * The device has to be brought up and down a few times before NetworkManager
>    sees it.  I'm not sure what NetworkManager is cueing off of.

HAL events.  If the device doesn't show up in HAL and doesn't have a
network interface with the "net.80211" capability, NM won't see it.  A
dump of 'lshal' when you're having the problem would be useful.  If that
shows the device correctly, then it might be that the device isn't
responding correctly to an SIOCSIWSCAN or SIOCGIWRANGE command in a
manner which NM is expecting.

Dan

>  * I was unable to get the thing to associate and come up using
>    iwconfig/ifconfig.  Might have been my range on that AP, though, since I was
>    shooting for an unencrypted network that is a not the closest network in my
>    building.
> 
>  * Usual odd bits with vendor drivers like odd build system subtleties and
>    seemingly unnecessary configuration files (does anyone really care to fiddle
>    with those, or doesn't everyone just want things to work with the standard
>    configuration mechanisms like I do?).
> 
> Is there an effort to move this driver in-tree?  The license is GPL.
> 
> Thanks,
> Forest

