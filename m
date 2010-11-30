Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55930 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab0K3HHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 02:07:45 -0500
Received: by iwn5 with SMTP id 5so1126102iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 23:07:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291097500.1673.100.camel@powerslave>
References: <1291038135-20672-1-git-send-email-shahar_levi@ti.com>
 <AANLkTikUOfQbk-TEE2=EejXOTr_t-LXvTim-Sc1OVwKG@mail.gmail.com> <1291097500.1673.100.camel@powerslave>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Nov 2010 23:07:24 -0800
Message-ID: <AANLkTi=y38YDVFQxS--2074FpQNsDD7iWqVjF77Gg_dg@mail.gmail.com>
Subject: Re: [PATCH v4 ] wl12xx: BA Initiator support
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: Shahar Levi <shahar_levi@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 10:11 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
...
> In theory the API *has* changed, not just extended.  Check this:
>
> -       ACX_BA_SESSION_RESPONDER_POLICY = 0x0055,
> -       ACX_BA_SESSION_INITIATOR_POLICY = 0x0056,
> +       ACX_BA_SESSION_POLICY_CFG   = 0x0055,
> +       ACX_BA_SESSION_RX_SETUP     = 0x0056,
>
> But in practice, this doesn't matter, because we were not using the
> RESPONDER/INITIATOR commands before...

Right.  So an old driver will still work with this new firmware.

> It's basically just those two extra commands that were added.  And one
> new event that is part of a future patch.
>
> In theory, we could check the firmware revision after boot and bail out
> if the version doesn't match.

Why not just disable BA sessions in this case (and keep that new event
masked), and let the driver keep running (just like it does today) ?

This way the new driver will work even with the old firmware (yes,
with degraded functionality, but most random ppl will just not care),
and of course, the old driver will keep working with the new firmware.

For us developers who lurk in linux-wireless it seems like a trivial
change, but if we consider the growing size of the 12xx community, and
the long period of time for which such a change will be effective (ppl
upgrading to latest compat, ppl that will one day upgrade to 2.6.38,
future ppl that will bisect and cross this firmware name change,
etc...), it's actually a lot of accumulated pain.

To keep our community happy, I vote to eliminate this pain when not necessary.

>
>
> --
> Cheers,
> Luca.
>
>
