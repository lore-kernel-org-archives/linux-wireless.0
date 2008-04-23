Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYDWTlN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 15:41:13 -0400
Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: drago01 <drago01@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1208978775.2814.4.camel@localhost.localdomain>
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>
	 <1ba2fa240801261411x7bb437c9s31aea593537afeba@mail.gmail.com>
	 <47B29F63.6050605@gmail.com>
	 <D936D925018D154694D8A362EEB0892003A7F599@orsmsx416.amr.corp.intel.com>
	 <f6ca9fed0803181232n4ac188ev5d10e7c68aad57aa@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003F2D487@orsmsx416.amr.corp.intel.com>
	 <f6ca9fed0803181446v139b688ek958ce29cf7d98457@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003F2D574@orsmsx416.amr.corp.intel.com>
	 <1ba2fa240803181607n3556955ar39eebdeebacffb7b@mail.gmail.com>
	 <f6ca9fed0803181610v10b533e9n267540e1b00d004f@mail.gmail.com>
	 <1ba2fa240803181635o6cc264f4s578bbca7e4561c0e@mail.gmail.com>
	 <1205936104.26119.9.camel@localhost.localdomain>
	 <1208978775.2814.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 15:37:21 -0400
Message-Id: <1208979441.2814.8.camel@localhost.localdomain> (sfid-20080423_214150_625839_F4F2AE06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-23 at 15:26 -0400, Dan Williams wrote:
> On Wed, 2008-03-19 at 10:15 -0400, Dan Williams wrote:
> > On Wed, 2008-03-19 at 01:35 +0200, Tomas Winkler wrote:
> > > On Wed, Mar 19, 2008 at 1:10 AM, drago01 <drago01@gmail.com> wrote:
> > > >
> > > > On Wed, Mar 19, 2008 at 12:07 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> > > >  > On Wed, Mar 19, 2008 at 12:06 AM, Chatre, Reinette
> > > >  >
> > > >  > <reinette.chatre@intel.com> wrote:
> > > >  >  >
> > > >  >
> > > >  >
> > > >  > > On Tuesday, March 18, 2008 2:47 PM, drago01  wrote:
> > > >  >  >
> > > >  >  >  >>  Please note that the driver loads/unloads the firmware during
> > > >  >  >  >>  interface up/down. That means that the host will not receive rfkill
> > > >  >  >  >>  events while the interface is down as there is no firmware to deal
> > > >  >  >  >> with these events.
> > > >  >  >  >>
> > > >  >  >  >>  Reinette
> > > >  >  >  >>
> > > >  >  >  >
> > > >  >  >  > OK that makes sense.
> > > >  >  >  > So a solution would be to not unload the firmware on down when the hw
> > > >  >  >  > rfkill is on. Is this a acceptable one or are they other (better
> > > >  >  >  > solutions). I can't think of any. And userspace cannot do anything
> > > >  >  >  > because bringing the device up and down again to look for the rfkill
> > > >  >  >  > status would be racy.
> > > >  >  >
> > > >  >  >  Having the firmware unloaded when the interface is down is a requirement
> > > >  >  >  for powersaving. We do not want the device to consume power when it is
> > > >  >  >  not used. The rfkill status should always be reported accurately when
> > > >  >  >  the interface is up. If it is not then it is a bug.
> > > >  >
> > > >  >  We will catch the HW rfkill event after loading the uCode so there is
> > > >  >  no problem with this.
> > > >  >  Not sure where should be the SW rfkill state stored.
> > > >
> > > >  yeah, but the ucode will be loaded when the device is brought back up,
> > > >  which does not happen in NM's case.
> > > >
> > > 
> > > You mean that NM doesn't have any notification that the radio was enabled again?
> > 
> > Well, NM would only be able to get that notification via HAL, which
> > would get the notification via the kernel RFKill layer or the input
> > layer.  In the case of iwlwifi, that even must come through the kernel
> > rfkill layer, however the driver decides to post that event.
> > 
> > > This one is tricky with 3945...the trivial question is why NM disables
> > > the device?
> > 
> > Because when the device is down (!IFF_UP), then the device is supposed
> > to enter the deepest power saving mode that it supports.  That's the
> > same for ethernet drivers and wireless drivers.  I think it's pretty
> > much up to the driver/ucode to track rfkill state across up/down/etc.
> > 
> > If 3945 can only detect the rfkill change when the ucode is loaded, then
> > we have a problem.
> > 
> > I'm not opposed to changing NetworkManager to keep the device up, but
> > just setting the TX power to 'off', though we must keep in mind that the
> > device is (a) not in a lowest power mode because RX circuits can still
> > be on, and (b) not all drivers probably respect WEXT txpower.  I don't
> > care about (b) at all, those drivers just have to get fixed.  But (a)
> > worries me since we don't have any API for inactive power saving modes
> > right now _other_ than !IFF_UP.  We will drain more power than setting
> > the device !IFF_UP.
> 
> So I did this, but we need a few changes to HAL, because the rfkill bits
> there aren't rich enough to distinguish between a hardware rfkill and a
> software rfkill.  So when SIOCSIWTXPOW to 'off', all you can get out of
> HAL is "I'm dead", which doesn't let you know whether you can turn the

Clarification: this behavior was seen on ipw2200.  Drivers/hardware that
use the kernels' rfkill framework may be different.

Dan

> radio back on with SIOCSIWTXPOW or whether there's a switch flipped
> somewhere.
> 
> Dan
> 
> > Dan
> > 
> > > In 4965 there is an interrupt announcing rkfil, in 3965 it's event
> > > from firmware. There was portably a good reason why the interrupt was
> > > added :)
> > > 
> > > Sorry no solution for now.
> > > 
> > > Tomas
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

