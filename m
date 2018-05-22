Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:42348 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeEVKjz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 06:39:55 -0400
Received: by mail-qt0-f195.google.com with SMTP id c2-v6so22714449qtn.9
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 03:39:55 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20180522004602.19370-1-andrew.zaborowski@intel.com>
 <5B03CC75.7060908@broadcom.com>
 <CAOq732+LheV0qx2yJF3j-b514cqa8hfRQBVVh=Epr1_W4UUnGA@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B03F379.5000904@broadcom.com> (sfid-20180522_123959_683696_24C6B6F8)
Date: Tue, 22 May 2018 12:39:53 +0200
MIME-Version: 1.0
In-Reply-To: <CAOq732+LheV0qx2yJF3j-b514cqa8hfRQBVVh=Epr1_W4UUnGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2018 12:33 PM, Andrew Zaborowski wrote:
> On 22 May 2018 at 09:53, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
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
> It's only a resend to include the Signed-off-by that I forgot the first time.

That could also be it ;-)

Thanks,
Arend
