Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59480 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750725AbdCAHbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 02:31:22 -0500
Message-ID: <1488352350.2698.1.camel@sipsolutions.net> (sfid-20170301_083243_858900_7915B5D5)
Subject: Re: [RFC 0/5] iwlwifi: enhance final opmode work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com, tj@kernel.org, arjan@linux.intel.com,
        ming.lei@canonical.com, zajec5@gmail.com
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, pmladek@suse.com,
        gregkh@linuxfoundation.org, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Mar 2017 08:12:30 +0100
In-Reply-To: <20170217020903.6370-1-mcgrof@kernel.org> (sfid-20170217_031056_571505_F608D489)
References: <20170217020903.6370-1-mcgrof@kernel.org>
         (sfid-20170217_031056_571505_F608D489)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> One of the limitations of using async_schedule() though is we cannot
> request_module() synchronously on async calls given that the module
> initialization code will call async_synchronize_full() if the module
> being initialized happened to have used async work on its
> initialization routine, otherwise we'd deadlock.
> 
> So, I either I change back to workqueus or we live happy with either:

I really think you should avoid breaking this API and change back.
Drivers have been using it, how to avoid the use-after-free with a
completion is well known, and there's generally no issue.

Making things "easier" while requiring lots of churn everywhere isn't
always a good thing.

If you end up introducing some new API then perhaps that new API would
make sense to use async_schedule(), but I don't really see all that
much point in changing all of this now.

johannes
