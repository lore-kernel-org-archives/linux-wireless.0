Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57120 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1KQPGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 10:06:31 -0500
Received: by bke11 with SMTP id 11so2100770bke.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 07:06:29 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] p54spi: Fix workqueue deadlock
Date: Thu, 17 Nov 2011 16:06:14 +0100
Cc: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20111116235546.096975f6@milhouse> <201111170007.58457.chunkeey@googlemail.com> <CAGRGNgVOmK+O7hifSuaKAL4vJCN1fkCZwZun4kchDpdLSLPZ7Q@mail.gmail.com>
In-Reply-To: <CAGRGNgVOmK+O7hifSuaKAL4vJCN1fkCZwZun4kchDpdLSLPZ7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111171606.15132.chunkeey@googlemail.com> (sfid-20111117_160634_278783_99DC696D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, November 17, 2011 01:04:49 AM Julian Calaby wrote:
> Christian, Michael,
> 
> I'm not sure these patches made it to the list.
> 
> Thanks,

You are right, but I don't know why? Michael can you please
resend the patch?

Regards,
	Chr

> On Thu, Nov 17, 2011 at 10:07, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Wednesday, November 16, 2011 11:55:46 PM Michael Büsch wrote:
> >> priv->work must not be synced while priv->mutex is locked, because
> >> the mutex is taken in the work handler.
> >> Move cancel_work_sync down to after the device shutdown code.
> >> This is safe, because the work handler checks fw_state and bails out
> >> early in case of a race.
> >>
> >> Signed-off-by: Michael Buesch <m@bues.ch>
> > Cc: <stable@kernel.org>
> > Acked-by: Christian Lamparter <chunkeey@googlemail.com>
