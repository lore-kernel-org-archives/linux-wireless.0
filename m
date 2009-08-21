Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:49908 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbZHUOTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 10:19:32 -0400
Received: by vws2 with SMTP id 2so615168vws.4
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 07:19:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0908191442j6b5733f3rb28967060abdbace@mail.gmail.com>
References: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com>
	 <b6c5339f0908191442j6b5733f3rb28967060abdbace@mail.gmail.com>
Date: Fri, 21 Aug 2009 10:19:33 -0400
Message-ID: <b6c5339f0908210719o2323d590w4a9f6a01d5ecb2d6@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292
From: Bob Copeland <me@bobcopeland.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 5:42 PM, Bob Copeland<me@bobcopeland.com> wrote:
> On Wed, Aug 19, 2009 at 4:47 PM, Fabio Comolli<fabio.comolli@gmail.com> wrote:
>> Hi all.
>> I see the following warning on an eeePC 900 (AR5001) running
>> 2.6.31-rc6 after a suspend/resume cycle:
>>
>> [  292.377941] ------------[ cut here ]------------
>> [  292.377976] WARNING: at net/mac80211/mlme.c:2292
>> ieee80211_sta_work+0x89/0xc39 [mac80211]()
>
>    if (WARN_ON(local->suspended)) ...

Okay, I think I see what is going on here.

  suspend
    ieee80211_scan_cancel
       ieee80211_notify_scan_completed
          ieee80211_mlme_scan_completed
          ieee80211_ibss_scan_completed
          ieee80211_mesh_scan_completed

All of these completed() notifications queue work.  That's not a problem
because we flush the workqueue shortly thereafter.  However, flushing the
workqueue runs the scheduled work, which can queue _more_ work (sometimes
on a timer with queue_delayed_work), and none of the work functions in
2.6.31 currently check for local->quiesced.

Repeat this process once more and we eventually hit the warning.

Can we just replace the last flush_workqueue() with cancel_delayed_work_sync()
or will that break something?

-- 
Bob Copeland %% www.bobcopeland.com
