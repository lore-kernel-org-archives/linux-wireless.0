Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48918 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2KSOwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:52:17 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so4863803oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 06:52:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353336285.18299.14.camel@jlt4.sipsolutions.net>
References: <1353239862-11313-1-git-send-email-eliad@wizery.com>
	<1353336285.18299.14.camel@jlt4.sipsolutions.net>
Date: Mon, 19 Nov 2012 16:52:16 +0200
Message-ID: <CAB3XZEcnew_7uJaWcMYF2Fv2ORKSUfPRGY0t-yrr1LKmwfWKYQ@mail.gmail.com> (sfid-20121119_155221_026264_1588EF2F)
Subject: Re: [PATCH] mac80211: make remain_on_channel() op pass vif param
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 4:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2012-11-18 at 13:57 +0200, Eliad Peller wrote:
>> Drivers (e.g. wl12xx) might need to know the vif
>> to roc on (mainly in order to configure the
>> rx filters correctly).
>>
>> Add the vif to the op params, and update the current
>> users (iwlwifi) to use the new api.
>
> Hmm, ok, but I think then the ROC merge logic may have to be changed?
>
yeah, i guess you're right.

@@ -2247,7 +2247,8 @@ static int ieee80211_start_roc_work(struct
ieee80211_local *local,

  out_check_combine:
        list_for_each_entry(tmp, &local->roc_list, list) {
-               if (tmp->chan != channel || tmp->chan_type != channel_type)
+               if (tmp->chan != channel || tmp->chan_type != channel_type ||
+                   tmp->sdata != sdata)
                        continue;

should something like this be enough?

Eliad.
