Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:48621 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYD0Khk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 06:37:40 -0400
Received: by an-out-0708.google.com with SMTP id d31so1108750and.103
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 03:37:38 -0700 (PDT)
Message-ID: <43e72e890804270337w366cf0dfp53cc9b58cc8c2c09@mail.gmail.com> (sfid-20080427_123754_393050_734898DE)
Date: Sun, 27 Apr 2008 03:37:37 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080427104009.d4zldn1eoks8s8g4@hayate.ip6>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6>
	 <20080426045909.GA17936@ruslug.rutgers.edu>
	 <20080426181848.foifd2bcw004kw4g@naisho.dyndns.info>
	 <43e72e890804261126n7c4463c9y2d4bb4dc444be096@mail.gmail.com>
	 <20080427004052.5sespv7h6o4wk8c0@hayate.ip6>
	 <20080427025324.GB17936@ruslug.rutgers.edu>
	 <20080427104009.d4zldn1eoks8s8g4@hayate.ip6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 27, 2008 at 12:40 AM, Jussi Kivilinna
<jussi.kivilinna@mbnet.fi> wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>
>
> > Ok I added cdc_ether.c and it compiles now if you use
> > compat-wireless.git and wireles-testing.git to pull. I tested this
> > only on 2.6.24 though, 2.6.22 compile may be broken now. We'll have
> > to test that.
> >
> > OK so regardless I ran into issues with a 13b1:0026 Linksys
> > (WUSB54GSC). Either I'm really not understanding this driver well or
> > it wasn't tested well. I take it its the first... The first oops I
> > run into is with access to the net_device on rndis_wext_bind(). I fixed
> > that (patch at the bottom) but then I run into a bug on
> > generic_rndis_bind() when accessing the net_device ....
> > I just didn't get that as I am sure to be setting it.
> >
> > I then note that somehow generic_rndis_bind() is being run first
> > than rndis_wext_bind()! How is this happening?
> >
> >
>
>  Ok, I'll try to explain usbnet framework. usbnet framework allows usb
> netdevices to share common code. Drivers depend depend on usbnet.c as tree:
>
>   usbnet
>    |
>    |\------------cdc_ether-----------rndis_host
>    |                |                     |
>   drivers        drivers that         drivers that
>   that only      need cdc_ether       need rndis_host
>   need usbnet    (and usbnet)         functions (rndis_wlan)
>   functions      functions
>
>  Drivers depending on usbnet are called minidriver in usbnet framework. Each
>  minidriver has list of devices supported and points probe function to
> usbnet:usbnet_probe(). If minidriver needs quirks over usbnet, this done in
> bind function. rndis_wlan, rndis_host and cdc_ether all have own modified
> bind function. So when rndis_wlan is loaded, usbnet:usbnet_probe() calls
> rndis_wext:rndis_wext_bind() calls rndis_host:generic_rndis_bind() which
> finally calls cdc_ether:usbnet_generic_cdc_bind(). Netdevice (and struct
> usbnet) is allocated in usbnet:usbnet_probe().
>
>  So usbnet.c should be included to compat-wireless, but modified usbnet.c
> would cause problems to other minidriver that aren't included in
> compat-wireless. Maybe this could be worked around with compat.diff and
> #ifdef's (?)

Hm, the other strategy is just to include updates for the other usbnet
drivers, the list isn't so extensive. But then this would be becoming
more than just compat-wireless but more like compat-net or something,
which I guess isn't such a bad idea.

>  Because there isn't standard way to detect wireless RNDIS device from
> non-wireless, rndis_host and rndis_wext both have same usb_device_id. When
> rndis_host is loaded on wireless device, rndis_host:generic_rndis_bind()
> fails and lets rndis_wlan probe next. If rndis_wlan is loaded on
> non-wireless device, rndis_host:generic_rndis_bind() fails and lets
> rndis_host be probed. Detection is done with checking device media type with
> RNDIS command.

Thank you so much for your explanation. I've added usbnet into
compat-wireless as well, this is a compat-wireless package after all
so I expect users of it to want to get wireless drivers. So at least
they'll have this driver now available. We can workout a solution for
the other usbnet drivers later, it may make sense to just include
them.

I'm writing this e-mail on 2.6.22 using rndis_wlan.ko on a WEP
network. I've tested this also on 2.6.24.

[  320.456000] usb 4-3: new high speed USB device using ehci_hcd and address 2
[  320.588000] usb 4-3: configuration #1 chosen from 1 choice
[  320.680000] usbcore: registered new interface driver cdc_ether
[  320.688000] usbcore: registered new interface driver rndis_host
[  320.984000] wlan0: register 'rndis_wlan' at usb-0000:00:1d.7-3,
Wireless RNDIS device, BCM4320b based, 00:1d:7e:9a:b3:17
[  320.984000] usbcore: registered new interface driver rndis_wlan
[  321.024000] udev: renamed network interface wlan0 to wlan2
[  321.168000] rndis_wlan 4-3:1.0: rndis media disconnect
[  332.492000] ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
[  333.664000] rndis_wlan 4-3:1.0: rndis media connect
[  349.280000] wlan2: no IPv6 routers present

rndis_wlan is a go!

  Luis
