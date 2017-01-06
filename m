Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35165 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031568AbdAFTYo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 14:24:44 -0500
Received: by mail-io0-f196.google.com with SMTP id m98so942940iod.2
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2017 11:24:43 -0800 (PST)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com. [209.85.214.45])
        by smtp.gmail.com with ESMTPSA id e143sm1892384itc.9.2017.01.06.11.24.42
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jan 2017 11:24:42 -0800 (PST)
Received: by mail-it0-f45.google.com with SMTP id 192so22771299itl.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2017 11:24:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483610213.4394.4.camel@sipsolutions.net>
References: <20161218002554.6362-1-andrew.zaborowski@intel.com>
 <1483544433.7312.13.camel@sipsolutions.net> <CAOq732KZrpsjK96uwwe3hna2DPkwbN3CvJz+LFxJzXxWw08wRA@mail.gmail.com>
 <1483610213.4394.4.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Fri, 6 Jan 2017 14:24:41 -0500
Message-ID: <CAOq732Ls-9bMaWV8HF7faY8iaHyqOj8PN+vbTPmFnAUJNnFrmQ@mail.gmail.com> (sfid-20170106_202502_372249_273441F0)
Subject: Re: [PATCH v4] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 5 January 2017 at 04:56, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2017-01-04 at 15:35 -0500, Andrew Zaborowski wrote:
>> On 4 January 2017 at 10:40, Johannes Berg <johannes@sipsolutions.net>
>> wrote:
>> > This also doesn't seem right - the same socket could possibly own
>> > both
>> > an interface and a connection? If the connection is on the same
>> > interface you might not really want to do both - though it
>> > shouldn't
>> > hurt if all the cancel_work is in the right place - but it could be
>> > a
>> > different interface?
>>
>> This is only a syntactic change though.  The "continue" is now in the
>> "if (schedule_destroy_work)" block so the other actions will not be
>> scheduled is the interface is being destroyed.
>
> Yes, this part is only syntactic, but you added something new
> afterwards, and that new thing should happen even if another interface
> is going to be scheduled for destruction.
>
> I actually think that the code right now is already wrong though, since
> schedule_destroy_work and schedule_scan_stop shouldn't be mutually
> exclusive, a single socket could own both a sched scan and a different
> interface.
>
> I'll fix that bug, and we'll have to deal with the conflicts when
> merging this.

Yes, good point.  I'll just rebase this patch on top of the fix.

Best regards
