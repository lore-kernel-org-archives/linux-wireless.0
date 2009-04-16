Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:49252 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZDPGPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 02:15:00 -0400
Received: by bwz17 with SMTP id 17so219937bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 23:14:58 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
References: <1239837672.11795.46.camel@violet>
	<1239841291.25334.18.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 09:14:56 +0300
In-Reply-To: <1239841291.25334.18.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 02\:21\:30 +0200")
Message-ID: <87ocuxf7kv.fsf@litku.valot.fi> (sfid-20090416_081505_163427_81B5D64F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi Marcel,
>
>> After a long debugging session with Reinette we finally tracked down
>> what is going on here. A full scan with this card takes 7-9 seconds and
>> that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
>> which then deauthenticates us with the AP (reason=6). 
>
> Yeah, this is a bug. We analysed this problem a couple of days ago and I
> thought Kalle was going to fix it -- maybe he forgot.

I was supposed to fix this during my easter vacation but was too lazy :)

> I forgot what exactly it was and how to fix it, hmm. Right now I'm
> confused and can't seem to reproduce my analysis. I thought it had
> something to do with using a different timer but we do seem to use the
> regular mgd.timer, so I'm not sure.

The discussion is here:

http://www.spinics.net/lists/kernel/msg866487.html

Basically the problem is that if you scan in an area where there are no
or very few APs and scan takes more than two seconds (like abg band
scans usually take), sta->last_rx won't get updated because mac80211 is
not receiving any frames. This is why the beacon loss check will trigger
in ieee80211_associated().

The problem won't happen if there are lot of APs in the neighbourhood
distributed throughout the channels because then sta->last_rx is updated
often enough and the beacon loss check won't trigger.

I have been thinking two ways to fix this, either disabling the timer
for the duration of the scan or add a check for scan scan in
ieee80211_associated(). I started implementing the former but haven't
finished it yet. It would be great if someone else can fix it.

-- 
Kalle Valo
