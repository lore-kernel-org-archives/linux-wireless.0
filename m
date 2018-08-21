Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:43527 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbeHUTaC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 15:30:02 -0400
Date: Tue, 21 Aug 2018 09:09:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] workqueue: create lockdep dependency in flush_work()
Message-ID: <20180821160914.GQ3978217@devbig004.ftw2.facebook.com> (sfid-20180821_180929_663883_BF89A335)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
 <20180821120317.4115-3-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180821120317.4115-3-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2018 at 02:03:17PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In flush_work(), we need to create a lockdep dependency so that
> the following scenario is appropriately tagged as a problem:
> 
>   work_function()
>   {
>     mutex_lock(&mutex);
>     ...
>   }
> 
>   other_function()
>   {
>     mutex_lock(&mutex);
>     flush_work(&work); // or cancel_work_sync(&work);
>   }
> 
> This is a problem since the work might be running and be blocked
> on trying to acquire the mutex.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

This makes sense to me.  Did you notice any extra lockdep warnings
with this?

Thanks.

-- 
tejun
