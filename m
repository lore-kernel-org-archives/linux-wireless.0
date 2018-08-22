Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:44964 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbeHVHZd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 03:25:33 -0400
Message-ID: <1534910543.25523.50.camel@sipsolutions.net> (sfid-20180822_060244_479463_992E6E9A)
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
From: Johannes Berg <johannes@sipsolutions.net>
To: Byungchul Park <byungchul.park@lge.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel-team@lge.com
Date: Wed, 22 Aug 2018 06:02:23 +0200
In-Reply-To: <20180822024535.GA2414@X58A-UD3R>
References: <20180821120317.4115-1-johannes@sipsolutions.net>
         <20180821120317.4115-2-johannes@sipsolutions.net>
         <20180821160814.GP3978217@devbig004.ftw2.facebook.com>
         <1534871894.25523.34.camel@sipsolutions.net>
         <20180821172711.GR3978217@devbig004.ftw2.facebook.com>
         <1534872621.25523.39.camel@sipsolutions.net>
         <20180821175550.GS3978217@devbig004.ftw2.facebook.com>
         <1534879241.25523.44.camel@sipsolutions.net>
         <20180822024535.GA2414@X58A-UD3R>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-22 at 11:45 +0900, Byungchul Park wrote:

> That should've been adjusted as well when Ingo reverted Cross-release.

I can't really say.

> It would be much easier to add each pair, acquire/release, before
> wait_for_completion() in both flush_workqueue() and flush_work() than
> reverting the whole commit.

The commit doesn't do much more than this though.

> What's lacking is only lockdep annotations for wait_for_completion().

No, I disagree. Like I said before, we need the lockdep annotations on
the WQ even when we don't actually create/use the completion, so we can
catch issues even when they don't actually happen.

johannes
