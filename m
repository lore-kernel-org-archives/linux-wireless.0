Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63583 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1DAThg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 15:37:36 -0400
Received: by iwn34 with SMTP id 34so3830041iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 12:37:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301645863.3832.5.camel@jlt3.sipsolutions.net>
References: <1301614180-5401-1-git-send-email-lrodriguez@atheros.com> <1301645863.3832.5.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 1 Apr 2011 12:37:16 -0700
Message-ID: <AANLkTi=m0tjcwK30it=7bzxW_4Lh2=tQidEu0QkWeUVK@mail.gmail.com>
Subject: Re: [PATCH v2] cfg80211: add work for processing invalid user reg hints
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 1, 2011 at 1:17 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-03-31 at 16:29 -0700, Luis R. Rodriguez wrote:
>>
>> +static void reg_timeout_work(struct work_struct *work)
>> +{
>> +     REG_DBG_PRINT("Timeout while waiting for CRDA to reply,"
>> +                   "restoring regulatory settings");
>> +     restore_regulatory_settings(true);
>> +}
>
> We have a queue of requests but you're timing out only the last one.
> Wouldn't that still get another one stuck on the queue?

The queue will sit still without processing any queued up regulatory
requests until the last_request was processed. The last_request will
be restored to the world regulatory domain request if we timeout on a
bogus request. There is however one issue here though and that is that
I did not clear out the pending requests when restoring regulatory
settings, and then add the pending stuff back on.

> TBH, I don't quite understand why we have last _and_ a queue to start with.

Well so the queue has the list of pending requests, the last_request
is actually the last request that was processed, this is always
non-null when after bootup and after restoring regulatory settings.
I'll send a v3 with the changes I noted.

Thanks for the review.

  Luis
