Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f48.google.com ([209.85.161.48]:39966 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbeHIVQI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 17:16:08 -0400
Received: by mail-yw1-f48.google.com with SMTP id z143-v6so5910152ywa.7
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2018 11:49:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180809111049.GC1955@redhat.com>
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com>
From: Randy Oostdyk <linux-kernel@oostdyk.com>
Date: Thu, 9 Aug 2018 12:49:58 -0600
Message-ID: <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com> (sfid-20180809_205002_383842_7BA5F816)
Subject: Re: wireless dongle causing entire machine to hang
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 9, 2018 at 5:10 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> I'm reluctant to replace _warn by _dbg messages as if somethings
> will go wrong we will not notice that. We can use printk_ratelimited()
> variant instead to do not spam log in speed that it will hung
> the machine. But the correct fix should be in USB host drivers,
> which seems to be not in perfect shape on those embedded platforms.

Agreed about the "correct" fix likely being on the USB side, but at
least using printk_ratelimited() will avoid the log spamming, and
avoid locking the machine, as you said.

Will someone else take that approach and come up with a patch, or is
this something I should try to take on myself? I could certainly test
such a patch, if desired.

Meanwhile, I'll look into reporting the USB bug, if it hasn't already been.
