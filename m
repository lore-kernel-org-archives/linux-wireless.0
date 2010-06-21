Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41159 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab0FURyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 13:54:31 -0400
Received: by gye5 with SMTP id 5so2370724gye.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 10:54:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277124410.28895.23.camel@gnutoo-laptop>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	<1275693948-3189-2-git-send-email-notasas@gmail.com>
	<AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
	<1277124410.28895.23.camel@gnutoo-laptop>
Date: Mon, 21 Jun 2010 13:54:29 -0400
Message-ID: <AANLkTimLKDqDn_97BbOYr1cdxbFdPvyTz_lxJ59LVJ1b@mail.gmail.com>
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Bob Copeland <me@bobcopeland.com>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 8:46 AM, Denis 'GNUtoo' Carikli
<GNUtoo@no-log.org> wrote:

> Hi, me and some other people are trying to run standard GNU/Linux (not
> android ) on the htcdream.

> [ 1556.425354] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [ 1556.734130] mmc0: Command timeout

In this case it was only up for 1/3 second before it quit
responding to reads.  With power saving disabled it works?

Probably not relevant to power saving, but:

Are you using the dedicated irq line or sdio interrupt?
It makes a big difference in overall throughput to use
the former.

> +       /*
> +        * FIXME: scanning while associated causes lockups,
> +        * so we don't allow that
> +        */
> +       if (wl->associated)
> +               return -EBUSY;

Any idea why?  Could you turn on lockdep?

-- 
Bob Copeland %% www.bobcopeland.com
