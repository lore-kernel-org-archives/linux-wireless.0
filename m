Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38572 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYJCT66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 15:58:58 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH] p54: fix memory management
Date: Fri, 3 Oct 2008 22:02:53 +0200
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>
References: <200810020359.40610.chunkeey@web.de> <48E586B4.5010808@lwfinger.net>
In-Reply-To: <48E586B4.5010808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810032202.53952.chunkeey@web.de> (sfid-20081003_215901_962401_B98C4D09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 October 2008 04:43:00 Larry Finger wrote:
> Christian Lamparter wrote:
> Oct  2 17:22:52 larrylap kernel: BUG: unable to handle kernel NULL
> pointer dereference at 0000000000000000
[...]

> [...] Tainted: GM

> Note, the "tainted" flag is false. No closed-source drivers have been
> loaded.
>

more about the flags can be found in Documentation/oops-tracing.txt:

  1: 'G' if all modules loaded have a GPL or compatible license, 'P' if
     any proprietary module has been loaded.  Modules without a
     MODULE_LICENSE or with a MODULE_LICENSE that is not recognised by
     insmod as GPL compatible are assumed to be proprietary.
[...]
  5: 'M' if any processor has reported a Machine Check Exception,
     ' ' if no Machine Check Exceptions have occurred.

so:
- the "G" flag is perfectly OK! (P would be the "closed-source" drivers)

- however, the "M"(CE) flag is worryingly. The question is, if p54 causes it, or not? 
  As far as I know, when a MCE gets logged a short message should pop up
  in the kernel's log and next you'll need extra tools like mcelog to see what's
  going wrong.

Regards,
	Chr
