Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:37184 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeH1UCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 16:02:08 -0400
Received: by mail-yb0-f178.google.com with SMTP id f145-v6so806459ybg.4
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 09:09:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180816110247.GC2797@redhat.com>
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com> <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
 <20180810111425.GA16269@redhat.com> <CAAemcoOK6pxENmX8By=WJR3PVE7u2HwbE50LD3v0+Cif6bS5Lg@mail.gmail.com>
 <20180815080747.GA26839@redhat.com> <CAAemcoMUm=O3yviObt3+u-Cf+ySrVD2HXOzUHHOU0L4wBm=e9w@mail.gmail.com>
 <20180816103107.GA2797@redhat.com> <20180816110247.GC2797@redhat.com>
From: Randy Oostdyk <linux-kernel@oostdyk.com>
Date: Tue, 28 Aug 2018 10:09:44 -0600
Message-ID: <CAAemcoPvPs5-xsvGdbXw9_PiDnb3QhkZ=vz_HO3b-VWQRoci0Q@mail.gmail.com> (sfid-20180828_180953_051848_03450DB3)
Subject: Re: wireless dongle causing entire machine to hang
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

I had considerable difficulty getting the module compiled and
installed. I had ignored your first patch, and only applied the second
patch (that you said compiles), but it turns out to be missing the
variable declarations portion of the first patch. After taking that
portion of the first patch, I managed to get the module to compile and
installed.

After one week of testing, I'm not able to cause the USB protocol
error (-71) to happen, except by disconnecting the device from the USB
bus. So I'm not able to fully ascertain if your patch really solved
the issue or not. Sorry... At least I can say that it doesn't break
anything!

I will try to continue testing, and report the results if I can manage
to get the error to surface again.

Cheers,
Randy

On Thu, Aug 16, 2018 at 5:02 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Aug 16, 2018 at 12:31:07PM +0200, Stanislaw Gruszka wrote:
>> I prepared a patch that count EPROTO errors and if it's bigger
>> than 10 mark device as gone. It should not make a problem
>> when we will get one time random error.  I'm attaching it,
>> please test.
>
> Forgot to compile the patch, here is one that compiles.
>
> Cheers
> Stanislaw
