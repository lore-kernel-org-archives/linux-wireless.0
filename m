Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55759 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1DKORn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 10:17:43 -0400
Received: by wwa36 with SMTP id 36so6704263wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 07:17:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimNaaUyJ2jKG1gZ3WeWPA9E25y3pw@mail.gmail.com>
References: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
	<1301658705.3832.21.camel@jlt3.sipsolutions.net>
	<AANLkTimRgE+Lors_LNFnWH2cVarswfoKYP582+Xwuf_X@mail.gmail.com>
	<1302172435.3779.2.camel@jlt3.sipsolutions.net>
	<BANLkTimNaaUyJ2jKG1gZ3WeWPA9E25y3pw@mail.gmail.com>
Date: Mon, 11 Apr 2011 19:47:41 +0530
Message-ID: <BANLkTi=mDveMRkvzAZHh-Mse=vBMcDDaGg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Check for queued frames before entering
 power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 7, 2011 at 5:17 PM, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
> On Thu, Apr 7, 2011 at 4:03 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> I'll agree that entering powersave is pointless if that means you won't
>> be able to transmit all frames. It seems to me that maybe instead we
>> should give flush() a timeout, and if it can't complete in that time, we
>> can postpone the powersave then?
>
> This seems better as it addresses both the issues I listed above. The
> flush() timeout should not be high enough for the application to
> timeout and also flush() should not drop any frame. Maybe it can
> return a status if the pending frames are not completed in that
> timeout so that PS can be deferred. I will check this out.

I tried the following as explained above:

@@ -765,11 +766,15 @@ void ieee80211_dynamic_ps_enable_work(struct
work_struct *work)
                 * Flush all the frames queued in the driver before
                 * going to power save
                 */
-               drv_flush(local, false);
-               ieee80211_send_nullfunc(local, sdata, 1);
+               if (drv_flush(local, false))
   //FLUSH 1
+                       mod_timer(&local->dynamic_ps_timer, jiffies +
+                          msecs_to_jiffies(conf->dynamic_ps_timeout));
+               else {
+                       ieee80211_send_nullfunc(local, sdata, 1);

-               /* Flush once again to get the tx status of nullfunc frame */
-               drv_flush(local, false);
+                       /* Flush to get the tx status of nullfunc frame */
+                       drv_flush(local, false);                       //FLUSH 2
+               }
        }

        if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&

When there are pending frames in FLUSH 1, ps_timer is started which
will execute in 100ms. If FLUSH 2 also takes 200ms(flush timeout in
ath9k) to complete, dynamic ps timer will be triggered at once and the
netif queues continue to be stopped. Hence flush timeout should not be
more than the dynamic ps timeout for this case. So, postponing PS
based on flush is not working. Can we have the earlier implementation
of new callback to check for pending frames before stopping the queues
for PS?

Vivek.
