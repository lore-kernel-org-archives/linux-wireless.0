Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50489 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1EFXcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 19:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110506232638.72e8900a@lxorguk.ukuu.org.uk>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
 <1304719780-27347-2-git-send-email-lrodriguez@atheros.com> <20110506232638.72e8900a@lxorguk.ukuu.org.uk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 6 May 2011 16:31:48 -0700
Message-ID: <BANLkTimB7MB=E2gq80Gu5==anxwJsqjZCA@mail.gmail.com> (sfid-20110507_013223_779522_76BEBC92)
Subject: Re: [RFC 1/2] misc: add Atheros ar1520 GPS support
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
	hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, allen.kao@atheros.com,
	roman.gezikov@atheros.com, joonas.viskari@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 6, 2011 at 3:26 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Last time this driver came up the answer was that the userspace was
> proprietary and this was in fact part of a mixed user/kernel driver which
> seemed to raise all sorts of interesting questions.
>
> This was NAKked before for that reason so why the resubmit. Kernel policy
> is clear enough ?

I was not aware such a patch was even submitted before..

>> + * You need a userspace application to cooperate with this driver. It and
>> + * more information about this driver can be obtained here:
>> + *
>> + * http://wireless.kernel.org/en/users/Drivers/ar5120
>
> Which says:
>
> Userspace application
>
> This driver requires a userspace application which will interact with the
> driver via ioctl. More information on this to be posted later.
>
> So NAK

Umm, yeah, also unaware there was no userspace app which was open that
was going to be provided, sorry about that, I'll check with the
team...

> Let's see an open userspace and then this driver can be submitted
>
> +               time =
>  wait_event_interruptible_timeout(ar1520_data->wait_irq,
> +
>  ar1520_data->irq_rx, +
>  msecs_to_jiffies(3142));
>
> Why 3142 ?

Really arbitrary as pi is, this didn't have a timeout before so I just
added this for now. Was hoping Roman or Joonas can better estimate a
better value here.

> Come to think of it why not fixes the races while you are it.

Sure.

  Luis
