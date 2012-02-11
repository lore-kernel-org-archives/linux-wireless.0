Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13944 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab2BKPTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 10:19:16 -0500
Message-ID: <20120211101915.8vya6m4004kgc0g4-cebfxv@webmail.spamcop.net> (sfid-20120211_161919_456913_35DF1B29)
Date: Sat, 11 Feb 2012 10:19:15 -0500
From: Pavel Roskin <proski@gnu.org>
To: Peter Stuge <peter@stuge.se>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: stop on rates with idx -1 in
	ath9k rate control's .tx_status
References: <20120211150152.4823.8570.stgit@ae>
	<20120211150614.30728.qmail@stuge.se>
In-Reply-To: <20120211150614.30728.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Peter Stuge <peter@stuge.se>:

> Pavel Roskin wrote:
>> Rate control algorithms are supposed to stop processing when they
>> encounter a rate with the index -1.  Checking for rate->count not being
>> zero is not enough.
>
> Maybe it's a good idea to use an unsigned variable and check for the
> actual error condition when it can happen, instead of checking for an
> "overflow" after the fact?

It's not my choice, it's written in include/net/mac80211.h:

  * A value of -1 for @idx indicates an invalid rate and, if used
  * in an array of retry rates, that no more rates should be tried.

I just want ath9k/rc to follow the documentation.

I believe the code in mac80211 uses both count=0 and idx=-1 to  
indicate the end on the rate list, but in some cases, only idx=-1 is  
used (my guess is that the list needs to be shortened).  In any case,  
mac80211 is must be correct because it expect rate control algorithms  
to do what's documented in the header.

>> -		if (!rate->count)
>> +		if (rate->idx < 0 || !rate->count)
>>  			break;
>
> At the very least this could test for <= 0.

Index 0 may be valid.  Other rate control algorithms only check for  
negative values.

-- 
Regards,
Pavel Roskin
