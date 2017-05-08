Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751791AbdEHOI0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 10:08:26 -0400
Message-ID: <1494252504.8248.2.camel@redhat.com> (sfid-20170508_160835_323301_8D587E98)
Subject: Re: mwifiex won't connect to WPA2 anymore
From: Dan Williams <dcbw@redhat.com>
To: Julien Cubizolles <j.cubizolles@free.fr>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 May 2017 09:08:24 -0500
In-Reply-To: <8737chpwfx.fsf@free.fr>
References: <87wpa3kxgi.fsf@free.fr> <87tw51y91z.fsf@free.fr>
         <1493844237.5647.9.camel@redhat.com> <87a86sfh2e.fsf@free.fr>
         <1493948347.26081.1.camel@redhat.com> <87mvaq4bsg.fsf@free.fr>
         <1494085819.19292.5.camel@redhat.com> <8737chpwfx.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-05-06 at 22:22 +0200, Julien Cubizolles wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> 
> > Ok, at this point the only thing I can think of is the MAC
> > randomization that NM has.  Please see:
> > 
> > https://blogs.gnome.org/thaller/2016/08/26/mac-address-spoofing-in-
> > networkmanager-1-4-0/
> > 
> > and look at the section "Randomization during Wi-Fi scanning" where
> > it
> > says:
> > 
> > ----
> > This default behavior can be disabled with a global configuration
> > option in NetworkManager.conf:
> > 
> > [device]
> > wifi.scan-rand-mac-address=no
> > ----
> > 
> > if you set that, and restart NetworkManager, does that magically
> > make
> > things work?
> 
> Yes! It's now working fine, thanks a lot. I have my wifi AP set to
> only
> accept a whitelist of MAC addresses so it makes sense that I can't
> connect if the MAC address is random. I'll disable the randomization
> for
> now on.

Well, ideally you wouldn't have to do this, but we haven't quite
figured out whether it's a bug in the way NM does randomization or
whether the drivers that require this switch (there are a few) are just
broken somehow.

Dan
