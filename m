Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37771 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETUvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 16:51:19 -0400
Received: by mail-wm0-f53.google.com with SMTP id v200so3812267wmv.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 13:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfj4m9svn35.fsf@redhat.com>
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
 <wrfjinyayf2i.fsf@redhat.com> <CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
 <wrfj4m9svn35.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Fri, 20 May 2016 13:50:38 -0700
Message-ID: <CAOw_LSGsLVhXVvqwQD7J4ZJSL4jq8+KE-0ZMMXa5YP12Nb3dCA@mail.gmail.com> (sfid-20160520_225123_013894_485FDC42)
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> > Unfortunately, I ran into a case today where even 5000 loops was not
> > enough after a cold boot. 5000 loops meant about 1.5 second delay
> > between finishing the firmware checksum poll, while waiting for the
> > firmware to start. It now appears to me that the number of required
> > polling loops must be strongly bimodal.
> >
> > I added some logging, so that the driver reports to me the number of
> > loops required for the firmware to start.
>
> This is bizarre, I wonder if the hardware is having issues in your
> laptop?

The other bug reports I linked to seem identical to what's happening to
mine, so I doubt it is an issue with one specific instance of the hardware.

> Another thing to try would be to do an additional reset of the
> chip and wait a bit before trying to load the firmware?

Thanks, I will give this a shot.

Am I understanding your idea correctly? To put a loop around the 8051
reset and the firmware polling loop, with a delay between failure and retry?

for (int retry=1; ii<=MAX_RETRIES; ii++) {
    for (retry=1; retry<=5; retry++) {
        /* Reset the 8051 */
        priv->fops->reset_8051(priv);

        /* Wait for firmware to become ready */
        for (i=0; i<RTL8XXXXU_FIRMWARE_POLL_MAX; i++) {
            ...
        }

        /* On failure, insert a delay before trying again */
        if (i==RTL8XXXU_FIRMWARE_POLL_MAX)
            msleep(500);
     }
}

Thanks,
Dan
