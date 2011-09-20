Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f52.google.com ([74.125.83.52]:56850 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab1ITMFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 08:05:47 -0400
Received: by gwb1 with SMTP id 1so332886gwb.11
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 05:05:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316450319.5995.33.camel@jlt3.sipsolutions.net>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari>
	<87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	<1316450319.5995.33.camel@jlt3.sipsolutions.net>
Date: Tue, 20 Sep 2011 15:05:46 +0300
Message-ID: <CAB3XZEeMZvv374SBTPDg1W8-E24=K5yVRhDQ0ktpUgxAEJgdzw@mail.gmail.com> (sfid-20110920_140550_826671_651A020D)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@adurom.com>, Luciano Coelho <coelho@ti.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 7:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-09-19 at 19:30 +0300, Eliad Peller wrote:
>
>> AFAIU from the coex guys, the scenario is something like this:
>> upon coex activity, the fw might delay its rx and tx paths. this means
>> that the fw might get a frame within the 100ms of the dyn ps, but
>> delay its processing and pass it up to the driver only later.
>> this will cause redundant psm enter (after 100ms) and psm exit (after
>> the fw passed the packet).
>> i'm not sure about the exact effect during coex operation, but
>> eventually these psm enter/exit affect the throughput.
>>
>> another point here, is that during a specific period (during auto_mode
>> on), there might or might not be coex activity. thus, we can't just
>> disable dyn_ps, as it will hurt throughput (when there is no coex
>> activity).
>>
>> bottom line - i'm not sure about all the details, but according to
>> their tests - it does improve the throughput.
>> (i can try getting better details if you have additional questions)
>
> It'd be interesting to see if we can just treat this as a "minimum awake
> time", kinda like going back to the range I thought about earlier.
>
do you mean something like:
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4274e94..57695e3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -702,11 +702,12 @@ void ieee80211_recalc_ps(struct ieee80211_local
*local, s32 latency)
                        if (latency > (1900 * USEC_PER_MSEC) &&
                            latency != (2000 * USEC_PER_SEC))
                                timeout = 0;
-                       else if (local->dynamic_ps_driver_timeout >= 0)
-                               timeout = local->dynamic_ps_driver_timeout;
                        else
                                timeout = 100;
                }
+               if (timeout && local->dynamic_ps_driver_timeout > timeout)
+                       timeout = local->dynamic_ps_driver_timeout;
+
                local->dynamic_ps_user_timeout = timeout;
                if (!local->disable_dynamic_ps)
                        conf->dynamic_ps_timeout =

?

i don't find it much different.

Eliad.
