Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:52859 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbdIOO1e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 10:27:34 -0400
Received: by mail-pg0-f49.google.com with SMTP id i195so1600405pgd.9
        for <linux-wireless@vger.kernel.org>; Fri, 15 Sep 2017 07:27:33 -0700 (PDT)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
 <1505414172.31630.13.camel@sipsolutions.net>
 <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
 <1505416964.31630.17.camel@sipsolutions.net>
 <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com>
 <1505418093.31630.21.camel@sipsolutions.net>
 <94a01366-1af7-4728-59e4-847bfd8476e0@gmail.com>
 <1505459955.31630.26.camel@sipsolutions.net>
 <ff73f237-71dd-5fde-9c9f-9bc8fce57e76@gmail.com>
 <1505482156.31630.39.camel@sipsolutions.net>
 <9b466254-e9c1-c5e4-c3fd-b881c4c583e9@gmail.com>
 <1505485208.31630.42.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <b87b61bc-6c29-3a4e-01bd-652cf1eb095c@gmail.com> (sfid-20170915_162738_999614_363772B7)
Date: Fri, 15 Sep 2017 09:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <1505485208.31630.42.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> And AFAIK the kernel generates a disconnected event as soon as we
>> send a CMD_AUTHENTICATE, so not sure how you envision 'your'
>> preauthentication working...
> 
> That's what I was trying to say - it doesn't. A few years ago we tried
> to support that but it's not really possible to do well.

Okay, *now* I'm with you :)

> 
>> However, you're not answering my question...
> 
> Which was?

So if we issue CMD_CONNECT with a PREV_BSSID, does/should OPERSTATE 
still stay UP?

>> One can use regular roaming on a full mac but not FT.
> 
> We had intended to have NL80211_CMD_ROAM to make that decision once,
> but never really used it for that... I think it could be implemented
> but I don't really know how well drivers were to support it.

I think it would be nice.  Worst case a driver won't implement it, but 
we can use FT on those that do.

Regards,
-Denis
