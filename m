Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50357 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZDPKIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:08:16 -0400
Received: by bwz17 with SMTP id 17so306415bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 03:08:14 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
References: <1239837672.11795.46.camel@violet>
	<1239841291.25334.18.camel@johannes.local>
	<87ocuxf7kv.fsf@litku.valot.fi>
	<1239873166.9737.4.camel@johannes.local>
	<87fxg8apgo.fsf@litku.valot.fi>
	<1239876253.9737.12.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 13:08:09 +0300
In-Reply-To: <1239876253.9737.12.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 12\:04\:13 +0200")
Message-ID: <878wm0ap2u.fsf@litku.valot.fi> (sfid-20090416_120819_518457_764B5D5D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> ifmgd->timer is run every two seconds, even then scanning and it calls
>> like this:
>> 
>> ieee80211_sta_timer() -> ieee80211_sta_work() -> ieee80211_associated()
>> 
>> And to my knowledge the timer is run even when scanning. Or am I missing
>> something?
>
> But ieee80211_sta_work() checks if we're scanning and aborts if we are.

Oh, I missed that one. Yes, you are right.

-- 
Kalle Valo
