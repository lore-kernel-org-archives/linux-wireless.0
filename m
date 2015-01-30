Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57941 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927AbbA3NCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:02:20 -0500
Received: by mail-wg0-f48.google.com with SMTP id x12so26724922wgg.7
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 05:02:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422621903.1919.7.camel@sipsolutions.net>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	<1422621903.1919.7.camel@sipsolutions.net>
Date: Fri, 30 Jan 2015 14:02:18 +0100
Message-ID: <CA+BoTQkdszYWbNJcV+1dDFsaSJ3aoTuC=ORUMr_aJx7_aQmcqw@mail.gmail.com> (sfid-20150130_140223_422764_CE83F1AA)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 13:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-30 at 13:31 +0100, Michal Kazior wrote:
>
>> +     INIT_LIST_HEAD(&ar->arctxs);
>>       INIT_LIST_HEAD(&ar->arvifs);
>
> I'm not sure why you have an interface list, but I'd say you don't need
> either since you have enumeration APIs:
>
> ieee80211_iterate_active_interfaces[_atomic,...]
>
> and
>
> ieee80211_iter_chan_contexts_atomic
>
> :)

I recall that at least there's one case where using these helpers is
impossible: drv_config() which can be called while mac80211 is already
holding iflist_mtx. ath10k needs to iterate over vifs and issue
blocking commands sometimes so it can't use atomic/rcu versions
either.


Michał
