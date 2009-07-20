Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:56631 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZGTQRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 12:17:24 -0400
Received: by mail-qy0-f173.google.com with SMTP id 3so173272qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2009 09:17:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907181948.54594.chunkeey@web.de>
References: <4A611FC0.9040507@lwfinger.net> <4A61E436.9060808@lwfinger.net>
	<200907181808.05142.chunkeey@web.de> <200907181948.54594.chunkeey@web.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 20 Jul 2009 09:17:04 -0700
Message-ID: <43e72e890907200917r5472f4c8kaaa78e0529ae617c@mail.gmail.com>
Subject: Re: WARN_ON at minstrel_get_rate (include/net/mac80211.h:2111)
To: Christian Lamparter <chunkeey@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 18, 2009 at 10:48 AM, Christian Lamparter<chunkeey@web.de> wrote:
> On Saturday 18 July 2009 18:08:04 Christian Lamparter wrote:
>> On Saturday 18 July 2009 17:03:18 Larry Finger wrote:
>> > Thanks for the patch. I'll let you know what happens.
>> I have my doubts. Do you still have the WARN_ON dump?
>> or at least which of the two functions are listed in the dump?
>> - rate_control_get_rate
>> - rate_control_rate_init <- unlikely/really surprising
>
> found a similar WARNINGs on kerneloops:
> http://www.kerneloops.org/raw.php?rawid=449304&msgid=
> but the user has ath5k.
>
> and there's more: iwlagn used to have this issue, but they fixed it.
> ---
> commit c338ba3ca5bef2df2082d9e8d336ff7b2880c326
> Author: Abbas, Mohamed <mohamed.abbas@intel.com>
> Date:   Wed Jan 21 10:58:02 2009 -0800
>
>    iwlwifi: fix rs_get_rate WARN_ON()
>
>    In ieee80211_sta structure there is u64 supp_rates[IEEE80211_NUM_BANDS]
>    this is filled with all support rate from assoc_resp.  If we associate
>    with G-band AP only supp_rates of G-band will be set the other band
>    supp_rates will be set to 0. If the user type this command
>    this will cause mac80211 to set to new channel, mac80211
>    does not disassociate in setting new channel, so the active
>    band is now A-band. then in handling the new essid mac80211 will
>    kick in the assoc steps which involve sending disassociation frame.
>    in this mac80211 will WARN_ON sta->supp_rates[A_BAND] == 0.

I revert this patch in my rate control cleanup series, the real issue
was underneath the hood in mac80211 and should no longer be present.
It was caused by scans being issued with the assumption a valid rate
will be found on a different band for the target sta entry (the AP).
In my patch, "mac80211: drop frames for sta with no valid rate" we
simply drop these frames now and warn whenever such attempts are being
made within mac80211.

  Luis
