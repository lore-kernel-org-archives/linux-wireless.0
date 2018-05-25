Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33917 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967293AbeEYRG2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 13:06:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id q4-v6so14307530wmq.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 10:06:28 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20180522172129.V9LI1.34449.root@dnvrco-web11>
References: <20180522172129.V9LI1.34449.root@dnvrco-web11>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Fri, 25 May 2018 19:06:27 +0200
Message-ID: <CA+icZUX+p2feWOnXSA=m3i+r560Mo2kHsadT4qFhx8VvUv_k8A@mail.gmail.com> (sfid-20180525_190632_814397_E1AD5897)
Subject: Re: Atheros AR9462 - 5Ghz not working
To: mgreger@cinci.rr.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 22, 2018 at 7:21 PM,  <mgreger@cinci.rr.com> wrote:
> I've run out of ideas and am hoping someone here can help.
>
> All I want to do is connect a client to my 5Ghz network.
>
> My client:
>   OS is Debian stable "Stretch" with sysvinit instead of systemd
>   Atheros AR9462 (World roaming 0x64 regdomain in EEPROM)
>   "iw reg set US"
>   "iw list" shows both 2.4Ghz and 5Ghz bands available.
>   "iw wlp3s0 survey dump" shows received traffic on 5Ghz bands.
>
> There are oodles of 5Ghz AP's within range, but scans (including passive scans) reveal only 2.4Ghz networks. My only guess was that it won't transmit due to regulatory requirements, but I cannot make it work.
>
> What I've tried:
>   Running with and without CRDA
>   Running latest mainline kernel
>   Hacking around on the ath9k driver and nl80211 to remove all regulatory enforcement.
>
> Nothing works and I'm pulling my hair out. Any help would be greatly appreciated.

Hi,

I try to give some initial help.

The linux-wireless driver is supported by ath9k driver see [1] and [2].

Unfortunately, you have not sent any log-files at least your dmesg-log.
No output of the above userspace commands or userspace-tools versions.
No information to VendorID/ProductID (PCI, USB, whatever).
It's not clear to me if this is a kernelspace (ath9k-driver) or
userspace (CRDA/regulatory) problem.
How should someone help you effectively?

The linux-wireless wiki has somne informations on how to debug
Atheros/Qualcomm ath9k-driver, see [3].

As a debianist I say try Linux v4.16 Debian packages from
stretch-backports (and maybe a higher version of wireless-regdb).

Try to ask questions the smart way [4] :-).

Hope this helps.

Regards,
- Sedat -

[1] https://wireless.wiki.kernel.org/en/users/drivers/ath9k
[2] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/devices
[3] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/debug
[4] http://www.catb.org/esr/faqs/smart-questions.html
