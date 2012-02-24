Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63939 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2BXQkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 11:40:40 -0500
Received: by ggnh1 with SMTP id h1so1225173ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 08:40:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330067955.3426.3.camel@jlt3.sipsolutions.net>
References: <1330050621-8955-1-git-send-email-ashok@cozybit.com> <1330067955.3426.3.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 24 Feb 2012 08:40:19 -0800
Message-ID: <CAPjQAd9ezrXpNSQUTy5FE5x57DdRTJCi7OVH98cXUBhUMfea4Q@mail.gmail.com> (sfid-20120224_174043_383323_9B4CBE47)
Subject: Re: [PATCH] {nl,cfg,mac}80211: Enable control quality monitoring for mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ashok Nagarajan <ashok@cozybit.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Feb 23, 2012 at 11:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-02-23 at 18:30 -0800, Ashok Nagarajan wrote:
>
>> +/*
>> + * NOTE: Mesh peer links are established only if average rssi of the peer
>> + * candidate satisfies the threshold. sta_meets_rssi_treshold doesn't use
>> + * hysteresis as fluctuations around threshold have no adverse effects.
>> + */
>> +
>> +#define sta_meets_rssi_threshold(sta, sdata) \
>> +             (sdata->vif.bss_conf.cqm_rssi_thold == 0 || \
>> +             ((s8) -ewma_read(&sta->avg_signal)) > \
>> +              sdata->vif.bss_conf.cqm_rssi_thold)
>
> This also isn't right, you're using a value (bss_conf.cqm_rssi_thold)
> intended for *signalling* for actual *decision making*.

Isn't that value used for making the decision (in userspace) on
whether a signal is good enough to associate?  On an open mesh this
decision takes place in the kernel.  It made more sense to us to reuse
that parameter for mesh than to introduce a new one.  Would you rather
see a separate mesh parameter for this?

Cheers,

Javier
