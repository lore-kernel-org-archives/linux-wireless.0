Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33085 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935097AbcJVL4L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 07:56:11 -0400
Received: by mail-vk0-f47.google.com with SMTP id 83so137788318vkd.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2016 04:56:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com> <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com> <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Sat, 22 Oct 2016 13:55:50 +0200
Message-ID: <CAOiHx==nbvwiiMZaqg5okdM6ab9ZLc+JOPdHdJJMUh9uhEt3PQ@mail.gmail.com> (sfid-20161022_135618_764526_2840B00E)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Oliver Zemann <oliver.zemann@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 21 October 2016 at 18:25, Oliver Zemann <oliver.zemann@gmail.com> wrote:
> The problem is gone with kernel 4.7.3 on armbian - both compex cards work
> (wle600, wle900),

Interesting to know this issue isn't present in 4.7 - I also
encountered it in 4.4 with LEDE.

> unfortunately that kernel does not support sfp (seems like
> its kind of proprietary drivers from clearfog).

They aren't really proprietary, they are proper patches that were
submitted as RFC once, so it shouldn't be much effort to port them to
e.g. 4.7. Anyways ...

> So its a driver issue but i
> have no clue who to contact or where to file a bug report. The only
> available kernel which supports sfp (from solidrun, vendor of the clearfog
> board) is 4.4.23
>
> I am wondering if i could simply checkout the 4.4.x sources, merge the
> atheros drivers in it and try to rebuild the kernel?

the issue seems to be that MSI interrupts do not work on 4.4 (at least
with ath10k, didn't have any other drivers that support it to test).
Your options are either to disable support for them in the kernel
config, or pass irq_mode=1 to ath10k_pci on probe to force legacy
interrupts; it should work then properly.


Regards
Jonas
