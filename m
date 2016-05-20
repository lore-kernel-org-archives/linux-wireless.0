Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35935 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETUyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 16:54:51 -0400
Received: by mail-wm0-f46.google.com with SMTP id n129so18431wmn.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 13:54:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOw_LSGsLVhXVvqwQD7J4ZJSL4jq8+KE-0ZMMXa5YP12Nb3dCA@mail.gmail.com>
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
 <wrfjinyayf2i.fsf@redhat.com> <CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
 <wrfj4m9svn35.fsf@redhat.com> <CAOw_LSGsLVhXVvqwQD7J4ZJSL4jq8+KE-0ZMMXa5YP12Nb3dCA@mail.gmail.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Fri, 20 May 2016 13:54:10 -0700
Message-ID: <CAOw_LSGnjhOO4hfPk9KttkFtLyT6XLxa92Cj=eKq6zgQ1at-RQ@mail.gmail.com> (sfid-20160520_225455_634337_45A1287C)
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 20, 2016 at 1:50 PM, Daniel Lenski <dlenski@gmail.com> wrote:
> Am I understanding your idea correctly? To put a loop around the 8051
> reset and the firmware polling loop, with a delay between failure and retry?

That was some sloppy pseudo-code by me... here's what I think you're
suggesting:

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

Thanks,
Dan
