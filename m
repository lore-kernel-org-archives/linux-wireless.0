Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:39262 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbeCOJ4v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 05:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <2929.1521106970@warthog.procyon.org.uk>
References: <20180314143529.1456168-1-arnd@arndb.de> <2929.1521106970@warthog.procyon.org.uk>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 15 Mar 2018 10:56:48 +0100
Message-ID: <CAK8P3a10hBz7QYk5v5MfhVMPOwFnWYTn95WZp1HtHrd7-GQpRg@mail.gmail.com> (sfid-20180315_105716_435260_5A29CBDD)
Subject: Re: [PATCH 00/16] remove eight obsolete architectures
To: David Howells <dhowells@redhat.com>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>, linux-usb@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2018 at 10:42 AM, David Howells <dhowells@redhat.com> wrote:
> Do we have anything left that still implements NOMMU?

Yes, plenty. I was wondering the same thing, but it seems that the architectures
we remove are almost completely representative of what we support overall,
except that they are all not licensed to 3rd parties, unlike many of the ones we
keep.

I've made an overview of the remaining architectures for my own reference[1].
The remaining NOMMU architectures are:

- arch/arm has ARMv7-M (Cortex-M microcontroller), which is actually
gaining traction
- arch/sh has an open-source J2 core that was added not that long ago,
it seems to
  be the only SH compatible core that anyone is working on.
- arch/microblaze supports both MMU/NOMMU modes (most use an MMU)
- arch/m68k supports several NOMMU targets, both the coldfire SoCs and the
  classic processors
- c6x has no MMU

       Arnd

[1] https://docs.google.com/spreadsheets/d/1QxMvW5jpVG2jb4RM9CQQl27-wVpNYOa-_3K2RVKifb0
