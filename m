Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33622 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1K2W2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 17:28:48 -0500
Received: by faaq16 with SMTP id q16so189586faa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 14:28:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322604877.11282.1.camel@jlt3.sipsolutions.net>
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	<1322555084.4110.2.camel@jlt3.sipsolutions.net>
	<CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com>
	<1322579973.4110.22.camel@jlt3.sipsolutions.net>
	<CALGY4fvSOdKtZbPSdvYkY3XXaGXNo-Ft8ir4LikmnTLqSkVCGA@mail.gmail.com>
	<1322604877.11282.1.camel@jlt3.sipsolutions.net>
Date: Tue, 29 Nov 2011 17:28:46 -0500
Message-ID: <CALGY4ftCLvwUuRZbH30PyUxAd6U7-p9hGwu8SjzLmqV4=XryZg@mail.gmail.com> (sfid-20111129_232851_135588_EAE80CB0)
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

2011/11/29 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2011-11-29 at 17:01 -0500, Nikolay Martynov wrote:
>
>> >>   Do APs broken is such way exist? I.e. APs which declare aggregation
>> >> support but do not respond to addba.
>> >
>> > I seem to remember something ... not really sure.
>>
>>   If such APs exist I think it might be possible to extend my patch to
>> do something like the following. For the first time make 10 attempts
>> to establish addba. If this fails - make no more attempts for the
>> duration of the connection. If this succeeds - use logic I've added in
>> the patch. This should handle broken APs and won't allow agg to be
>> disable because of some random blackout.
>
> Wouldn't that be equivalent to just bumping the number of tries?

  Well, sort of if you are willing to bump it to 10-15, I guess it
would be kind of same thing.
  I've seen couple of times when 3 wasn't enough and agg got disabled,
but 10-15 seems reasonably large to give up completely.

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
