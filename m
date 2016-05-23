Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35288 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbcEWVsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 17:48:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id f75so407173wmf.2
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2016 14:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfjlh30mvbi.fsf@redhat.com>
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
 <wrfjinyayf2i.fsf@redhat.com> <CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
 <wrfj4m9svn35.fsf@redhat.com> <CAOw_LSH8yGT+OoJU=a23B32mZ+qLkNuronB+vqZ5SaBRAG-fQw@mail.gmail.com>
 <wrfjlh30mvbi.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Mon, 23 May 2016 14:47:22 -0700
Message-ID: <CAOw_LSGp42x1vxWajOsY8Q9revtRAjkuQiHgjWbHtP_oL+ND_w@mail.gmail.com> (sfid-20160523_234810_360261_0C4FB26A)
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2016 at 12:24 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Interesting, so if I understand you correctly, if you run
> rtl8xxxu_power_off() once, the driver comes up correctly?

Right. If rtl8xxxu_init_device() fails, I simply call
rtl8xxxu_power_off(), and then rtl8xxxu_init_device() again. It never
fails on the second try.

       for (retry=0; retry<2; retry++) {
               ret = rtl8xxxu_init_device(hw);
               if (ret==0) {
                       break;
               } else if (retry==1) {
                       dev_err(&udev->dev, "Fatal - failed to init device.\n");
                       goto exit;
               } else {
                       dev_warn(&udev->dev, "Failed to init device,
will power off and retry.\n");
                       rtl8xxxu_power_off(priv);
                       msleep(50);
               }
       }

> It is possible that rtl8xxxu_power_off() resets something that isn't being
> initialized normally in the init sequence. It would be interesting to
> try to break it down to find out which piece of the _power_off() code
> we're missing.

Here's the evidence that I have:

1. I can reliably induce the failure-to-start condition by warm-booting via
   kexec --force, without rtl8xxxu_power_off()

2. I can reliably recover from this artificially-induced failure-to-start using
   rtl8xxxu_power_off(), and it appears to work for the "naturally occurring"
   failure-to-start too.

3. I can *not* recover from artificially induced failure-to-start by lengthening
   the polling timeout.

   (Which means that my previous patch to lengthen the timeout was
   bogus, and it must have just worked by luck or some detail of how I was
   rebooting while testing it.)

> Nice work!

Thanks. If someone else is able to reproduce the artificial failure-to-start,
I'll be more confident that I've actually solved it this time.

Thanks,
Dan
