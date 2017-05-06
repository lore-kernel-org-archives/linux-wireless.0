Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:57477 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdEFUW3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 May 2017 16:22:29 -0400
From: Julien Cubizolles <j.cubizolles@free.fr>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mwifiex won't connect to WPA2 anymore
References: <87wpa3kxgi.fsf@free.fr> <87tw51y91z.fsf@free.fr>
        <1493844237.5647.9.camel@redhat.com> <87a86sfh2e.fsf@free.fr>
        <1493948347.26081.1.camel@redhat.com> <87mvaq4bsg.fsf@free.fr>
        <1494085819.19292.5.camel@redhat.com>
Date: Sat, 06 May 2017 22:22:26 +0200
In-Reply-To: <1494085819.19292.5.camel@redhat.com> (Dan Williams's message of
        "Sat, 06 May 2017 10:50:19 -0500")
Message-ID: <8737chpwfx.fsf@free.fr> (sfid-20170506_222239_284253_5E9DF416)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:


> Ok, at this point the only thing I can think of is the MAC
> randomization that NM has.  Please see:
>
> https://blogs.gnome.org/thaller/2016/08/26/mac-address-spoofing-in-networkmanager-1-4-0/
>
> and look at the section "Randomization during Wi-Fi scanning" where it
> says:
>
> ----
> This default behavior can be disabled with a global configuration
> option in NetworkManager.conf:
>
> [device]
> wifi.scan-rand-mac-address=no
> ----
>
> if you set that, and restart NetworkManager, does that magically make
> things work?

Yes! It's now working fine, thanks a lot. I have my wifi AP set to only
accept a whitelist of MAC addresses so it makes sense that I can't
connect if the MAC address is random. I'll disable the randomization for
now on.

Julien.
