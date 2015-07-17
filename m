Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:5532 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822AbbGQNVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:21:51 -0400
Message-ID: <55A8FF32.5070308@neratec.com> (sfid-20150717_152200_942538_CBB05D47)
Date: Fri, 17 Jul 2015 15:12:18 +0200
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] cfg80211: Handle minimum bandwidth for quarter and
 half rates
References: <1434035553-6621-1-git-send-email-matthias.may@neratec.com>	 (sfid-20150611_171301_187773_8C09D939) <1437136527.1933.9.camel@sipsolutions.net>
In-Reply-To: <1437136527.1933.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/15 14:35, Johannes Berg wrote:
> On Thu, 2015-06-11 at 17:12 +0200, Matthias May wrote:
>> The goal of this patch is to improve regd handling of quarter and
>> half rates.
>>
>> The original assumption of 20MHz wide channels is with the
>> introduction of
>> quarter and half rates no longer true.
>> With this patch we no longer disable all channels that don't fit into
>> the
>> 20MHz grid, but instead set the appropriate flags to disable
>> operation on
>> specific bandwidths.
>>
> Applied.
>
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Johannes
I've improved this patch a bit since i posted v3.
Mainly setting more disabled flags when using a country code which only 
allows only narrow channels.
In certain circumstance it was possible to start operation on a 20/10 
channel on a channel which only allowed 5/10.

I didn't post it yet because i was running some more tests with it and 
used it "productively" to see if something else breaks.
Will post it now.

Best regards
Matthias
