Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55262 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZBRSLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 13:11:12 -0500
Received: by bwz5 with SMTP id 5so54443bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 10:11:09 -0800 (PST)
To: Oliver Neukum <oliver@neukum.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jason Andryuk <jandryuk@gmail.com>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, milan.plzik@gmail.com
Subject: Re: at76_usb development
References: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com>
	<20090204144317.GA3845@tuxdriver.com>
	<da94abde0902040748l6194cdd3i7044c839f3110e5a@mail.gmail.com>
	<200902051008.04061.oliver@neukum.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 20:11:06 +0200
In-Reply-To: <200902051008.04061.oliver@neukum.org> (Oliver Neukum's message of "Thu\, 5 Feb 2009 10\:08\:02 +0100")
Message-ID: <87wsbnzkcl.fsf@litku.valot.fi> (sfid-20090218_191118_324878_B6A68282)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oliver Neukum <oliver@neukum.org> writes:

> Am Wednesday 04 February 2009 16:48:11 schrieb Kalle Valo:
>> Yes, please cc also me. I try to keep up-to-date what's happening with
>> at76-usb so that the same fixes will be fixed in at76c50x-usb as well.
>
> Here is what I found with at76-usb as it is in the current kernel:
>
>  static int at76_wait_completion(struct at76_priv *priv, int cmd)
>  {
>         int status = 0;
>
>         unsigned long timeout = jiffies + CMD_COMPLETION_TIMEOUT;
>
>         do {
>
> This can go wrong in a preemptible kernel. You have no guarantee the full
> timeout is granted.
>
> @@ -1631,7 +1633,7 @@ static void at76_rx_tasklet(unsigned long param)
>         buf = (struct at76_rx_buffer *)priv->rx_skb->data;
>
>         if (urb->status != 0) {
> -               if (urb->status != -ENOENT && urb->status != -ECONNRESET)
> +               if (urb->status != -ENOENT && urb->status != -ECONNRESET && urb->status != -ESHUTDOWN)
>
> Should also check for ESHUTDOWN, also in at76_mac80211_tx_callback()

Thanks. I added these comments to my todo list, and will fix them
later.
 
-- 
Kalle Valo
