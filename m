Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34768 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeHUVRE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 17:17:04 -0400
Date: Tue, 21 Aug 2018 10:55:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
Message-ID: <20180821175550.GS3978217@devbig004.ftw2.facebook.com> (sfid-20180821_195604_932920_CE902C3A)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
 <20180821120317.4115-2-johannes@sipsolutions.net>
 <20180821160814.GP3978217@devbig004.ftw2.facebook.com>
 <1534871894.25523.34.camel@sipsolutions.net>
 <20180821172711.GR3978217@devbig004.ftw2.facebook.com>
 <1534872621.25523.39.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534872621.25523.39.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Tue, Aug 21, 2018 at 07:30:21PM +0200, Johannes Berg wrote:
> I don't see how? This is only relevant in ordered/single-threaded WQs,
> but even there it doesn't matter doesn't matter as explained?
> 
> I'm actually seeing a false positive report from lockdep, because it
> *is* flushing, i.e. I'm running into the case of the work actually
> running, i.e. the "_sync" part of "cancel_work_sync()" is kicking in,
> but in that case a single-threaded WQ can't have anything executing
> *before* it, so we don't need to generate a lockdep dependency - and in
> fact don't *want* to create one to avoid the false positive.
> 
> I'm not really sure what you think we might be missing? Am I missing
> some case where cancel_work_sync() can possibly deadlock? Apart from the
> issue I addressed in the second patch, obviously.

Ah, that was me being slow.  I thought you were skipping the work's
lockdep_map.  I can almost swear we had that before (the part you're
adding on the second patch).  Right, fd1a5b04dfb8 ("workqueue: Remove
now redundant lock acquisitions wrt. workqueue flushes") removed it
because it gets propagated through wait_for_completion().  Did we miss
some cases with that change?

Thanks.

-- 
tejun
