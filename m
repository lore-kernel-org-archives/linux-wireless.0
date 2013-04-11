Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4132 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3DKKrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 06:47:37 -0400
Message-ID: <516694BF.7090701@broadcom.com> (sfid-20130411_124740_599840_068B44F7)
Date: Thu, 11 Apr 2013 12:47:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: introduce critical protocol indication
 from user-space
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
 <1365501997.8465.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365501997.8465.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2013 12:06 PM, Johannes Berg wrote:
> On Mon, 2013-04-08 at 11:09 +0200, Arend van Spriel wrote:
>> +void cfg80211_crit_proto_stopped(struct wireless_dev *wdev)
>> +{
>> +	struct cfg80211_registered_device *rdev;
>> +
>> +	rdev = wiphy_to_dev(wdev->wiphy);
>> +	WARN_ON(!rdev->crit_proto_started);
>> +	rdev->crit_proto_started = false;
>> +}
>
> Oh, so you don't want to tell userspace?

Just an observation will looking for an example of netlink event 
messaging to user-space. I noticed that the cfg80211_ft_event() function 
used fixed GFP_KERNEL value. Should event functions always have a gfp_t 
parameter?

Gr. AvS

