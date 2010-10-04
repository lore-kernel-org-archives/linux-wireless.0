Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:28037 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751107Ab0JDCHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 22:07:49 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0391968067
	for <linux-wireless@vger.kernel.org>; Mon,  4 Oct 2010 11:07:48 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: Can 'iw' show the current tx-power?
Date: Mon, 4 Oct 2010 11:07:46 +0900
References: <4CA6B6F9.8080104@candelatech.com> <201010041043.07551.br1@einfach.org> <AANLkTikMHVauosiqRbOw1Dp8JuFS2tpXYd-Hcps_SbPD@mail.gmail.com>
In-Reply-To: <AANLkTikMHVauosiqRbOw1Dp8JuFS2tpXYd-Hcps_SbPD@mail.gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010041107.46117.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon October 4 2010 10:46:45 you wrote:
> On Mon, Oct 4, 2010 at 11:43 AM, Bruno Randolf <br1@einfach.org> wrote:
> > On Mon October 4 2010 10:27:47 Jonathan Guerin wrote:
> >> On Sun, Oct 3, 2010 at 4:48 AM, Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > wrote:
> >> > On Sat, 2010-10-02 at 10:23 -0700, Ben Greear wrote:
> >> >> On 10/02/2010 08:21 AM, Maxim Levitsky wrote:
> >> >> > On Fri, 2010-10-01 at 21:37 -0700, Ben Greear wrote:
> >> >> >> It seems it can set it, but I don't see any command to print out
> >> >> >> the current value?
> >> >> >> 
> >> >> >> Thanks,
> >> >> >> Ben
> >> >> > 
> >> >> > This is pretty much last missing feature from iw.
> >> >> 
> >> >> Maybe that and current operating transfer rate?  I can't
> >> >> seem to find that anywhere other than 'iwconfig'...
> >> > 
> >> > iw wlan0 link shows that.
> >> 
> >> This does not work in adhoc mode:
> >> 
> >> # iw dev wlan0 info
> >> Interface wlan0
> >>         ifindex 4
> >>         type IBSS
> >> 
> >> # iw dev wlan0 link
> >> Not connected.
> > 
> > the TX rate is different for each station (and basically for each
> > individual packet too) so it does not make sense to show that for the
> > "link" (what ever "link" may mean in the context of ad-hoc...).
> > 
> > iw wlan0 station dump
> > 
> > can show you the last TX rate for each station, but again, the rate can
> > and will change on a per-packet basis.
> > 
> > there is no such thing as a "current transfer rate".
> 
> With iwconfig, we can set a fixed rate, shouldn't this be what we
> expect to see as the 'rate'?

it only makes sense if you set a single fixed rate.

> Speaking of, is there a particular reason why we still have to use
> iwconfig to set the rate as well?

a TX bitrate mask has been added to iw in version 0.9.21:

commit 0db5d893ecf2ce4538af6fdcae3d94f2f83757e2                                         
Author: Johannes Berg <johannes@sipsolutions.net>                                       
Date:   Fri Sep 24 17:44:07 2010 +0200                                                  
                                                                                        
    version 0.9.21                                                                      
                                                                                        
     * transmit power support                                                           
     * TX bitrate mask support                                                          
     * more informative scan output                                                     
     * make it build on old systems                                                                

you can use it like this, e.g.: "iw wlan0 set bitrates legacy-2.4 12 18 24"

this is much more flexible than the iwconfig way, as it allows a bitmap of TX 
rates which can be used. again this is a reason why it does not make sense to 
show a single TX bitrate, but i guess this TX bitmap could/should be shown 
somewhere.

bruno
