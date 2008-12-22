Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34618 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYLVK3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 05:29:06 -0500
Received: by ewy10 with SMTP id 10so2112959ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 02:29:02 -0800 (PST)
Message-ID: <494F6BE6.60009@gmail.com> (sfid-20081222_112913_424201_9A63EE3B)
Date: Mon, 22 Dec 2008 10:28:54 +0000
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] wireless: Add channel/frequency conversions
References: <1229797871-21179-1-git-send-email-kilroyd@googlemail.com>	 (sfid-20081220_193122_880708_FEC683E0) <1229855782.4953.8.camel@johannes>
In-Reply-To: <1229855782.4953.8.camel@johannes>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2008-12-20 at 18:31 +0000, David Kilroy wrote:
>> While refactorring orinoco I found I was encapsulating the static
>> channel frequency table. A quick poll of drivers showed that a number of
>> the older driver have their own version of the table, and use it in the
>> same way. So rather than keep this to orinoco I added the function to
>> the ieee80211 header.
>>
>> To be complete I've added conversion routines for all the
>> bands/modulations in IEEE 802.11-2007
>>
>> Does this seem reasonable? Should they go somewhere else?
> 
> Seems fine, though maybe lib80211 would be appropriate? I'd hate using
> lib80211 in cfg80211 though since that pulls in all crypto bits that we
> don't need there. OTOH, the code really isn't big, so I wouldn't worry
> about inlining them.

I didn't quite get what you meant by that last statement - did you mean
that the inlining is OK, or that you'd prefer them not inlined?

If you meant the former (and there aren't any strong opinions about
lib80211), I'll just submit as is.


Regards,

Dave.
