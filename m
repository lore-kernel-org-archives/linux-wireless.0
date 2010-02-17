Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46225 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176Ab0BQJHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 04:07:02 -0500
Received: by bwz19 with SMTP id 19so5270254bwz.28
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 01:07:00 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] nl80211: add power save commands
References: <20100216201026.25148.40799.stgit@tikku>
	<1266396458.5091.0.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 17 Feb 2010 11:06:57 +0200
In-Reply-To: <1266396458.5091.0.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Wed\, 17 Feb 2010 09\:47\:38 +0100")
Message-ID: <87fx50grim.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2010-02-16 at 22:10 +0200, Kalle Valo wrote:
>
>>  	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
>>  	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
>> +	[NL80211_ATTR_PS_STATE] = { .type = NLA_U8 },
>>  };
>
> Looks good to me, though typically we use NLA_U32 for enums. Should we
> deviate from that because we won't ever extend this anyway, or should we
> use NLA_U32 to be more consistent?

Good point. In my opinion we should definitely use u32 for
consistency, there's no real reason to use u8 here. If it's ok for
you, I'll send v2 later today which uses u32.

Thank you for the review.

-- 
Kalle Valo
