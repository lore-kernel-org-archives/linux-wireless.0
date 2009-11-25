Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32985 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZKYQrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:47:12 -0500
Message-ID: <4B0D5F95.9000308@trash.net>
Date: Wed, 25 Nov 2009 17:47:17 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: RFC: mac80211: add ethtool support
References: <4B0D58EA.8060304@trash.net> <1259166692.32372.13.camel@johannes.local> <4B0D5C8F.3040005@trash.net> <1259167010.32372.14.camel@johannes.local> <4B0D5E8D.2070408@trash.net> <20091125164313.GE7800@tuxdriver.com>
In-Reply-To: <20091125164313.GE7800@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Nov 25, 2009 at 05:42:53PM +0100, Patrick McHardy wrote:
>> Johannes Berg wrote:
>>> On Wed, 2009-11-25 at 17:34 +0100, Patrick McHardy wrote:
>>>> Johannes Berg wrote:
>>>>> On Wed, 2009-11-25 at 17:18 +0100, Patrick McHardy wrote:
>>>>>>     mac80211: add ethtool support
>>>>>>     
>>>>>>     Add ethtool support and add a drvname field to struct ieee80211_ops, which is
>>>>>>     used for ethtool driver information. This is useful with multiple different
>>>>>>     wireless cards to find out which device is using which driver.
>>>>>>     
>>>>> I thought we _had_ ethtool support via cfg80211?!
>>>> Mhh good point :) For some reason it didn't show any information, but
>>>> that might have been a mistake on my part. I'll give it another shot :)
>>> It probably won't show the driver name because we haven't pushed that
>>> through in any way?
>> Its actually showing:
>>
>> # ethtool -i wlan0
>> Cannot get driver information: Operation not supported
>>
>> which shouldn't happen, since the callback is defined. I'll
>> have a closer look at this.
> 
> What kernel are you using?

OK, that was a mistake on my part, I added the patch on net-next,
but the above test was done on net-2.6. Everything is working fine,
sorry for the confusion :)
