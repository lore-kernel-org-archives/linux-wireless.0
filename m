Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33592 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbcGYHvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 03:51:50 -0400
Received: by mail-io0-f195.google.com with SMTP id y195so11356064iod.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 00:51:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160722221929.GN5537@wotan.suse.de>
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
 <20160721070938.GA2658@redhat.com> <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
 <20160721080541.GB2658@redhat.com> <5790A28F.8030102@redhat.com>
 <20160721115122.GA31869@redhat.com> <a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
 <20160722102559.GA2662@redhat.com> <84a2cfbe-3d58-a5ec-e028-166dce4c9304@broadcom.com>
 <579216D8.2010401@redhat.com> <20160722221929.GN5537@wotan.suse.de>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Mon, 25 Jul 2016 10:51:47 +0300
Message-ID: <CANUX_P2dosQr=B-Sd2+fcgWnrLjdT_ee5j0tt=8A_ns_YJ3Wew@mail.gmail.com> (sfid-20160725_095202_450388_C6A0432F)
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>,
	Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2016 at 1:19 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Fri, Jul 22, 2016 at 08:51:36AM -0400, Prarit Bhargava wrote:
>> On 07/22/2016 08:21 AM, Arend Van Spriel wrote:
>> >> Another option to solve to problem would be stop requesting not
>> >> available publicly firmware. However, I assume some drivers would
>> >> like to preserve that option.
>> >
>> > Actually, this is not the case with brcmfmac. We do need a firmware
>> > file, ie. brcm/brcmfmac4356-pcie.bin, and also request for a nvram file,
>> > ie. brcm/brcmfmac4356-pcie.txt. The latter is optional and the device
>> > works fine without it.
>> >
>> > What is still unclear to me is when request_firmware_direct() would fail
>> > and in what circumstances the udev helper is a valid callback. Can you
>> > explain such a scenario. Another question I have is what the reasons are
>> > behind the 60 seconds timeout.
>>
>> request_firmware_direct() will fail when the specified FW file is not present.
>> This is different from request_firmware() which implements a usermode helper to
>> potentially download firmware, or unpack a firmware image.
>>
>> Re: 60 second timeout ... The 60 second timeout with request_firmware() is
>> completely arbitrary.  There is no way for udev to signal back to the kernel
>> that userspace helper has not completed its actions, so the kernel has a 60 dead
>> man timer-ish delay.
>
> Lets call it what it was: the 60 second timeout thing was simply a mistake.
> Its no longer 60 seconds anyway, and in fact its accepted a dreaded issue.
> What *we* should be doing is thinking about proper long term architecture now.
> Async probe was one solution to some issues, a new flexible firmware API
> that avoids the usermode helper 100% is another.
>
> Distros stuck with the fallback option should review their strategies,
> either disabling the fallback option, upgrade systemd, or use alternative
> solutions (opensuse has a good one).
>
>> >>>> However I wonder if changing that will not broke the case when
>> >>>> driver is build-in in the kernel and f/w is not yet available when
>> >>>> driver start to initialize. Or maybe nowadays this is not the case
>> >>>> any longer, i.e. the MODULE_FIRMWARE macros assure proper f/w
>> >>>> images are build-in in the kernel or copied to initramfs?
>> >>>
>> >>> That is a nice idea, but I have not seen any change in that area. Could
>> >>> have missed it.
>> >>
>> >> I believe this is how the things are already done, IOW switching to
>> >> request_firmware_direct() in the driver should be no harm.
>> >
>> > Ok. What are the consequences when:
>> > - driver is built-in.
>> > - driver+firmware present on initramfs.
>> > - driver on initramfs, firmware only present on rootfs.
>> > - driver+firmware only on rootfs.
>> >
>> > I assume the third one would be considered a configuration issue.
>>
>> I think your question here can be answered by reading drivers/base/Kconfig:88,
>> and reading about those 4 config options.
>
> No, this documentation is terrible, I've posted some patches to help with this
> mess.
>
>> I could paraphrase it butI think the
>> Kconfig notes are better than I could explain it.  Note that this is how things
>> currently work with request_firmware_nowait().  IIRC request_firmware_nowait()
>> is just an asynchronous version of request_firmware().
>
> ... its a mess.
>

Awesome. I leave the code as is and ignore any RHEL bugs that are
related to that. If someone wants to improve all this, I'd be thankful
if he could do the work in the subsystem as Arend suggested.
