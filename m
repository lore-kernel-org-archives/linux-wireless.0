Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50152 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACFr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 00:47:58 -0500
Message-ID: <50E51B7F.7000607@qca.qualcomm.com> (sfid-20130103_064803_512804_CCC9E21E)
Date: Thu, 3 Jan 2013 11:17:43 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>   <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com>   <1356694308.9922.1.camel@jlt4.sipsolutions.net>   (sfid-20121228_123135_896103_E2B28BED) <1356699373.9922.2.camel@jlt4.sipsolutions.net>  <50E11F43.4010006@qca.qualcomm.com> <1357131412.9839.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1357131412.9839.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 02 January 2013 06:26 PM, Johannes Berg wrote:
> On Mon, 2012-12-31 at 10:44 +0530, Vasanthakumar Thiagarajan wrote:
>>
>> On Friday 28 December 2012 06:26 PM, Johannes Berg wrote:
>>> On Fri, 2012-12-28 at 12:31 +0100, Johannes Berg wrote:
>>>> On Fri, 2012-12-28 at 15:51 +0530, Vasanthakumar Thiagarajan wrote:
>>>>
>>>>> V4:
>>>>> 	- Change it accordingly so that at any time the driver can
>>>>> 	  support either white or black list not both.
>>>>
>>>> I was under the impression you needed both. Unless I get confirmation
>>>> from Kalle and/or Jouni I'll not apply this lest it needs to be changed
>>>> in yet again incompatible ways later ...
>>>
>>> Actually I just talked to Jouni again and it seems that the best way to
>>> think of the combined black/whitelist is to treat it as a whitelist +
>>> "notification avoidance optimisation list". The key here being
>>> optimisation, we don't really have to worry about it in terms of feature
>>> advertising etc. since it can be ignored/managed by the driver.
>>
>> Sure. Is the assumption here is the stations in optimisation list \
>> either be denied or allowed which is specific to driver?.
>
> ?
> Basically we would have two modes:
>   * whitelist
>   * blacklist
>
> (each might or might not be supported by the driver)
>
> When a station is on the blacklist it's ignored. When it's on the
> whitelist it's allowed. When it's on neither, but a list is configured,
> an event might be sent. When there's a black-&  whitelist, the blacklist
> is this an optimisation to suppress the event, so we don't need a third
> mode "black- and whitelist supported".

Thanks!, I was really confused with this optimization part.
If I get it correctly, there needs to be a mechanism for
driver to advertise its dual list capability to user space.

Vasanth
