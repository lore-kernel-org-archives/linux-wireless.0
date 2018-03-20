Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:43975 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbeCTRLt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 13:11:49 -0400
Received: by mail-pf0-f193.google.com with SMTP id j2so885523pff.10
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2018 10:11:48 -0700 (PDT)
Date: Tue, 20 Mar 2018 10:11:47 -0700 (PDT)
Subject: Re: [PATCH 00/16] remove eight obsolete architectures
In-Reply-To: <CAK8P3a01pfvsdM1mR8raU9dA7p4H-jRJz2Y8-+KEY76W_Mukpg@mail.gmail.com>
CC: hare@suse.de, dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
From: Palmer Dabbelt <palmer@sifive.com>
To: Arnd Bergmann <arnd@arndb.de>
Message-ID: <mhng-f6731cb9-8394-419d-b14b-c6fcd6c0930d@palmer-si-x1c4> (sfid-20180320_181214_252382_F67015E7)
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Mar 2018 03:42:25 PDT (-0700), Arnd Bergmann wrote:
> On Thu, Mar 15, 2018 at 10:59 AM, Hannes Reinecke <hare@suse.de> wrote:
>> On 03/15/2018 10:42 AM, David Howells wrote:
>>> Do we have anything left that still implements NOMMU?
>>>
>> RISC-V ?
>> (evil grin :-)
>
> Is anyone producing a chip that includes enough of the Privileged ISA spec
> to have things like system calls, but not the MMU parts?
>
> I thought at least initially the kernel only supports hardware that has a rather
> complete feature set.

We currently do not have a NOMMU port.  As far as I know, everyone who's
currently producing RISC-V hardware with enough memory to run Linux has S mode
with paging support.  The ISA allows for S mode without paging but there's no
hardware for that -- if you're going to put a DRAM controller on there then
paging seems pretty cheap.  You could run a NOMMU port on a system with S-mode
and paging, but With all the superpage stuff I don't think you'll get an
appreciable performance win for any workload running without an MMU so there's
nothing to justify the work (and incompatibility) of a NOMMU port there.

While I think you could implement a NOMMU port on a machine with only M and U
modes (and therefor no address translation at all), I don't know of any MU-only
machines that have enough memory to run Linux (ours have less than 32KiB).  A
SBI-free Linux would be a prerequisite for this, but there's some interest in
that outside of a NOMMU port so it might materialize anyway.

Of course, QEMU could probably be tricked into emulating one of these machines
with little to no effort :)...  That said, I doubt we'll see a NOMMU port
materialize without some real hardware as it's a lot of work for a QEMU-only
target.
