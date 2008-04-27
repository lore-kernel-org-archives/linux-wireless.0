Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112]:60376 "EHLO
	smtp2.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYD0HkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 03:40:12 -0400
Message-ID: <20080427104009.d4zldn1eoks8s8g4@hayate.ip6> (sfid-20080427_094027_638619_EC3AD713)
Date: Sun, 27 Apr 2008 10:40:09 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6>
	<20080426045909.GA17936@ruslug.rutgers.edu>
	<20080426181848.foifd2bcw004kw4g@naisho.dyndns.info>
	<43e72e890804261126n7c4463c9y2d4bb4dc444be096@mail.gmail.com>
	<20080427004052.5sespv7h6o4wk8c0@hayate.ip6>
	<20080427025324.GB17936@ruslug.rutgers.edu>
In-Reply-To: <20080427025324.GB17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

> Ok I added cdc_ether.c and it compiles now if you use
> compat-wireless.git and wireles-testing.git to pull. I tested this
> only on 2.6.24 though, 2.6.22 compile may be broken now. We'll have
> to test that.
>
> OK so regardless I ran into issues with a 13b1:0026 Linksys
> (WUSB54GSC). Either I'm really not understanding this driver well or
> it wasn't tested well. I take it its the first... The first oops I
> run into is with access to the net_device on rndis_wext_bind(). I fixed
> that (patch at the bottom) but then I run into a bug on
> generic_rndis_bind() when accessing the net_device ....
> I just didn't get that as I am sure to be setting it.
>
> I then note that somehow generic_rndis_bind() is being run first
> than rndis_wext_bind()! How is this happening?
>

Ok, I'll try to explain usbnet framework. usbnet framework allows usb  
netdevices to share common code. Drivers depend depend on usbnet.c as  
tree:

  usbnet
    |
    |\------------cdc_ether-----------rndis_host
    |                |                     |
  drivers        drivers that         drivers that
  that only      need cdc_ether       need rndis_host
  need usbnet    (and usbnet)         functions (rndis_wlan)
  functions      functions

Drivers depending on usbnet are called minidriver in usbnet framework. Each
minidriver has list of devices supported and points probe function to  
usbnet:usbnet_probe(). If minidriver needs quirks over usbnet, this  
done in bind function. rndis_wlan, rndis_host and cdc_ether all have  
own modified bind function. So when rndis_wlan is loaded,  
usbnet:usbnet_probe() calls rndis_wext:rndis_wext_bind() calls  
rndis_host:generic_rndis_bind() which finally calls  
cdc_ether:usbnet_generic_cdc_bind(). Netdevice (and struct usbnet) is  
allocated in usbnet:usbnet_probe().

So usbnet.c should be included to compat-wireless, but modified  
usbnet.c would cause problems to other minidriver that aren't included  
in compat-wireless. Maybe this could be worked around with compat.diff  
and #ifdef's (?)

Because there isn't standard way to detect wireless RNDIS device from  
non-wireless, rndis_host and rndis_wext both have same usb_device_id.  
When rndis_host is loaded on wireless device,  
rndis_host:generic_rndis_bind() fails and lets rndis_wlan probe next.  
If rndis_wlan is loaded on non-wireless device,  
rndis_host:generic_rndis_bind() fails and lets rndis_host be probed.  
Detection is done with checking device media type with RNDIS command.

  - Jussi



