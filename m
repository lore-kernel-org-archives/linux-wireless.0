Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:30465 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXKUWpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 17:45:03 -0500
Received: by py-out-1112.google.com with SMTP id u77so7520952pyb
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2007 14:45:02 -0800 (PST)
Message-ID: <43e72e890711211445r385ecf3bkd6176924d597a79a@mail.gmail.com> (sfid-20071121_224510_493975_AE454DD8)
Date: Wed, 21 Nov 2007 17:45:02 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/2] ath5k: more consistent info and error logging
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <1195636079-10357-1-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195636079-10357-1-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 21, 2007 4:07 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> added new macros ATH5K_INFO, ATH5K_WARN and ATH5K_ERR for more consistent
> logging inside ath5k. they prepend "ath5k phyX:" to all lines so we can
> distinguish between different cards in multi-card setups. ATH5K_WARN and
> ATH5K_ERR use net_ratelimit(), so they can be used anywhere without having to
> check net_ratelimit() seperately.
>
> the macros get a reference to sc, so we can automatically add additional
> information: right now it is used to get the phy name, but having this in one
> central place gived us the flexibility to switch to dev_info/warn/... or others
> instead too. i think using "phyX" makes the output most readable and easier to
> match with the output from mac80211. in cases where we don't have sc available
> we still use ATH5K_PRINTF.
>
> changed all printk, most dev_info and most AR5K_PRINTF lines to use these
> macros instead. deleted AR5K_PRINT because it's easy to use ATH5K_PRINTF
> instead.
>
> for base.c
> Changes-licensed-under: 3-clause-BSD
>
> for all others...
> Changes-licensed-under: ISC
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Thanks for splitting this. I believe you missed some notes I made in
the previous e-mail. The boring legal notes are specially important.

  Luis
