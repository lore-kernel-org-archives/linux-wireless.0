Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54222 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbeEVKax (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 06:30:53 -0400
Received: by mail-wm0-f65.google.com with SMTP id a67-v6so30306935wmf.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 03:30:53 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20180522004602.19370-1-andrew.zaborowski@intel.com>
 <5B03CC75.7060908@broadcom.com> <1526977281.6787.8.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B03F15B.90904@broadcom.com> (sfid-20180522_123057_581130_BB485132)
Date: Tue, 22 May 2018 12:30:51 +0200
MIME-Version: 1.0
In-Reply-To: <1526977281.6787.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2018 10:21 AM, Johannes Berg wrote:
> On Tue, 2018-05-22 at 09:53 +0200, Arend van Spriel wrote:
>> On 5/22/2018 2:46 AM, Andrew Zaborowski wrote:
>>> Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
>>> NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
>>> from clients other than the connection owner set in the connect,
>>> authenticate or associate commands, if it was set.
>>>
>>> The main point of this check is to prevent chaos when two processes
>>> try to use nl80211 at the same time, it's not a security measure.
>>> The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
>>> START_AP/STOP_AP.
>>
>> Isn't this V2? What has changed since last time?
>
> It was RFC before I guess.

Ah, yes. That's it.

Thanks,
Arend
