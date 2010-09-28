Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0I1HZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 03:25:50 -0400
Subject: Re: [PATCH] carl9170: fix hung workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201009272303.01535.chunkeey@googlemail.com>
References: <201009272303.01535.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:25:47 +0200
Message-ID: <1285658747.3885.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 23:03 +0200, Christian Lamparter wrote:
> The patch "mac80211: wait for scan work complete before
> restarting hw", broke carl9170's restart path.
> 
> Previously it was possible to call ieee80211_restart_hw
> from mac80211's internal workqueue. Now though it hangs
> because of the flush_workqueue in the procedure.

I thought I asked somebody to move that. It's expected that you are
allowed to call it -- the flush and scan cancel code there needs to be
moved into the _work_, out of the restart_hw() function.

johannes

