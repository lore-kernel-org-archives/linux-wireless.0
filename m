Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64336 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZA1Qzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:55:36 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power save mode is disabled
References: <20090122114240.31443.18218.stgit@tikku>
	<20090122114546.31443.79387.stgit@tikku>
	<1232643729.5819.3.camel@johannes.local>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 28 Jan 2009 18:49:34 +0200
In-Reply-To: <1232643729.5819.3.camel@johannes.local> (ext Johannes Berg's message of "Thu\, 22 Jan 2009 18\:02\:09 +0100")
Message-ID: <87hc3jgyu9.fsf@nokia.com> (sfid-20090128_175540_755314_8F4E1F33)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-01-22 at 13:45 +0200, Kalle Valo wrote:
>
>> +	printk(KERN_DEBUG "sending ps-poll");
>
> remove one, add another? Or forgot quilt refresh? :)

I have no idea what happened :) I'll fix that.

> If we receive a frame, but don't send any, we'll still stay awake.
> Should receiving update the dynamic timer as well, to avoid that case?
> Here, I mean:
>
>> @@ -1816,9 +1851,24 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
> ...
>> +                       if (local->hw.conf.dynamic_ps_timeout > 0) {
>> +                               local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>> +                               ieee80211_hw_config(local,
>> +                                                   IEEE80211_CONF_CHANGE_PS);
>> +                               ieee80211_send_nullfunc(local, sdata, 0);

You mean case where directed_time is set, dynamic_ps_timeout is zero
and station doesn't transmit anything? That's not a problem because in
that case power save is not disabled at all, ps-poll is sent while
power save mode is enabled. So there won't any problem.

Like I said last week, I need to revisit this case later to get proper
support for other hw designs, eg. broadcom.

-- 
Kalle Valo
