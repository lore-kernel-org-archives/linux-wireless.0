Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64970 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LME4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 23:56:54 -0500
Message-ID: <50C95FFE.2040200@qca.qualcomm.com> (sfid-20121213_055657_776726_973BDF7C)
Date: Thu, 13 Dec 2012 10:26:30 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com>  <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>  <1355255841.9819.18.camel@jlt4.sipsolutions.net>  <50C81331.9080304@qca.qualcomm.com>  <1355311595.9708.2.camel@jlt4.sipsolutions.net>  (sfid-20121212_122620_162346_E59A9D73) <1355311635.9708.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355311635.9708.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 12 December 2012 04:57 PM, Johannes Berg wrote:
> On Wed, 2012-12-12 at 12:26 +0100, Johannes Berg wrote:
>
>> Yeah but I don't think that's a valid general assumption, and with the
>> feature advertising API that you came up with, the driver can't
>> advertise that it supports both at the same time etc.
>>
>> Also, in fact, I think there needs to be more justification for why you
>> need two lists to start with -- it seems to me that a white- and
>> blacklist doesn't make sense at all, unless it's not really a white- and
>> blacklist but one of
>>   1) a blacklist
>>   2) a whitelist + a "do not notify" list
>
> And actually, without a notify mechanism (which I don't think exists
> yet) this doesn't make sense anyway

We have it for a connection request from a client listed under
black list through NL80211_ATTR_CONN_FAILED_REASON in
NL80211_CMD_CONN_FAILED. But the one which needs to be
there for a connection from client which is part of
neither of the groups is not yet there. As I mentioned
in my previous reply, is this also be sent in
NL80211_CMD_CONN_FAILED.

Vasanth
