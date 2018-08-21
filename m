Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:37132 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbeHUWmN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 18:42:13 -0400
Message-ID: <1534879241.25523.44.camel@sipsolutions.net> (sfid-20180821_212058_769566_F202B54E)
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Byungchul Park <byungchul.park@lge.com>
Date: Tue, 21 Aug 2018 21:20:41 +0200
In-Reply-To: <20180821175550.GS3978217@devbig004.ftw2.facebook.com> (sfid-20180821_195557_005865_AFE22844)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
         <20180821120317.4115-2-johannes@sipsolutions.net>
         <20180821160814.GP3978217@devbig004.ftw2.facebook.com>
         <1534871894.25523.34.camel@sipsolutions.net>
         <20180821172711.GR3978217@devbig004.ftw2.facebook.com>
         <1534872621.25523.39.camel@sipsolutions.net>
         <20180821175550.GS3978217@devbig004.ftw2.facebook.com>
         (sfid-20180821_195557_005865_AFE22844)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 10:55 -0700, Tejun Heo wrote:

> > I'm not really sure what you think we might be missing? Am I missing
> > some case where cancel_work_sync() can possibly deadlock? Apart from the
> > issue I addressed in the second patch, obviously.
> 
> Ah, that was me being slow.  I thought you were skipping the work's
> lockdep_map.  I can almost swear we had that before (the part you're
> adding on the second patch).  Right, fd1a5b04dfb8 ("workqueue: Remove
> now redundant lock acquisitions wrt. workqueue flushes") removed it
> because it gets propagated through wait_for_completion().  Did we miss
> some cases with that change?

Hmm.

It doesn't seem to be working.

No, ok, actually it probably *does*, but the point is similar to my
issue # 3 before - we don't do any of this unless the work is actually
running, but we really want the lockdep annotation *regardless* of that,
so that we catch the error unconditionally.

So perhaps that commit just needs to be reverted entirely - I'd only
looked at a small subset of it, but the flush_workqueue() case has the
same problem - we only get to the completion when there's something to
flush, not when the workqueue happens to actually be empty. But again,
for lockdep we want to catch *potential* problems, not only *actual*
ones.

The remaining part of the patch I'm not sure I fully understand (removal
of lockdep_init_map_crosslock()), but I suppose if we revert the other
bits we need to revert this as well.

So please drop this patch, but revert Byungchul Park's commit
fd1a5b04dfb8 again, I don't think the lockdep annotations there are
really redundant as I just explained.

johannes
