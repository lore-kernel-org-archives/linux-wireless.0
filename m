Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbeCORIg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 13:08:36 -0400
Date: Thu, 15 Mar 2018 10:08:30 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-input@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        linux-rtc@vger.kernel.org, linux-spi <linux-spi@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: rfc: remove print_vma_addr ? (was Re: [PATCH 00/16] remove eight
 obsolete architectures)
Message-ID: <20180315170830.GA17574@bombadil.infradead.org> (sfid-20180315_180913_218696_ABBE5550)
References: <20180314143529.1456168-1-arnd@arndb.de>
 <2929.1521106970@warthog.procyon.org.uk>
 <CAMuHMdXcxuzCOnFCNm4NXDv-wfYJDO5GQpB_ECu7j=2BjMhNpA@mail.gmail.com>
 <1521133006.22221.35.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521133006.22221.35.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2018 at 09:56:46AM -0700, Joe Perches wrote:
> I have a patchset that creates a vsprintf extension for
> print_vma_addr and removes all the uses similar to the
> print_symbol() removal.
> 
> This now avoids any possible printk interleaving.
> 
> Unfortunately, without some #ifdef in vsprintf, which
> I would like to avoid, it increases the nommu kernel
> size by ~500 bytes.
> 
> Anyone think this is acceptable?
> 
> Here's the overall patch, but I have it as a series
> ---
>  Documentation/core-api/printk-formats.rst |  9 +++++
>  arch/arm64/kernel/traps.c                 | 13 +++----
>  arch/mips/mm/fault.c                      | 16 ++++-----
>  arch/parisc/mm/fault.c                    | 15 ++++----
>  arch/riscv/kernel/traps.c                 | 11 +++---
>  arch/s390/mm/fault.c                      |  7 ++--
>  arch/sparc/mm/fault_32.c                  |  8 ++---
>  arch/sparc/mm/fault_64.c                  |  8 ++---
>  arch/tile/kernel/signal.c                 |  9 ++---
>  arch/um/kernel/trap.c                     | 13 +++----
>  arch/x86/kernel/signal.c                  | 10 ++----
>  arch/x86/kernel/traps.c                   | 18 ++++------
>  arch/x86/mm/fault.c                       | 12 +++----
>  include/linux/mm.h                        |  1 -
>  lib/vsprintf.c                            | 58 ++++++++++++++++++++++++++-----
>  mm/memory.c                               | 33 ------------------
>  16 files changed, 112 insertions(+), 129 deletions(-)

This doesn't feel like a huge win since it's only called ~once per
architecture.  I'd be more excited if it made the printing of the whole
thing standardised; eg we have a print_fault() function in mm/memory.c
which takes a suitable set of arguments.
