Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39688 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0JAMvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 08:51:32 -0400
Received: by fxm14 with SMTP id 14so534359fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 05:51:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] carl9170: fix hung workqueue
Date: Fri, 1 Oct 2010 14:51:28 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <201009272303.01535.chunkeey@googlemail.com> <1285658747.3885.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285658747.3885.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010011451.28418.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 September 2010 09:25:47 Johannes Berg wrote:
> On Mon, 2010-09-27 at 23:03 +0200, Christian Lamparter wrote:
> > The patch "mac80211: wait for scan work complete before
> > restarting hw", broke carl9170's restart path.
> > 
> > Previously it was possible to call ieee80211_restart_hw
> > from mac80211's internal workqueue. Now though it hangs
> > because of the flush_workqueue in the procedure.
> 
> I thought I asked somebody to move that. It's expected that you are
> allowed to call it -- the flush and scan cancel code there needs to be
> moved into the _work_, out of the restart_hw() function.
> 
John,

you can drop this patch and add Stanislaw's patch - series:
"[PATCH 1/6] mac80211: perform scan cancel in hw reset work"
instead.

Regards,
	Chr
