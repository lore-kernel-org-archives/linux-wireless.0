Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:48719 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYLEFrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 00:47:16 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/5] mac80211: enable IEEE80211_CONF_PS only when associated
References: <20081202200219.5507.83250.stgit@tikku>
	<20081202200359.5507.40576.stgit@tikku>
	<1228411658.5692.19.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 05 Dec 2008 07:47:02 +0200
In-Reply-To: <1228411658.5692.19.camel@johannes.berg> (ext Johannes Berg's message of "Thu\, 04 Dec 2008 18\:27\:38 +0100")
Message-ID: <87vdtzi36x.fsf@nokia.com> (sfid-20081205_064721_521566_4501B9DF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2008-12-02 at 22:03 +0200, Kalle Valo wrote:
>
>> -	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>> +	if (ps == local->powersave)
>> +		return ret;
>> +
>> +set:
>> +	local->powersave = ps;
>> +
>> +	if (sdata->vif.type != NL80211_IFTYPE_STATION)
>> +		return ret;
>
> Shouldn't that test be earlier? There's little sense in supporting PS if
> you have a non-STA interface. 

I'll move the test.

> In fact, it might make sense to check that there's no other
> interface (except monitor) open?

I'll add this check as well.

Thank you for the comments.

-- 
Kalle Valo
