Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:40180 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeEVKdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 06:33:13 -0400
Received: by mail-io0-f196.google.com with SMTP id g14-v6so17849976ioc.7
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 03:33:12 -0700 (PDT)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com. [209.85.214.54])
        by smtp.gmail.com with ESMTPSA id z88-v6sm9573913ioi.25.2018.05.22.03.33.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 May 2018 03:33:12 -0700 (PDT)
Received: by mail-it0-f54.google.com with SMTP id j186-v6so24676033ita.5
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 03:33:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5B03CC75.7060908@broadcom.com>
References: <20180522004602.19370-1-andrew.zaborowski@intel.com> <5B03CC75.7060908@broadcom.com>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Tue, 22 May 2018 12:33:11 +0200
Message-ID: <CAOq732+LheV0qx2yJF3j-b514cqa8hfRQBVVh=Epr1_W4UUnGA@mail.gmail.com> (sfid-20180522_123316_194430_C94358DD)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from conn_owner
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2018 at 09:53, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> On 5/22/2018 2:46 AM, Andrew Zaborowski wrote:
>> Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
>> NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
>> from clients other than the connection owner set in the connect,
>> authenticate or associate commands, if it was set.
>>
>> The main point of this check is to prevent chaos when two processes
>> try to use nl80211 at the same time, it's not a security measure.
>> The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
>> START_AP/STOP_AP.
>
> Isn't this V2? What has changed since last time?

It's only a resend to include the Signed-off-by that I forgot the first time.

Best regards
