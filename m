Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39692 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdHBKH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 06:07:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, Michael Skeffington <mike@astro.ai>
Subject: Re: [PATCH] mac80211: remove mic_fail_no_key label
References: <20170802090431.GB2790@redhat.com> <598196F3.9070208@broadcom.com>
        <20170802093551.GA4777@redhat.com>
Date: Wed, 02 Aug 2017 13:07:22 +0300
In-Reply-To: <20170802093551.GA4777@redhat.com> (Stanislaw Gruszka's message
        of "Wed, 2 Aug 2017 11:35:52 +0200")
Message-ID: <87vam6uvtx.fsf@purkki.adurom.net> (sfid-20170802_120731_025160_450F4E75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Wed, Aug 02, 2017 at 11:10:11AM +0200, Arend van Spriel wrote:
>> On 8/2/2017 11:04 AM, Stanislaw Gruszka wrote:
>> >For historic reasons we have separate cases for mic_fail and
>> >mic_fail_no_key. But with current code we can merge those cases,
>> >as we already have NULL key check since:
>> >
>> >commit a66b98db570a638afd909459e1e6bfa272344bd3
>> >Author: Arik Nemtsov <arik@wizery.com>
>> >Date:   Thu Jun 23 00:00:24 2011 +0300
>> >
>> >     mac80211: fix rx->key NULL dereference during mic failure
>> 
>> Maybe better to use:
>> ... since commit a66b98db570a ("mac80211: fix rx->key NULL
>> dereference during mic failure").
>> 
>> as it is the preferred method to reference git commits.
>
> Is easier for me to just copy-paste commit in form the git log/show
> command provides, so I use that form. Is there tool or git log/show
> option to get commit log in the preferred form, so I do not have to
> change it manually?

I do it like this:

$ git show --format=fixes a66b98db570a638afd909459e1e6bfa272344bd3 | head -1
Fixes: a66b98db570a ("mac80211: fix rx->key NULL dereference during mic failure")

How to configure it is documented in SubmittingPatches:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

-- 
Kalle Valo
