Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbcEWTYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 15:24:34 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
	<wrfjinyayf2i.fsf@redhat.com>
	<CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
	<wrfj4m9svn35.fsf@redhat.com>
	<CAOw_LSH8yGT+OoJU=a23B32mZ+qLkNuronB+vqZ5SaBRAG-fQw@mail.gmail.com>
Date: Mon, 23 May 2016 15:24:33 -0400
In-Reply-To: <CAOw_LSH8yGT+OoJU=a23B32mZ+qLkNuronB+vqZ5SaBRAG-fQw@mail.gmail.com>
	(Daniel Lenski's message of "Fri, 20 May 2016 19:40:01 -0700")
Message-ID: <wrfjlh30mvbi.fsf@redhat.com> (sfid-20160523_212450_660954_EEA2BC78)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> I tried various versions of running rtl8xxxu_init_device in a loop, with
> delays in between retries, and did not have any success.
>
> If the device doesn't want to start on the first load after boot, running
> various parts of init over and over just doesn't fix it. But unloading the
> driver and reloading does seem to fix it.
>
> So then I wondered...
>
> - Why does the firmware always (?) start on the *second try* of
>   loading rtl8xxxu, even if it failed to load after thousands of loops on
>   the first load attempt.
> - What would be the difference between the two cases?
> - As far as I understand it, the main effect on the hardware of unloading
>   the driver and then reloading it is that the device is power-cycled
>   (rtl8xxxu_power_off in rtl8xxxu_disable_device).
> - Is it possible that the device sometimes starts up in an unknown state
>   after a cold boot?
> - Hypothesis: since the rtl8xxxu driver does not explicitly power off the
>   device before attempting to power it on, if it boots up in an unknown
>   state, it will remain in this state until explicitly power-cycled.
>
> So then I tried powering off the device for 500ms after a failure in
> rtl8xxxu_init_device, before a retry:
>
>        for (retry=5; retry>=0; retry--) {
>                ret = rtl8xxxu_init_device(hw);
>                if (ret==0) {
>                        break;
>                } else {
>                        dev_err(&udev->dev, "Failed to init device,
> will retry %d more times.\n", retry);
>                        if (retry==0)
>                                goto exit;
>                        else {
>                                /* power off for 500 ms before retry */
>                                rtl8xxxu_power_off(priv);
>                                msleep(500);
>                        }
>                }
>        }
>
> So far, this always seems to work on the second try, even with a very
> short firmware_poll_max (50).
>
> I even tried forcing 50 power-cycles and inits in a row, and the firmware
> still starts up on the 51st cycle, and everything works fine.
>
> I don't understand *why* this works, but it seems like it might be a
> more reliable solution, since it addresses the experience common to
> the multiple bug reports, wherein the failure is only on the first attempt
> after cold boot.

Interesting, so if I understand you correctly, if you run
rtl8xxxu_power_off() once, the driver comes up correctly?

It is possible that rtl8xxxu_power_off() resets something that isn't being
initialized normally in the init sequence. It would be interesting to
try to break it down to find out which piece of the _power_off() code
we're missing.

Nice work!

Cheers,
Jes
