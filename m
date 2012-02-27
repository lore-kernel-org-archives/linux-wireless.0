Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab2B0PYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:24:55 -0500
Message-ID: <1330356422.1941.10.camel@dcbw.foobar.com> (sfid-20120227_162505_765708_360A8337)
Subject: Re: libertas firmware loading slow with latest UDEV
From: Dan Williams <dcbw@redhat.com>
To: Joe Woodward <jw@terrafix.co.uk>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2012 09:27:02 -0600
In-Reply-To: <WC20120227100911.6501DA@terrafix.co.uk>
References: <WC20120227100911.6501DA@terrafix.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 10:09 +0000, Joe Woodward wrote:
> Hi,
> 
> Im running on a stock 3.2 kernel and have updated from udev-175 to udev-181/kmod-5, and loading the libertas firmware (WiFi SD8686 SDIO) 
> takes a *lot* longer (it does eventually succeed).

Yeah, because latest udev requires async firmware loading, and libertas
hasn't been converted for that.  The fault is really udev's for
requiring it, as nothing has changed in libertas, but async firmware
loading is a good thing anyway, so udev is doing us a service by pulling
the world forward a bit :)  It's a problem for any of the libertas bus
types, USB, SDIO, GSPI, CF.  I don't think anyone is working on a fix,
though if I have some time I'd look into it.  But don't let that stop
somebody from doing it first.

Dan

> In fact, it takes 30 seconds longer, which seems to imply some timeout somewhere is being hit.
> 
> # modprobe libertas_sdio
> [  108.600311] libertas_sdio: Libertas SDIO driver
> [  108.613891] libertas_sdio: Copyright Pierre Ossman
> [  139.116882] libertas_sdio mmc1:0001:1: (unregistered net_device): 00:19:88:3e:4f:f9, fw 9.70.3p36, cap 0x00000303
> [  139.191223] libertas_sdio mmc1:0001:1: wlan0: Marvell WLAN 802.11 adapter
> 
> After doing an initial Google it seems that changes in udev-177 may have caused this issue, and that this is due to the way certain drivers load 
> firmware, which needs fixing in the kernel.
> 
> So I have a couple of questions:
>  - Is this analysis correct?
>  - In my case is this a libertas_sdio-specific driver issue?
>  - And is anyone working on a fix or have a patch for a fix?
>  - Or is there anything I can do to work around this problem in the mean time?
> 
> Thanks,
> Joe
> 
> 
> 
> References:
> http://www.spinics.net/lists/netdev/msg185742.html
> https://bbs.archlinux.org/viewtopic.php?id=134012
> 
> From https://bbs.archlinux.org/viewtopic.php?pid=1045516#p1045516:
> What is happening is that some kernel drivers are asking udev to load their firmware before their modules have finished loading. This used to work 
> fine because udev gave firmware request special treatment and served them without waiting for anything else.
> 
> As of udev-177 this is no longer done. All events are treated the same, and a firmware event that is the child of a module event (which is the case 
> that is causing us problems) is only served once the parent event has finished. In order to avoid dead-locks the modprobe is given a 30 seconds 
> timeout, after which the firmware event can continue to be loaded. This is what you are seeing.
> 
> This problem should be solved by fixing the kernel drivers, and I know that at least he netdev guys are aware of it and working on it. If anyone is 
> interested in helping out they should go to the kernel bugzilla/mailinglist.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


