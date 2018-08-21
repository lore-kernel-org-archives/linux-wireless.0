Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43743 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbeHUUsR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 16:48:17 -0400
Date: Tue, 21 Aug 2018 10:27:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
Message-ID: <20180821172711.GR3978217@devbig004.ftw2.facebook.com> (sfid-20180821_192725_761527_55888B0B)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
 <20180821120317.4115-2-johannes@sipsolutions.net>
 <20180821160814.GP3978217@devbig004.ftw2.facebook.com>
 <1534871894.25523.34.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534871894.25523.34.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Johannes.

On Tue, Aug 21, 2018 at 07:18:14PM +0200, Johannes Berg wrote:
> > But this can lead to a deadlock.  I'd much rather err on the side of
> > discouraging complex lock dancing around ordered workqueues, no?
> 
> What can lead to a deadlock?

Oh not this particular case, but I was wondering whether we'd be
missing legitimate possible deadlock cases by skipping lockdep for all
cancel_work_sync()'s as they can actually flush.

Thanks.

-- 
tejun
