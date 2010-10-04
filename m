Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:5654 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751102Ab0JDBnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 21:43:12 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0288416587
	for <linux-wireless@vger.kernel.org>; Mon,  4 Oct 2010 10:43:10 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: Can 'iw' show the current tx-power?
Date: Mon, 4 Oct 2010 10:43:07 +0900
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4CA6B6F9.8080104@candelatech.com> <1286045327.11979.263.camel@maxim-laptop> <AANLkTin0G=_JjtDytJYgwYdh=AQZs=S-518XgChA9Voo@mail.gmail.com>
In-Reply-To: <AANLkTin0G=_JjtDytJYgwYdh=AQZs=S-518XgChA9Voo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010041043.07551.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon October 4 2010 10:27:47 Jonathan Guerin wrote:
> On Sun, Oct 3, 2010 at 4:48 AM, Maxim Levitsky <maximlevitsky@gmail.com> 
wrote:
> > On Sat, 2010-10-02 at 10:23 -0700, Ben Greear wrote:
> >> On 10/02/2010 08:21 AM, Maxim Levitsky wrote:
> >> > On Fri, 2010-10-01 at 21:37 -0700, Ben Greear wrote:
> >> >> It seems it can set it, but I don't see any command to print out
> >> >> the current value?
> >> >> 
> >> >> Thanks,
> >> >> Ben
> >> > 
> >> > This is pretty much last missing feature from iw.
> >> 
> >> Maybe that and current operating transfer rate?  I can't
> >> seem to find that anywhere other than 'iwconfig'...
> > 
> > iw wlan0 link shows that.
> 
> This does not work in adhoc mode:
> 
> # iw dev wlan0 info
> Interface wlan0
>         ifindex 4
>         type IBSS
> 
> # iw dev wlan0 link
> Not connected.

the TX rate is different for each station (and basically for each individual 
packet too) so it does not make sense to show that for the "link" (what ever 
"link" may mean in the context of ad-hoc...).

iw wlan0 station dump

can show you the last TX rate for each station, but again, the rate can and 
will change on a per-packet basis.

there is no such thing as a "current transfer rate".

bruno
