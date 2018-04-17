Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:41898 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752204AbeDQI20 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 04:28:26 -0400
Received: by mail-wr0-f175.google.com with SMTP id v24so15930429wra.8
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 01:28:26 -0700 (PDT)
Subject: Re: Driver crashes on resume after suspend
To: Carl-Erik Kopseng <carlerik@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com
References: <CAA05WiZDz1yqHHA-x8bkLSBru_kmwU9wws7gp5NQQEjYEDCaVw@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AD5B027.1030706@broadcom.com> (sfid-20180417_102831_439863_6B190A0E)
Date: Tue, 17 Apr 2018 10:28:23 +0200
MIME-Version: 1.0
In-Reply-To: <CAA05WiZDz1yqHHA-x8bkLSBru_kmwU9wws7gp5NQQEjYEDCaVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 4/17/2018 12:02 AM, Carl-Erik Kopseng wrote:
> I have a BCM4350 on my Ubuntu 18.04 system. Until today, I could never
> suspend my computer, as the driver brcmfmac would crash on resume
> (looking in dmesg) and only a reboot would make the device reappear.
>
> Today, I found a workaround by making the pm-* commands remove and add
> the module before any power management action:
>    echo 'SUSPEND_MODULES="brcmfmac"' | sudo tee -a /etc/pm/config.d/config
>
> This worked fine, but it took me quite a lot of digging, including
> trying out the `wl` driver, the `b43` package, and lots of tweaking. But
> even after going full circle and finding a fix, this still doesn't
> address the actual underlying problem: that brcmfmac doesn't survive
> hibernation and standby. Is there any data I can supply to remedy the
> situation? I attached the dump from wifi debugging utility to pinpoint
> my configuration, but it doesn't contain any dmesg output from the
> kernel crashes. You would probably want a more detailed output than what
> is supplied by dmesg anyway ...

Well. dmesg is always a start so let's have it. If you can compile the 
driver you could build it with CONFIG_BRCMDBG enabled and load the 
driver with parameter 'debug=0x80000'.

Regards,
Arend
