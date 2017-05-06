Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751619AbdEFPuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 May 2017 11:50:22 -0400
Message-ID: <1494085819.19292.5.camel@redhat.com> (sfid-20170506_175025_994651_EA718BCF)
Subject: Re: mwifiex won't connect to WPA2 anymore
From: Dan Williams <dcbw@redhat.com>
To: Julien Cubizolles <j.cubizolles@free.fr>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 06 May 2017 10:50:19 -0500
In-Reply-To: <87mvaq4bsg.fsf@free.fr>
References: <87wpa3kxgi.fsf@free.fr> <87tw51y91z.fsf@free.fr>
         <1493844237.5647.9.camel@redhat.com> <87a86sfh2e.fsf@free.fr>
         <1493948347.26081.1.camel@redhat.com> <87mvaq4bsg.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-05-06 at 10:41 +0200, Julien Cubizolles wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> 
> > Just to test, could you add:
> > 
> > auth_alg=OPEN
> > key_mgmt=WPA-PSK
> > scan_ssid=1
> > 
> > to the block and retry with the supplicant?  I don't know why those
> > would make a difference but they might.
> 
> They don't: wpa_supplicant still connects with these settings.

Ok, at this point the only thing I can think of is the MAC
randomization that NM has.  Please see:

https://blogs.gnome.org/thaller/2016/08/26/mac-address-spoofing-in-networkmanager-1-4-0/

and look at the section "Randomization during Wi-Fi scanning" where it
says:

----
This default behavior can be disabled with a global configuration
option in NetworkManager.conf:

[device]
wifi.scan-rand-mac-address=no
----

if you set that, and restart NetworkManager, does that magically make
things work?

Dan
