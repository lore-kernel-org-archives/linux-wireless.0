Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:16141 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbYBQBDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 20:03:30 -0500
Received: by py-out-1112.google.com with SMTP id u52so1451952pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 16 Feb 2008 17:03:27 -0800 (PST)
Message-ID: <43e72e890802161703o6a8039c0pe80506afbce0f3a3@mail.gmail.com> (sfid-20080217_010347_772983_2D574E81)
Date: Sat, 16 Feb 2008 20:03:27 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Fabio Venturi" <f.venturi@tdnet.it>
Subject: Re: Problem compiling ath5k
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <20080216172923.GA7439@silverstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080216103846.GC9290@silverstar>
	 <1c252d490802160400gd8a11a6y7e164d9b05f626c8@mail.gmail.com>
	 <20080216172923.GA7439@silverstar>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 16, 2008 12:29 PM, Fabio Venturi <f.venturi@tdnet.it> wrote:
> On Sat, Feb 16, 2008 at 01:00:39PM +0100, Joachim Frieben wrote:
> > > Hello to the list,
> > > I'd like to try the ath5k kernel module for my Atheros AR2413 Wireless
> > > Card
> > > so I downloaded the compat-wireless-2.6.tar.bz2
> > > I'm running a 2.6.24.2 kernel (the laste stable),
> > > but the compile stage ends immediately:
> > I simply removed ipw2100 from config.mk (I think that was the name ..) in
> > order to skip the build of ipw2100.ko which is ok since I was just
> > interested in the ath5k driver. All other drivers built correctly then.

These issues are being addressed with ipw, essentially we need some
items ported over.

> OK,
> now the driver compile and load without any problem and
> the wlan0 and master0 devices are created.
> There are no error in dmesg, but I can't scan for stations,
> iwlist wlan0 scan
> says there are no active stations.
> Do I need extra modules for scanning?
> I'm using an Atheros AR2413, is this device supposed to work with
> the ath5k module?
> Thank you in advance for any help,

You need to turn your interface up first:

ip link set wlan0 up

Or

ifconfig wlan0 up

  Luis
