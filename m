Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:34328 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZGHHmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 03:42:16 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: BUG REPORT: libertas causing kernel lockups
Date: Wed, 8 Jul 2009 09:42:05 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alexander Barinov <alex.barinov@gmail.com>
References: <20090704130346.01b2e869@dream> <200907070859.39413.hs4233@mail.mn-solutions.de> <1246957007.4755.1.camel@johannes.local>
In-Reply-To: <1246957007.4755.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200907080942.05291.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes, but the patch that I quoted makes it allowable to sleep
> there, so it must be something else. Is it maybe using the
> RTNL there? Or using schedule_work() and then waiting for it
> or something that the work triggers, which will deadlock on
> the RTNL if there's something in front of it on the queue that
> needs the RTNL, because get_wireless_stats is executed under
> RTNL? (lockdep couldn't find that particular case because it
> knows nothing about completions)

Again this is all from my memory, around the 2.6.25 
time. "iwconfig" or "cat /proc/net/wireless" ended up in 
drivers/net/wireless/libertas/wext.c, AFAIK in 
lbs_get_wireless_stats(). This calls

   lbs_cmd_with_response(priv, CMD_802_11_GET_LOG, &log);

this is a macro calling lbs_cmd(). This thingy then does 
__lbs_cmd_async(), which creates a "command node", queues this, 
and calls

	wake_up_interruptible(&priv->waitq);

(cmd.c, around line 2050) to get the queue handled (e.g. sending 
the command to the firmware). And I think that this wake_up-call 
calls __schedule() now.



Later, lbs_cmd() does this:

   might_sleep();
   wait_event_interruptible(cmdnode->cmdwait_q,
        cmdnode->cmdwaitqwoken);

But AFAIK this isn't problematic.

-- 
http://www.holgerschurig.de
