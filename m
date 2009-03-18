Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44788 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbZCRLu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 07:50:29 -0400
Received: by bwz17 with SMTP id 17so9568bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 04:50:26 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: don't drop null frames during software scan
References: <20090318092507.17198.83588.stgit@tikku>
	<1237368810.5100.15.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Mar 2009 13:50:23 +0200
In-Reply-To: <1237368810.5100.15.camel@johannes.local> (Johannes Berg's message of "Wed\, 18 Mar 2009 10\:33\:30 +0100")
Message-ID: <87bprzm4n4.fsf@litku.valot.fi> (sfid-20090318_125142_224887_0EE953B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-03-18 at 11:25 +0200, Kalle Valo wrote:
>
>> +		/*
>> +		 * When software scanning only nullfunc frames (to notify
>> +		 * the sleep state to the AP) and probe requests (for the
>> +		 * active scan) are allowed, everything else should be
>> +		 * dropped. See ieee80211_start_scan() for more.
>> +		 */
>>  		return TX_DROP;
>
> That makes it sounds "too correct" to drop frames it seems. Should we
> say something like
>
> 	... and probe requests (...) are allowed, all other frames
> 	should not be sent and we should not get here, but if we do
> 	nonetheless,drop them to avoid sending them off-channel.
>
> Or even add this link:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/30089

Ok, I'll improve it.

> (you also forgot to s/null/nullfunc/ in the subject :) )

Heh, I'll fix that.

v4 coming up.

-- 
Kalle Valo
