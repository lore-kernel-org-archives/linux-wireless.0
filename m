Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:34771 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751708AbcJMX5e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 19:57:34 -0400
Received: by mail-yb0-f171.google.com with SMTP id o189so11777776yba.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 16:57:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Thu, 13 Oct 2016 16:57:32 -0700
Message-ID: <CALupW3CrY5sZYBcx5Bd3E_M_Kx2sx8_N9h_uexvg_DSO0c-tJA@mail.gmail.com> (sfid-20161014_015738_524715_0569BC72)
Subject: Re: [RFC 0/5] ath6kl: non WMI data service support
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

On Thu, Oct 13, 2016 at 9:39 AM, Erik Stromdahl
<erik.stromdahl@gmail.com> wrote:
> This patch series is intended to prepare the ath6kl driver
> for newer chipsets that doesn't use the current WMI data
> endpoints for data traffic.
>
> The chipset I have been working with (and used for testing)
> is QCA6584. It is SDIO based (at least the variant I have
> been using) with 802.11p WAVE DSRC capabilities.
>
> This chipset is different from the AR600X family in that
> it does not use the WMI data services (service id's 0x101
> to 0x104 ) for data traffic.
> Instead it uses the HTT data service for data and wmi unified
> for control messages.
> It is also different when it comes to mailbox addresses
> and HTC header format as well, but these differences are not
> part of this patch series.
>

I've only taken a quick look and I'll make specific comments to
specific patches later, but I've got to ask the question, should these
changes go into ath6kl or be a new driver?

Just because the number starts with 6000 doesn't mean it's a ath6kl
chip. The 10k series chips all start with 9000 for example, but they
rate their own driver.

You state that all of the underpinnings of the communication with the
chip are totally different:
* Doesn't use WMI
* Different mailboxing
* Different HTC layer

If all of the commands and all of the communication layers to the chip
are totally different, then perhaps it isn't an ath6kl chip. So if
it's largely similar, then OK, but seems to me with the changes you're
saying above, it's mostly different.

I'm saying all that without any knowledge of this chip. My experience
is limited to various versions of the 6003 and 6004 chips.

Just trying to stimulate discussion here.

Thanks,
- Steve
