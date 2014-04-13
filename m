Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64448 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaDMJbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 05:31:07 -0400
Received: by mail-pa0-f44.google.com with SMTP id bj1so7156314pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 02:31:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 13 Apr 2014 12:30:50 +0300
Message-ID: <CA+XVXfdepnQyTGQ5stYLjAngpvf_hxRfMUSbjufCDwoBKhTySA@mail.gmail.com> (sfid-20140413_113112_273806_886725E5)
Subject: Re: [RFC/RFT] cfg80211: reg: track crda request
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	mcgrof@do-not-panic.com, linux@eikelenboom.it, collen@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 11, 2014 at 3:29 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Track CRDA requests and handle timeout
> when no answer from CRDA.
> This could happen during startup when
> crda binary is not available.

[...]
> @@ -1864,7 +1865,8 @@ static void reg_process_pending_hints(void)
>
>         /* When last_request->processed becomes true this will be rescheduled */
>         if (lr && !lr->processed) {
> -               REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
> +               REG_DBG_PRINT("Pending %s regulatory request, waiting for it to be processed...\n",
> +                             reg_initiator_name(lr->initiator));
>                 return;


The patch is good, but what's why not also apply Luis' original
("cfg80211: fix processing world regdomain when non modular") + my
suggested fix for the issue there?

The way I see it, the sooner we retry the better. Why should I see
this print instead of trying to re-process the hint?

Arik
