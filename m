Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:41457 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162AbXFMQHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 12:07:35 -0400
Message-ID: <46701643.3040908@warmcat.com>
Date: Wed, 13 Jun 2007 17:07:31 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH Try#11 3/4] cfg80211: Radiotap parser
References: <20070612130435.896010304@warmcat.com>	 <20070612130502.157979021@warmcat.com>	 <200706122242.08045.flamingice@sourmilk.net> <1181749596.29767.82.camel@johannes.berg>
In-Reply-To: <1181749596.29767.82.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2007-06-12 at 22:42 -0700, Michael Wu wrote:
>> On Tuesday 12 June 2007 06:04, andy@warmcat.com wrote:
>>> +typedef enum  {
>>> +       RADIOTAP_PARSER_OK = 0,
>>> +       RADIOTAP_PARSER_DONE,
>>> +       RADIOTAP_PARSER_INVALID
>>> +} ieee80211_radiotap_parser_retcode_t;
> 
>> Yuck. I much prefer the standard error codes used in the previous version..
> 
> I would as well, but as I outlined before we basically have four things
> that can happen
>  * we found a next item we understood
>  * we have a parser error
>  * we reached the end
>  * we found an item we can't support (and thus we don't support any
>    further ones either assuming we add support sequentially)
> 
> I would like to be able to distinguish all these cases, the previous
> version couldn't distinguish between the last two. However, I'm not
> convinced that error codes are reasonable for something that isn't an
> error (i.e. reaching the end)

Is it useful to report that there were items in the radiotap section
that were not illegal but were not comprehensible either?  Any app that
is written against the parser will be using the contempary list of
constants from ieee80211_radiotap.h, and anything added in there should
be added to radiotap.c.  Put another way you won't be in any better
position to understand or handle radiotap args that cfg80211 doesn't
understand than cfg80211 is itself.  Is there a case where you don't
want to ignore these unknown later entries that could appear?

This parser is used in userspace apps too, packetspammer, penumbrad,
aircrack and mdk, and hopefully others when injection becomes something
that happens out of the box.  The E* error constants are available in
userspace too.  Although you can make a case for either way probably
radiotap isn't so wonderfully grand that it deserves its own enum for
its results IMO.

-Andy

