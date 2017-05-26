Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34802 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764497AbdEZPKM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 11:10:12 -0400
Received: by mail-qt0-f180.google.com with SMTP id c13so10519045qtc.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 08:10:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bmqi4q2u.fsf@purkki.adurom.net>
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
 <1494928877-27168-11-git-send-email-amit.karwar@redpinesignals.com> <87bmqi4q2u.fsf@purkki.adurom.net>
From: amit karwar <amitkarwar@gmail.com>
Date: Fri, 26 May 2017 20:40:11 +0530
Message-ID: <CAEhWJFnaG4xC71CL_ayYEyGg0HMNoyHK7aE9gcGAmsako8Q9Tw@mail.gmail.com> (sfid-20170526_171017_496879_2465E219)
Subject: Re: [v3 10/11] rsi: Add new firmware loading method
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 24, 2017 at 1:57 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> The older firmware loading method has been deprecated and not in use
>> for any chipets. New method is introduced which works based on soft
>> boot loader. In this method, complete RAM image and FLASH image are
>> present in the flash. Before loading the functional firmware, host
>> issues boot loader commands to verify whether firmware to load is
>> different from the current functional firmware. If not, firmware
>> upgrade progresses and boot loader will switch to the new functional
>> firmware.
>>
>> "rs9113_wlan_qspi.rps" is the firmware filename used in this patch.
>
> I don't know if you saw the discussion with the wil6210 firmware, but
> the linux-firmware maintainers prefer to have a subdirectory for
> firmware files. I'm planning to apply this series now, but you can send
> a followup patch ASAP which changes the rsi driver to use a subdirectory
> for the firmware files?

I have just sent a follow up patch.

> Normally these kind of breaks in user space interface are not allowed,
> and instead the requirement is that the driver has a transition period
> from the old firmware interface to the new one. But I'm making an
> exception here as, to my knowledge, the upstream rsi driver is not that
> widely used and I want to get the driver development going on again.
>

Right. Driver is not currently much used.
Thanks for accepting the changes.

Regards,
Amitkumar Karwar
