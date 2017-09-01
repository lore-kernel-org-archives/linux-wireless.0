Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdIAIPN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 04:15:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>
Subject: Re: [PATCH 1/2] iwlwifi: fix long debug print
References: <20170825082730.31388-1-luca@coelho.fi>
        <20170825082730.31388-2-luca@coelho.fi>
        <1504216665.2786.48.camel@perches.com>
        <1504244238.31031.24.camel@coelho.fi>
        <1504246520.2361.3.camel@perches.com>
Date: Fri, 01 Sep 2017 11:15:07 +0300
In-Reply-To: <1504246520.2361.3.camel@perches.com> (Joe Perches's message of
        "Thu, 31 Aug 2017 23:15:20 -0700")
Message-ID: <87k21irg1g.fsf@kamboji.qca.qualcomm.com> (sfid-20170901_101518_899688_E2A5B6E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Fri, 2017-09-01 at 08:37 +0300, Luca Coelho wrote:
>> On Thu, 2017-08-31 at 14:57 -0700, Joe Perches wrote:
>> > On Fri, 2017-08-25 at 11:27 +0300, Luca Coelho wrote:
>> > > From: Liad Kaufman <liad.kaufman@intel.com>
>> > > 
>> > > There is a debug print that sometimes reaches over
>> > > 110 chars, thus generating a warning in those cases.
>> > 
>> > What emits a warning here?
>> 
>> We have a WARN_ON in iwl-devtrace-msg.h:
>> 
>> #define MAX_MSG_LEN	110
>
> OK, thanks for the hint.
>
> The commit message is a bit obscure.
>
> It might make sense to add a comment to describe these
> trace events coming from TRACE_EVENT(iwlwifi_dbg,
>
> All the IWL_DEBUG_<foo> use this trace message maximum.

Unfortunately the patch is already commited to wireless-drivers-next so
we can't change the commit log anymore.

-- 
Kalle Valo
