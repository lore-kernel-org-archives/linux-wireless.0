Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44419 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaDIOSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 10:18:35 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so2508062pdj.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 07:18:35 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/8] cfg80211: fix possible compile warning in wext-compat.h
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	<1397047610.4964.14.camel@jlt4.sipsolutions.net>
Date: Wed, 09 Apr 2014 22:18:27 +0800
In-Reply-To: <1397047610.4964.14.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 09 Apr 2014 14:46:50 +0200")
Message-ID: <8738hmfux8.fsf@gmail.com> (sfid-20140409_161840_202441_5ADD3542)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 14:46:50 +0200, Johannes Berg wrote:
> On Wed, 2014-04-09 at 09:28 +0800, Zhao, Gang wrote:
>> Function cfg80211_wext_freq() is declared in wext-compat.h, but its
>> parameter struct wiphy's declaration is not included there. Actually
>> the parameter is not used in this function, so change it to normal
>> net_device.
>> 
>> The compile warning doesn't show up due to duplicate including, but
>> it's worth fixing it.
>
> Why not just include the right file here?

As I said in commit log, that parameter is not used in that function,
and all the other functions in wext-compat.h use net_device as their
parameters, I don't see any reason why this function should be specific.

Although changing the parameter type seems complicated the problem, I
think it's the more reasonable way.

>
> johannes
