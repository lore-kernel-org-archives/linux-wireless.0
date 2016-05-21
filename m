Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34957 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcEUCkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 22:40:42 -0400
Received: by mail-wm0-f50.google.com with SMTP id i142so6273380wmf.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 19:40:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfj4m9svn35.fsf@redhat.com>
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
 <wrfjinyayf2i.fsf@redhat.com> <CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
 <wrfj4m9svn35.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Fri, 20 May 2016 19:40:01 -0700
Message-ID: <CAOw_LSH8yGT+OoJU=a23B32mZ+qLkNuronB+vqZ5SaBRAG-fQw@mail.gmail.com> (sfid-20160521_044127_035422_68F357E2)
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 20, 2016 at 7:08 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>
> Daniel Lenski <dlenski@gmail.com> writes:
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
> laptop? Another thing to try would be to do an additional reset of the
> chip and wait a bit before trying to load the firmware?

I tried various versions of running rtl8xxxu_init_device in a loop, with
delays in between retries, and did not have any success.

If the device doesn't want to start on the first load after boot, running
various parts of init over and over just doesn't fix it. But unloading the
driver and reloading does seem to fix it.

So then I wondered...

- Why does the firmware always (?) start on the *second try* of
  loading rtl8xxxu, even if it failed to load after thousands of loops on
  the first load attempt.
- What would be the difference between the two cases?
- As far as I understand it, the main effect on the hardware of unloading
  the driver and then reloading it is that the device is power-cycled
  (rtl8xxxu_power_off in rtl8xxxu_disable_device).
- Is it possible that the device sometimes starts up in an unknown state
  after a cold boot?
- Hypothesis: since the rtl8xxxu driver does not explicitly power off the
  device before attempting to power it on, if it boots up in an unknown
  state, it will remain in this state until explicitly power-cycled.

So then I tried powering off the device for 500ms after a failure in
rtl8xxxu_init_device, before a retry:

       for (retry=5; retry>=0; retry--) {
               ret = rtl8xxxu_init_device(hw);
               if (ret==0) {
                       break;
               } else {
                       dev_err(&udev->dev, "Failed to init device,
will retry %d more times.\n", retry);
                       if (retry==0)
                               goto exit;
                       else {
                               /* power off for 500 ms before retry */
                               rtl8xxxu_power_off(priv);
                               msleep(500);
                       }
               }
       }

So far, this always seems to work on the second try, even with a very
short firmware_poll_max (50).

I even tried forcing 50 power-cycles and inits in a row, and the firmware
still starts up on the 51st cycle, and everything works fine.

I don't understand *why* this works, but it seems like it might be a
more reliable solution, since it addresses the experience common to
the multiple bug reports, wherein the failure is only on the first attempt
after cold boot.

Thanks,
Dan
