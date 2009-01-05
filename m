Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:51327 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZAEVUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 16:20:52 -0500
Received: by gxk6 with SMTP id 6so5930661gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 13:20:51 -0800 (PST)
Message-ID: <b6c5339f0901051320r7d00ef96l7a945812aeaf28be@mail.gmail.com> (sfid-20090105_222059_154068_2A54C752)
Date: Mon, 5 Jan 2009 16:20:50 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Problem with rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <496273D4.6020600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <496273D4.6020600@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 5, 2009 at 3:55 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Johannes,
>
> I'm chasing a problem with suspend/resume on rtl8187; however, in my testing, I
> found that a simple "modprobe -r/modprobe" sequence fails, even though
> unplugging/replugging the stick with or without a "modprobe -r" works just fine.
> The last rtl8187 routine that was started was rtl8187_add_interface. From a
> debugging message, I see that info->flags = 0x6B6B6B6B - the SLUB debugging
> poison value.  If I interpret the traceback correctly, a workqueue has been
> restarted without being properly initialized.

Is this with the current driver unmodified?

If by any chance it is with your proposed patch from last week that always
called start() or stop() in resume/suspend without some is_up flag,
you will definitely get oopses doing that because the register/unregister
will be unbalanced.

-- 
Bob Copeland %% www.bobcopeland.com
