Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57709 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab1EYXIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 19:08:36 -0400
Received: by yia27 with SMTP id 27so68902yia.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 16:08:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306340205-30758-1-git-send-email-coelho@ti.com>
References: <1306340205-30758-1-git-send-email-coelho@ti.com>
Date: Thu, 26 May 2011 02:08:35 +0300
Message-ID: <BANLkTim4Gf8GVTqj7wcZrdGG6MM0mpTEvw@mail.gmail.com> (sfid-20110526_010839_612657_E1748135)
Subject: Re: [PATCH 2.6.40] wl12xx: fix oops in sched_scan when forcing a
 passive scan
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Luca,

On Wed, May 25, 2011 at 7:16 PM, Luciano Coelho <coelho@ti.com> wrote:
> Fix kernel oops when trying to use passive scheduled scans.  The
> reason was that in passive scans there are no SSIDs, so there was a
> NULL pointer dereference.
>
> To solve the problem, we now check the number of SSIDs provided in the
> sched_scan request and only access the list if there's one or more
> (ie. passive scan is not forced).  We also move the channels from
> active to passive if passive scanning is forced.  For this to work,
> it's necessary to set both active and passive dwell times for all
> channels.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
[...]

why does sched scan without ssids means passive scan? can't we just do
active sched scan without ssids?

> +       if (force_passive) {
> +               /* move active channels to passive lists */
> +               cfg->passive[0] += cfg->active[0] - 1;
> +               cfg->active[0] = 1;
looks like a potential integer underflow.

if you're forcing a passive scan, why do you need to set an active channel?

anyway, this seems a bit wrong.
i don't think you can just do "arbitrary transfers" of the channel
counts, as their order seem to matter (i.e. the order of elements in
the channel array is passive[0],passive[1],..,active[0],active[1]...,
so you actually need to shift all the elements)

Eliad.
