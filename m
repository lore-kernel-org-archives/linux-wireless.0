Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:59543 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GKNMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 09:12:08 -0400
Received: by mail-la0-f51.google.com with SMTP id fq12so6791063lab.10
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jul 2013 06:12:07 -0700 (PDT)
Message-ID: <51DEAF24.4040301@cogentembedded.com> (sfid-20130711_151226_563117_E7916DF3)
Date: Thu, 11 Jul 2013 17:12:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Daniel Mack <zonque@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 44/50] sound: usb: caiaq: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-45-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-45-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-07-2013 13:06, Ming Lei wrote:

> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().

> Cc: Daniel Mack <zonque@gmail.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   sound/usb/caiaq/audio.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

> diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
> index 7103b09..e5675ab 100644
> --- a/sound/usb/caiaq/audio.c
> +++ b/sound/usb/caiaq/audio.c
> @@ -672,10 +672,11 @@ static void read_completed(struct urb *urb)
>   		offset += len;
>
>   		if (len > 0) {
> -			spin_lock(&cdev->spinlock);
> +			unsigned long flags;

    Emoty line wouldn't hurt here, after declaration.

> +			spin_lock_irqsave(&cdev->spinlock, flags);
>   			fill_out_urb(cdev, out, &out->iso_frame_desc[outframe]);
>   			read_in_urb(cdev, urb, &urb->iso_frame_desc[frame]);
> -			spin_unlock(&cdev->spinlock);
> +			spin_unlock_irqrestore(&cdev->spinlock, flags);

WBR, Sergei

