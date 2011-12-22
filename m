Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38495 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab1LVI74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 03:59:56 -0500
Received: by iaeh11 with SMTP id h11so13217238iae.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 00:59:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324469186-18507-1-git-send-email-eyal@wizery.com>
References: <1324469186-18507-1-git-send-email-eyal@wizery.com>
Date: Thu, 22 Dec 2011 10:59:55 +0200
Message-ID: <CAB3XZEdMS-_=qz+DTjtEsM8CGa0wvyqKdtWNF5+aCjV+=+326g@mail.gmail.com> (sfid-20111222_095959_980391_949D19A9)
Subject: Re: [PATCH] wl12xx: trigger recovery for failures in sched scan stop
From: Eliad Peller <eliad@wizery.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 2:06 PM, Eyal Shapira <eyal@wizery.com> wrote:
> mac80211 requires that drv_sched_scan_stop
> will always succeed. We have a few possible errors
> such as OOM, failure to ELP wakeup, fail in the FW command.
> Instead of no-op , trigger a recovery which would
> mark sched scan as stopped and clear up any bad FW state.
>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---
this patch seems a bit redundant.

>        ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       if (ret < 0) {
> +               wl12xx_queue_recovery_work(wl);
>                goto out;
> +       }
>
we enqueue recovery in wl1271_ps_elp_wakeup() in most error paths.


> -       /* FIXME: what to do if alloc'ing to stop fails? */
>        stop = kzalloc(sizeof(*stop), GFP_KERNEL);
>        if (!stop) {
>                wl1271_error("failed to alloc memory to send sched scan stop");
> -               return;
> +               goto recovery;
>        }
not sure if initiating recovery here will really help. it'll probably
fail as well, and good chances we are going to panic soon anyway :)

>        ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
>                              sizeof(*stop), 0);
> +
> +       kfree(stop);
> +
>        if (ret < 0) {
>                wl1271_error("failed to send sched scan stop command");
> -               goto out_free;
> +               goto recovery;
>        }
>
wl1271_cmd_send enqueues recovery work on error as well.

anyway, the major thing i don't like here is handling the sched_stop
in a different manner than the rest of the commands.

Eliad.
