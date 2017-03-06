Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52844 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754189AbdCFVvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 16:51:40 -0500
Message-ID: <1488837079.27057.13.camel@sipsolutions.net> (sfid-20170306_230602_145613_2589DA4D)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 06 Mar 2017 22:51:19 +0100
In-Reply-To: <a4d62049-b406-0321-11c1-109c61527df5@googlemail.com> (sfid-20170306_224744_278723_C0B24B25)
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
         <1487938277.2540.13.camel@sipsolutions.net>
         <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com>
         <1487965047.30601.2.camel@sipsolutions.net>
         <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com>
         <1488444909.8390.11.camel@sipsolutions.net>
         <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com>
         <1488479939.23555.1.camel@sipsolutions.net>
         <37f7bd69-9a0e-7e49-7035-9e6f2cfef260@googlemail.com>
         <1488787876.5761.1.camel@sipsolutions.net>
         <a4d62049-b406-0321-11c1-109c61527df5@googlemail.com>
         (sfid-20170306_224744_278723_C0B24B25)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Agree, nothing looks bad. Try running "iw event" while you suspend
> > - if
> > the NIC thought it woke up the system there will be an event
> > indicating
> > so.
> > 
> 
> Indeed, I get:
> 1488836432.153465: wlan0 (phy #0): WoWLAN wakeup
>         * packet (might be truncated):
> ac:fd:ce:de:e1:58:b8:27:eb:f4:3b:4c:08:00:45:00:00:31:78:d1:40:00:3f:
> 06:3d:55:c0:a8:02:23:c0:a8:02:2d:30:39:30:39:f2:04:6f:88:8b:74:4c:c2:
> 50:18:72:10:00:00:00:00:57:41:4b:45:55:50:4e:4f:57
>         * TCP connection wakeup received
> 
> Note the trailing "57:41:4b:45:55:50:4e:4f:57" which is your
> "WAKEUPNOW". 
> 
> Also magic packet "works" this way, i.e. shows up via "iw event". 

Right. So that means the device did in fact stay powered all the way
through, otherwise we wouldn't have been able to retrieve this event
data.

> I realized I also have a Win10 installation on that machine - and may
> as well try WoWLAN with it. 
> Enabling (in the dreaded device manager) wake via the WiFi device,
> magic packet mode, I also cannot wake the machine. 

Ok. I didn't even know it was easy to actually get this configured on
Windows :)

> So if it was a driver bug, it would have to be present both in
> Windows and Linux drivers - but I guess it's just another case
> of broken system firmware *sigh*. 

Agree, that seems rather unlikely. Unless there's some kind of "magic"
setup that the UEFI wants, and the driver knows nothing about ... also
seems unlikely though.

> And that's even though it's a pretty recent Clevo W230SD-based
> machine (which I considered decently widespread)
> with unlocked UEFI (so I see almost all options), but of course
> nothing related to ACPI wakeup. 
> But I guess widespread alone does not help ;-). 

Yeah, too bad. Want to ask the manufacturer for help? ;-)

johannes
