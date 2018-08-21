Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36138 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbeHUTVY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 15:21:24 -0400
Date: Tue, 21 Aug 2018 09:00:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] workqueue lockdep limitations/bugs
Message-ID: <20180821160039.GO3978217@devbig004.ftw2.facebook.com> (sfid-20180821_180126_052774_5D2E0BF7)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180821120317.4115-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Johannes.

On Tue, Aug 21, 2018 at 02:03:15PM +0200, Johannes Berg wrote:
> 3)
> The third problem is more complicated, but it means that we likely miss a
> lot of potential locking problems with ordered workqueues, and I think we
> should really try to fix this somehow.
> 
> Let's say we again have an ordered workqueue, and the following:
> 
> work1_function
> {
> 	mutex_lock(&mutex);
> }

Regular mutexes complain when the locker isn't the unlocker already.
Do we really care about this case?

Thanks.

-- 
tejun
