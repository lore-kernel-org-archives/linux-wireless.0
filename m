Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52476 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbZDPJt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:49:58 -0400
Received: by fxm2 with SMTP id 2so306249fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 02:49:56 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
References: <1239837672.11795.46.camel@violet>
	<1239841291.25334.18.camel@johannes.local>
	<87ocuxf7kv.fsf@litku.valot.fi>
	<1239873166.9737.4.camel@johannes.local>
	<1239874982.9737.7.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 12:49:54 +0300
In-Reply-To: <1239874982.9737.7.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 11\:43\:02 +0200")
Message-ID: <87ocux9bct.fsf@litku.valot.fi> (sfid-20090416_115001_765354_263C53DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-16 at 11:12 +0200, Johannes Berg wrote:
>
>> > I have been thinking two ways to fix this, either disabling the timer
>> > for the duration of the scan or add a check for scan scan in
>> > ieee80211_associated(). I started implementing the former but haven't
>> > finished it yet. It would be great if someone else can fix it.
>> 
>> But that doesn't make sense to me now. ieee80211_associated() is only
>> run from the station work (ieee80211_sta_work) which doesn't do anything
>> when we're scanning (and gets restarted on scan end). So even if last_rx
>> or last_beacon isn't updated we should only run the evaluation of that
>> after the scan finishes.
>> 
>> I'll try to reproduce this.
>
> Can't. Scanning here, with 4965, takes almost 7 seconds, but all I see
> is, _after_ the scan, a probe:
>
> [ 1534.592164] wlan0: beacon loss from AP 00:1d:7e:4a:a1:ab - sending probe request
>

How many APs can your 4965 see? You need to have at least 4 second
silence period to see the disassication (2 seconds for beacon loss
detection, other two seconds for waiting probe response).

Try artificially dropping received frames during scan or something like
that.

-- 
Kalle Valo
